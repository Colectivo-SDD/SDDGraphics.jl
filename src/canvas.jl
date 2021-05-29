
_width = 500
_height = 500

"Return the current canvas size (width and height)."
canvassize() = _width, _height

"Set the canvas size (width and height)."
canvassize(w::Integer, h::Integer) = global _width, _height = w, h

width() = _width
height() = _height
width(w) = global _with = w
height(h) = global _height = h


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

"Create a square (**Tuple** of four real numbers) to set the rectangular region."
square(l::Real, x0::Real=0, y0::Real=0) = x0-l, x0+l, y0-l, y0+l


"Check if (x,y) is inside of the rectangular region."
insiderectregion(x::Real, y::Real) = _xmin < x < _xmax && _ymin < y < _ymax

"Check if z is inside of the rectangular region."
insiderectregion(z::Complex) = insiderectregion(z.re, z.im)

"Check if x is inside of the rectangular region."
insiderectregion(x::Real) = insiderectregion(x,0)


"Adjust canvas size to rectangular region to have the same aspect ratio."
function adjustcanvas()
    aspectratio = (_ymax-_ymin)/(_xmax-_xmin)
    if aspectration <= 1
        global _width = Int(ceil(_height/aspectratio))
    else
        global _height = Int(ceil(_width*aspectratio))
    end # if
end

"Adjust rectangular region to canvas size to have the same aspect ratio."
function adjustrectregion() # INCORRECT!
    aspectratio = _height/_width
    if aspectration <= 1
        x0 = (_xmin+_xmax)/2
        Δx = (_xmax-_xmin)/aspectratio
        global _xmin = x0 - Δx
        global _xmax = x0 + Δx
    else
        y0 = (_ymin+_ymax)/2
        Δy = (_ymax-_ymin)*aspectratio
        global _ymin = y0 - Δy
        global _ymax = y0 + Δy
    end # if
end


"Convert plane coordinates to image coordinates."
pointtopixel(x::Real, y::Real) =
    Integer(ceil(_height*(_ymax-y)/(_ymax-_ymin))), # j
    Integer(ceil(_width*(x-_xmin)/(_xmax-_xmin)))   # i

"Convert complex plane coordinates to image coordinates."
pointtopixel(z::Number) = pointtopixel(real(z), imag(z))


"Convert plane coordinates to canvas coordinates."
pointtocanvas(x::Real, y::Real) =
    _width*(x-_xmin)/(_xmax-_xmin), _height*(_ymax-y)/(_ymax-_ymin)

"Convert complex plane coordinates to canvas coordinates."
pointtocanvas(z::Number) = pointtocanvas(real(z), imag(z))


"Convert image coordinates to plane coordinates."
pixeltopoint(i::Integer, j::Integer) =
    _xmin+(i-1)*(_xmax-_xmin)/(_width-1), _ymax-(j-1)*(_ymax-_ymin)/(_height-1)

"Convert canvas coordinates to plane coordinates."
canvastopoint(i::Real, j::Real) =
    _xmin+(i-1)*(_xmax-_xmin)/(_width-1), _ymax-(j-1)*(_ymax-_ymin)/(_height-1)
