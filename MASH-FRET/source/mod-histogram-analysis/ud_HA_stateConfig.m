function ud_HA_stateConfig(h_fig)

% update 8.4.2019 by MH: correct update of checkbox_thm_BS

% collect interface parameters
h = guidata(h_fig);
p = h.param;

h_pan = h.uipanel_HA_stateConfiguration;
if ~prepPanel(h_pan,h)
    return
end

% collect experiment settings
proj = p.curr_proj;
tpe = p.thm.curr_tpe(proj);
tag = p.thm.curr_tag(proj);
prm = p.proj{proj}.HA.prm{tag,tpe};
curr = p.proj{proj}.HA.curr{tag,tpe};

if isempty(prm.plot{2})
    setProp(get(h_pan,'children'),'Enable', 'off');
    return
end

start = curr.thm_start;
rmse_start = start{4}; % [apply penalty, penalty, max. nb. of Gaussian]

if isfield(prm,'thm_res') && size(prm.thm_res,1)>=3
    res = prm.thm_res;
    rmse_res = res{3,1}; % [logL BIC]
else
    rmse_res = [];
end

set([h.edit_thm_penalty h.edit_thm_maxGaussNb h.edit_thm_LogL ...
    h.edit_thm_BIC], 'BackgroundColor', [1 1 1]);

set(h.radiobutton_thm_penalty, 'Value', rmse_start(1));
set(h.radiobutton_thm_BIC, 'Value', ~rmse_start(1));
Kmax = rmse_start(3);
set(h.edit_thm_maxGaussNb, 'String', num2str(Kmax));
if rmse_start(1)
    set(h.radiobutton_thm_penalty, 'FontWeight', 'bold');
    set(h.radiobutton_thm_BIC, 'FontWeight', 'normal');
    set(h.edit_thm_penalty, 'String', num2str(rmse_start(2)));
else
    set(h.radiobutton_thm_BIC, 'FontWeight', 'bold');
    set(h.radiobutton_thm_penalty, 'FontWeight', 'normal');
    set(h.edit_thm_penalty, 'String', '', 'Enable', 'off');
end
if ~isempty(rmse_res)
    curr_gauss = get(h.popupmenu_thm_nTotGauss, 'Value');
    if curr_gauss>Kmax
        curr_gauss = Kmax;
    end
    set(h.popupmenu_thm_nTotGauss, 'String', ...
        cellstr(num2str((1:Kmax)')), 'Value', curr_gauss);
    if ~rmse_start(1)
        [o,Kopt] = min(rmse_res(:,2));
    else
        Kopt = 1;
        for k = 2:Kmax
            if ((rmse_res(k,1)-rmse_res(k-1,1))/ ...
                    abs(rmse_res(k-1,1)))>(rmse_start(2)-1)
                Kopt = k;
            else
                break;
            end
        end
    end
    set(h.text_thm_calcNgauss, 'String', num2str(Kopt));
    set(h.edit_thm_LogL, 'String', ...
        num2str(rmse_res(curr_gauss,1)));
    if rmse_start(1)
        set([h.text_thm_BIC h.edit_thm_BIC], 'Enable', 'off');
        set(h.edit_thm_BIC, 'String', '');
    else
        set([h.text_thm_BIC h.edit_thm_BIC], 'Enable', 'on');
        set(h.edit_thm_BIC, 'String', ...
            num2str(rmse_res(curr_gauss,2)));
    end
else
    set([h.text_thm_suggNgauss h.text_thm_calcNgauss ...
        h.text_thm_for h.popupmenu_thm_nTotGauss ...
        h.text_thm_nTotGauss h.text_thm_LogL ...
        h.edit_thm_LogL h.text_thm_BIC h.edit_thm_BIC], ...
        'Enable', 'off');
    set([h.text_thm_calcNgauss h.edit_thm_LogL], 'String', '');
    set(h.popupmenu_thm_nTotGauss, 'String', {''});
end
