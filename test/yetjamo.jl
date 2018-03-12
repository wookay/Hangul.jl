using Hangul # YetJamo Initial Medial Final YetSyllable ComposeError
using Test

iㄱ = YetJamo(0x1100) # ㄱ U+1100
mㅏ = YetJamo(0x1161) # ㅏ U+1161
fㄱ = YetJamo(0x11A8) # ㄱ U+11A8

@test YetSyllable(iㄱ) == YetSyllable(iㄱ, nothing, nothing) 
@test YetSyllable(mㅏ) == YetSyllable(nothing, mㅏ, nothing)
@test YetSyllable(fㄱ) == YetSyllable(nothing, nothing, fㄱ) 

@test to_string(YetSyllable(iㄱ)) == "ᄀᅠ"
@test to_string(YetSyllable(iㄱ, mㅏ)) == "가"
@test to_string(YetSyllable(iㄱ, fㄱ)) == "ᄀᅠᆨ"
@test to_string(YetSyllable(iㄱ, mㅏ, fㄱ)) == "각"
@test codepoint.(collect(to_string(YetSyllable(iㄱ, mㅏ, fㄱ)))) == [0x1100, 0x1161, 0x11a8]

@test to_string(YetSyllable(mㅏ)) == "ᅟᅡ"
@test to_string(YetSyllable(mㅏ, fㄱ)) == "ᅟᅡᆨ"
@test to_string(YetSyllable(fㄱ)) == "ᅟᅠᆨ"

@test length(to_string(YetSyllable(iㄱ))) == 2
@test length(to_string(YetSyllable(mㅏ))) == 2
@test length(to_string(YetSyllable(fㄱ))) == 3

iㅿ = YetJamo(0x1140)  # ㅿ U+1140
@test iㅿ isa YetJamo{Initial}
@test to_string(YetSyllable(iㅿ)) == "ᅀᅠ"

@test to_string(YetSyllable(iㅿ, mㅏ)) == "ᅀᅡ"
@test to_string(YetSyllable(iㅿ, mㅏ, fㄱ)) == "ᅀᅡᆨ"

@test length(to_string(YetSyllable(iㅿ))) == 2

@test Syllable(YetSyllable(iㄱ, mㅏ)) == Syllable(Jamo('ㄱ'), Jamo('ㅏ'))
@test Syllable(YetSyllable(iㄱ, mㅏ, fㄱ)) == Syllable(Jamo('ㄱ'), Jamo('ㅏ'), Jamo('ㄱ'))
@test YetSyllable(iㄱ, mㅏ) == YetSyllable(Syllable(Jamo('ㄱ'), Jamo('ㅏ')))
@test YetSyllable(iㄱ, mㅏ, fㄱ) == YetSyllable(Syllable(Jamo('ㄱ'), Jamo('ㅏ'), Jamo('ㄱ')))

@test_throws ComposeError Syllable(YetSyllable(iㅿ, mㅏ, fㄱ)) # 매핑 좀 해줘요

@test YetJamo('ᄀ') == YetJamo(0x1100) == YetJamo{Initial}(0x1100) # ㄱ U+1100
@test YetJamo('ᅡ')  == YetJamo(0x1161) == YetJamo{Medial}(0x1161)  # ㅏ U+1161
@test YetJamo('ᆨ')  == YetJamo(0x11A8) == YetJamo{Final}(0x11A8)   # ㄱ U+11A8
@test YetJamo('ᅀ') == YetJamo(0x1140) == YetJamo{Initial}(0x1140) # ㅿ U+1140

@test_throws Hangul.YetJamoError YetJamo(0)
@test_throws Hangul.YetJamoError YetJamo('a')
@test_throws Hangul.YetJamoError YetJamo('ㄱ') # 0x3131

@test YetJamo{Initial}(0x1100) == YetJamo(0x1100) == YetJamo('ᄀ') == Jamo(0x1100) == Jamo('ᄀ')
