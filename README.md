# Hangul

|  **Documentation**                        |  **Build Status**                                                 |
|:-----------------------------------------:|:-----------------------------------------------------------------:|
|  [![][docs-latest-img]][docs-latest-url]  |  [![][travis-img]][travis-url] [![][appveyor-img]][appveyor-url]  |


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



[docs-latest-img]: https://img.shields.io/badge/docs-latest-blue.svg
[docs-latest-url]: https://wookay.github.io/docs/Hangul.jl/

[travis-img]: https://api.travis-ci.org/wookay/Hangul.jl.svg?branch=master
[travis-url]: https://travis-ci.org/wookay/Hangul.jl

[appveyor-img]: https://ci.appveyor.com/api/projects/status/16v354v47q72lwwp?svg=true
[appveyor-url]: https://ci.appveyor.com/project/wookay/hangul-jl
