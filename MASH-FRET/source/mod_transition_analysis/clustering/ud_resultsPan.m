function ud_resultsPan(h_fig)
% Set results panel to proper values

% collect interface parameters
h = guidata(h_fig);
p = h.param.TDP;
proj = p.curr_proj;
tpe = p.curr_type(proj);
tag = p.curr_tag(proj);

% collect processing parameters
curr = p.proj{proj}.curr{tag,tpe};
prm = p.proj{proj}.prm{tag,tpe};
Jmax = curr.clst_start{1}(3);

set([h.text_TDPbobaRes h.text_TDPbobaSig h.edit_TDPbobaRes ...
    h.edit_TDPbobaSig h.text_tdp_showModel h.text_tdp_Jequal ...
    h.popupmenu_tdp_model h.pushbutton_tdp_impModel ...
    h.pushbutton_TDPresetClust],'Enable','on');

set([h.edit_TDPbobaRes h.edit_TDPbobaSig], 'BackgroundColor', [1 1 1]);

if isfield(curr,'clst_res') && ~isempty(curr.clst_res{1})
    isRes = true;
else
    isRes = false;
end

% set results
if ~isRes
    set([h.text_TDPbobaRes h.text_TDPbobaSig h.edit_TDPbobaRes ...
        h.edit_TDPbobaSig h.text_tdp_showModel h.text_tdp_Jequal ...
        h.popupmenu_tdp_model h.pushbutton_tdp_impModel ...
        h.pushbutton_TDPresetClust], 'Enable', 'off');
    set([h.edit_TDPbobaRes h.edit_TDPbobaSig], 'String', '');
    return
end

% collect results and processing parameters at last update
res = prm.clst_res;
meth = prm.clst_start{1}(1); % last applied
boba = prm.clst_start{1}(6); % last applied
J = res{3};

% set optimum state configuration and bootstrap results
if boba
    if ~isempty(res{2})
        set(h.edit_TDPbobaRes, 'String', num2str(res{2}(1)));
        set(h.edit_TDPbobaSig, 'String', num2str(res{2}(2)));
    end
else
    if meth==2
        [BICmin,Jopt] = min(res{1}.BIC);
    else
        for J = 1:Jmax
            if ~isempty(res{1}.mu{J})
                break
            end
        end
        Jopt = J;
    end
    set([h.edit_TDPbobaSig h.text_TDPbobaSig],'Enable','off');
    set(h.edit_TDPbobaSig, 'String', '');
    set(h.edit_TDPbobaRes,'String',num2str(Jopt));
end

if meth==2
    set([h.text_tdp_showModel,h.text_tdp_Jequal,h.popupmenu_tdp_model,...
        h.pushbutton_tdp_impModel],'Enable','on');
    set(h.axes_tdp_BIC,'Visible','on');

    str_pop = cell(1,Jmax-1);
    for j = 2:Jmax
        str_pop{j-1} = num2str(j);
    end
    J = curr.clst_res{3};
    set(h.popupmenu_tdp_model,'String',str_pop,'Value',J-1);

else
    set([h.text_tdp_showModel,h.text_tdp_Jequal,h.popupmenu_tdp_model,...
        h.pushbutton_tdp_impModel],'Enable','off');
end

