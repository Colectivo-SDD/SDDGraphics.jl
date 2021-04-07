
# Supported backends
const _supportedbackends = Dict{Symbol,String}(
    :images => "Images"
    #:luxor => "Luxor"
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
        if sym in keys(_backends)
            global _backend_symbol = sym
            global _backend = _backends[sym]
        else
            global _backend_symbol = sym
            namebe = Symbol(_supportedbackends[sym]*"BE")
            global _backend = @eval $namebe
            global _backends[sym] = _backend
        end # if initialized
    else
        @warn("""`:$sym` is not a supported backend.
            Current backend is `:$_backend_symbol`.""")
    end # if supported
end # function
