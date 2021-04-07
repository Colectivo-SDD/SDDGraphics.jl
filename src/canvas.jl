
_width = 500
_height = 500

"Return the current canvas size (width and height)."
canvassize() = _width, _height

"Set the canvas size (width and height)."
canvassize(w::Integer, h::Integer) = global _width, _height = w, h


_xmin = -2
_xmax = 2
_ymin = -2
_ymax = 2

for fun = (:xmin, :xmax, :ymin, :ymax)
    var = Symbol("_",fun)
    @eval begin
        $fun() = $var
        $fun(t::Real) = global $var = t
    end # eval
end # for

"Return the current X limits of the rectangular region of drawing."
xlims() = _xmin, _xmax

"Set the X limits of the rectangular region of drawing."
xlims(a::Real, b::Real) = global _xmin, _xmax = a, b


"Return the current Y limits of the rectangular region of drawing."
ylims() = _ymin, _ymax

"Set the Y limits of the rectangular region of drawing."
ylims(a::Real, b::Real) = global _ymin, _ymax = a, b


"Set the rectangular region limits."
rectregion(x0::Real, x1::Real, y0::Real,y1 ::Real) =
    global _xmin, _xmax, _ymin, _ymax = x0, x1, y0, y1


"Check if (x,y) is inside of the rectangular region."
insiderectregion(x::Real, y::Real) = _xmin < x < _xmax && _ymin < y < _ymax

"Check if z is inside of the rectangular region."
insiderectregion(z::Complex) = insiderectregion(z.re, z.im)

"Check if x is inside of the rectangular region."
insiderectregion(x::Real) = insiderectregion(x,0)


"Convert plane coordinates to image coordinates."
pointtopixel(x::Real, y::Real) =
    Integer(ceil(_height*(_ymax-y)/(_ymax-_ymin))), # j
    Integer(ceil(_width*(x-_xmin)/(_xmax-_xmin)))   # i

"Convert complex plane coordinates to image coordinates."
pointtopixel(z::Complex) = pointtopixel(z.re, z.im)

"Convert real line coordinates to image coordinates."
pointtopixel(x::Real) = pointtopixel(x, 0)

"Convert image coordinates to plane coordinates."
pixeltopoint(i::Integer, j::Integer) =
    _xmin+(i-1)*(_xmax-_xmin)/(_width-1), _ymax-(j-1)*(_ymax-_ymin)/(_height-1)
