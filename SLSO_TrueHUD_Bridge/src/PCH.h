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

// 4. Логирование
#include <spdlog/sinks/basic_file_sink.h>

namespace logger = SKSE::log;
using namespace std::literals;