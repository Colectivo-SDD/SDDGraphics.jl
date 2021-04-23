
"""
A simple common interface to diverse graphics packages backends useful for
drawings in SDD algorithms.
"""
module SDDGraphics

include("canvas.jl")
include("colors.jl")
include("colormaps.jl")

function configure(;kwargs...)
  for (k,v) in kwargs
    if k == :canvassize
      canvasize(v...)
    elseif k == :width
      width(v)
    elseif k == :height
      height(v)
    elseif k == :xlims
      xlims(v...)
    elseif k == :ylims
      width(v...)
    elseif k == :rectregion
      rectregion(v...)
    elseif k == :xmin
      xmin(v)
    elseif k == :xmax
      xmax(v)
    elseif k == :ymin
      ymin(v)
    elseif k == :ymax
      ymax(v)
    elseif k == :color
      color(v)
    elseif k == :bgcolor
      bgcolor(v)
    elseif k == :colorscheme
      colorscheme(v)
    elseif k == :colormap
      colormap(v)
    end
  end
end

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
  pixeltopoint,
  #linewidth,
  #style,
  colortype,
  color,
  bgcolor,
  colorscheme,
  colorarray,
  colormap,
  RadialColorMap,
  AngleColorMap,
  configure


include("backends/images.jl")
include("backends/luxor.jl")
include("backends.jl")
include("drawing.jl")

export
  backend,
  backends,
  supported,
  drawingkind,
  newdrawing,
  drawpixel,
  drawpoint,
  #drawcircle,
  #drawarc,
  #drawbox,
  #drawlinesegment,
  drawing

end
