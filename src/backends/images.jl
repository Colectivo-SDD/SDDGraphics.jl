
import Images
export Images

"Inner module Images Backend"
module ImagesBE

PM = parentmodule(ImagesBE)


_color = PM._ColorType(0,0,0)
_bgcolor = PM._ColorType(1,1,1)

color(c::PM._ColorType) = global _color = c

color() = _color


bgcolor(c::PM._ColorType) = global _bgcolor = c

bgcolor() = _bgcolor


_image = fill(_bgcolor, PM._height, PM._width)

newdrawing() = global _image =
    fill(_bgcolor, PM._height, PM._width)


drawpixel(i::Integer, j::Integer) = global _image[j,i] = _color
drawpoint(x::Real, y::Real) = global _image[PM.pointtopixel(x,y)...] = _color
drawpoint(z::Complex) = global _image[PM.pointtopixel(z)...] = _color
drawpoint(x::Real) = global _image[PM.pointtopixel(x)...] = _color


drawing() = _image


#_not_supported = [:drawcircle]

end # module
