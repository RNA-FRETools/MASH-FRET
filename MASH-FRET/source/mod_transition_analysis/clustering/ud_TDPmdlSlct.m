function ud_TDPmdlSlct(h_fig)

%% collect parameters
h = guidata(h_fig);
p = h.param.TDP;
proj = p.curr_proj;

exc = p.proj{proj}.excitations;
nExc = p.proj{proj}.nb_excitations;
nChan = p.proj{proj}.nb_channel;
labels = p.proj{proj}.labels;
FRET = p.proj{proj}.FRET;
nFRET = size(FRET,1);
S = p.proj{proj}.S;
nS = size(S,1);

tpe = p.curr_type(proj);
prm = p.proj{proj}.prm{tpe};

meth = prm.clst_start{1}(1);
mode = prm.clst_start{1}(2);
Jmax = prm.clst_start{1}(3);
curr_k = prm.clst_start{1}(4);
N = prm.clst_start{1}(5);
boba = prm.clst_start{1}(6);
clr = prm.clst_start{3}(curr_k,:);
res = prm.clst_res;


%% build data type list
str_pop = {};
for l = 1:nExc
    for c = 1:nChan
        str_pop = [str_pop [labels{c} ' at ' num2str(exc(l)) 'nm']];
    end
end
for n = 1:nFRET
    str_pop = [str_pop ['FRET ' labels{FRET(n,1)} '>' labels{FRET(n,2)}]];
end
for n = 1:nS
    str_pop = [str_pop ['S ' labels{S(n)}]];
end


%% set general parameters
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

set(h.popupmenu_TDPdataType, 'Value', tpe, 'String', str_pop);
set(h.edit_TDPnStates, 'String', num2str(Jmax));

[id_clr,o,o] = find(p.colList(:,1)==clr(1) & p.colList(:,2)==clr(2) & ...
    p.colList(:,3)==clr(3));
if ~isempty(id_clr)
    set(h.popupmenu_TDPcolour, 'Value', id_clr(1), 'Enable', 'on');
end
set(h.edit_TDPcolour, 'Enable', 'inactive', 'BackgroundColor', clr);


%% set starting parameters
if meth == 1 % kmean clustering
    state = get(h.popupmenu_TDPstate, 'Value');
    if state > Jmax
        state = Jmax;
    end
    trs_k = prm.clst_start{2}(state,:);
    
    set(h.text_TDPstate, 'String', 'state n°:');
    
    str_pop = cellstr(num2str((1:Jmax)'));
    set(h.popupmenu_TDPstate, 'Value', state, 'String', str_pop, ...
        'TooltipString', '<html><u>Select</u> state</html>');
    
    set(h.togglebutton_TDPkmean, 'Value', 1, 'FontWeight', 'bold');
    set(h.togglebutton_TDPgauss, 'Value', 0, 'FontWeight', 'normal');

    set([h.text_TDPstate h.popupmenu_TDPstate h.text_TDPiniVal ...
        h.edit_TDPiniVal h.pushbutton_TDPautoStart], 'Enable', 'on');
    
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
    
    set([h.text_TDPiniVal h.edit_TDPiniVal],'String','','Enable','off');
    set([h.text_TDPradius h.edit_TDPradius],'String','','Enable','off');
    set(h.pushbutton_TDPautoStart,'Enable','off');
    
    set(h.text_TDPiter, 'String', 'restarts:');
    set(h.edit_TDPmaxiter, 'String', num2str(N), 'TooltipString', ...
        cat(2,'<html>Maximum number of <b>GM initializations:</b><br> <b>',...
        '5</b> is a good compromise between<br>execution time and result ',...
        'accuracy.</html>'));
end

if boba
    nSpl = prm.clst_start{1}(7);
    nRpl = prm.clst_start{1}(8);
    set([h.edit_TDPnRepl h.text_TDPnRepl h.edit_TDPnSpl ...
        h.text_TDPnSpl], 'Enable', 'on');
    set([h.edit_TDPnSpl h.edit_TDPnSpl], 'BackgroundColor', [1 1 1]);
    set(h.edit_TDPnSpl, 'String', num2str(nSpl));
    set(h.edit_TDPnRepl, 'String', num2str(nRpl));
else
    set([h.edit_TDPnRepl h.text_TDPnRepl h.edit_TDPnSpl ...
        h.text_TDPnSpl], 'Enable', 'off');
    set([h.edit_TDPnSpl h.edit_TDPnSpl], 'String', '');
end
set(h.checkbox_TDPboba, 'Value', boba);


%% set results
if isempty(res{1})
    
    % build transition list
    str_list = {};
    for j1 = 1:Jmax
        for j2 = 1:Jmax
            if j1 ~= j2
                vals = round(100*prm.clst_start{2}([j1 j2],1))/100;
                str_list = [str_list strcat(num2str(vals(1)), ' to ', ...
                    num2str(vals(2)))];
            end
        end
    end
    if isempty(str_list) || meth == 2 %GM
        str_list = {''};
        curr_k = 1;
    end
    set(h.listbox_TDPtrans, 'String', str_list, 'Value', curr_k, ...
        'Enable', 'on');
    set([h.edit_TDPbobaRes h.edit_TDPbobaSig h.text_TDPbobaRes ...
        h.text_TDPbobaSig], 'Enable', 'off');
    set([h.edit_TDPbobaRes h.edit_TDPbobaSig], 'String', '');
    
    set([h.text_tdp_showModel,h.text_tdp_Jequal,h.popupmenu_tdp_model,...
        h.pushbutton_tdp_impModel],'Enable','off');
    set(h.axes_tdp_BIC,'Visible','off');
    cla(h.axes_tdp_BIC);

else
    J = res{3};
    if J*(J-1) <= 0
        curr_k = 1;
    elseif curr_k > J*(J-1)
        curr_k = J*(J-1);
    end
    
    % build transition list
    str_list = {};
    k = 0;
    for j1 = 1:J
        for j2 = 1:J
            if j1 ~= j2
                k = k+1;
                vals = round(100*res{1}.mu{J}([j1 j2],1))/100;
                str_list = [str_list strcat(num2str(vals(1)), ' to ', ...
                    num2str(vals(2)))];
            end
        end
    end
    if isempty(str_list)
        str_list = {''};
    end
    set(h.listbox_TDPtrans, 'String', str_list, 'Value', curr_k, ...
        'Enable', 'on');
    
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
                    break;
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
    else
        set([h.text_tdp_showModel,h.text_tdp_Jequal,h.popupmenu_tdp_model,...
            h.pushbutton_tdp_impModel],'Enable','off');
        cla(h.axes_tdp_BIC);
        set(h.axes_tdp_BIC,'Visible','off');
    end
end



