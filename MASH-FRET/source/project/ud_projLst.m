function p = ud_projLst(p, h_lb)

str_projLst = {};
val = 0;
if ~isempty(p.proj)
    for i = 1:size(p.proj,2)
        proj_name = p.proj{i}.exp_parameters{1,2};
        if isempty(proj_name)
            if ~isempty(p.proj{i}.proj_file)
                [o,proj_name,o] = fileparts(p.proj{i}.proj_file);
            else
                proj_name = 'Project';
            end
        end
        name = proj_name;
        n = 1;
        if ~isempty(str_projLst)
            while sum(strcmp(str_projLst, proj_name))
                n = n+1;
                proj_name = [name '(' num2str(n) ')'];
            end
        end
        str_projLst = [str_projLst proj_name];
        p.proj{i}.exp_parameters{1,2} = proj_name;
    end
    val = p.curr_proj;
end
set(h_lb, 'Value', val, 'String', str_projLst);