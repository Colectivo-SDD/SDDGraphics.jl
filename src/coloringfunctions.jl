
"""
Abstract super-type for coloring functions.

Here, a coloring function is a function from the mathematical space (euclidean
plane, complex plane, etc) to the color space.

The colors used come from the current color map (really a color scheme of
**ColorSchemes.jl**) defined in `colors.jl`.
"""
abstract type AbstractColoringFunction <: Function end


"""
    RadialColoringFunction(centerx=0, centery=0 [; innerradius=0, outeradius=1])
    RadialColoringFunction(center [; innerradius=0, outeradius=1])

The radial coloring function is given by the function

\$(x,y) \\mapsto \\begin{cases}
colorscheme[0] & r \\leq innererradius \\\\
colorscheme[\\frac{r-innererradius}{outerradius-innererradius}] & \\, \\\\
colorscheme[1] & r \\geq outerradius \\\\
\\end{cases}\$

where \$r=|(x,y)-(centerx,centery)|\$.
"""
struct RadialColoringFunction <: AbstractColoringFunction
    centerx::Float64
    centery::Float64
    inrad::Float64
    outrad::Float64

    function RadialColoringFunction(x::Real=0, y::Real=0; innerradius::Real=0, outerradius::Real=1)
        @assert innerradius >= 0 && outerradius > 0 && outerradius > innerradius "Incorrect inner or outer radiuses values."
        new(x,y,innerradius,outerradius)
    end
end

RadialColoringFunction(z::Complex; innerradius::Real=0, outerradius::Real=1) =
RadialColoringFunction(real(z),imag(z),inneradius,outeradius)

RadialCF = RadialColoringFunction

center(cf::RadialColoringFunction) = cf.centerx, cf.centery
innerradius(cf::RadialColoringFunction) = cf.inrad
outerradius(cf::RadialColoringFunction) = cf.outrad


function (cf::RadialColoringFunction)(x::Real, y::Real)
    r = sqrt((x - cf.centerx)^2 + (y - cf.centery)^2)
    if r >= cf.outrad || isnan(r)
        return last(_colorarray)
    elseif r <= cf.inrad
        return first(_colorarray)
    end
    _colorscheme[(r - cf.inrad)/(cf.outrad - cf.inrad)]
end

function (cf::RadialColoringFunction)(z::Number)
    cf(real(z), imag(z))
end


"""
    AngleColoringFunction(center=0)
    AngleColoringFunction(centerx,centery)

The angle coloring function is given by the function

\$z \\mapsto colorscheme[\\frac{angle(z-center)+\\pi}{2\\pi}]\$
"""
struct AngleColoringFunction <: AbstractColoringFunction
    center::Complex{Float64}

    function AngleColoringFunction(z::Number=0)
        new(z)
    end
end

AngleColoringFunction(x::Real, y::Real) = AngleColoringFunction(complex(x,y))

AngleCF = AngleColoringFunction

center(cf::AngleColoringFunction) = cf.center


function (cf::AngleColoringFunction)(z::Number)
    if isnan(z)
        return last(_colorarray)
    end
    _colorscheme[(angle(z - cf.center) + π)/(2π)]
end

function (cf::AngleColoringFunction)(x::Real, y::Real)
    cf(complex(x,y))
end


#=
ToDo!
LinearColoringFunction (linear gradient, any direction)
RadialAngleColoringFunction (combination)
MultiRadialColoringFunction (Multi-center)
LineRadialColoringFunction
CircleRadialColoringFunction
RectangleColoringFunction (Inside rectangle one color, outside other color)
DiscColoringFunction (Inside disc one color, outside other color)
ImageColoringFunction (Colors from image's pixels)
BandColoringFunction (regular bands plane tesselation)
ChessColoringFunction (regular rectangles plane tesselation)
RadialChessColoringFunction ("regular radial rectangles" plane tesselation)
=#


_coloringfunction = RadialColoringFunction()

"Set the coloring function."
coloringfunction(cf::AbstractColoringFunction) = global _coloringfunction = cf

"Get the current coloring function."
coloringfunction() = _coloringfunction
