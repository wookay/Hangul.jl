# module Hangul

# 첫가끝
const Initial = :Initial
const Peak = :Peak
const Final = :Final

primitive type YetJamo{T} <: AbstractChar 32 end

const 초성채움 = Char(0x115F)
const 중성채움 = Char(0x1160)

YetJamo{T}(c::UInt32) where T = reinterpret(YetJamo{T}, c)
Base.codepoint(c::YetJamo{T}) where T = reinterpret(UInt32, c)

compose(i::YetJamo{Initial}) = string(i, 중성채움)
compose(i::YetJamo{Initial}, p::YetJamo{Peak}) = string(i, p)
compose(i::YetJamo{Initial}, f::YetJamo{Final}) = string(i, 중성채움, f)
compose(i::YetJamo{Initial}, p::YetJamo{Peak}, f::YetJamo{Final}) = string(i, p, f)

compose(p::YetJamo{Peak}) = string(초성채움, p)
compose(p::YetJamo{Peak}, f::YetJamo{Final}) = string(초성채움, p, f)

compose(f::YetJamo{Final}) = string(초성채움, 중성채움, f)

# module Hangul
