
#
# Makie graphics/visualization ecosystem uyilities
#

@reexport using Makie


"""
Convert an `Array{<:Real}` to `Point2f`.
"""
topoint2f(a::AbstractArray{<:Real}) = Point2f(a[1], a[2])

"""
Convert an `Array{<:Real}` to `Point3f`.
"""
topoint3f(a::AbstractArray{<:Real}) = Point3f(a[1], a[2], a[3])

"""
Convert a `Number` to `Point2f`.
"""
topoint2f(c::Number) = Point2f(real(c), imag(c))

"""
Convert an `Array{<:Real}` to `Point2`.
"""
topoint2(a::AbstractArray{<:Real}) = Point2(a[1], a[2])

"""
Convert an `Array{<:Real}` to `Point3`.
"""
topoint3(a::AbstractArray{<:Real}) = Point3(a[1], a[2], a[3])

"""
Convert a `Number` to `Point2`.
"""
topoint2(c::Number) = Point2(real(c), imag(c))

"""
Convert a `Point{2,T}` to `Complex{T}`.
"""
tocomplex(p::Point{2,T}) where {T<:Real} = complex(p[1], p[2])


"""
Create a pair of **Makie**'s `Figure` `Axis` with basic configuration.
The created axis is positioned at the block `[1,1]` of the created figure.
#### Keyword Arguments
-`resolution`: Resolution for the figure.
-`aspect`: Aspect for the axis.
-`limits`: Limits for the axis.
-`axes=true`: Draw coordinated axes if `true`.
-`axescolor="black"`: Coordinated axes color.
-`identity=false`: Draw the identity function graph if `true`.
-`identitycolor="gray`: Color of the identity function graph.
-`colorbar=nothing`: Set a `Colorcar`, positioned in `[2,1]`.
-`colorbarlimits=(0,1)`: Limit values for the colorbar.
"""
function basicfigureaxis(; resolution=(800,600), aspect=DataAspect(), limits=(0,1,0,1),
  axes=true, axescolor="black",
  identity=false, identitycolor="gray",
  colorbar=nothing, colorbarlimits=(0,1) )

  fig = Figure(resolution=resolution)
  ax = Axis(fig[1,1], aspect=aspect, limits=limits)

  if axes
    hlines!(ax, [0], color=axescolor)
    vlines!(ax, [0], color=axescolor)
  end

  if identity
    lines!(ax, [-100,100], [-100,100], color=identitycolor)
  end

  if !isnothing(colorbar)
    Colorbar(fig[2,1], colormap=colorbar, limits=colorbarlimits)
  end

  fig, axis
end


"""
Create a "pearl": A unit circle mesh with radial 
"""
