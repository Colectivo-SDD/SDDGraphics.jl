
import Images
export Images

"Inner module Images Backend"
module ImagesBE

#PM = parentmodule(ImagesBE)
import ..SDDGraphics: _ColorType, _width, _height, pointtopixel
#PM.

_color = _ColorType(0,0,0)
_bgcolor = _ColorType(1,1,1)

color(c::_ColorType) = global _color = c

color() = _color


bgcolor(c::_ColorType) = global _bgcolor = c

bgcolor() = _bgcolor


_image = fill(_bgcolor, _height, _width)

newdrawing() = global _image =
    fill(_bgcolor, _height, _width)


drawpixel(i::Integer, j::Integer) = global _image[j,i] = _color
drawpoint(x::Real, y::Real) = global _image[pointtopixel(x,y)...] = _color
drawpoint(z::Complex) = global _image[pointtopixel(z)...] = _color
drawpoint(x::Real) = global _image[pointtopixel(x)...] = _color


drawing() = _image


end # module
