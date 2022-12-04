function ud_kinFit(h_fig)
% Set properties of all controls in panel "State lifetimes" to proper values.
%
% h_fig: handle to main figure

% Last update by MH, 27.1.2020: do not update histogram and plot anymore (done only when pressing "cluster" or "fit"and adapt to current (curr) and last applied (prm) parameters
% update by MH, 12.12.2019: move script that plots boba fret icon from here to buildPanelTAstateTransitionRates.m (plot is now done only once when building GUI)

% collect interface parameters
h = guidata(h_fig);
p = h.param;

h_pan = h.uipanel_TA_dtHistograms;
if ~prepPanel(h.uipanel_TA_dtHistograms,h)
    return
end

% collect experiment settings
proj = p.curr_proj;
tpe = p.TDP.curr_type(proj);
tag = p.TDP.curr_tag(proj);
curr = p.proj{proj}.TA.curr{tag,tpe};
prm = p.proj{proj}.TA.prm{tag,tpe};

if ~(isfield(curr,'clst_res') && ~isempty(curr.clst_res{1}))
    setProp(get(h_pan,'children'), 'Enable', 'off');
    return
end

% collect processing parameters
mat = prm.clst_start{1}(4);
clstDiag = prm.clst_start{1}(9);
J = curr.lft_start{2}(1);
v = curr.lft_start{2}(2);
bin = curr.lft_start{2}(3);
excl = curr.lft_start{2}(4);
rearr = curr.lft_start{2}(5);

if isfield(prm,'lft_res') && ~isempty(prm.lft_res) && ...
        size(prm.lft_res,1)>=v && ~isempty(prm.lft_res{v,2})
    isRes = true;
else
    isRes = false;
end

% update dwell time processing
set(h.edit_TA_slBin, 'String', num2str(bin));
set(h.checkbox_TA_slExcl, 'Value', excl);
set(h.checkbox_tdp_rearrSeq, 'Value', rearr);

% bin state values
nTrs = getClusterNb(J,mat,clstDiag);
[j1,j2] = getStatesFromTransIndexes(1:nTrs,J,mat,clstDiag);
[vals,~] = binStateValues(curr.clst_res{1}.mu{J},bin,[j1,j2]);
vals = unique(round(100*vals)/100);
V = numel(vals);

% update state value list
str_list = {};
for val = 1:V
    str_list = cat(2,str_list,num2str(vals(val)));
end
if isempty(str_list)
    str_list = {'Select a state value'};
end
set(h.popupmenu_TA_slStates, 'String', str_list, 'Value', v);

% update transition list
vs = 1:V;
vs = vs(vs~=v);
str_k = cell(1,V);
str_k{1} = 'all';
c = 1;
for v2 = vs
    c = c+1;
    str_k{c} = [num2str(vals(v)) ' to ' num2str(vals(v2))];
end
k = get(h.popupmenu_TA_slTrans,'value');
if k>V
    k = V;
end
set(h.popupmenu_TA_slTrans, 'Value', k, 'String', str_k);

% update fit results
if isRes
    
    % collect results
    lft_k = prm.lft_res(v,:);
    
    % update degenerated level list
    nExp = prm.lft_start{1}{v,1}(3);
    str_e = cell(1,nExp);
    for i = 1:nExp
        str_e{i} = num2str(i);
    end
    degen = get(h.popupmenu_TA_slDegen,'value');
    if degen>nExp
        degen = nExp;
    end
    set(h.popupmenu_TA_slDegen, 'Value', degen, 'String', str_e);

    % show fit results
    boba = prm.lft_start{1}{v,1}(5);
    if boba && degen>size(lft_k{1},1)
        pop_res = NaN;
        dec_res = NaN;
    elseif ~boba && degen>size(lft_k{2},1)
        pop_res = NaN;
        dec_res = NaN;
    elseif boba && size(lft_k{1},2)>=4 
        amp_res = lft_k{1}(degen,1:2,k); % show contribution for particular transition
        dec_res = lft_k{1}(degen,3:4,1); % show overall decay constant (from total fit)
        pop_res(1) = amp_res(1)/sum(lft_k{1}(:,1,k));
        if pop_res(1)==1
            pop_res(2) = 0;
        else
            pop_res(2) = pop_res(1)*sum(lft_k{1}(:,2,k)./lft_k{1}(:,1,k));
        end
    else
        amp_res = lft_k{2}(degen,1,k); % show contribution for particular transition
        dec_res = lft_k{2}(degen,2,1); % show overall decay constant (from total fit)
        pop_res = amp_res(1)/sum(lft_k{2}(:,1,k));
    end
    
    % set GUI
    set([h.edit_TA_slTauMean,h.edit_TA_slTauSig h.edit_TA_slPopMean,...
        h.edit_TA_slPopSig],'Enable','off','String','');
    if ~(numel(dec_res)==1 && isnan(dec_res))
        set(h.edit_TA_slTauMean, 'String', num2str(dec_res(1)), 'Enable', ...
            'on', 'BackgroundColor', [0.75 1 0.75]);
        if boba
            set(h.edit_TA_slTauSig, 'String', num2str(dec_res(2)), ...
                'Enable', 'on', 'BackgroundColor', [0.75 1 0.75]);
        end
        if ~(numel(pop_res)==1 && isnan(pop_res))
            set(h.edit_TA_slPopMean, 'String', num2str(pop_res(1)), 'Enable', ...
                'on', 'BackgroundColor', [0.75 1 0.75]);
            if boba
                set(h.edit_TA_slPopSig, 'String', num2str(pop_res(2)), ...
                    'Enable', 'on', 'BackgroundColor', [0.75 1 0.75]);
            end
        end
    end
    if ~boba 
        set([h.text_TA_slTauSig,h.text_TA_slPopSig], 'String', '', ...
            'Enable', 'off');
    else
        set([h.text_TA_slTauSig,h.text_TA_slPopSig], 'String', 'sigma');
    end

else
    set([h.popupmenu_TA_slDegen h.text_TA_slDegen ...
        h.text_TA_slTau h.text_TA_slPop h.text_TA_slTauSig ...
        h.text_TA_slPopSig h.edit_TA_slTauMean h.edit_TA_slTauSig ...
        h.edit_TA_slPopMean h.edit_TA_slPopSig], 'Enable', 'off');
    set([h.edit_TA_slTauMean h.edit_TA_slTauSig h.edit_TA_slPopMean ...
        h.edit_TA_slPopSig], 'String', '');
    set(h.popupmenu_TA_slDegen,'string',{'Select a degenerated level'},...
        'value',1);
end

if isfield(h,'figure_TA_fitSettings') && ishandle(h.figure_TA_fitSettings)
    ud_fitSettings(h_fig);
end

