using Hangul # Jamo Syllable to_char to_syllable
using Test

g = Jamo('ㄱ')
@test g isa Jamo
@test g == 'ㄱ'

o = Jamo('ㅗ')
@test o isa Jamo
@test o == 'ㅗ'

m = Jamo('ㅁ')
@test m isa Jamo
@test m == 'ㅁ'

@test '고' == to_char(Syllable(g, o))
@test '고' == to_char(Syllable(g, o, nothing))
@test '곰' == to_char(Syllable(g, o, m))

@test 'ㄱ' == to_char(Syllable(g, nothing, nothing))
@test 'ㅗ' == to_char(Syllable(nothing, o, nothing))
@test 'ㅁ' == to_char(Syllable(nothing, nothing, m))

@test_throws ComposeError to_char(Syllable(g, nothing, m))
@test_throws ComposeError to_char(Syllable(nothing, o, m))
@test_throws ComposeError to_char(Syllable(nothing, nothing, nothing))

@test Syllable(g, o, nothing) == to_syllable('고')
@test Syllable(g, o, m) == to_syllable('곰')
@test Syllable(g, nothing, nothing) == to_syllable('ㄱ')
@test Syllable(nothing, o, nothing) == to_syllable('ㅗ')

@test_throws DecomposeError to_syllable('ㄳ') # 종성은 DecomposeError
@test_throws DecomposeError to_syllable('a')
