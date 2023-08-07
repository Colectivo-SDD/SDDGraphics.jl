
#
# Colors and ColorSchemes utilities
#

@reexport using Colors, ColorVectorSpace, ColorSchemes
# ColorVectorSpace = "c3611d14-8923-5661-9e6a-0046d554d3a4"

#import Base.reverse


"""
Return the reversed color array in a `ColorScheme` colormap.
"""
#reverse(cs::ColorScheme) = Base.reverse(cs.colors)
#reverse(s::Symbol) = Base.reverse(colorschemes[s].colors)


"""
Return the color array in a `ColorScheme` colormap (or array of colors), with a given alpha.
"""
withalpha(ca::Vector{<:Colorant}, a::Real=0.5) = [ RGBA(c,a) for c in ca ]
withalpha(cs::ColorScheme, a::Real=0.5) = [ RGBA(c,a) for c in cs.colors ]
withalpha(s::Symbol, a::Real=0.5) = withalpha(colorschemes[s], a)


"""
Return the color array in a `ColorScheme` colormap (or array of colors),
with alpha values given by a function \$\\alpha:[0,1]\\rightarow [0,1]\$,
\$\\alpha((colorindex-1)/numcolors)=...\$
"""
withalpha(ca::Vector{<:Colorant}, a::Function) = [ RGBA(c[n],a[(n-1)/(length(ca)-1)]) for n in 1:(length(ca)) ]
withalpha(cs::ColorScheme, a::Function) = [ RGBA(cs.colors[n], a((n-1)/length(cs.colors))) for n in 1:length(cs.colors) ] 
withalpha(s::Symbol, a::Function) = withalpha(colorschemes[s], a)

