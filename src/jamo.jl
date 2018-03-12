# module Hangul

# 자음 모음
const Consonant = :Consonant
const Vowel     = :Vowel

# Hangul Compatibility Letter
primitive type Letter{T} <: AbstractChar 32 end

# Hangul Syllables
struct Syllable
    initial::Union{Nothing,Letter{Consonant}}
    medial::Union{Nothing,Letter{Vowel}}
    final::Union{Nothing,Letter{Consonant}}
end

struct ComposeError <: Exception
    message::String
end

struct DecomposeError <: Exception
    message::String
end

struct LetterError <: Exception
    message::String
end

Syllable(i::Union{Nothing,Letter{Consonant}}, m::Union{Nothing,Letter{Vowel}}) = Syllable(i, m, nothing)

Letter{T}(c::UInt32) where T = reinterpret(Letter{T}, c)
Base.codepoint(l::Letter{T}) where T = reinterpret(UInt32, l)

function Jamo(c::Char)::Letter # LetterError
    Jamo(codepoint(c))
end

function Jamo(c::Union{UInt16,UInt32})::Union{Letter,YetJamo} # LetterError
    # 0x3130 : undef
    # 0x318f : undef
    if 0x3131 <= c <= 0x314e || # ㄱ   ... ㅎ  # Consonant letters
       0x3165 <= c <= 0x3186    # ㄴㄴ ... ㆆ  # Old consonant letters
        Letter{Consonant}(c)
    elseif 0x314f <= c <= 0x3163 || # ㅏ ... ㅣ   # Vowel letters
           0x3187 <= c <= 0x318e    # ㆇ ... ㆎ   # Old vowel letters
        Letter{Vowel}(c)
    elseif is_yetjamo(c)
        YetJamo(c)
    else
        throw(LetterError(string(c)))
    end
end

macro _w_str(s::String) # Vector{Char}
    Expr(:call, ()->first.(split(s, ' ')))
end

const 모음채움 = Letter{Vowel}(0x3164)     # HANGUL FILLER
const 자음채움 = Letter{Consonant}(0x318f) # ?

const 초성표 = Letter{Consonant}.(_w"ㄱ ㄲ ㄴ ㄷ ㄸ ㄹ ㅁ ㅂ ㅃ ㅅ ㅆ ㅇ ㅈ ㅉ ㅊ ㅋ ㅌ ㅍ ㅎ")
const 중성표 = Letter{Vowel}.(_w"ㅏ ㅐ ㅑ ㅒ ㅓ ㅔ ㅕ ㅖ ㅗ ㅘ ㅙ ㅚ ㅛ ㅜ ㅝ ㅞ ㅟ ㅠ ㅡ ㅢ ㅣ")
const 종성표 = Letter{Consonant}.(vcat([자음채움], _w"ㄱ ㄲ ㄳ ㄴ ㄵ ㄶ ㄷ ㄹ ㄺ ㄻ ㄼ ㄽ ㄾ ㄿ ㅀ ㅁ ㅂ ㅄ ㅅ ㅆ ㅇ ㅈ ㅊ ㅋ ㅌ ㅍ ㅎ"))

const 중성오프셋 = 28  # length(종성표)
const 초성오프셋 = 588 # length(중성표) * 중성오프셋  # 21 * 28
const 가 = 0xac00 # codepoint('가')
const 힣 = 0xd7a3 # codepoint('힣')

indexof(순서::Vector{Letter{T}}, 소리::Letter{T}) where T = findall(occursin(소리), 순서)[1]

function throw_compose_error(syl::Syllable) # ComposeError
    throw(ComposeError(string(syl)))
end

function throw_decompose_error(c::Char) # DecomposeError
    throw(DecomposeError(string(c)))
end

function to_char(syl::Syllable)::Char # ComposeError
    초성, 중성, 종성 = syl.initial, syl.medial, syl.final
    if 초성 isa Nothing
        if 중성 isa Nothing
            if 종성 isa Nothing
                throw_compose_error(syl)
            else
                Char(종성)
            end
        else # 초성x, 중성o
            if 종성 isa Nothing
                Char(중성)
            else
                throw_compose_error(syl)
            end
        end
    else # 초성o
        if 중성 isa Nothing
            if 종성 isa Nothing
                Char(초성)
            else
                throw_compose_error(syl)
            end
        else # 초성o, 중성o
            초성인덱스 = (indexof(초성표, 초성) - 1) * 초성오프셋
            중성인덱스 = (indexof(중성표, 중성) - 1) * 중성오프셋
            value = 가 + 초성인덱스 + 중성인덱스
            if 종성 isa Nothing
            else
                종성인덱스 = indexof(종성표, 종성) - 1
                value += 종성인덱스
            end
            Char(value)
        end
    end
end

function to_syllable(c::Char)::Syllable # DecomposeError
    code = codepoint(c)
    if 가<= code <= 힣
        value::UInt32 = code - 가
        초성인덱스 = Int(round(value / 초성오프셋, RoundToZero)) + 1
        n = value % 초성오프셋
        중성인덱스 = Int(round(n / 중성오프셋, RoundToZero)) + 1
        종성인덱스 = Int(n % 중성오프셋) + 1
        Syllable(초성표[초성인덱스], 중성표[중성인덱스], 1 == 종성인덱스 ? nothing : 종성표[종성인덱스])
    else
        if c in 초성표
            Syllable(Letter{Consonant}(c), nothing, nothing)
        elseif c in 중성표
            Syllable(nothing, Letter{Vowel}(c), nothing)
        else
            throw_decompose_error(c)
        end
    end
end

# module Hangul
