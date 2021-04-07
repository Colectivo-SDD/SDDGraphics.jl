
using Colors, ColorSchemes
export Colors, ColorSchemes


_ColorType = RGB{Float64}
_colorscheme = colorschemes[:jet1]
_colorarray = Colorant[]


"Set the color type for pixel images."
function colortype(T::DataType)
    @assert typeof(T) <: Colorant
    global _ColorType = T
end # function

"Get the color type for pixel images."
colortype() = _ColorType


_calculatecolorarray(ncolors::Integer) =
    global _colorarray = [ _colorscheme[n/ncolors] for n in 0:ncolors ]

_calculatecolorarray(100)


"Update the color array to new size."
function updatecolorarray(ncolors::Integer)
    if ncolors == length(_colorarray) return end
    _calculatecolorarray(ncolors)
end # function

"Get the current Color Scheme."
colorarray() = _colorarray


"Set the Color Scheme, from identifier symbol."
function colorscheme(sym::Symbol)
    global _colorscheme = colorschemes[sym]
    _calculatecolorarray(length(_colorarray))
end # function

"Set the Color Scheme."
function colorscheme(cs::ColorScheme)
    global _colorscheme = cs
    _calculatecolorarray(length(_colorarray))
end # function

"Get the current Color Scheme."
colorscheme() = _colorscheme


"Set the current color from n-th color in the color array."
color(n::Integer) = _backend.color(convert(_ColorType, _colorarray[n]))

"Set the current color from t-interpolated color in the color scheme."
color(t::Real) = _backend.color(convert(_ColorType, _colorscheme[t]))

"Set the current color."
color(c::Colorant) = _backend.color(convert(_ColorType, c))

"Get the current color"
color() = _backend.color()


"Set the current background color."
bgcolor(c::Colorant) = _backend.bgcolor(convert(_ColorType, c))

"Get the current background color"
bgcolor() = _backend.bgcolor()
