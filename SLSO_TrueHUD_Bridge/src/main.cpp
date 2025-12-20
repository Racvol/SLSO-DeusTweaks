#include "PCH.h"
// === FIX: Добавляем стандартные библиотеки для TrueHUDAPI ===
#include <functional>
#include <mutex>
#include <shared_mutex>
#include <unordered_map>
#include <deque>
#include <chrono>
#include <algorithm>


#include <filesystem>
#include <Windows.h>
#include <SimpleIni.h>


#include "TrueHUDAPI.h"



// Глобальные переменные
static TRUEHUD_API::IVTrueHUD4* g_trueHUD = nullptr;
static SKSE::PluginHandle g_pluginHandle = SKSE::kInvalidPluginHandle;
static bool g_targetControlGranted = false;

// Хранилище для 3-й полоски
struct OrgasmData {
    float current;
    float max;
};
static std::unordered_map<std::uint32_t, OrgasmData> g_orgasmMap;
static std::shared_mutex g_lock;

// === Callbacks для TrueHUD (3-я полоска) ===
float GetOrgasmCurrent(RE::Actor* actor) {
    if (!actor) return -1.0f;
    std::shared_lock lock(g_lock);
    auto it = g_orgasmMap.find(actor->GetHandle().native_handle());
    return (it != g_orgasmMap.end()) ? it->second.current : -1.0f;
}

float GetOrgasmMax(RE::Actor* actor) {
    if (!actor) return 100.0f;
    std::shared_lock lock(g_lock);
    auto it = g_orgasmMap.find(actor->GetHandle().native_handle());
    float val = (it != g_orgasmMap.end()) ? it->second.max : 100.0f;
    // Guard against zero or negative max to avoid division-by-zero in TrueHUD
    return (val <= 0.0f) ? 100.0f : val;
}

// === Нативные функции для Papyrus ===
namespace SLSO_Bridge {
    void EnableSexBars(RE::StaticFunctionTag*, RE::Actor* actor) {
        if (!actor || !g_trueHUD) return;
        auto handle = actor->GetHandle();

        // Only request target control if we haven't already obtained it
        if (!g_targetControlGranted) {
            auto tRes = g_trueHUD->RequestTargetControl(g_pluginHandle);
            if (tRes == TRUEHUD_API::APIResult::OK || tRes == TRUEHUD_API::APIResult::AlreadyGiven) {
                g_targetControlGranted = true;
            } else {
                logger::warn("RequestTargetControl failed: {}", static_cast<int>(tRes));
            }
        }

        g_trueHUD->AddActorInfoBar(handle);
        
        // Розовая стамина
        g_trueHUD->OverrideBarColor(handle, RE::ActorValue::kStamina, TRUEHUD_API::BarColorType::BarColor, 0xFF69B4);
        g_trueHUD->OverrideBarColor(handle, RE::ActorValue::kStamina, TRUEHUD_API::BarColorType::PhantomColor, 0xFFC0CB);
        g_trueHUD->OverrideBarColor(handle, RE::ActorValue::kStamina, TRUEHUD_API::BarColorType::FlashColor, 0xFF1493);
        
        // Фиолетовая мана (Mind Break)
        g_trueHUD->OverrideBarColor(handle, RE::ActorValue::kMagicka, TRUEHUD_API::BarColorType::BarColor, 0x8A2BE2);
    }

    void UpdateOrgasmBar(RE::StaticFunctionTag*, RE::Actor* actor, float current, float max) {
        if (!actor) return;
        std::unique_lock lock(g_lock);
        g_orgasmMap[actor->GetHandle().native_handle()] = { current, max };
    }

    void DisableSexBars(RE::StaticFunctionTag*, RE::Actor* actor) {
        if (!actor || !g_trueHUD) return;
        auto handle = actor->GetHandle();

        g_trueHUD->RemoveActorInfoBar(handle, TRUEHUD_API::WidgetRemovalMode::Normal);
        g_trueHUD->RevertBarColor(handle, RE::ActorValue::kStamina, TRUEHUD_API::BarColorType::BarColor);
        g_trueHUD->RevertBarColor(handle, RE::ActorValue::kStamina, TRUEHUD_API::BarColorType::PhantomColor);
        g_trueHUD->RevertBarColor(handle, RE::ActorValue::kStamina, TRUEHUD_API::BarColorType::FlashColor);
        g_trueHUD->RevertBarColor(handle, RE::ActorValue::kMagicka, TRUEHUD_API::BarColorType::BarColor);

        {
            std::unique_lock lock(g_lock);
            g_orgasmMap.erase(handle.native_handle());
        }
    }

    void ReleaseTrueHUDControls(RE::StaticFunctionTag*) {
        if (!g_trueHUD) {
            logger::warn("ReleaseTrueHUDControls called but TrueHUD API not available");
            return;
        }

        auto tRes = g_trueHUD->ReleaseTargetControl(g_pluginHandle);
        if (tRes == TRUEHUD_API::APIResult::OK) {
            logger::info("Released target control");
        } else {
            logger::warn("ReleaseTargetControl returned {}", static_cast<int>(tRes));
        }

        auto rRes = g_trueHUD->ReleaseSpecialResourceBarControl(g_pluginHandle);
        if (rRes == TRUEHUD_API::APIResult::OK) {
            logger::info("Released special resource bars control");
        } else {
            logger::warn("ReleaseSpecialResourceBarControl returned {}", static_cast<int>(rRes));
        }

        g_targetControlGranted = false;
    }

