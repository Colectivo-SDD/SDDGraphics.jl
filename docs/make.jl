push!(LOAD_PATH, "./../src/")
using SDDGraphics

using Documenter
makedocs(
    modules = [SDDGraphics],
    sitename = "SDDGraphics Reference",
    format = Documenter.HTML(
        prettyurls = get(ENV, "CI", nothing) == "true",
        warn_outdated = true,
        collapselevel=1,
        )
)
