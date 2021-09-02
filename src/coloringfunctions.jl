
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

const RadialCF = RadialColoringFunction

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

const AngleCF = AngleColoringFunction

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


"""
    AngleBumpColoringFunction(center=0,beta=1)
    AngleBumpColoringFunction(centerx,centery,beta=1)

The angle with bump coloring function is given by the function

\$z \\mapsto colorscheme[\\frac{angle(z-center)+\\pi}{2\\pi}]/(1+\\beta|z-center|^2))\$
"""
struct AngleBumpColoringFunction <: AbstractColoringFunction
    center::Complex{Float64}
    β::Float64

    function AngleColoringFunction(z::Number=0,β::Real=1)
        new(z)
    end
end

AngleBumpColoringFunction(x::Real, y::Real, β::Real=1) =
AngleBumpColoringFunction(complex(x,y),β)

const AngleBumpCF = AngleBumpColoringFunction

center(cf::AngleBumpColoringFunction) = cf.center
bumpfactor(cf::AngleBumpColoringFunction) = cf.β


function (cf::AngleBumpColoringFunction)(z::Number)
    if isnan(z)
        return last(_colorarray)
    end
    w = z - cf.center
    _colorscheme[(angle(w) + π)/(2π)]/(1+β*abs2(w))
end

function (cf::AngleBumpColoringFunction)(x::Real, y::Real)
    cf(complex(x,y))
end



"""
    ChessColoringFunction(centerx=0,centery=0,width=1,height=1)
    ChessColoringFunction(center,width=1,height=1)

The chess coloring function.
"""
struct ChessColoringFunction <: AbstractColoringFunction
    centerx::Float64
    centery::Float64
    width::Float64
    height::Float64

    function ChessColoringFunction(x::Real=0,y::Real=0,w::Real=1,h::Real=1)
        new(x,y,w,h)
    end
end

ChessColoringFunction(z::Number,w::Real=1,h::Real=1) =
ChessColoringFunction(real(x),imag(y),w,h)

const ChessCF = ChessColoringFunction

center(cf::ChessColoringFunction) = complex(cf.centerx, cf.centery)
centerx(cf::ChessColoringFunction) = cf.centerx
centery(cf::ChessColoringFunction) = cf.centery
width(cf::ChessColoringFunction) = cf.width
height(cf::ChessColoringFunction) = cf.height


function (cf::ChessColoringFunction)(x::Real, y::Real)
    if abs(x) >= typemax(Int64) || abs(y) >= typemax(Int64) || isnan(x) || isnan(y)
        return _colorscheme[0.5]
    end
    if floor(Int64, mod1(cf.centerx + x/cf.width, 2)) == floor(Int64, mod1(cf.centery + y/cf.height, 2))
        return first(_colorarray)
    end
    last(_colorarray)
end

function (cf::ChessColoringFunction)(z::Number)
    cf(real(z), imag(z))
end



#=
ToDo!
LinearColoringFunction (linear gradient, any direction)
RadialAngleColoringFunction (combination) ???
MultiRadialColoringFunction (Multi-center) ???
LineBumpColoringFunction
CircleBumpColoringFunction
RectangleColoringFunction (Inside rectangle one color, outside other color)
DiscColoringFunction (Inside disc one color, outside other color)
ImageColoringFunction (Colors from image's pixels)
BandColoringFunction (regular bands plane tesselation, check chess)
RadialChessColoringFunction ("regular radial rectangles" plane tesselation)
=#


_coloringfunction = RadialColoringFunction()

"Set the coloring function."
coloringfunction(cf::AbstractColoringFunction) = global _coloringfunction = cf

"Get the current coloring function."
coloringfunction() = _coloringfunction
