function ud_TDPmdlSlct(h_fig)

% Last update by MH, 26.1.2020: adapat to current (curr) and last applied (prm) parameters

% collect parameters
h = guidata(h_fig);
p = h.param.TDP;
proj = p.curr_proj;
tpe = p.curr_type(proj);
tag = p.curr_tag(proj);

curr = p.proj{proj}.curr{tag,tpe};

meth = curr.clst_start{1}(1);
mode = curr.clst_start{1}(2);
Jmax = curr.clst_start{1}(3);
N = curr.clst_start{1}(5);
boba = curr.clst_start{1}(6);
if isfield(curr,'clst_res') && ~isempty(curr.clst_res{1})
    isRes = true;
else
    isRes = false;
end

% set general parameters
set([h.text_TDPdataType h.popupmenu_TDPdataType ...
    h.togglebutton_TDPkmean h.togglebutton_TDPgauss ...
    h.popupmenu_TDPstate h.text_TDPstate h.text_TDPnStates ...
    h.edit_TDPnStates h.text_TDPiter h.edit_TDPmaxiter ...
    h.pushbutton_TDPautoStart h.pushbutton_TDPresetClust ...
    h.pushbutton_TDPupdateClust h.text_TDPradius h.edit_TDPradius ...
    h.checkbox_TDPboba h.text_tdp_showModel h.text_tdp_Jequal ...
    h.popupmenu_tdp_model h.pushbutton_tdp_impModel], 'Enable','on',...
    'Visible','on');

set([h.edit_TDPnStates h.edit_TDPiniVal h.edit_TDPradius ...
    h.edit_TDPmaxiter h.listbox_TDPtrans], 'BackgroundColor', [1 1 1]);

set(h.edit_TDPnStates, 'String', num2str(Jmax));


