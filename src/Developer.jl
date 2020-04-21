module Developer

using ReplMaker, PkgTemplates

function __init__()
    initrepl(inputredirector, 
                prompt_text="dev> ",
                prompt_color = :blue, 
                start_key='}', 
                mode_name="Developer")
end

function inputredirector(s)
    args = split(s)
    println("do $(args[1]) with arguments $(args[2:end])")

    fun, remargs = redirectiontarget(args)
    
    fun(remargs)
    
end

function redirectiontarget(args)
    args[1] =="deps" && return DepsManagement.redirecttopkg, args[2:end]
    targ = args[1] == "CI" ? CI.redirectiontarget(args[2:end]) : DevCycle.redirectiontarget(args)
    return targ
end

########################################
#        Pkg development cycle         #
########################################
module DevCycle

function redirectiontarget(args)
    args[1] == "generate" && return generate, args[2:end]
    args[1] == "package" && return package, args[2:end]
    args[1] == "tag" && return tag, args[2:end]
    error("unknown command DevCycle.$(args[1])")
end

#to create a new package (from a template in an empty directory)
function generate(args)

end

#to convert the current project to a package (Pkg.jl terminology)
function package end

#Major minor patch build custom
function tag end
end

########################################
#             Dependencies             #
########################################
module DepsManagement
using Pkg
#redirects most comands to pkg, disable some like 'activate'
# 'deps' CMD ARGS...

function redirecttopkg(args)
    Pkg.REPLMode.pkgstr(join(args))
end
end

########################################
#                  CI                  #
########################################
module CI
# 'CI' CMD Provider ARGS...

function redirectiontarget(args)
    args[1] == "add" && return add, args[2:end]
    args[1] == "remove" && return remove, args[2:end]
    error("unknown command CI.$(args[1])")
end

function add end

function remove end
end

end # module
