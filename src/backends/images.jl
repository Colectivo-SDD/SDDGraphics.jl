
@reexport using Images

"Inner module Images Backend"
module ImagesBE

import ..SDDGraphics: _ColorType, _width, _height, _colormap, pointtopixel

_color = _ColorType(0,0,0)
_bgcolor = _ColorType(1,1,1)

color(c::_ColorType) = global _color = c
color(x::Real, y::Real) = global _color = _colormap(x,y)
color(z::Number) = global _color = _colormap(z)
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
