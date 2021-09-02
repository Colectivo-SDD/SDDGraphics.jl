
"Inner module Luxor Backend"
module LuxorBE

import Luxor
import SDDGeometry: AbstractLine, AbstractRay, AbstractLineSegment,
    AbstractCircle, AbstractArc, basepoint, basepointR2, initialpointR2, finalpointR2,
    lineangle, centerR2, radius
import ..SDDGraphics: colortype, _ColorType, _bgcolor, _fgcolor, _coloringfunction,
    _width, _height, _xmax, _xmin, _ymax, _ymin, pointtocanvas,
    _drawingkind, _axes
#_linewidth, _pointsize,

using Colors


_color = RGBA{Float64}(0,0,1,1) # Blue

function _init()
    colortype(Colors.RGBA{Float64}) # Luxor uses colors with alpha
    _bgcolor = _ColorType(1,1,1,0) # White completely transparent
    _fgcolor = _ColorType(0,0,0,1) # Black completely opaque
    _color = _ColorType(0,0,1,1)
end


function color(c::_ColorType)
    global _color = c
    Luxor.setcolor(c)
end

function color(x::Real, y::Real)
    global _color = _coloringfunction(x,y)
    Luxor.setcolor(_color)
end

function color(z::Number)
    global _color = _coloringfunction(z)
    Luxor.setcolor(_color)
end

color() = _color


#=_linearblend = Luxor.Blend(Luxor.Point(-2,0), Luxor.Point(2,0))
Luxor.addstop(_linearblend, 0.0, _bgcolor)
Luxor.addstop(_linearblend, 0.5,   _color)
Luxor.addstop(_linearblend, 0.0, _bgcolor)

_radialblend = Luxor.Blend(Luxor.O, Luxor.Point(1,0))
Luxor.addstop(_radialblend, 0.0,   _color)
Luxor.addstop(_radialblend, 1.0, _bgcolor)

linearblend() = _linearblend
radialblend() = _radialblend=#

_pearlblend = Luxor.blend(Luxor.O, 0, Luxor.O, 1) # A radial blend
Luxor.addstop(_pearlblend, 0, _bgcolor)
Luxor.addstop(_pearlblend, 1, _color)


_drawing = nothing
_scalex = 1.0
_scaley = -1.0


function newdrawing()
    global _drawing = Luxor.Drawing(_width, _height, _drawingkind)
    Luxor.background(_bgcolor)

    if _axes
        Luxor.setcolor(_fgcolor)
        w0, h0 = pointtocanvas(0,0)
        Luxor.arrow(Luxor.Point(0,h0), Luxor.Point(_width,h0), linewidth=2, arrowheadlength=8)
        Luxor.arrow(Luxor.Point(w0,_height), Luxor.Point(w0,0), linewidth=2, arrowheadlength=8)
    end

    global _scalex = _width/(_xmax - _xmin)
    global _scaley = -_height/(_ymax - _ymin)
    Luxor.origin()
    Luxor.scale(_scalex, _scaley)
    Luxor.translate(-(_xmin + _xmax)/2, -(_ymin + _ymax)/2)
    Luxor.setcolor(_color)
    Luxor.setline(_linewidth)
end # function


_pointsize = 1.0

pointsize(ps::Real) = global _pointsize = ps
pointsize() = _pointsize

_linewidth = 1.0

linewidth(lw::Real) = global _linewidth = lw
linewidth() = _linewidth

_style = :stroke # :fill, :fillstroke, :clip, SDD: :linearblend, :radialblend, :pearl

style(s::Symbol) = global _style = s
style() = _style


point(x::Real, y::Real) = Luxor.Point(x, y)
point(z::Number) = Luxor.Point(real(z), imag(z))


#drawpixel(i::Integer, j::Integer) = NOT SUPPORTED IN LUXOR

drawpoint(x::Real, y::Real) =
Luxor.circle(point(x,y),_pointsize/_scalex,:fill)
drawpoint(z::Number) =
Luxor.circle(point(z),_pointsize/_scalex,:fill)

