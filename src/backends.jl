
# Supported backends
const _supportedbackends = Dict{Symbol,String}(
    :images => "Images",
    :luxor => "Luxor"
    #:cairomakie => "CairoMakie"
    #:glmakie => "GLMakie"
    #:wglmakie => "WGLMakie"
    )

# Initializaed backends
_backends = Dict{Symbol,Module}()

# Current backend
_backend_symbol = :images
_backend = ImagesBE
_backends[:images] = ImagesBE


backends() = keys(_backends)

backend() = _backend_symbol

"Set ready for use a supported graphics backend."
function backend(sym::Symbol)
    if sym in keys(_supportedbackends)
        if sym in keys(_backends) # if initialized
            global _backend_symbol = sym
            global _backend = _backends[sym]
            #_backend._init()
        else
            include(string(@__DIR__,"/backends/", sym, ".jl"))
            global _backend_symbol = sym
            namebe = Symbol(_supportedbackends[sym]*"BE")
            global _backend = @eval $namebe
            global _backends[sym] = _backend
            #_backend._init()
        end # if initialized
        #@info "Using backend :$_backend_symbol."
    else
        @warn """:$sym is not a supported backend.
            Current backend is :$_backend_symbol."""
    end # if supported
    _backend_symbol
end # function


function supported(funname)
    if !isdefined(_backend, funname)
        @error string(funname, " is not supported in ",  _supportedbackends[_backend_symbol], " backend")
        return false
    end
    true
end
