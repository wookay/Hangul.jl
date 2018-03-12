__precompile__(true)

module Hangul

# Hangul Compatibility Jamo
export Jamo, Syllable
export ComposeError, DecomposeError
export to_char, to_syllable
include("jamo.jl")

# Hangul Jamo
export YetJamo, YetSyllable
export Initial, Medial, Final
export to_string
include("yetjamo.jl")

end # module
