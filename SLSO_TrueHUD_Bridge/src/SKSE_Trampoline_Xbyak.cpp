#include "SKSE/Trampoline.h"
#ifdef SKSE_SUPPORT_XBYAK
#include <xbyak/xbyak.h>
#include <cstring>

namespace SKSE
{
    // Provide Trampoline::allocate(Xbyak::CodeGenerator&) when the external CommonLibSSE-NG
    // library was built without SKSE_SUPPORT_XBYAK. This shim uses the existing
    // allocate(std::size_t) implementation to satisfy the missing symbol at link time.
    void* Trampoline::allocate(Xbyak::CodeGenerator& a_code)
    {
        void* result = allocate(a_code.getSize());
        std::memcpy(result, a_code.getCode(), a_code.getSize());
        return result;
    }
}
#endif
