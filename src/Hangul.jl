__precompile__(true)

module Hangul

# Hangul Compatibility Jamo
export Jamo
export Letter, Consonant, Vowel
export Syllable
export ComposeError, DecomposeError
export to_char, to_syllable
include("jamo.jl")

# Hangul Jamo
export YetJamo
export Initial, Medial, Final
export YetSyllable
export to_string
include("yetjamo.jl")

end # module
