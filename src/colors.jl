
@reexport using Colors, ColorVectorSpace, ColorSchemes


_ColorType = RGB{Float64}
_bgcolor = _ColorType(1,1,1) # White
_fgcolor = _ColorType(0,0,0) # Black
#_color = _ColorType(0,0,1) # Blue
#_gridcolor = _ColorType(0.5,0.5,0.5) # Gray
#_featurecolor = _ColorType(0.5,0.5,0.5) # Gray
_colorscheme = colorschemes[:jet]
_colorarray = Colorant[]

mutable struct _ColorConfig

end

"Set the color type for pixel images."
function colortype(T::DataType)
    @assert T <: Colorant
    global _ColorType = T
end # function

"Get the color type for pixel images."
colortype() = _ColorType


function _calculatecolorarray(ncolors::Integer)
    if ncolors <= 1
        global _colorarray = [ _colorscheme[1] ]
        return _colorarray
    end
    N = ncolors-1
    global _colorarray = [ _colorscheme[n/N] for n in 0:N ]
end

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

"Set the current color using the current coloring function."
color(x::Real, y::Real) = _backend.color(convert(_ColorType, _coloringfunction(x,y)))

"Set the current color using the current coloring function."
color(z::Number) = _backend.color(convert(_ColorType, _coloringfunction(z)))

"Set the current color."
color(c::Colorant) = _backend.color(convert(_ColorType, c))

"Set the current color using RGBA."
color(r::Real,g::Real,b::Real,a::Real=1) =
_backend.color(convert(_ColorType, RGBA{Float64}(r,g,b,a)))


"Get the current color"
color() = _backend.color()


"Set the current background color."
bgcolor(c::Colorant) = global _bgcolor = convert(_ColorType, c)

"Set the current background color using RGBA."
bgcolor(r::Real,g::Real,b::Real,a::Real=1) =
global _bgcolor = convert(_ColorType, RGBA{Float64}(r,g,b,a))

"Get the current background color"
bgcolor() = _bgcolor

"Set the current foreground color."
fgcolor(c::Colorant) = global _fgcolor = convert(_ColorType, c)

"Set the current foreground color using RGBA."
fgcolor(r::Real,g::Real,b::Real,a::Real=1) =
global _fgcolor = convert(_ColorType, RGBA{Float64}(r,g,b,a))

"Get the current foreground color"
fgcolor() = _fgcolor


"""
    colorinterpolationbg(t, n)

Set the current color as the  linear color interpolation using the n-th color
in the current colormap to the backgrund color.

#### Arguments
- `t::Real`: Number between \$0\$ and \$1\$.
- `n::Int`: Color index in the color array from colormap.
"""
colorinterpolationbg(t::Real, n::Int) =
_backend.color(convert(_ColorType, (1-t)*_colorarray[n]+t*_bgcolor))

"""
    colorinterpolationfg(t, n)

Set the current color as the  linear color interpolation using the n-th color
in the current colormap to the foreground color.

#### Arguments
- `t::Real`: Number between \$0\$ and \$1\$.
- `n::Int`: Color index in the color array from colormap.
"""
colorinterpolationfg(t::Real, n::Int) =
_backend.color(convert(_ColorType, (1-t)*_colorarray[n]+t*_fgcolor))
