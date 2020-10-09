function ud_kinFit(h_fig)
% Set properties of all controls in panel "Transition rates" to proper values.
%
% h_fig: handle to main figure

% Last update by MH, 27.1.2020: do not update histogram and plot anymore (done only when pressing "cluster" or "fit"and adapt to current (curr) and last applied (prm) parameters
% update by MH, 12.12.2019: move script that plots boba fret icon from here to buildPanelTAstateTransitionRates.m (plot is now done only once when building GUI)

% collect interface parameters
h = guidata(h_fig);
def_clrlst = h.color_list;
p = h.param.TDP;
proj = p.curr_proj;
tpe = p.curr_type(proj);
tag = p.curr_tag(proj);

% collect project parameters
curr = p.proj{proj}.curr{tag,tpe};
prm = p.proj{proj}.prm{tag,tpe};

% set all control enabled
setProp(h.uipanel_TA_stateTransitionRates, 'Enable', 'on');

% reset edit field background color
set([h.edit_TDP_nExp h.edit_TDPbsprm_01 h.edit_TDPbsprm_02 ...
    h.edit_TDPfit_aLow h.edit_TDPfit_aStart h.edit_TDPfit_aUp ...
    h.edit_TDPfit_decLow h.edit_TDPfit_decStart h.edit_TDPfit_decUp ...
    h.edit_TDPfit_betaLow h.edit_TDPfit_betaStart h.edit_TDPfit_betaUp], ...
    'backgroundcolor', [1 1 1]);

if ~(isfield(curr,'clst_res') && ~isempty(curr.clst_res{1}))
    setProp(h.uipanel_TA_stateTransitionRates, 'Enable', 'off');
    set(h.listbox_TDPtrans, 'String', '', 'Value', 0);
    set(h.popupmenu_TDP_expNum, 'Value', 1, 'String', {''});
    return
end

% collect processing parameters
curr_k = curr.kin_start{2}(2);
if isfield(prm,'kin_res') && ~isempty(prm.kin_res) && ...
        size(prm.kin_res,1)>=curr_k && ~isempty(prm.kin_res{curr_k,2})
    isRes = true;
else
    isRes = false;
end
J = curr.kin_start{2}(1);
nTrs = size(curr.clst_res{1}.mu{J},1);
kin_start = curr.kin_start{1}(curr_k,:);
stchExp = kin_start{1}(1);
if stchExp
    curr_exp = 1;
    nExp = 1;
else
    curr_exp = kin_start{1}(3);
    nExp = kin_start{1}(2);
end
boba = kin_start{1}(4);
n_rep = kin_start{1}(5);
n_spl = kin_start{1}(6);
w = kin_start{1}(7);
amp_prm = kin_start{2}(curr_exp,1:3);
dec_prm = kin_start{2}(curr_exp,4:6);
beta_prm = kin_start{2}(curr_exp,7:9);
clr = prm.clst_start{3}(curr_k,:);

% update transition list
str_list = {};
for k = 1:nTrs
    vals = round(100*curr.clst_res{1}.mu{J}(k,[1,2]))/100;
    str_list = cat(2,str_list,...
        strcat(num2str(vals(1)),' to ',num2str(vals(2))));
end
if isempty(str_list)
    str_list = {''};
end
set(h.listbox_TDPtrans, 'String', str_list, 'Value', curr_k);

% update color list
nClr = size(def_clrlst,2);
clrlst = def_clrlst;
i = 0;
for c = 1:size(p.colList,1)
    if c>nClr
        i = i+1;
        clrlst = cat(2,clrlst,sprintf('random color n°%i',i));
    end
end
[id,o,o] = find(p.colList(:,1)==clr(1) & p.colList(:,2)==clr(2) & ...
    p.colList(:,3)==clr(3));
set(h.popupmenu_TDPcolour, 'String', clrlst, 'Value', id(1));
set(h.edit_TDPcolour,'Enable','inactive','BackgroundColor',clr);

% update exponential list
str_e = cell(1,nExp);
for i = 1:nExp
    str_e{i} = sprintf('exponential n°:%i', i);
end
set(h.popupmenu_TDP_expNum, 'Value', curr_exp, 'String', str_e);

% update fit method
set(h.radiobutton_TDPstretch, 'Value', stchExp);
set(h.radiobutton_TDPmultExp, 'Value', ~stchExp);
set(h.edit_TDP_nExp, 'String', num2str(nExp));
set(h.checkbox_BOBA, 'Value', boba);
if boba
    set(h.edit_TDPbsprm_01, 'String', num2str(n_rep));
    set(h.edit_TDPbsprm_02, 'String', num2str(n_spl));
    set(h.checkbox_bobaWeight, 'Value', w);
else
    set([h.text_bs_nRep h.edit_TDPbsprm_01 h.text_bs_nSamp ...
        h.edit_TDPbsprm_02 h.checkbox_bobaWeight], 'Enable', 'off');
    set([h.edit_TDPbsprm_01,h.edit_TDPbsprm_02], 'String', '');
end

% update fit parameters
if stchExp
    set([h.edit_TDP_nExp h.popupmenu_TDP_expNum], 'Enable', 'off');
    set(h.edit_TDPfit_betaLow, 'String', num2str(beta_prm(1)));
    set(h.edit_TDPfit_betaStart, 'String', num2str(beta_prm(2)));
    set(h.edit_TDPfit_betaUp, 'String', num2str(beta_prm(3)));
else
    set([h.text_TDPfit_beta h.edit_TDPfit_betaLow ...
        h.edit_TDPfit_betaStart h.edit_TDPfit_betaUp], 'Enable', 'off');
    set([h.edit_TDPfit_betaLow h.edit_TDPfit_betaStart ...
        h.edit_TDPfit_betaUp], 'String', '');
end
set(h.edit_TDPfit_aLow, 'String', num2str(amp_prm(1)));
set(h.edit_TDPfit_aStart, 'String', num2str(amp_prm(2)));
set(h.edit_TDPfit_aUp, 'String', num2str(amp_prm(3)));
set(h.edit_TDPfit_decLow, 'String', num2str(dec_prm(1)));
set(h.edit_TDPfit_decStart, 'String', num2str(dec_prm(2)));
set(h.edit_TDPfit_decUp, 'String', num2str(dec_prm(3)));


% update fit results
if isRes
    
    % collect results
    kin_k = prm.kin_res(curr_k,:);
    boba = prm.kin_start{1}{curr_k,1}(4);
    stchExp = prm.kin_start{1}{curr_k,1}(1);
    if boba && curr_exp>size(kin_k{1},1)
        amp_res = NaN;
        dec_res = NaN;
    elseif ~boba && curr_exp>size(kin_k{2},1)
        amp_res = NaN;
        dec_res = NaN;
    elseif boba && size(kin_k{1},2)>=4 
        amp_res = kin_k{1}(curr_exp,1:2);
        dec_res = kin_k{1}(curr_exp,3:4);
    else
        amp_res = kin_k{2}(curr_exp,1);
        dec_res = kin_k{2}(curr_exp,2);
    end
    if stchExp
        if boba && curr_exp>size(kin_k{2},1)
            beta_res = NaN;
        elseif ~boba && curr_exp>size(kin_k{2},1)
            beta_res = NaN;
        elseif boba && size(kin_k{1},2)>=6
            beta_res = kin_k{1}(1,5:6);
        else
            beta_res = kin_k{2}(1,3);
        end
    else
        beta_res = NaN;
    end
    
    % set GUI
    set([h.edit_TDPfit_aRes,h.edit_TDPfit_ampBs,h.edit_TDPfit_decRes,...
        h.edit_TDPfit_decBs,h.edit_TDPfit_betaRes,h.edit_TDPfit_betaBs], ...
        'Enable', 'off', 'String', '');
    if ~(numel(amp_res)==1 && isnan(amp_res))
        set(h.edit_TDPfit_aRes, 'String', num2str(amp_res(1)), 'Enable', ...
            'on', 'BackgroundColor', [0.75 1 0.75]);
        if boba
            set(h.edit_TDPfit_ampBs, 'String', num2str(amp_res(2)), ...
                'Enable', 'on', 'BackgroundColor', [0.75 1 0.75]);
        end
    end
    if ~(numel(dec_res)==1 && isnan(dec_res))
        set(h.edit_TDPfit_decRes, 'String', num2str(dec_res(1)), 'Enable', ...
            'on', 'BackgroundColor', [0.75 1 0.75]);
        if boba
            set(h.edit_TDPfit_decBs, 'String', num2str(dec_res(2)), ...
                'Enable', 'on', 'BackgroundColor', [0.75 1 0.75]);
        end
    end
    if ~(numel(beta_res)==1 && isnan(beta_res))
        set(h.edit_TDPfit_betaRes, 'String', num2str(beta_res(1)), ...
            'Enable', 'on', 'BackgroundColor', [0.75 1 0.75]);
        if boba
            set(h.edit_TDPfit_betaBs, 'String', num2str(beta_res(2)), ...
                'Enable', 'on', 'BackgroundColor', [0.75 1 0.75]);
        end
    end
    if ~boba 
        set(h.text_TDPfit_bsRes, 'Enable', 'off');
    end

else
    set([h.text_TDPfit_res h.edit_TDPfit_aRes h.edit_TDPfit_decRes ...
        h.edit_TDPfit_betaRes h.text_TDPfit_bsRes ...
        h.edit_TDPfit_ampBs h.edit_TDPfit_decBs ...
        h.edit_TDPfit_betaBs], 'Enable', 'off');
    set([h.edit_TDPfit_aRes h.edit_TDPfit_decRes ...
        h.edit_TDPfit_betaRes h.edit_TDPfit_ampBs ...
        h.edit_TDPfit_decBs h.edit_TDPfit_betaBs], 'String', '');
end

