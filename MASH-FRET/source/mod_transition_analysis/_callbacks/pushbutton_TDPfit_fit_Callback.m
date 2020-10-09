function pushbutton_TDPfit_fit_Callback(obj, evd, h_fig)

% Last update by MH, 27.1.2020: move fitting script to separate function updateDtHistFit.m and plot dwell time histogram after fitting

% get interface parameters
h = guidata(h_fig);
p = h.param.TDP;
if isempty(p.proj)
    return
end

proj = p.curr_proj;
tpe = p.curr_type(proj);
tag = p.curr_tag(proj);

% get processing parameters
curr_k = p.proj{proj}.curr{tag,tpe}.kin_start{2}(2);

% update histogram and fit
p = updateDtHistFit(p,tag,tpe,curr_k,h_fig);

% save results
h.param.TDP = p;
guidata(h_fig,h);

% update plots and GUI
updateFields(h_fig, 'TDP');
