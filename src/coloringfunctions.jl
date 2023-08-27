
"""
Abstract super-type for coloring functions.

Here, a coloring function is a function from the mathematical space (euclidean
plane, complex plane, etc) to the color space.
"""
abstract type AbstractColoringFunction <: Function end

#The colors used come from the current color map (really a color scheme of
#**ColorSchemes.jl**) defined in `colors.jl`.


"""
    DiscColoringFunction(centerx=0, centery=0 [; radius=1])
    DiscColoringFunction(center [; radius=1])

Coloring with the \$0\$ color if inside of disc and \$1\$ if outside
"""
struct DiscColoringFunction <: AbstractColoringFunction
    centerx::Float64
    centery::Float64
    rad::Float64

    function DiscColoringFunction(x::Real=0, y::Real=0; radius::Real=1)
        @assert radius > 0 "Incorrect inner or outer radius value."
        new(x,y,radius)
    end
end

DiscColoringFunction(z::Complex; radius::Real=1)=DiscColoringFunction(real(z),imag(z),radius=radius)

const DiscCF = DiscColoringFunction

center(cf::DiscCF) = cf.centerx, cf.centery
radius(cf::DiscCF) = cf.rad


function (cf::DiscCF)(x::Real, y::Real)
    r = sqrt((x - cf.centerx)^2 + (y - cf.centery)^2)
    if r >= cf.rad || isnan(r)
        return 1.0
    end
    0.0
end

function (cf::DiscCF)(z::Number)
    cf(real(z), imag(z))
end

function (cf::DiscCF)(p::AbstractVector{<:Real})
    cf(p[1], p[2])
end


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

    function RadialColoringFunction(x::Real=0, y::Real=0;
        innerradius::Real=0, outerradius::Real=1)
        @assert innerradius >= 0 && outerradius > 0 && outerradius > innerradius "Incorrect inner or outer radiuses values."
        new(x,y,innerradius,outerradius)
    end
end

RadialColoringFunction(z::Complex; innerradius::Real=0, outerradius::Real=1) =
RadialColoringFunction(real(z),imag(z),inneradius=innerradius,outerradius=outerradius)

const RadialCF = RadialColoringFunction

center(cf::RadialCF) = cf.centerx, cf.centery
innerradius(cf::RadialCF) = cf.inrad
outerradius(cf::RadialCF) = cf.outrad


function (cf::RadialCF)(x::Real, y::Real)
    r = sqrt((x - cf.centerx)^2 + (y - cf.centery)^2)
    if r >= cf.outrad || isnan(r)
        return 1.0 # last(_colorarray)
    elseif r <= cf.inrad
        return 0.0 #first(_colorarray)
    end
    #_colorscheme[(r - cf.inrad)/(cf.outrad - cf.inrad)]
    (r - cf.inrad)/(cf.outrad - cf.inrad)
end

function (cf::RadialCF)(z::Number)
    cf(real(z), imag(z))
end

function (cf::RadialCF)(p::AbstractVector{<:Real})
    cf(p[1], p[2])
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

center(cf::AngleCF) = cf.center


function (cf::AngleCF)(z::Number)
    if isnan(z)
        return 1.0 #last(_colorarray)
    end
    #_colorscheme[(angle(z - cf.center) + π)/(2π)]
    (angle(cf.center - z) + π)/(2π)
end

function (cf::AngleCF)(x::Real, y::Real)
    cf(complex(x,y))
end

function (cf::AngleCF)(p::AbstractVector{<:Real})
    cf(complex(p[1], p[2]))
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
        return 1.0 #last(_colorarray)
    end
    w = z - cf.center
    #_colorscheme[(angle(w) + π)/(2π)]/(1+β*abs2(w))
    (angle(w) + π)/(2π)/(1+β*abs2(w))
end

function (cf::AngleBumpColoringFunction)(x::Real, y::Real)
    cf(complex(x,y))
end

function (cf::AngleBumpColoringFunction)(p::AbstractVector{<:Real})
    cf(complex(p[1], p[2]))
end


"""
    ChessColoringFunction(; [limits])

The chess coloring function.
"""
struct ChessColoringFunction <: AbstractColoringFunction
    limits

    function ChessColoringFunction(; limits=(0,1,0,1))
        new(limits)
    end
end

const ChessCF = ChessColoringFunction


