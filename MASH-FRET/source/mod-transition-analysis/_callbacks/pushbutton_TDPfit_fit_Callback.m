function pushbutton_TDPfit_fit_Callback(obj, evd, h_fig)
% pushbutton_TDPfit_fit_Callback(h_but,[],h_fig)
%
% h_but: handle to pushbutton from which the function was called (buttons "Fit current" or "Fit all")
% h_fig: handle to main figure

% Last update by MH, 27.1.2020: move fitting script to separate function updateDtHistFit.m and plot dwell time histogram after fitting

% get interface parameters
h = guidata(h_fig);
p = h.param;
if ~isModuleOn(p,'TA')
    return
end

proj = p.curr_proj;
tag = p.TDP.curr_tag(proj);
tpe = p.TDP.curr_type(proj);
curr = p.proj{proj}.TA.curr{tag,tpe};

% get state index
if obj==h.pushbutton_TA_slFitAll
    % show process
    setContPan('Fit all dwell time histograms...','process',h_fig);
    
    V = size(curr.clst_res{4},2);
    vals = 1:V;
    if loading_bar('init',h_fig,V,'Fitting all dwell time histograms...')
        return
    end
    h = guidata(h_fig);
    h.barData.prev_var = h.barData.curr_var;
    guidata(h_fig, h);
    lb = 0;
    
else
    % show process
    setContPan('Fit current dwell time histogram...','process',h_fig);
    
    vals = curr.lft_start{2}(2);
    lb = 2;
end

% update histogram and fit
for v = vals
    p = updateDtHistFit(p,tag,tpe,v,h_fig,lb);
    if ~lb && loading_bar('update', h_fig)
        return
    end
end

if ~lb
    loading_bar('close',h_fig);
end

% save results
h.param = p;
guidata(h_fig,h);

% bring average image plot tab front
bringPlotTabFront('TAdt',h_fig);

% update plots and GUI
updateFields(h_fig, 'TDP');

% show success
setContPan('Dwell time histogram fit successfully completed!','process',...
    h_fig);
