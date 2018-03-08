using Hangul
using Test

ga = Char('가')
@test ga isa Char
@test ga == '가'

nieun = Jamo('ㄴ')
@test nieun isa Jamo
@test nieun == 'ㄴ'

a = Jamo('ㅏ')
@test a isa Jamo
@test a == 'ㅏ'

import Hangul: 빈초성, 빈중성, 빈종성, Intermediate
@test '나' == compose(nieun, a)
@test '나' == compose(nieun, a, 빈종성)
@test (nieun, a, 빈종성) == decompose('나')

@test 'ㄱ' == compose(Jamo('ㄱ'), 빈중성, 빈종성)
@test 'ㅏ' == compose(빈초성, Jamo('ㅏ'), 빈종성)

@test Intermediate(Jamo('ㄱ'), 빈중성, Jamo('ㄴ')) == compose(Jamo('ㄱ'), 빈중성, Jamo('ㄴ'))
@test Intermediate(빈초성, Jamo('ㅏ'), Jamo('ㄴ')) == compose(빈초성, Jamo('ㅏ'), Jamo('ㄴ'))
@test Intermediate(빈초성, 빈중성, 'ㄴ') == compose(빈초성, 빈중성, Jamo('ㄴ'))
@test Intermediate(빈초성, 빈중성, 빈종성) == compose(빈초성, 빈중성, 빈종성)

@test (nieun, a, 빈종성) == decompose(compose(nieun, a))
@test (nieun, a, 빈종성) == decompose(compose(nieun, a, 빈종성))

@test (Jamo('ㄱ'), 빈중성, 빈종성) == decompose(compose(Jamo('ㄱ'), 빈중성, 빈종성))
@test (빈초성, Jamo('ㅏ'), 빈종성) == decompose(compose(빈초성, Jamo('ㅏ'), 빈종성))

@test (Jamo('ㄱ'), 빈중성, Jamo('ㄴ')) == decompose(compose(Jamo('ㄱ'), 빈중성, Jamo('ㄴ')))
@test (빈초성, Jamo('ㅏ'), Jamo('ㄴ')) == decompose(compose(빈초성, Jamo('ㅏ'), Jamo('ㄴ')))
@test (빈초성, 빈중성, 'ㄴ') == decompose(compose(빈초성, 빈중성, Jamo('ㄴ')))
@test (빈초성, 빈중성, 빈종성) == decompose(compose(빈초성, 빈중성, 빈종성))