function (cf::ChessColoringFunction)(x::Real, y::Real)
    if abs(x) >= typemax(Int32) || abs(y) >= typemax(Int32) || isnan(x) || isnan(y)
        return 0.5 #_colorscheme[0.5]
    end
    xmin, xmax, ymin, ymax = limits 
    if floor(Int64, mod1(xmin + x/(xmax-xmin), 2)) == floor(Int64, mod1(ymin + y/(ymax-ymin), 2))
        return 0.0 #first(_colorarray)
    end
    1.0 #last(_colorarray)
end

function (cf::ChessColoringFunction)(z::Number)
    cf(real(z), imag(z))
end

function (cf::ChessColoringFunction)(p::AbstractVector{<:Real})
    cf(p[1], p[2])
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

*ColorMap, for "simple" preimages
LinearColoringFunction (linear gradient, any direction)
MultiRadialColoringFunction (Multi-center) ???
LineRadialColoringFunction
CircleRadialColoringFunction
RectangleColoringFunction (Inside rectangle one color, outside other color)
-DiscColoringFunction (Inside disc one color, outside other color)
BandColoringFunction (regular bands plane tesselation)
-ChessColoringFunction (regular rectangles plane tesselation)
RadialChessColoringFunction ("regular radial rectangles" plane tesselation)

=#


using Colors, ColorSchemes

"""
    ClassicDomainColoringFunction([colormap; radius, radialcolor, width, height, cartesiancolor])
"""
struct ClassicDomainColoringFunction <: AbstractColoringFunction
    cm::ColorScheme
    deltar::Float64
    deltax::Float64
    deltay::Float64
    rexp::Float64
    cexp::Float64
    rshade::RGB{Float64}
    cshade::RGB{Float64}

    function ClassicDomainColoringFunction(clrmap::Union{Symbol,Vector{<:Colorant}}=:hsv;
        radialshade::Colorant=RGBf(0.8,0.8,0.8), radius::Real=1, radialexp::Real=4,
        cartesianshade::Colorant=RGBf(0.2,0.2,0.2), width::Real=2, height::Real=2, cartesianexp::Real=4)
        new(clrmap isa Symbol ? colorschemes[clrmap] : ColorSchemes(clrmap),
          radius,width,height,radialexp,cartesianexp,RGBf(radialshade),RGBf(cartesianshade))
    end
end

const ClassicDomainCF = ClassicDomainColoringFunction


function (cf::ClassicDomainCF)(z::Number)
    r = abs(z)
    if isnan(r)
        return cf.cshade
    end
    r = (r%cf.deltar)/cf.deltar
    r ^= cf.rexp

    c = RGBf(cf.cm[(angle(-z)+pi)/(2pi)])
    c = (1.0-r)*c + r*cf.rshade

    x = (abs(real(z))%cf.deltax)/cf.deltax
    y = (abs(imag(z))%cf.deltay)/cf.deltay
    v = abs(cos(pi*x)*cos(pi*y))
    v ^= (1/cf.cexp)

    v*c + (1.0-v)*cf.cshade # return color
end

function (cf::ClassicDomainCF)(x::Real, y::Real)
    cf(complex(x,y))
end

function (cf::ClassicDomainCF)(p::AbstractVector{<:Real})
    cf(complex(p[1],p[2]))
end


"""
    CartesianGridColoringFunction([centerx, centery, width, height, horizontalcolor, verticalcolor])
"""
struct CartesianGridColoringFunction <: AbstractColoringFunction
    centerx::Float64
    centery::Float64
    deltax::Float64
    deltay::Float64
    sexp::Float64
    bgcolor::RGB{Float64}
    hcolor::RGB{Float64}
    vcolor::RGB{Float64}

    function CartesianGridColoringFunction(; centerx::Real=0, centery::Real=0, width::Real=1, height::Real=1,
        shadeexp::Real=4, bgcolor::Colorant=RGBf(1,1,1),
        horizontalcolor::Colorant=RGBf(0,0,0.5), verticalcolor::Colorant=RGBf(0.5,0,0))
        new(centerx,centery,width,height,shadeexp,RGBf(bgcolor),RGBf(horizontalcolor),RGBf(verticalcolor))
    end
end

const CartesianGridCF = CartesianGridColoringFunction


function (cf::CartesianGridCF)(x::Real, y::Real)
    x = (abs(x-cf.centerx)%cf.deltax)/cf.deltax
    y = (abs(y-cf.centery)%cf.deltay)/cf.deltay
    hv = abs(sin(pi*x))^(1/cf.sexp)
    vv = abs(sin(pi*y))^(1/cf.sexp)
    c = (1.0-hv)*cf.hcolor + hv*cf.bgcolor
    (1.0-vv)*cf.vcolor + vv*c # return color
