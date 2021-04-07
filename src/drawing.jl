
_drawingkind = :pixels

"""
Set the current kind of drawing
- `:pixels` or `png`: Drawing pixels.
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


"Draw the (i,j) pixel."
drawpixel(i::Integer, j::Integer) = _backend.drawpixel(i,j)

"Draw the point (x,y)."
drawpoint(x::Real, y::Real) = _backend.drawpoint(x,y)

"Draw the point z."
drawpoint(z::Complex) = _backend.drawpoint(z)

"Draw the point x."
drawpoint(x::Real) = _backend.drawpoint(x)


"Returns the current created drawing."
drawing() = _backend.drawing()
