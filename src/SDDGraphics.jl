
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
  rectregion,
  xlims,
  ylims,
  xmin,
  ymin,
  xmax,
  ymax,
  insiderectregion,
  pointtopixel,
  pixeltopoint,
  pointtocanvas,
  canvastopoint


include("colors.jl")
include("coloringfunctions.jl")

export
  colortype,
  color,
  bgcolor,
  fgcolor,
  colorscheme,
  colormap,
  colorarray,
  coloringfunction,
  RadialColoringFunction, RadialCF,
  AngleColoringFunction, AngleCF


include("drawing.jl")

#ToDo!: Documentation.
"""
    configure(; kwargs...)

Shortcut function to configure graphics.

#### Arguments
- `canvassize=(w,h)` or `canvas=(w,h)`: Set the canvas size.
"""
  function configure(; kwargs...)
    for (k,v) in kwargs
      if k == :canvassize || k == :canvas
        canvassize(v...)
      elseif k == :width || k == :w
        width(v)
      elseif k == :height || k == :h
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
      elseif k == :bgcolor || k == :bgc
        bgcolor(v)
      elseif k == :fgcolor || k == :fgc
        fgcolor(v)
      elseif k == :colormap || k == :cm || k == :colorscheme || k == :cs
        colorscheme(v)
      elseif k == :colormapinv || k == :cminv || k == :colorschemeinv || k == :csinv
        colorscheme(v,true)
      elseif k == :coloringfunction || k == :cf
        coloringfunction(v)
      elseif k == :axes
        axes(v)
      elseif k == :pointsize || k == :ps
        pointsize(v)
      elseif k == :linewidth || k == :lw
        linewidth(v)
      end
    end
  end

export
  pointsize,
  linewidth,
  #style, # :stroke, :fill, :fillstroke, :fillgrad
  #dash
  configure,
  drawingkind,
  newdrawing,
  drawpixel,
  drawpoint,
  #drawline,
  #drawray,
  #drawlinesegment,
  #drawcircle,
  #drawarc,
  #drawpath,
  #drawbox, #?
  #drawrect, #?
  drawing


include("backends/images.jl") # Default backend
include("backends.jl")

export
  backend,
  backends,
  supported

end
