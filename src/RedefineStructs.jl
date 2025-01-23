module RedefineStructs

export @dev

macro dev(struct_def)
    if struct_def.args[1] == Symbol("@with_kw")
        struct_name = struct_def.args[3].args[2]
    else
        struct_name = struct_def.args[2]
    end

    struct_def = string(struct_def)

    ex = """
    module Redefined
        # Load all code and packages from parent module
        Parent = parentmodule(@__MODULE__)

        skips = [:eval, :include, :Redefined, Symbol("$struct_name")]

        # Load functions and variables
        for name in names(Parent, all=true, imported=true)
            if name ∉ skips && !occursin("#", string(name))
                @eval const \$(name) = \$(Parent).\$(name)
            end
        end

        modules(m::Module) = ccall(:jl_module_usings, Any, (Any,), m)

        # Load packages
        for mod in modules(Parent)
            try
                eval(Meta.parse("using \$mod"))
            catch err
                @warn err
            end
        end

        $struct_def
    end; $struct_name = Redefined.$struct_name
    """

    return esc(Meta.parse(ex))
end

end # module RedefineStructs
