#pragma once

// 1. Гарантируем отключение макросов Windows
#ifndef NOMINMAX
#define NOMINMAX
#endif

#ifndef WIN32_LEAN_AND_MEAN
#define WIN32_LEAN_AND_MEAN
#endif

// 2. Дополнительная защита: если кто-то (например, внешний SDK) уже включил их
#if defined(min)
#undef min
#endif

#if defined(max)
#undef max
#endif

// 3. Теперь безопасно подключаем CommonLib
#include "RE/Skyrim.h"
#include "SKSE/SKSE.h"

#include <cstdint>

#include <string_view>
#include <memory>
#include <algorithm>

// Windows API helpers used by some TrueHUD headers (e.g. GetModuleHandle/GetProcAddress)
#include <Windows.h>

// 4. Логирование
#include <spdlog/sinks/basic_file_sink.h>

namespace logger = SKSE::log;
using namespace std::literals;

// Additional compatibility includes pulled from TrueHUD PCH
#include <REL/Relocation.h>
#include <SimpleIni.h>

// Utility alias used in some TrueHUD sources
namespace util {
	using SKSE::stl::report_and_fail;
}

#ifdef NDEBUG
#    include <spdlog/sinks/basic_file_sink.h>
#else
#    include <spdlog/sinks/msvc_sink.h>
#endif

// Export helper and relocation macro used by TrueHUD sources
#ifndef DLLEXPORT
#define DLLEXPORT __declspec(dllexport)
#endif

#ifndef RELOCATION_OFFSET
#define RELOCATION_OFFSET(SE, AE) REL::VariantOffset(SE, AE, 0).offset()
#endif