drawline(x::Real, y::Real, θ::Real) = Luxor.rule(point(x,y),θ)
drawline(z::Number, θ::Real) = Luxor.rule(point(z),θ)
drawline(l::AbstractLine) = Luxor.rule(point(basepoint(l)), lineangle(l))

drawray(x::Real, y::Real, θ::Real) =
Luxor.line(Luxor.Point(x,y),Luxor.Point(2_width*cos(θ),2_width*sin(θ)),:stroke)
drawray(z::Number, θ::Real) =
Luxor.line(Luxor.Point(real(z),imag(z)),Luxor.Point(2_width*cos(θ),2_width*sin(θ)),:stroke)
drawray(l::AbstractRay) =
Luxor.line(Luxor.Point(basepointR2(l)...),Luxor.Point(2_width*cos(lineangle(l)),2_width*sin(lineangle(l))),:stroke)

drawlinesegment(x1::Real, y1::Real, x2::Real, y2::Real) =
Luxor.line(Luxor.Point(x1,y1),Luxor.Point(x2,y2),:stroke)
drawlinesegment(z1::Number, z2::Number) =
Luxor.line(Luxor.Point(real(z1),imag(z1)),Luxor.Point(real(z2),imag(z2)),:stroke)
drawlinesegment(l::AbstractLineSegment) =
Luxor.line(Luxor.Point(initialpointR2(l)...),Luxor.Point(finalpointR2(l)...),:stroke)


function drawcircle(x::Real, y::Real, r::Real)
    if _style == :fillborder
        Luxor.circle(x,y,r,:fill)
        return Luxor.@layer begin
            Luxor.setcolor(_fgcolor)
            Luxor.circle(x,y,r,:stroke)
        end
    elseif _style == :pearl
        return Luxor.@layer begin
            _pearlblend1 = Luxor.blend(point(x,y), 0, point(x,y), r) # A radial blend
            Luxor.addstop(_pearlblend1, 0, _bgcolor)
            Luxor.addstop(_pearlblend1, 1, _color)
            #Luxor.addstop(_pearlblend, 1, _color)
            #Luxor.blendadjust(_pearlblend1,point(x,y),r,r)
            Luxor.setblend(_pearlblend1)
            Luxor.circle(x,y,r,:fill)
        end
    end
    Luxor.circle(x,y,r,_style)
end

drawcircle(z::Number, r::Real) = drawcircle(real(z), imag(z), r)
drawcircle(c::AbstractCircle) = drawcircle(centerR2(c)..., radius(c))


drawarc(x1::Real, y1::Real, x2::Real, y2::Real, x3::Real, y3::Real) =
Luxor.arc2r(Luxor.Point(x1,y1),Luxor.Point(x2,y2),Luxor.Point(x3,y3),:stroke)
drawarc(z1::Number, z2::Number, z3::Number) =
Luxor.arc2r(Luxor.Point(real(z1),imag(z1)),Luxor.Point(real(z2),imag(z2)),Luxor.Point(real(z3),imag(z3)),:stroke)
drawarc(a::AbstractArc) =
Luxor.arc2r(Luxor.Point(centerR2(a)...),Luxor.Point(initialpointR2(a)...),Luxor.Point(finalpointR2(a)...),:stroke)

drawarc(x1::Real, y1::Real, x2::Real, y2::Real) =
Luxor.arc2sagitta(Luxor.Point(x1,y1),Luxor.Point(x2,y2),sqrt((x1-x2)^2+(y1-y2)^2)/2+0.001,:stroke)
drawarc(z1::Number, z2::Number) =
Luxor.arc2sagitta(Luxor.Point(real(z1),imag(z1)),Luxor.Point(real(z2),imag(z2)),abs(z1-z2)/2+0.001,:stroke)


function drawing()
    Luxor.finish()
    Luxor.preview()
    _drawing
end # function

end # module
