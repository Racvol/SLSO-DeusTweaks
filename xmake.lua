-- ==========================================================================
-- Root xmake.lua: SLSO DeusTweaks Build System (Final Stable)
-- ==========================================================================
set_project("SLSO_DeusTweaks")

-- Конфигурация: Путь к Skyrim
option("game_path")
    set_default("D:/Games/The Elder Scrolls V - Skyrim/")
    set_showmenu(true)
    set_description("Path to the Skyrim installation folder")

-- ==========================================================================
-- ЗАДАЧИ (Tasks)
-- ==========================================================================

-- 1. Сборка моста (C++ DLL)
task("build_bridge")
    set_category("action")
    set_menu({usage = "xmake build_bridge", description = "Build the TrueHUD Bridge DLL"})
    on_run(function ()
        -- Определяем локально, чтобы не зависеть от внешних scope
        local bridge_dir = "SLSO_TrueHUD_Bridge"
        
        if not os.isdir(bridge_dir) then 
            raise("Bridge directory not found: " .. bridge_dir) 
        end
        
        print("Configuring Bridge project...")
        os.execv("xmake", {"f", "-p", "windows", "-a", "x64", "-m", "release", "-y", "-P", bridge_dir})
        
        print("Building Bridge project...")
        os.execv("xmake", {"-v", "-P", bridge_dir})
    end)

-- 2. Компиляция Papyrus
task("pyro")
    set_category("action")
    set_menu({usage = "xmake pyro", description = "Compile Papyrus scripts"})
    on_run(function ()
        import("core.project.config")

        local root = os.projectdir()
        -- Защита от nil при получении конфига
        local gp = tostring(config.get("game_path") or "D:/Games/The Elder Scrolls V - Skyrim")
        
        local papyrus_exe = path.join(gp, "Papyrus Compiler", "PapyrusCompiler.exe")
        if not os.isfile(papyrus_exe) then
            raise("PapyrusCompiler.exe not found at: " .. papyrus_exe)
        end

        local output_dir = path.absolute(path.join(root, "Scripts"))
        if not os.isdir(output_dir) then os.mkdir(output_dir) end

        local imports = {
            "Scripts/Source",
            "PapyrusSources/SRC_OSLAroused",
            "PapyrusSources/SRC_XPMSE",
            "PapyrusSources/SRC_FNIS",
            "PapyrusSources/SRC_SOS",
            "PapyrusSources/SRC_SLUtilityPlus",
            "PapyrusSources/SRC_SL166b",
            "PapyrusSources/SRC_OStim",
            "PapyrusSources/SRC_ConsoleUtil",
            "PapyrusSources/SRC_MfgFix",
            "PapyrusSources/SRC_RaceMenu",
            "PapyrusSources/SRC_SkyUI",
            "PapyrusSources/SRC_PO3",
            "PapyrusSources/SRC_JContainers",
            path.join(gp, "Data", "Scripts", "Source")
        }

        local import_paths = {}
        for _, d in ipairs(imports) do
            local abs_p = path.absolute(d)
            if os.isdir(abs_p) then
                table.insert(import_paths, 1, abs_p)
            end
        end
        local import_string = table.concat(import_paths, ";")
        
        local flags_file = path.join(gp, "Data", "Scripts", "Source", "TESV_Papyrus_Flags.flg")
        local input_dir = path.absolute("Scripts/Source")
        
        local args = { input_dir, "-all", "-output=" .. output_dir, "-import=" .. import_string }
        if os.isfile(flags_file) then
            table.insert(args, "-flags=" .. flags_file)
        end

        print("Running official Papyrus Compiler...")
        os.execv(papyrus_exe, args)
        print("Success: Scripts compiled to " .. output_dir)
    end)

-- 3. Очистка
task("clean")
    set_category("action")
    set_menu({usage = "xmake clean", description = "Remove all build artifacts"})
    on_run(function ()
        local bridge_dir = "SLSO_TrueHUD_Bridge"
        
        if os.isdir(bridge_dir) then
            print("Cleaning Bridge project...")
            os.execv("xmake", {"clean", "-P", bridge_dir})
            os.rm(path.join(bridge_dir, ".xmake"))
            os.rm(path.join(bridge_dir, "build"))
        end

        print("Cleaning compiled scripts and root cache...")
        os.rm("Scripts/*.pex")
        os.rm(".xmake")
        os.rm("build")
        print("Project cleaned.")
    end)

-- 4. Мастер-задача (Используем execv вместо task.run для стабильности в HEAD версии)
task("full")
    set_category("action")
    set_menu({usage = "xmake full", description = "Build DLL and compile scripts"})
    on_run(function ()
        print(">>> Phase 1: Building C++ Bridge <<<")
        os.execv("xmake", {"build_bridge"})
        
        print(">>> Phase 2: Compiling Papyrus Scripts <<<")
        os.execv("xmake", {"pyro"})
        
        print(">>> FULL BUILD COMPLETE <<<")
    end)

task("submodules")
    set_category("action")
    on_run(function ()
        os.exec("git submodule update --init --recursive --force")
    end)

-- 5. Deploy (copy mod files into MO2 mod folder)
task("deploy")
    set_category("action")
    set_menu({usage = "xmake deploy [target]", description = "Deploy mod files to a target mod folder (default MO2 path)"})
    on_run(function ()
        import("core.project.config")
        local target = nil
        -- Priority: CLI arg > config value > ENV > default
        if #(_ARGV or {}) > 0 then
            target = _ARGV[1]
        else
            target = config.get("deploy_target") or os.getenv("DEPLOY_TARGET") or "D:/Games/Modding/MO2/mods/SLSO DeusTweaks"
        end

        print("Deploy target: " .. target)

        local items = { "SKSE", "Scripts", "Interface" }
        local root = os.projectdir()

        -- Ensure target exists
        if not os.isdir(target) then
            print("Creating target folder: " .. target)
            os.mkdir(target)
        end

        -- Remove existing folders/files
        for _, item in ipairs(items) do
            local dst = path.join(target, item)
            if os.exists(dst) then
                print("Removing existing: " .. dst)
                os.rm(dst)
            end
        end

        -- Remove SLSO.esp if exists
        local esp_dst = path.join(target, "SLSO.esp")
        if os.exists(esp_dst) then
            print("Removing existing: " .. esp_dst)
            os.rm(esp_dst)
        end

        -- Copy items
        for _, item in ipairs(items) do
            local src = path.absolute(item)
            if not os.exists(src) then
                print("Warning: source not found, skipping: " .. src)
            else
                print("Copying: " .. src .. " -> " .. path.join(target, item))
                os.cp(src, target)
            end
        end

        -- Copy esp
        local esp_src = path.absolute("SLSO.esp")
        if os.exists(esp_src) then
            print("Copying: " .. esp_src .. " -> " .. esp_dst)
            os.cp(esp_src, esp_dst)
        else
            print("Warning: SLSO.esp not found in project root: " .. esp_src)
        end

        print("Deploy finished.")
    end)