    bool RegisterFuncs(RE::BSScript::IVirtualMachine* vm) {
        vm->RegisterFunction("EnableSexBars", "SLSO_TrueHUD", EnableSexBars);
        vm->RegisterFunction("DisableSexBars", "SLSO_TrueHUD", DisableSexBars);
        vm->RegisterFunction("UpdateOrgasmBar", "SLSO_TrueHUD", UpdateOrgasmBar);
        vm->RegisterFunction("ReleaseTrueHUDControls", "SLSO_TrueHUD", ReleaseTrueHUDControls);
        return true;
    }
}

// === Инициализация ===
void InitializeMessaging() {
    auto* messaging = SKSE::GetMessagingInterface();
    messaging->RegisterListener([](SKSE::MessagingInterface::Message* message) {
        // Clear stored per-actor data when a game is loaded to avoid leaking data across saves
        if (message->type == SKSE::MessagingInterface::kPostLoadGame) {
            std::unique_lock lock(g_lock);
            g_orgasmMap.clear();
            logger::info("Orgasm map cleared on game load");
        }

        if (message->type == SKSE::MessagingInterface::kPostLoad) {
            g_trueHUD = reinterpret_cast<TRUEHUD_API::IVTrueHUD4*>(
                TRUEHUD_API::RequestPluginAPI(TRUEHUD_API::InterfaceVersion::V4)
            );
            if (g_trueHUD) {
                logger::info("TrueHUD API acquired");

                // 1) Request control over special resource bars before registering callbacks
                auto res = g_trueHUD->RequestSpecialResourceBarsControl(g_pluginHandle);
                if (res == TRUEHUD_API::APIResult::OK || res == TRUEHUD_API::APIResult::AlreadyGiven) {
                    logger::info("Special resource control granted");
                    g_trueHUD->RegisterSpecialResourceFunctions(g_pluginHandle, GetOrgasmCurrent, GetOrgasmMax, false, true);
                } else {
                    logger::error("Failed to request special resource control: {}", static_cast<int>(res));
                }

                // 2) Optionally request target control as well (good practice when manipulating targets)
                auto tRes = g_trueHUD->RequestTargetControl(g_pluginHandle);
                if (tRes == TRUEHUD_API::APIResult::OK || tRes == TRUEHUD_API::APIResult::AlreadyGiven) {
                    logger::info("Target control granted");
                    g_targetControlGranted = true;
                } else {
                    logger::warn("Failed to request target control: {}", static_cast<int>(tRes));
                }
            }
        }
    });
}
SKSEPluginInfo(
    REL::Version{ 1, 0, 0, 0 },
    "SLSO_TrueHUD_Bridge",
    "DeusTweaks",
    "",
    SKSE::StructCompatibility::Independent,
    {},
    REL::Version{ 0, 0, 0, 0 }
);

SKSEPluginLoad(const SKSE::LoadInterface* a_skse)
{

    SKSE::Init(a_skse);
    g_pluginHandle = a_skse->GetPluginHandle();

    auto path = SKSE::log::log_directory();
    if (path) {
        *path /= "SLSO_TrueHUD_Bridge.log";
        auto sink = std::make_shared<spdlog::sinks::basic_file_sink_mt>(path->string(), true);
        auto log = std::make_shared<spdlog::logger>("global log", sink);
        // Try to read INI located next to the DLL first, fallback to Data\SKSE\Plugins
        CSimpleIniA ini;
        ini.SetUnicode();
        long iniLevel = static_cast<long>(spdlog::level::info);
        bool loaded = false;

        // 1) Try DLL-adjacent INI: <plugin>.ini
        wchar_t dllPath[MAX_PATH] = { 0 };
        HMODULE hModule = GetModuleHandleW(L"SLSO_TrueHUD_Bridge.dll");
        if (hModule && GetModuleFileNameW(hModule, dllPath, MAX_PATH)) {
            std::filesystem::path configPath(dllPath);
            configPath.replace_extension(".ini");
            if (ini.LoadFile(configPath.string().c_str()) == 0) {
                iniLevel = ini.GetLongValue("Debug", "LogLevel", iniLevel);
                logger::info("Config loaded from {}", configPath.string());
                loaded = true;
            } else {
                logger::debug("No DLL-adjacent INI at {}", configPath.string());
            }
        }

        // 2) Fallback to Data\SKSE\Plugins\SLSO_TrueHUD_Bridge.ini
        if (!loaded) {
            std::filesystem::path dataPath = std::filesystem::path("Data") / "SKSE" / "Plugins" / "SLSO_TrueHUD_Bridge.ini";
            if (ini.LoadFile(dataPath.string().c_str()) == 0) {
                iniLevel = ini.GetLongValue("Debug", "LogLevel", iniLevel);
                logger::info("Config loaded from {}", dataPath.string());
                loaded = true;
            } else {
                logger::debug("No fallback INI at {}", dataPath.string());
            }
        }

        // Clamp to valid spdlog levels (0..6)
        if (iniLevel < static_cast<long>(spdlog::level::trace)) iniLevel = static_cast<long>(spdlog::level::trace);
        if (iniLevel > static_cast<long>(spdlog::level::critical)) iniLevel = static_cast<long>(spdlog::level::critical);
        auto level = static_cast<spdlog::level::level_enum>(iniLevel);
        log->set_level(level);
        log->flush_on(level);
        spdlog::set_default_logger(log);
        spdlog::set_pattern("[%T.%e] [%=5t] [%L] %v");
        spdlog::flush_every(std::chrono::seconds(5));
    }

    InitializeMessaging();
    
    auto papyrus = SKSE::GetPapyrusInterface();
    if (papyrus) {
        papyrus->Register(SLSO_Bridge::RegisterFuncs);
    }

    return true;
}