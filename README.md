# Hangul

[![Latest](https://img.shields.io/badge/docs-latest-blue.svg)](https://wookay.github.io/docs/Hangul.jl/)

[![Travis CI](https://api.travis-ci.org/wookay/Hangul.jl.svg?branch=master)](https://travis-ci.org/wookay/Hangul.jl)

[![Build status](https://ci.appveyor.com/api/projects/status/16v354v47q72lwwp?svg=true)](https://ci.appveyor.com/project/wookay/hangul-jl)


⌨️  한글 처리

### Jamo
 * `Jamo` -> `Union{Letter,YetJamo}`

### Hangul Compatibility Letter
 * 자음모음 `Letter{T}`
 * `Syllable`
 * `to_char`
 * `to_syllable`

### Hangul Jamo
 * 첫가끝 `YetJamo{T}`
 * `YetSyllable`
 * `to_string`
