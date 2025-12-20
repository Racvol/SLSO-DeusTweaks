set_project("SLSO_TrueHUD_Bridge")
set_version("1.0.0")

option("build_tests")
    set_default(false)
    set_showmenu(true)
    set_description("Build unit tests")
option_end()

includes("extern/CommonLibSSE-NG")
-- Add SimpleIni as a dependency via xmake package manager
add_requires("simpleini")
-- Add xbyak (used by some TrueHUD hooks) if available
add_requires("xbyak")

target("SLSO_TrueHUD_Bridge")
    set_kind("shared")
    set_languages("cxx23")
    add_files("src/**.cpp")
    add_includedirs("include", "extern/CommonLibSSE-NG/include", "src/TrueHUD", {public = true})
    add_deps("commonlibsse-ng")
    add_defines("SKSE_SUPPORT_XBYAK=1")
    -- link xbyak package (header-only)
    add_packages("xbyak")
    -- Use unified PCH so TrueHUD headers are covered
    set_pcxxheader("src/PCH.h")
    -- Link the simpleini package (header-only)
    add_packages("simpleini")
    add_syslinks("Advapi32", "bcrypt", "D3D11", "d3dcompiler", "Dbghelp", "DXGI", "Ole32", "Version")
    add_defines("ENABLE_SKYRIM_AE=1", "ENABLE_SKYRIM_SE=1")
    set_filename("SLSO_TrueHUD_Bridge.dll")

    after_build(function (target)
        local out = target:targetfile()
        local root_dir = os.projectdir()
        local dst_dir = path.join(path.directory(root_dir), "SKSE", "Plugins")
        os.mkdir(dst_dir)
        os.cp(out, dst_dir)
        cprint("${green}[deploy]${clear} %s -> %s", path.filename(out), dst_dir)
    end)

if is_mode("debug") and has_config("build_tests") then
    target("SLSO_TrueHUD_Bridge")
        add_deps("CommonLibSSETests")
end