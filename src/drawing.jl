
import SDDGeometry: AbstractLine, AbstractRay, AbstractLineSegment,
    AbstractCircle, AbstractArc, basepointR2, initialpointR2, finalpointR2,
    angle, centerR2, radius

_drawingkind = :png

"""
Set the current kind of drawing
- `:pixels` or `png`: Drawing pixels. Support depends on backend.
- `:vectorial` or `svg`: Drawing using vectorial shapes. Support depends on backend.
"""
function drawingkind(dk::Symbol)
    if dk == :svg || dk == :vectorial
        global _drawingkind = :svg
    else
        global _drawingkind = :png
    end
end # function

"Returns the current drawing kind symbol."
drawingkind() = _drawingkind


"Create a new drawing, using drawing kind and canvas data."
newdrawing() = _backend.newdrawing()


_axes = false

"Set true to draw coordinated axes."
axes(b::Bool) = global _axes = b

"Drawing coordinated axes?"
axes() = _axes


"Set the point size."
pointsize(ps::Real) = _backend.pointsize(ps)

"Get the point size."
pointsize() = _backend.pointsize()

"Set the line width."
linewidth(lw::Real) = _backend.linewidth(lw)

"Get the line width."
linewidth() = _backend.linewidth()

"""
Set the drawing style for shapes. Options:
- `:stroke`.
- `:fill`.
- `:fillstroke`.
- `:fillgrad`: Using a gradient coloring fill.
"""
style(s::Symbol) = _backend.style(s)

"Get the drawing style."
style() = _backend.style()


"Draw the (i,j) pixel."
drawpixel(i::Integer, j::Integer) = _backend.drawpixel(i,j)

"Draw the point (x,y)."
drawpoint(x::Real, y::Real) = _backend.drawpoint(x,y)

"Draw the point z."
drawpoint(z::Complex) = _backend.drawpoint(z)

"Draw the point x."
drawpoint(x::Real) = _backend.drawpoint(x)

drawlinesegment(x1::Real, y1::Real, x2::Real, y2::Real) =
_backend.drawlinesegment(x1,y1,x2,y2)
drawlinesegment(z1::Number, z2::Number) = _backend.drawlinesegment(z1,z2)
drawlinesegment(l::AbstractLineSegment) = _backend.drawlinesegment(l)

drawline(x::Real, y::Real, θ::Real) = _backend.drawline(x,y,θ)
drawline(z::Number, θ::Real) = _backend.drawline(z,θ)
drawline(l::AbstractLine) = _backend.drawline(l)

drawcircle(x::Real, y::Real, r::Real) = _backend.drawcircle(x,y,r)
drawcircle(z::Number, r::Real) = _backend.drawcircle(z,r)
drawcircle(c::AbstractCircle) = _backend.drawcircle(c)

drawarc(x1::Real,y1::Real,x2::Real,y2::Real,x3::Real,y3::Real) =
_backend.drawarc(x1,y1,x2,y2,x3,y3)
drawarc(z1::Number,z2::Number,z3::Number) = _backend.drawarc(z1,z2,z3)
drawarc(a::AbstractArc) = _backend.drawarc(a)
drawarc(x1::Real,y1::Real,x2::Real,y2::Real) =
_backend.drawarc(x1,y1,x2,y2)
drawarc(z1::Number,z2::Number) = _backend.drawarc(z1,z2)

"Returns the current created drawing."
drawing() = _backend.drawing()
