# RedefineStructs.jl

> **Note**: Very hacky and likely un-Julian.

A simple `@dev` macro to allow you to redefine structs in the Julia REPL.
- https://discourse.julialang.org/t/redefine-struct-when-working-with-repl
- https://github.com/timholy/Revise.jl/issues/18

Intended _only_ for use during code development.

## Installation
```
pkg> add https://github.com/mossr/RedefineStructs.jl
```

## Usage

```julia
using RedefineStructs

@dev struct MyStruct
    x::Int
end
```

Then you can redefine `MyStruct` in the REPL without an error:

```julia
@dev struct MyStruct
    x::String
    y::Vector
end
```

Works with `Base.@kwdef`:
```julia
@dev Base.@kwdef struct MyStruct
    x::String = "Something"
    y::Vector = [1, 2, 3]
end
```

And with the `@with_kw` macro from `Parameters.jl` as well:
```julia
using Parameters

@dev @with_kw struct MyStruct
    x::String = "Something"
    y::Vector = [1, 2, 3]
end
```

And composite types:
```julia
struct State
    s::Int
end

@dev struct MyStruct
    state::State
end
```

## Limitations

Once you've settled on a definition of your struct, you can remove the `@dev` macro but will have to restart the REPL due to the struct now being defined as a `const`.
