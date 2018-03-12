# module Hangul

# Hangul Compatibility Jamo
primitive type Jamo <: AbstractChar 32 end

# Hangul Syllables
struct Syllable
    initial::Union{Nothing,Jamo}
    medial::Union{Nothing,Jamo}
    final::Union{Nothing,Jamo}
end

struct ComposeError <: Exception
    message::String
end

struct DecomposeError <: Exception
    message::String
end

Syllable(i::Union{Nothing,Jamo}, m::Union{Nothing,Jamo}) = Syllable(i, m, nothing)

Jamo(c::UInt32) = reinterpret(Jamo, c)
Base.codepoint(c::Jamo) = reinterpret(UInt32, c)

macro _w_str(s)
  Expr(:call, ()->(Jamo ∘ first).(split(s, ' ')))
end

const 빈초성 = Jamo(0x3130)
const 빈중성 = Jamo(0x3164)
const 빈종성 = 빈초성

const 초성표 = _w"ㄱ ㄲ ㄴ ㄷ ㄸ ㄹ ㅁ ㅂ ㅃ ㅅ ㅆ ㅇ ㅈ ㅉ ㅊ ㅋ ㅌ ㅍ ㅎ"
const 중성표 = _w"ㅏ ㅐ ㅑ ㅒ ㅓ ㅔ ㅕ ㅖ ㅗ ㅘ ㅙ ㅚ ㅛ ㅜ ㅝ ㅞ ㅟ ㅠ ㅡ ㅢ ㅣ"
const 종성표 = vcat([빈종성], _w"ㄱ ㄲ ㄳ ㄴ ㄵ ㄶ ㄷ ㄹ ㄺ ㄻ ㄼ ㄽ ㄾ ㄿ ㅀ ㅁ ㅂ ㅄ ㅅ ㅆ ㅇ ㅈ ㅊ ㅋ ㅌ ㅍ ㅎ")
const 중성오프셋 = 28  # length(종성표)
const 초성오프셋 = 588 # length(중성표) * 중성오프셋  # 21 * 28
const 가 = 0xac00 # codepoint('가')
const 힣 = 0xd7a3 # codepoint('힣')

indexof(순서::Vector{Jamo}, 소리::Jamo) = findall(occursin(소리), 순서)[1]

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
            값 = 가 + 초성인덱스 + 중성인덱스
            if 종성 isa Nothing
            else
                종성인덱스 = (indexof(종성표, 종성) - 1)
                값 += 종성인덱스
            end
            Char(값)
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
        종성 = 종성표[종성인덱스]
        Syllable(초성표[초성인덱스], 중성표[중성인덱스], 종성 == 빈종성 ? nothing : 종성)
    else
        if c in 초성표
            Syllable(Jamo(c), nothing, nothing)
        elseif c in 중성표
            Syllable(nothing, Jamo(c), nothing)
        else
            throw_decompose_error(c)
        end
    end
end

# module Hangul
