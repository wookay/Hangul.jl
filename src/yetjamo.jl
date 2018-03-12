# module Hangul

# 첫가끝
const Initial = :Initial
const Medial  = :Medial
const Final   = :Final

# Hangul Jamo
primitive type YetJamo{T} <: AbstractChar 32 end

struct YetJamoError <: Exception
    message::String
end

struct YetSyllable
    initial::Union{Nothing,YetJamo{Initial}}
    medial::Union{Nothing,YetJamo{Medial}}
    final::Union{Nothing,YetJamo{Final}}
end

YetJamo{T}(c::UInt32) where T = reinterpret(YetJamo{T}, c)
Base.codepoint(c::YetJamo{T}) where T = reinterpret(UInt32, c)

YetSyllable(i::YetJamo{Initial}) = YetSyllable(i, nothing, nothing)
YetSyllable(m::YetJamo{Medial}) = YetSyllable(nothing, m, nothing)
YetSyllable(f::YetJamo{Final}) = YetSyllable(nothing, nothing, f)

YetSyllable(i::YetJamo{Initial}, m::YetJamo{Medial}) = YetSyllable(i, m, nothing)
YetSyllable(i::YetJamo{Initial}, f::YetJamo{Final}) = YetSyllable(i, nothing, f)
YetSyllable(m::YetJamo{Medial}, f::YetJamo{Final}) = YetSyllable(nothing, m, f)

const 초성채움 = Char(0x115F)
const 중성채움 = Char(0x1160)

function to_string(ysyl::YetSyllable)::String
    초성, 중성, 종성 = ysyl.initial, ysyl.medial, ysyl.final
    if 초성 isa Nothing
        if 중성 isa Nothing
            if 종성 isa Nothing
                string()
            else
                string(초성채움, 중성채움, 종성)
            end
        else # 초성x, 중성o
            if 종성 isa Nothing
                string(초성채움, 중성)
            else
                string(초성채움, 중성, 종성)
            end
        end
    else # 초성o
        if 중성 isa Nothing
            if 종성 isa Nothing
                string(초성, 중성채움)
            else
                string(초성, 중성채움, 종성)
            end
        else # 초성o, 중성o
            if 종성 isa Nothing
                string(초성, 중성)
            else
                string(초성, 중성, 종성)
            end
        end
    end
end

const 초성ㄱ = 0x1100
const 중성ㅏ = 0x1161
const 종성ㄱ = 0x11a8

function is_yetjamo(c::Union{UInt16,UInt32})::Bool
    초성ㄱ <= c <= 0x115f || # ㄱ   ... HCF
    0xa960 <= c <= 0xa97c || # ㄷㅁ ... ㆆㆆ # Hangul Jamo Extended-A
    0x1160 <= c <= 0x11a7 || # HJF ... ㅗㅒ
    0xd7b0 <= c <= 0xd7c6 || # ㅗㅕ... .ㅔ  # Hangul Jamo Extended-B
    종성ㄱ <= c <= 0x11ff || # ㄱ   ... ㄴㄴ
    0xd7cb <= c <= 0xd7fb    # ㄴㄹ ... ㅍㅌ  # Hangul Jamo Extended-B 
end

function YetJamo(c::UInt32)::YetJamo # YetJamoError
    if 초성ㄱ <= c <= 0x115f || # ㄱ   ... HCF
       0xa960 <= c <= 0xa97c    # ㄷㅁ ... ㆆㆆ # Hangul Jamo Extended-A
        YetJamo{Initial}(c)
    elseif 0x1160 <= c <= 0x11a7 || # HJF ... ㅗㅒ
           0xd7b0 <= c <= 0xd7c6    # ㅗㅕ... .ㅔ  # Hangul Jamo Extended-B
        YetJamo{Medial}(c)
    elseif 종성ㄱ <= c <= 0x11ff || # ㄱ   ... ㄴㄴ
           0xd7cb <= c <= 0xd7fb    # ㄴㄹ ... ㅍㅌ  # Hangul Jamo Extended-B 
        YetJamo{Final}(c)
    else
        throw(YetJamoError(string(c)))
    end
end

function YetSyllable(syl::Syllable)::YetSyllable
    if syl.initial isa Nothing
        초성 = nothing
    else
        초성 = YetJamo{Initial}(초성ㄱ + indexof(초성표, syl.initial) - 1)
    end
    if syl.medial isa Nothing
        중성 = nothing
    else
        중성 = YetJamo{Medial}(중성ㅏ + indexof(중성표, syl.medial) - 1)
    end
    if syl.final isa Nothing
        종성 = nothing
    else
        종성 = YetJamo{Final}(종성ㄱ + indexof(종성표, syl.final) - 1 - 1)
    end
    YetSyllable(초성, 중성, 종성)
end

# 매핑 좀 해줘요
# 
#   Hangul Jamo - Range: 1100–11FF
#   http://www.unicode.org/charts/PDF/U1100.pdf
#
#   Hangul Compatibility Jamo - Range: 3130–318F
#   http://www.unicode.org/charts/PDF/U3130.pdf

function throw_compose_error(ysyl::YetSyllable) # ComposeError
    throw(ComposeError(string("매핑 좀 해줘요 ", ysyl)))
end

function Syllable(ysyl::YetSyllable)::Syllable # ComposeError
    if ysyl.initial isa Nothing
        초성 = nothing
    else
        인덱스 = Int(ysyl.initial - 초성ㄱ) + 1
        if 1 <= 인덱스 <= 19 # length(초성표)
            초성 = Letter{Consonant}(초성표[인덱스])
        else
            throw_compose_error(ysyl) # 매핑 좀 해줘요
        end
    end
    if ysyl.medial isa Nothing
        중성 = nothing
    else
        인덱스 = Int(ysyl.medial - 중성ㅏ) + 1
        if 1 <= 인덱스 <= 21 # length(중성표)
            중성 = Letter{Vowel}(중성표[인덱스])
        else
            throw_compose_error(ysyl) # 매핑 좀 해줘요
        end
    end
    if ysyl.final isa Nothing
        종성 = nothing
    else
        인덱스 = Int(ysyl.final - 종성ㄱ + 1) + 1
        if 1 <= 인덱스 <= 28 # length(종성표)
            종성 = Letter{Consonant}(종성표[인덱스])
        else
            throw_compose_error(ysyl) # 매핑 좀 해줘요
        end
    end
    Syllable(초성, 중성, 종성)
end

# module Hangul
