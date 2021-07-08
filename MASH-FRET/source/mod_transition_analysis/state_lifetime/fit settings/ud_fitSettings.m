function ud_fitSettings(h_fig)

% collect interface parameters
h = guidata(h_fig);

if ~(isfield(h,'figure_TA_fitSettings') && ...
        ishandle(h.figure_TA_fitSettings))
    return
end

p = h.param.TDP;
proj = p.curr_proj;
tpe = p.curr_type(proj);
tag = p.curr_tag(proj);

h_fig2 = h.figure_TA_fitSettings;
q = guidata(h_fig2);

% collect project parameters
curr = p.proj{proj}.curr{tag,tpe};
prm = p.proj{proj}.prm{tag,tpe};

% set all control enabled
setProp(h.figure_TA_fitSettings, 'Enable', 'on');

% reset edit field background color
set([q.edit_TDP_nExp q.edit_TDPbsprm_01 q.edit_TDPbsprm_02 ...
    q.edit_TDPfit_aLow q.edit_TDPfit_aStart q.edit_TDPfit_aUp ...
    q.edit_TDPfit_decLow q.edit_TDPfit_decStart q.edit_TDPfit_decUp ...
    q.edit_TDPfit_betaLow q.edit_TDPfit_betaStart q.edit_TDPfit_betaUp], ...
    'backgroundcolor', [1 1 1]);

% collect processing parameters
v = curr.lft_start{2}(2);
lft_start = curr.lft_start{1}(v,:);
auto = lft_start{1}(1);
stchExp = lft_start{1}(2);
if stchExp
    curr_exp = 1;
    nExp = 1;
else
    curr_exp = lft_start{1}(4);
    nExp = lft_start{1}(3);
end
if curr_exp>nExp
    curr_exp = nExp;
end
boba = lft_start{1}(5);
n_rep = lft_start{1}(6);
n_spl = lft_start{1}(7);
w = lft_start{1}(8);
amp_prm = lft_start{2}(curr_exp,1:3);
dec_prm = lft_start{2}(curr_exp,4:6);
beta_prm = lft_start{2}(curr_exp,7:9);

if isfield(prm,'lft_res') && ~isempty(prm.lft_res) && ...
        size(prm.lft_res,1)>=v && ~isempty(prm.lft_res{v,2})
    isRes = true;
else
    isRes = false;
end

% update state value list
str_v = get(h.popupmenu_TA_slStates,'string');
set(q.popupmenu_TA_slStates,'string',str_v,'value',v);

% update exponential list
str_e = cell(1,nExp);
for i = 1:nExp
    str_e{i} = sprintf('exponential n°:%i', i);
end
set(q.popupmenu_TDP_expNum, 'Value', curr_exp, 'String', str_e);

% update fit method
set(q.radiobutton_TA_slAuto, 'Value', auto);
set(q.radiobutton_TA_slMan, 'Value', ~auto);
if auto
    set([q.radiobutton_TDPstretch,q.radiobutton_TDPmultExp,q.edit_TDP_nExp,...
        q.checkbox_BOBA,q.text_bs_nRep,q.text_bs_nSamp,q.edit_TDPbsprm_01,...
        q.edit_TDPbsprm_02,q.checkbox_bobaWeight,q.edit_TDPfit_betaLow,...
        q.edit_TDPfit_betaStart,q.edit_TDPfit_betaUp,q.edit_TDPfit_aLow,...
        q.edit_TDPfit_aStart,q.edit_TDPfit_aUp,q.edit_TDPfit_decLow,...
        q.edit_TDPfit_decStart,q.edit_TDPfit_decUp],'enable','off');
