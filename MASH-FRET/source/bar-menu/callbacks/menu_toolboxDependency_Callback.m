function menu_toolboxDependency_Callback(obj,evd,mode)

if strcmp(mode,'analysis') || strcmp(mode,'discovery')
    check_dependencies(mode);
end