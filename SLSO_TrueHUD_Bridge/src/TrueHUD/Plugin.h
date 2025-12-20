#pragma once

#include <string_view>
#include <REL/Relocation.h>

namespace Plugin
{
    using namespace std::literals;

    inline constexpr REL::Version VERSION{ 1u, 0u, 0u, 0u };
    inline constexpr auto NAME = "TrueHUD"sv;
}
