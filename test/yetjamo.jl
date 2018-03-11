using Hangul
using Test

iㄱ = YetJamo{Initial}(0x1100) # ㄱ U+1100
pㅏ = YetJamo{Peak}(0x1161)    # ㅏ U+1161
fㄱ = YetJamo{Final}(0x11A8)   # ㄱ U+11A8

@test compose(iㄱ) == "ᄀᅠ"
@test compose(iㄱ, pㅏ) == "가"
@test compose(iㄱ, fㄱ) == "ᄀᅠᆨ"
@test compose(iㄱ, pㅏ, fㄱ) == "각"

@test compose(pㅏ) == "ᅟᅡ"
@test compose(pㅏ, fㄱ) == "ᅟᅡᆨ"

@test compose(fㄱ) == "ᅟᅠᆨ"

@test 2 == length(compose(iㄱ))
@test 2 == length(compose(pㅏ))
@test 3 == length(compose(fㄱ))

iㅿ = YetJamo{Initial}(0x1140)  # ㅿ U+1140
@test iㅿ isa YetJamo{Initial}
@test compose(iㅿ) == "ᅀᅠ"

@test compose(iㅿ, pㅏ) == "ᅀᅡ"
@test compose(iㅿ, pㅏ, fㄱ) == "ᅀᅡᆨ"

@test 2 == length(compose(iㅿ))