else
    set(q.radiobutton_TDPstretch, 'Value', stchExp);
    set(q.radiobutton_TDPmultExp, 'Value', ~stchExp);
    set(q.edit_TDP_nExp, 'String', num2str(nExp));
    set(q.checkbox_BOBA, 'Value', boba);
    if boba
        set(q.edit_TDPbsprm_01, 'String', num2str(n_rep));
        set(q.edit_TDPbsprm_02, 'String', num2str(n_spl));
        set(q.checkbox_bobaWeight, 'Value', w);
    else
        set([q.text_bs_nRep q.edit_TDPbsprm_01 q.text_bs_nSamp ...
            q.edit_TDPbsprm_02 q.checkbox_bobaWeight], 'Enable', 'off');
        set([q.edit_TDPbsprm_01,q.edit_TDPbsprm_02], 'String', '');
    end

    % update fit parameters
    if stchExp
        set([q.edit_TDP_nExp q.popupmenu_TDP_expNum], 'Enable', 'off');
        set(q.edit_TDPfit_betaLow, 'String', num2str(beta_prm(1)));
        set(q.edit_TDPfit_betaStart, 'String', num2str(beta_prm(2)));
        set(q.edit_TDPfit_betaUp, 'String', num2str(beta_prm(3)));
    else
        set([q.text_TDPfit_beta q.edit_TDPfit_betaLow ...
            q.edit_TDPfit_betaStart q.edit_TDPfit_betaUp], 'Enable', 'off');
        set([q.edit_TDPfit_betaLow q.edit_TDPfit_betaStart ...
            q.edit_TDPfit_betaUp], 'String', '');
    end
    set(q.edit_TDPfit_aLow, 'String', num2str(amp_prm(1)));
    set(q.edit_TDPfit_aStart, 'String', num2str(amp_prm(2)));
    set(q.edit_TDPfit_aUp, 'String', num2str(amp_prm(3)));
    set(q.edit_TDPfit_decLow, 'String', num2str(dec_prm(1)));
    set(q.edit_TDPfit_decStart, 'String', num2str(dec_prm(2)));
    set(q.edit_TDPfit_decUp, 'String', num2str(dec_prm(3)));
end

% update fit results
if isRes
    % collect results
    lft_k = prm.lft_res(v,:);
    boba = prm.lft_start{1}{v,1}(5);
    stchExp = prm.lft_start{1}{v,1}(2);
    if boba && curr_exp>size(lft_k{1},1)
        amp_res = NaN;
        dec_res = NaN;
    elseif ~boba && curr_exp>size(lft_k{2},1)
        amp_res = NaN;
        dec_res = NaN;
    elseif boba && size(lft_k{1},2)>=4 
        amp_res = lft_k{1}(curr_exp,1:2);
        dec_res = lft_k{1}(curr_exp,3:4);
    else
        amp_res = lft_k{2}(curr_exp,1);
        dec_res = lft_k{2}(curr_exp,2);
    end
    if stchExp
        if boba && curr_exp>size(lft_k{2},1)
            beta_res = NaN;
        elseif ~boba && curr_exp>size(lft_k{2},1)
            beta_res = NaN;
        elseif boba && size(lft_k{1},2)>=6
            beta_res = lft_k{1}(1,5:6);
        else
            beta_res = lft_k{2}(1,3);
        end
    else
        beta_res = NaN;
    end
    
    % set GUI
    set([q.edit_TDPfit_aRes,q.edit_TDPfit_ampBs,q.edit_TDPfit_decRes,...
        q.edit_TDPfit_decBs,q.edit_TDPfit_betaRes,q.edit_TDPfit_betaBs], ...
        'Enable', 'off', 'String', '');
    if ~(numel(amp_res)==1 && isnan(amp_res))
        set(q.edit_TDPfit_aRes, 'String', num2str(amp_res(1)), 'Enable', ...
            'on', 'BackgroundColor', [0.75 1 0.75]);
        if boba
            set(q.edit_TDPfit_ampBs, 'String', num2str(amp_res(2)), ...
                'Enable', 'on', 'BackgroundColor', [0.75 1 0.75]);
        end
    end
    if ~(numel(dec_res)==1 && isnan(dec_res))
        set(q.edit_TDPfit_decRes, 'String', num2str(dec_res(1)), 'Enable', ...
            'on', 'BackgroundColor', [0.75 1 0.75]);
        if boba
            set(q.edit_TDPfit_decBs, 'String', num2str(dec_res(2)), ...
                'Enable', 'on', 'BackgroundColor', [0.75 1 0.75]);
        end
    end
    if ~(numel(beta_res)==1 && isnan(beta_res))
        set(q.edit_TDPfit_betaRes, 'String', num2str(beta_res(1)), ...
            'Enable', 'on', 'BackgroundColor', [0.75 1 0.75]);
        if boba
            set(q.edit_TDPfit_betaBs, 'String', num2str(beta_res(2)), ...
                'Enable', 'on', 'BackgroundColor', [0.75 1 0.75]);
        end
    end
    if ~boba 
        set(q.text_TDPfit_bsRes, 'Enable', 'off');
    end

else
    set([q.text_TDPfit_res q.edit_TDPfit_aRes q.edit_TDPfit_decRes ...
        q.edit_TDPfit_betaRes q.text_TDPfit_bsRes ...
        q.edit_TDPfit_ampBs q.edit_TDPfit_decBs ...
        q.edit_TDPfit_betaBs], 'Enable', 'off');
    set([q.edit_TDPfit_aRes q.edit_TDPfit_decRes ...
        q.edit_TDPfit_betaRes q.edit_TDPfit_ampBs ...
        q.edit_TDPfit_decBs q.edit_TDPfit_betaBs], 'String', '');
end

