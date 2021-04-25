
"""
Abstract super-type for color maps.

Here, a color map is a function from the mathematical space (real line,
complex plane, etcetera) to the color space.

The colors used come from the current color scheme (**ColorSchemes.jl**)
defined in `colors.jl`.
"""
abstract type AbstractColorMap end


"""
    RadialColorMap(centerx=0, centery=0 [; innerradius=0,outeradius=1])
    RadialColorMap(center [; innerradius=0,outeradius=1])

The radial color map is given by the function

\$(x,y) \\mapsto \\begin{cases}
colorscheme[0] & r \\leq innererradius \\\\
colorscheme[\\frac{r-innererradius}{outerradius-innererradius}] & \\, \\\\
colorscheme[1] & r \\geq outerradius \\\\
\\end{cases}\$

where \$r=|(x,y)-(centerx,centery)|\$.
"""
struct RadialColorMap <: AbstractColorMap
    centerx::Float64
    centery::Float64
    inrad::Float64
    outrad::Float64

    function RadialColorMap(x::Real=0, y::Real=0; innerradius::Real=0, outerradius::Real=1)
        @assert innerradius >= 0 && outerradius > 0 && outerradius > innerradius "Incorrect inner or outer radiuses values."
        new(x,y,innerradius,outerradius)
    end
end

RadialColorMap(z::Complex; innerradius::Real=0, outerradius::Real=1) = RadialColorMap(real(z),imag(z),inneradius,outeradius)

center(cm::RadialColorMap) = cm.centerx, cm.centery
innerradius(cm::RadialColorMap) = cm.inrad
outerradius(cm::RadialColorMap) = cm.outrad


function (cm::RadialColorMap)(x::Real, y::Real)
    r = sqrt((x - cm.centerx)^2 + (y - cm.centery)^2)
    if r >= cm.outrad || isnan(r)
        return last(_colorarray)
    elseif r <= cm.inrad
        return first(_colorarray)
    end
    _colorscheme[(r - cm.inrad)/(cm.outrad - cm.inrad)]
end

function (cm::RadialColorMap)(z::Number)
    cm(real(z), imag(z))
end


"""
    AngleColorMap(center=0)
    AngleColorMap(centerx,centery)

The angle color map is given by the function

\$z \\mapsto colorscheme[\\frac{angle(z-center)+\\pi}{2\\pi}]\$
"""
struct AngleColorMap <: AbstractColorMap
    center::Complex{Float64}

    function AngleColorMap(z::Number=0)
        new(z)
    end
end

AngleColorMap(x::Real, y::Real) = AngleColorMap(complex(x,y))

center(cm::AngleColorMap) = cm.center


function (cm::AngleColorMap)(z::Number)
    if isnan(z)
        return last(_colorarray)
    end
    _colorscheme[(angle(z - cm.center) + π)/(2π)]
end

function (cm::AngleColorMap)(x::Real, y::Real)
    cm(complex(x,y))
end


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
BandColorMap (regular bands plane tesselation)
ChessColorMap (regular rectangles plane tesselation)
RadialChessColorMap ("regular radial rectangles" plane tesselation)
=#


_colormap = RadialColorMap()

"Set the color map."
colormap(cm::AbstractColorMap) = global _colormap = cm

"Get the current color map."
colormap() = _colormap
