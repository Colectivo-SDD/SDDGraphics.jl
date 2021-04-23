
"""
Abstract super-type for color maps.

Here, a color map is a function from the mathematical space (real line,
complex plane, etcetera) to the color space.

The colors used come from the current color scheme (**ColorSchemes.jl**)
defined in `colors.jl`.
"""
abstract type AbstractColorMap end


"""
    RadialColorMap(x,y,inner,outer)


"""
struct RadialColorMap <: AbstractColorMap
    centerx::Float64
    centery::Float64
    innerradius::Float64
    outerradius::Float64

    function RadialColorMap(x::Real=0, y::Real=0, irad::Real=0, orad::Real=1)
        @assert irad >= 0 && orad > 0 && orad > irad "Incorrect inner or outer radiuses values."
        new(x,y,irad,orad)
    end
end

RadialColorMap(x::Real=0, y::Real=0; inner::Real=0, outer::Real=1) = RadialColorMap(x,y,inner,outer)

RadialColorMap(z::Complex; inner::Real=0, outer::Real=1) = RadialColorMap(real(z),imag(z),inner,outer)


function (cm::RadialColorMap)(x::Real, y::Real)
    r = sqrt((x-centerx)^2 + (y-centery)^2)
    if r <= innerradius
        return first(_colorarray)
    elseif r >= outerradius
        return last(_colorarray)
    end
    r -= innerradius
    _colorscheme[r/(outerradius - innerradius)]
end

function (cm::RadialColorMap)(z::Number) = cm(real(z), imag(z))


"""
    AngleColorMap(x,y)


"""
struct AngleColorMap <: AbstractColorMap
    center::Complex{Float64}

    function AngleColorMap(z::Number=0)
        new(z)
    end
end

AngleColorMap(x::Real, y::Real) = AngleColorMap(complex(x,y))


function (cm::AngleColorMap)(z::Number)
    _colorscheme[(angle(z - center) + π)/(2π)]
end

function (cm::AngleColorMap)(x::Real, y::Real) = cm(complex(x,y))


#=
ToDo!
LinearColorMap (linear gradient, any direction)
RadialAngleColorMap (combination)
MultiRadialColorMap
LineRadialColorMap
CircleRadialColorMap
RectangleColorMap (Inside rectangle one color, outside other color)
CircleColorMap (Inside circle one color, outside other color)
ImageColorMap (Colors from image's pixels)
BandColorMap (regular bands plane tesselation) ???
ChessColorMap (regular rectangles plane tesselation)
HexColorMap (regular HexColorMapgones plane tesselation) ???
TriColorMap (regular triangles plane tesselation) ???
=#

_colormap = RadialColorMap()

"Set the color map."
colormap(cm::AbstractColorMap) = global _colormap = cm

#colormap() = _colormap