end

function (cf::CartesianGridCF)(z::Number)
    cf(real(z), imag(z))
end

function (cf::CartesianGridCF)(p::AbstractVector{<:Real})
    cf(p[1],p[2])
end


"""
    PolarGridColoringFunction([centerx, centery, radius, arcs, circlecolor, raycolor])
"""
struct PolarGridColoringFunction <: AbstractColoringFunction
    centerx::Float64
    centery::Float64
    deltar::Float64
    deltaa::Float64
    sexp::Float64
    bgcolor::RGB{Float64}
    ccolor::RGB{Float64}
    rcolor::RGB{Float64}

    function PolarGridColoringFunction(; centerx::Real=0, centery::Real=0, radius::Real=1, arcs::Real=8,
        shadeexp::Real=4, bgcolor::Colorant=RGBf(1,1,1),
        circlescolor::Colorant=RGBf(0,0,0.5), rayscolor::Colorant=RGBf(0.5,0,0))
        new(centerx,centery,radius,2pi/arcs,shadeexp,RGBf(bgcolor),RGBf(circlescolor),RGBf(rayscolor))
    end
end

const PolarGridCF = PolarGridColoringFunction


function (cf::PolarGridCF)(z::Number)
    z0 = z - complex(cf.centerx,cf.centery)
    r = (abs(z0)%cf.deltar)/cf.deltar
    a = ((angle(-z0)+pi)%cf.deltaa)/cf.deltaa
    rv = abs(sin(pi*r))^(1/cf.sexp)
    av = abs(sin(pi*a))^(1/cf.sexp)
    c = (1.0-rv)*cf.ccolor + rv*cf.bgcolor
    (1.0-av)*cf.rcolor + av*c # return color
end

function (cf::PolarGridCF)(x::Real, y::Real)
    cf(complex(x,y))
end

function (cf::PolarGridCF)(p::AbstractVector{<:Real})
    cf(complex(p[1],p[2]))
end


"""
    PictureColoringFunction(img [; limits, outsidecolor])
"""
struct PictureColoringFunction <: AbstractColoringFunction
    img
    lims
    outcolor

    function PictureColoringFunction(img; limits=(0,1,0,1), outsidecolor::Colorant=RGB(0,0,0))
        new(img, limits, outsidecolor)
    end
end

const PictureCF = PictureColoringFunction


function (cf::PictureCF)(x::Real, y::Real)
    if abs(x) >= typemax(Int32) || abs(y) >= typemax(Int32)
        return cf.outcolor
    end
    H,W = size(cf.img)
    xmin, xmax, ymin, ymax = cf.lims
    w = floor(Int64, W*(x-xmin)/(xmax-xmin))
    h = floor(Int64, H*(ymax-y)/(ymax-ymin))
    if w < 0 || w >= W || h < 0 || h >= H
        return cf.outcolor
    end
    cf.img[h+1,w+1] # return color
end

function (cf::PictureCF)(z::Number)
    cf(real(z), imag(z))
end

function (cf::PictureCF)(p::AbstractVector{<:Real})
    cf(p[1],p[2])
end


"""
    RepeatPictureColoringFunction(img [; limits])
"""
struct RepeatPictureColoringFunction <: AbstractColoringFunction
    img
    lims

    function RepeatPictureColoringFunction(img; limits::NTuple{4,<:Real}=(0,1,0,1))
        new(img, limits)
    end
end

const RepeatPictureCF = RepeatPictureColoringFunction


function (cf::RepeatPictureCF)(x::Real, y::Real)
    if abs(x) >= typemax(Int32) || abs(y) >= typemax(Int32) || isnan(x) || isnan(y)
        return cf.img[1,1]
    end
    H,W = size(cf.img)
    xmin, xmax, ymin, ymax = cf.lims
    xr = mod1(x-xmin, xmax-xmin-0.000001)
    yr = mod1(ymax-y, ymax-ymin-0.000001)
    cf.img[floor(Int64, H*(yr)/(ymax-ymin))+1, floor(Int64, W*(xr)/(xmax-xmin))+1] # return color
end

function (cf::RepeatPictureCF)(z::Number)
    cf(real(z), imag(z))
end

function (cf::RepeatPictureCF)(p::AbstractVector{<:Real})
    cf(p[1],p[2])
end


#_coloringfunction = RadialColoringFunction()

#"Set the coloring function."
#coloringfunction(cf::AbstractColoringFunction) = global _coloringfunction = cf

#"Get the current coloring function."
#coloringfunction() = _coloringfunction
