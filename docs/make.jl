using Documenter, Hangul

makedocs(
    modules = [Hangul],
    clean = false,
    format = :html,
    sitename = "Hangul.jl",
    authors = "WooKyoung Noh",
    pages = Any[
        "Home" => "index.md",
        "Jamo" => "Jamo.md",
        "YetJamo" => "YetJamo.md",
    ],
    html_prettyurls = !("local" in ARGS),
)