% set starting parameters
if meth == 1 % kmean clustering
    state = get(h.popupmenu_TDPstate, 'Value');
    if state > Jmax
        state = Jmax;
    end
    trs_k = curr.clst_start{2}(state,:);
    
    set(h.text_TDPstate, 'String', 'state n°:');
    
    str_pop = cellstr(num2str((1:Jmax)'));
    set(h.popupmenu_TDPstate, 'Value', state, 'String', str_pop, ...
        'TooltipString', '<html><u>Select</u> state</html>');
    
    set(h.togglebutton_TDPkmean, 'Value', 1, 'FontWeight', 'bold');
    set(h.togglebutton_TDPgauss, 'Value', 0, 'FontWeight', 'normal');

    set([h.text_TDPstate h.popupmenu_TDPstate h.text_TDPiniVal ...
        h.edit_TDPiniVal h.pushbutton_TDPautoStart ...
        h.tooglebutton_TDPmanStart], 'Enable', 'on');
    
    set(h.uipanel_TA_selectTool,'visible','off');
    setProp(h.uipanel_TA_selectTool,'enable','on');
    set(h.tooglebutton_TDPmanStart,'value',0);

    set(h.text_TDPstate, 'String', 'state:');
    set(h.text_TDPiter, 'String', 'iter nb.:');
    set(h.text_TDPiniVal, 'String', 'value');
%     set(h.text_TDPradius, 'String', sprintf('  \nradius'));
    set(h.text_TDPradius, 'String', 'radius');
    set(h.edit_TDPiniVal, 'String', num2str(trs_k(1)));
    set(h.edit_TDPradius, 'String', num2str(trs_k(2)), 'TooltipString', ...
        cat(2,'<html><b>Cluster radius</b>: used for <b>k-mean</b> ',...
        'clustering</html>'));
    
    set(h.edit_TDPmaxiter, 'String', num2str(N), 'TooltipString', ...
        cat(2,'<html>Maximum number of <b>k-mean iterations:</b><br><b>',...
        '100</b> is a good compromise between<br>execution time and ',...
        'result accuracy.</html>'));
    
    ud_selectToolPan(h_fig);
    
    set([h.text_tdp_showModel,h.text_tdp_Jequal,h.popupmenu_tdp_model,...
        h.pushbutton_tdp_impModel],'Enable','off');
    cla(h.axes_tdp_BIC);
    set(h.axes_tdp_BIC,'Visible','off');
    
else % GMM-based clustering
    
    set(h.togglebutton_TDPkmean, 'Value', 0, 'FontWeight', 'normal');
    set(h.togglebutton_TDPgauss, 'Value', 1, 'FontWeight', 'bold');
    
    set (h.text_TDPstate, 'String', 'cluster shape');
    
    str_pop = {'spherical','ellipsoid straight','ellipsoid diagonal', ...
        'free'};
    set(h.popupmenu_TDPstate, 'Value', mode, 'String', str_pop, ...
        'TooltipString', cat(2,'<html><b>Cluster shape</b> for <b>GM</b> ',...
        'clustering</html>'));
    
    set([h.text_TDPiniVal,h.edit_TDPiniVal,h.text_TDPradius,...
        h.edit_TDPradius],'String','','Enable','off');
    set([h.pushbutton_TDPautoStart,h.tooglebutton_TDPmanStart],'Enable',...
        'off');
    set(h.uipanel_TA_selectTool,'visible','off');
    
    set(h.text_TDPiter, 'String', 'restarts:');
    set(h.edit_TDPmaxiter, 'String', num2str(N), 'TooltipString', ...
        cat(2,'<html>Maximum number of <b>GM initializations:</b><br> <b>',...
        '5</b> is a good compromise between<br>execution time and result ',...
        'accuracy.</html>'));
end

if boba
    nSpl = curr.clst_start{1}(7);
    nRpl = curr.clst_start{1}(8);
    set([h.edit_TDPnRepl h.text_TDPnRepl h.edit_TDPnSpl ...
        h.text_TDPnSpl], 'Enable', 'on');
    set([h.edit_TDPnSpl h.edit_TDPnSpl], 'BackgroundColor', [1 1 1]);
    set(h.edit_TDPnSpl, 'String', num2str(nSpl));
    set(h.edit_TDPnRepl, 'String', num2str(nRpl));
else
    set([h.edit_TDPnRepl h.text_TDPnRepl h.edit_TDPnSpl ...
        h.text_TDPnSpl], 'Enable', 'off');
    set([h.edit_TDPnRepl h.edit_TDPnSpl], 'String', '');
end
set(h.checkbox_TDPboba, 'Value', boba);


% set results
if ~isRes
    set(h.listbox_TDPtrans, 'String', '', 'Value', 0, 'Enable', 'off');
    set([h.popupmenu_TDPcolour,h.edit_TDPcolour], 'Enable', 'off');
    set([h.edit_TDPbobaRes h.edit_TDPbobaSig h.text_TDPbobaRes ...
        h.text_TDPbobaSig], 'Enable', 'off');
    set([h.edit_TDPbobaRes h.edit_TDPbobaSig], 'String', '');
    
    set([h.text_tdp_showModel,h.text_tdp_Jequal,h.popupmenu_tdp_model,...
        h.pushbutton_tdp_impModel],'Enable','off');
    set(h.axes_tdp_BIC,'Visible','off');
    cla(h.axes_tdp_BIC);

else
    % collect results and processing parameters at last update
    res = curr.clst_res;
    meth = curr.clst_start{1}(1);
    boba = curr.clst_start{1}(6);
    J = res{3};

    % set optimum state configuration and bootstrap results
    if boba
        set([h.text_TDPbobaRes h.text_TDPbobaSig], 'Enable', 'on');
        set([h.edit_TDPbobaRes h.edit_TDPbobaSig], 'Enable', 'inactive');
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
        set(h.text_TDPbobaRes,'Enable','on');
        set(h.edit_TDPbobaRes,'Enable','inactive','String',num2str(Jopt));
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
        cla(h.axes_tdp_BIC);
        set(h.axes_tdp_BIC,'Visible','off');
    end
end



