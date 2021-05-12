
@reexport using Colors, ColorSchemes


_ColorType = RGB{Float64}
_colorscheme = colorschemes[:jet1]
_colorarray = Colorant[]


"Set the color type for pixel images."
function colortype(T::DataType)
    @assert T <: Colorant
    global _ColorType = T
end # function

"Get the color type for pixel images."
colortype() = _ColorType


_calculatecolorarray(ncolors::Integer) = global _colorarray = [ _colorscheme[n/ncolors] for n in 0:ncolors ]

_calculatecolorarray(100)


"Update the color array to new size."
function updatecolorarray(ncolors::Integer)
    if ncolors == length(_colorarray) return end
    _calculatecolorarray(ncolors)
end # function

"Get the current Color Scheme."
colorarray() = _colorarray


"""
    colorscheme(symbol,invert=false)

Set the **ColorScheme** (to define a color map), from identifier symbol.

#### Arguments
- `sym::Symbol`: Valid colorscheme symbol identifier from **ColorSchemes.jl**.
- `invert::Bool`: If true, create the color scheme with reverse colors order.
"""
function colorscheme(sym::Symbol, invert::Bool=false)
    global _colorscheme = invert ? ColorScheme(reverse(colorschemes[sym].colors)) : colorschemes[sym]
    _calculatecolorarray(length(_colorarray))
    _colorscheme
end # function

"Set the color map (setting a **ColorScheme**), from identifier symbol."
colormap(sym::Symbol, invert::Bool=false) = colorscheme(sym,invert)

"Set the **ColorScheme** to define a color map."
function colorscheme(cs::ColorScheme, invert::Bool=false)
    global _colorscheme = invert ? ColorScheme(reverse(cs.colors)) : cs
    _calculatecolorarray(length(_colorarray))
end # function

"Set the color map (setting a **ColorScheme**), from identifier symbol."
colormap(cs::ColorScheme, invert::Bool=false) = colorscheme(sym,invert)

"Get the current color map as a **ColorScheme**."
colorscheme() = _colorscheme

"Get the current color map as a **ColorScheme**."
colormap() = _colorscheme


"Set the current color from n-th color in the color array."
color(n::Integer) = _backend.color(convert(_ColorType, _colorarray[n]))

"Set the current color from t-interpolated color in the color scheme."
colorinterpolation(t::Real) = _backend.color(convert(_ColorType, _colorscheme[t]))

"Set the current color using the current color map"
color(x::Real, y::Real) = _backend.color(x,y)

#"Set the current color using the current color map"
#color(x::Real) = _backend.color(x,0)

"Set the current color using the current color map"
color(z::Number) = _backend.color(z)

"Set the current color."
color(c::Colorant) = _backend.color(convert(_ColorType, c))

"Get the current color"
color() = _backend.color()


"Set the current background color."
bgcolor(c::Colorant) = _backend.bgcolor(convert(_ColorType, c))

"Get the current background color"
bgcolor() = _backend.bgcolor()

"Set the current foreground color."
fgcolor(c::Colorant) = _backend.fgcolor(convert(_ColorType, c))

"Get the current foreground color"
fgcolor() = _backend.fgcolor()
