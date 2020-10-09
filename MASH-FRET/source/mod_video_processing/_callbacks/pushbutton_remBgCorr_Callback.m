function pushbutton_remBgCorr_Callback(obj, evd, h_fig)

% collect interface parameters
h = guidata(h_fig);
p = h.param.movPr;
n = get(h.listbox_bgCorr, 'Value');

if n>0 && size(p.bgCorr,1)>=n
    p.bgCorr(n,:) = [];
end

% save modifications
h.param.movPr = p;
guidata(h_fig, h);

% set GUI to proper values and refresh plot
updateFields(h_fig, 'imgAxes');