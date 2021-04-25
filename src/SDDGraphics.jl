
"""
A simple common interface to diverse graphics packages backends useful for
drawings in SDD algorithms.
"""
module SDDGraphics

using Reexport

include("canvas.jl")

export
  canvassize,
  width,
  height,
  xlims,
  ylims,
  xmin,
  ymin,
  xmax,
  ymax,
  pointtopixel,
  pixeltopoint


include("colors.jl")
include("colormaps.jl")

export
  colortype,
  color,
  bgcolor,
  colorscheme,
  colorarray,
  colormap,
  RadialColorMap,
  AngleColorMap


include("drawing.jl")

  function configure(;kwargs...)
    for (k,v) in kwargs
      if k == :canvassize || k == :canvas
        canvasize(v...)
      elseif k == :width
        width(v)
      elseif k == :height
        height(v)
      elseif k == :xmin
        xmin(v)
      elseif k == :xmax
        xmax(v)
      elseif k == :ymin
        ymin(v)
      elseif k == :ymax
        ymax(v)
      elseif k == :xlims
        xlims(v...)
      elseif k == :ylims
        width(v...)
      elseif k == :rectregion || k == :rect
        rectregion(v...)
      elseif k == :color
        color(v)
      #elseif k == :fgcolor || k == :fgc
        #fgcolor(v)
      elseif k == :bgcolor || k == :bgc
        bgcolor(v)
      elseif k == :colorscheme || k == :cs
        colorscheme(v)
      elseif k == :colorschemeinv || k == :csinv
        colorscheme(v,true)
      elseif k == :colormap || k == :cm
        colormap(v)
      #elseif k == :axes
        #axes(v)
      end
    end
  end

export
  #strokewidth,
  #fill,
  #style,
  configure,
  drawingkind,
  newdrawing,
  drawpixel,
  drawpoint,
  #drawline,
  #drawray,
  #drawlinesegment,
  #drawcircle,
  #drawcirculararc,
  #drawbox,
  #drawrect,
  drawing


include("backends/images.jl")
#include("backends/luxor.jl")
include("backends.jl")

export
  backend,
  backends,
  supported

end
