
"Inner module Images Backend"
module ImagesBE

using Images

import ..SDDGraphics: _ColorType, _width, _height, pointtopixel,
    _axes, _coloringfunction

_color = _ColorType(0,0,0)
_bgcolor = _ColorType(1,1,1)
_fgcolor = _ColorType(0,0,0)


color(c::_ColorType) = global _color = c
color(x::Real, y::Real) = global _color = _coloringfunction(x,y)
color(z::Number) = global _color = _coloringfunction(z)
color() = _color

bgcolor(c::_ColorType) = global _bgcolor = c
bgcolor() = _bgcolor

fgcolor(c::_ColorType) = global _fgcolor = c
fgcolor() = _fgcolor


_image = fill(_bgcolor, _height, _width)

newdrawing() = global _image =
    fill(_bgcolor, _height, _width)


drawpixel(i::Integer, j::Integer) = global _image[j,i] = _color
drawpoint(x::Real, y::Real) = global _image[pointtopixel(x,y)...] = _color
drawpoint(z::Number) = global _image[pointtopixel(z)...] = _color


function drawing()
    if _axes
        j0, i0 = pointtopixel(0,0)
        i0 = i0 < 1 ? 1 : (i0 > _width ? _width : i0)
        j0 = j0 < 1 ? 1 : (j0 > _height ? _height : j0)
        for i in 1:_width
            _image[j0,i] = _fgcolor
        end
        for j in 1:_height
            _image[j,i0] = _fgcolor
        end
    end
    _image
end


end # module
