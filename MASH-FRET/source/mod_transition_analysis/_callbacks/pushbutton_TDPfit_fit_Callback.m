function pushbutton_TDPfit_fit_Callback(obj, evd, h_fig)
% pushbutton_TDPfit_fit_Callback([],[],h_fig)
% pushbutton_TDPfit_fit_Callback(excl,[],h_fig)
%
% h_fig: handle to main figure
% excl: {1-by-1} (1) to exclude first and last dwell times ins equences, (0) otherwise

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

% ask user about dwell time exclusion
h = guidata(h_fig);
if iscell(obj)
    excl = obj{1};
else
    excl = questdlg({sprintf(cat(2,'The first and last dwell times of state ',...
        'trajectories are truncated due to the limited observation time ',...
        'window and often lead to biased results.\n\nDo you want to exclude ',...
        'the trucated dwell-times from the fit?'))},...
        'Exclude flanking dwell-times?','Exclude','Include','Cancel',...
        'Exclude');
    if strcmp(excl, 'Exclude')
        excl = 1;
    elseif strcmp(excl, 'Include')
        excl = 0;
    else
        return
    end
end

% update histogram and fit
p = updateDtHistFit(p,tag,tpe,curr_k,excl,h_fig);

% save results
h.param.TDP = p;
guidata(h_fig,h);

% update plots and GUI
updateFields(h_fig, 'TDP');
