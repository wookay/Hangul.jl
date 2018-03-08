# module Hangul

primitive type Jamo <: AbstractChar 32 end

struct Intermediate
    initial::Jamo
    medial::Jamo
    final::Jamo
end

Jamo(c::UInt32) = reinterpret(Jamo, c)
Base.codepoint(c::Jamo) = reinterpret(UInt32, c)

macro _w_str(s)
  Expr(:call, ()->(Jamo ∘ first).(split(s, ' ')))
end

const 빈초성 = Jamo(0x3130)
const 빈중성 = Jamo(0x3164)
const 빈종성 = Jamo(0x3130)
# const 초성채움 = Jamo(0x115F)
# const 중성채움 = Jamo(0x1160)
const 초성표 = _w"ㄱ ㄲ ㄴ ㄷ ㄸ ㄹ ㅁ ㅂ ㅃ ㅅ ㅆ ㅇ ㅈ ㅉ ㅊ ㅋ ㅌ ㅍ ㅎ"
const 중성표 = _w"ㅏ ㅐ ㅑ ㅒ ㅓ ㅔ ㅕ ㅖ ㅗ ㅘ ㅙ ㅚ ㅛ ㅜ ㅝ ㅞ ㅟ ㅠ ㅡ ㅢ ㅣ"
const 종성표 = vcat([빈종성], _w"ㄱ ㄲ ㄳ ㄴ ㄵ ㄶ ㄷ ㄹ ㄺ ㄻ ㄼ ㄽ ㄾ ㄿ ㅀ ㅁ ㅂ ㅄ ㅅ ㅆ ㅇ ㅈ ㅊ ㅋ ㅌ ㅍ ㅎ")
const 중성오프셋 = length(종성표) # 28
const 초성오프셋 = length(중성표) * 중성오프셋 # 21 * 28
const 가 = codepoint('가') # 0xac00
const 힣 = codepoint('힣') # 0xd7a3

indexof(순서::Vector{Jamo}, 소리::Jamo) = findall(occursin(소리), 순서)[1]

compose(초성::Jamo, 중성::Jamo)::Char = compose(초성, 중성, 빈종성)
function compose(초성::Jamo, 중성::Jamo, 종성::Jamo)::Union{Char,Intermediate}
    if 빈중성 == 중성
        if 빈초성 == 초성
            Intermediate(초성, 중성, 종성)
        else
            if 빈종성 == 종성
                Char(초성)
            else
                Intermediate(초성, 중성, 종성)
            end
        end
    else
        if 빈초성 == 초성
            if 빈종성 == 종성
                Char(중성)
            else
                Intermediate(초성, 중성, 종성)
            end
        else
            초성인덱스 = (indexof(초성표, 초성) - 1) * 초성오프셋
            중성인덱스 = (indexof(중성표, 중성) - 1) * 중성오프셋
            종성인덱스 = (indexof(종성표, 종성) - 1)
            값 = 가 + 초성인덱스 + 중성인덱스 + 종성인덱스
            Char(값)
        end
    end
end

function decompose(i::Intermediate)::Tuple{Jamo, Jamo, Jamo}
    (i.initial, i.medial, i.final)
end

function decompose(c::Char)::Tuple{Jamo, Jamo, Jamo}
    if c in 초성표
        (Jamo(c), 빈중성, 빈종성)
    elseif c in 중성표
        (빈초성, Jamo(c), 빈종성)
    else
        값::UInt32 = c - 가
        초성인덱스 = Int(값 / 초성오프셋) + 1
        값 %= 초성오프셋
        중성인덱스 = Int(값 / 중성오프셋) + 1
        종성인덱스 = Int(값 % 중성오프셋) + 1
        (초성표[초성인덱스],
         중성표[중성인덱스],
         종성표[종성인덱스])
    end
end

# module Hangul
