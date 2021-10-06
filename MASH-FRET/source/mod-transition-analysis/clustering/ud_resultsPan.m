function ud_resultsPan(h_fig)
% Set results panel to proper values

% defaults
ttstr0{1} = wrapHtmlTooltipString('Select the <b>inferred model</b> to show on the TDP plot: labels correspond to the <u>number of states</u>.');
ttstr0{2} = wrapHtmlTooltipString('Select the <b>inferred model</b> to show on the TDP plot: labels correspond to the  <u>number of clusters on one side of the TDP diagonal</u>.');
ttstr0{3} = wrapHtmlTooltipString('Select the <b>inferred model</b> to show on the TDP plot: labels correspond to the  <u>number of clusters</u>.');

% collect interface parameters
h = guidata(h_fig);
p = h.param;

if ~prepPanel(h.uipanel_TA_results,h)
    return
end

% collect experiment settings
proj = p.curr_proj;
tpe = p.TDP.curr_type(proj);
tag = p.TDP.curr_tag(proj);
curr = p.proj{proj}.TA.curr{tag,tpe};
prm = p.proj{proj}.TA.prm{tag,tpe};

if isfield(curr,'clst_res') && ~isempty(curr.clst_res{1})
    isRes = true;
else
    isRes = false;
end

% set results
if ~isRes
    set([h.text_TDPbobaRes h.text_TDPbobaSig h.edit_TDPbobaRes ...
        h.edit_TDPbobaSig h.text_tdp_showModel h.text_tdp_Jequal  ...
        h.text_tdp_BIC h.edit_tdp_BIC h.popupmenu_tdp_model ...
        h.pushbutton_tdp_impModel h.pushbutton_TDPresetClust],'Enable',...
        'off');
    set([h.edit_TDPbobaRes h.edit_TDPbobaSig h.edit_tdp_BIC],'String','');
    return
end

% collect results and processing parameters at last update
res = prm.clst_res;
meth = prm.clst_start{1}(1); % last applied
boba = prm.clst_start{1}(6); % last applied
Jmax = prm.clst_start{1}(3);
mat = prm.clst_start{1}(4);

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
    set(h.axes_tdp_BIC,'Visible','on');

    J = curr.clst_res{3};
    if mat==1
        str_pop = cell(1,Jmax-1);
        for j = 2:Jmax
            str_pop{j-1} = num2str(j);
        end
        val = J-1;
    else
        str_pop = cellstr(num2str((1:Jmax)'));
        val = J;
    end
    set(h.popupmenu_tdp_model,'String',str_pop,'Value',val,'TooltipString',...
        ttstr0{mat});
    set(h.edit_tdp_BIC,'string',num2str(res{1}.BIC(J)));

else
    set([h.text_tdp_showModel,h.text_tdp_Jequal,h.text_tdp_BIC,...
        h.edit_tdp_BIC,h.popupmenu_tdp_model,h.pushbutton_tdp_impModel],...
        'Enable','off');
end

