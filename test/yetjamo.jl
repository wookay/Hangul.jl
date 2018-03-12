using Hangul
using Test

iㄱ = YetJamo{Initial}(0x1100) # ㄱ U+1100
mㅏ = YetJamo{Medial}(0x1161)  # ㅏ U+1161
fㄱ = YetJamo{Final}(0x11A8)   # ㄱ U+11A8

@test YetSyllable(iㄱ) == YetSyllable(iㄱ, nothing, nothing) 
@test YetSyllable(mㅏ) == YetSyllable(nothing, mㅏ, nothing)
@test YetSyllable(fㄱ) == YetSyllable(nothing, nothing, fㄱ) 

@test to_string(YetSyllable(iㄱ)) == "ᄀᅠ"
@test to_string(YetSyllable(iㄱ, mㅏ)) == "가"
@test to_string(YetSyllable(iㄱ, fㄱ)) == "ᄀᅠᆨ"
@test to_string(YetSyllable(iㄱ, mㅏ, fㄱ)) == "각"

@test to_string(YetSyllable(mㅏ)) == "ᅟᅡ"
@test to_string(YetSyllable(mㅏ, fㄱ)) == "ᅟᅡᆨ"

@test to_string(YetSyllable(fㄱ)) == "ᅟᅠᆨ"

@test 2 == length(to_string(YetSyllable(iㄱ)))
@test 2 == length(to_string(YetSyllable(mㅏ)))
@test 3 == length(to_string(YetSyllable(fㄱ)))

iㅿ = YetJamo{Initial}(0x1140)  # ㅿ U+1140
@test iㅿ isa YetJamo{Initial}
@test to_string(YetSyllable(iㅿ)) == "ᅀᅠ"

@test to_string(YetSyllable(iㅿ, mㅏ)) == "ᅀᅡ"
@test to_string(YetSyllable(iㅿ, mㅏ, fㄱ)) == "ᅀᅡᆨ"

@test 2 == length(to_string(YetSyllable(iㅿ)))

@test Syllable(YetSyllable(iㄱ, mㅏ)) == Syllable(Jamo('ㄱ'), Jamo('ㅏ'))
@test Syllable(YetSyllable(iㄱ, mㅏ, fㄱ)) == Syllable(Jamo('ㄱ'), Jamo('ㅏ'), Jamo('ㄱ'))
@test YetSyllable(iㄱ, mㅏ) == YetSyllable(Syllable(Jamo('ㄱ'), Jamo('ㅏ')))
@test YetSyllable(iㄱ, mㅏ, fㄱ) == YetSyllable(Syllable(Jamo('ㄱ'), Jamo('ㅏ'), Jamo('ㄱ')))

@test_throws ComposeError Syllable(YetSyllable(iㅿ, mㅏ, fㄱ))
