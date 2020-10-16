function pushbutton_TDPfit_fit_Callback(obj, evd, h_fig)
% pushbutton_TDPfit_fit_Callback(h_but,[],h_fig)
%
% h_but: handle to pushbutton from which the function was called (buttons "Fit current" or "Fit all")
% h_fig: handle to main figure

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
curr = p.proj{proj}.curr{tag,tpe};

% get state index
if obj==h.pushbutton_TA_slFitAll
    V = size(curr.clst_res{4},2);
    vals = 1:V;
    if loading_bar('init',h_fig,V,'Fitting all dwell time histograms...');
        return
    end
    h = guidata(h_fig);
    h.barData.prev_var = h.barData.curr_var;
    guidata(h_fig, h);
    lb = 0;
else
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
h.param.TDP = p;
guidata(h_fig,h);

% update plots and GUI
updateFields(h_fig, 'TDP');
