
"Inner module Luxor Backend"
module LuxorBE

import Luxor
import SDDGeometry: AbstractLine, AbstractRay, AbstractLineSegment,
    AbstractCircle, AbstractArc, basepointR2, initialpointR2, finalpointR2,
    angle, centerR2, radius
import ..SDDGraphics: Colors, color, colortype, _ColorType, _coloringfunction,
    _width, _height, _xmax, _xmin, _ymax, _ymin, pointtocanvas, _drawingkind, _axes

using Colors

colortype(Colors.RGBA{Float64}) # Luxor uses colors with alpha
_bgcolor = _ColorType(1,1,1,0) # White completely transparent
_fgcolor = _ColorType(0,0,0,1) # Black completely opaque
_color = _ColorType(0,0,1,1)


function color(c::_ColorType)
    global _color = c
    Luxor.setcolor(c)
end

function color(x::Real, y::Real)
    global _color = c
    Luxor.setcolor(_coloringfunction(x,y))
end

function color(z::Number)
    global _color = c
    Luxor.setcolor(_coloringfunction(z))
end

color() = _color


bgcolor(c::_ColorType) = global _bgcolor = c
bgcolor() = _bgcolor

fgcolor(c::_ColorType) = global _fgcolor = c
fgcolor() = _fgcolor

_drawing = nothing
_scalex = 1.0
_scaley = -1.0


function newdrawing()
    global _drawing = Luxor.Drawing(_width, _height, _drawingkind)
    Luxor.background(_bgcolor)
    Luxor.origin()
    global _scalex = _width/(_xmax - _xmin)
    global _scaley = -_height/(_ymax - _ymin)
    Luxor.scale(_scalex, _scaley)
    Luxor.translate(-(_xmin + _xmax)/2, -(_ymin + _ymax)/2)
    if _axes
        Luxor.setcolor(_fgcolor)
        Luxor.rule(Luxor.O)
        Luxor.rule(Luxor.O, π/2)
        Luxor.setcolor(_color)
    end
end # function


_pointsize = 1.0

pointsize(ps::Real) = global _pointsize = ps
pointsize() = _pointsize

_linewidth = 1.0

linewidth(lw::Real) = global _linewidth = lw
linewidth() = _linewidth

_style = :stroke

style(s::Symbol) = global _style = s
style() = _style


#drawpixel(i::Integer, j::Integer) = NOT SUPPORTED IN LUXOR

drawpoint(x::Real, y::Real) =
Luxor.circle(Luxor.Point(x,y),_pointsize/_scalex,:fill)
drawpoint(z::Number) =
Luxor.circle(Luxor.Point(real(z),imag(z)),_pointsize/_scalex,:fill)

drawline(x::Real, y::Real, θ::Real) = Luxor.rule(Luxor.Point(x,y),θ)
drawline(z::Number, θ::Real) = Luxor.rule(Luxor.Point(real(z),imag(z)),θ)
drawline(l::AbstractLine) = Luxor.rule(Luxor.Point(basepointR2(l)...),angle(l))

drawray(x::Real, y::Real, θ::Real) =
Luxor.line(Luxor.Point(x,y),Luxor.Point(2_width*cos(θ),2_width*sin(θ)),:stroke)
drawray(z::Number, θ::Real) =
Luxor.line(Luxor.Point(real(z),imag(z)),Luxor.Point(2_width*cos(θ),2_width*sin(θ)),:stroke)
drawray(l::AbstractRay) =
Luxor.line(Luxor.Point(basepointR2(l)...),Luxor.Point(2_width*cos(angle(l)),2_width*sin(angle(l))),:stroke)

drawlinesegment(x1::Real, y1::Real, x2::Real, y2::Real) =
Luxor.line(Luxor.Point(x1,y1),Luxor.Point(x2,y2),:stroke)
drawlinesegment(z1::Number, z2::Number) =
Luxor.line(Luxor.Point(real(z1),imag(z1)),Luxor.Point(real(z2),imag(z2)),:stroke)
drawlinesegment(l::AbstractLineSegment) =
Luxor.line(Luxor.Point(initialpointR2(l)...),Luxor.Point(finalpointR2(l)...),:stroke)

function _blend(x::Real, y::Real, r::Real)
    b = Luxor.blend(Luxor.Point(x,y), Luxor.Point(x+r,y))
    Luxor.addstop(b, 0.0, _bgcolor)
    Luxor.addstop(b, 0.5,   _color)
    Luxor.addstop(b, 1.0, _fgcolor)
    b
end

function drawcircle(x::Real, y::Real, r::Real)
    if _style == :fillgrad
        Luxor.setblend(_blend(x,y,r))
        return Luxor.circle(x,y,r,:fill)
    end
    Luxor.circle(x,y,r,_style)
end

function drawcircle(z::Number, r::Real)
    if _style == :fillgrad #
        Luxor.setblend(_blend(real(z),imag(z),r))
        return Luxor.circle(real(z),imag(z),r,:fill)
    end
    Luxor.circle(real(z),imag(z),r,_style)
end

function drawcircle(c::AbstractCircle)
    if _style == :fillgrad #
        Luxor.setblend(_blend(centerR2(c)...,radius(c)))
        return Luxor.circle(centerR2(c)...,radius(c),:fill)
    end
    Luxor.circle(centerR2(c)...,radius(c),_style)
end

#drawcirclegrad()?

drawarc(x1::Real, y1::Real, x2::Real, y2::Real, x3::Real, y3::Real) =
Luxor.arc2r(Luxor.Point(x1,y1),Luxor.Point(x2,y2),Luxor.Point(x3,y3),:stroke)
drawarc(z1::Number, z2::Number, z3::Number) =
Luxor.arc2r(Luxor.Point(real(z1),imag(z1)),Luxor.Point(real(z2),imag(z2)),Luxor.Point(real(z3),imag(z3)),:stroke)
drawarc(a::AbstractArc) =
Luxor.arc2r(Luxor.Point(centerR2(a)...),Luxor.Point(initialpointR2(a)...),Luxor.Point(finalpointR2(a)...),:stroke)

drawarc(x1::Real, y1::Real, x2::Real, y2::Real) =
Luxor.arc2sagitta(Luxor.Point(x1,y1),Luxor.Point(x2,y2),sqrt((x1-x2)^2+(y1-y2)^2)/2,:stroke)
drawarc(z1::Number, z2::Number) =
Luxor.arc2sagitta(Luxor.Point(real(z1),imag(z1)),Luxor.Point(real(z2),imag(z2)),abs(z1-z2)/2,:stroke)


function drawing()
    Luxor.finish()
    Luxor.preview()
    _drawing
end # function

end # module
