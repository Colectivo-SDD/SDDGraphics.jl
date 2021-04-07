
"""
A simple common interface to diverse graphics packages backends useful for
drawings in SDD algorithms.
"""
module SDDGraphics

include("canvas.jl")
include("colors.jl")
include("backends/images.jl")
include("backends/luxor.jl")
include("backends.jl")
include("drawing.jl")

export
  backend,
  backends,
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
  #configure,
  colortype,
  color,
  bgcolor,
  colorscheme,
  colorarray,
  #linewidth,
  #style,
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
