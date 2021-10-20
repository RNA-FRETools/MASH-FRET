function pushbutton_remBgCorr_Callback(obj, evd, h_fig)

% collect interface parameters
h = guidata(h_fig);
p = h.param;
filtlst = p.proj{p.curr_proj}.VP.curr.edit{1}{4};

% update applied filter list
n = get(h.listbox_bgCorr, 'Value');
if n>0 && size(filtlst,1)>=n
    filtlst(n,:) = [];
end

% save modifications
p.proj{p.curr_proj}.VP.curr.edit{1}{4} = filtlst;
h.param = p;
guidata(h_fig, h);

% set GUI to proper values and refresh plot
updateFields(h_fig, 'imgAxes');