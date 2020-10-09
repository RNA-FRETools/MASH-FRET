function pushbutton_remFRET_Callback(obj, evd, h_fig)
h = guidata(h_fig);
slct = get(h.itgExpOpt.listbox_FRETcalc, 'Value');
p = guidata(h.figure_itgExpOpt);

if isempty(p{3})
    return
end

don = p{3}(slct,1);
acc = p{3}(slct,2);

% remove FRET
p{3}(slct,:) = [];

% remove S
if size(p{4},1)>0
    p{4}(p{4}(:,1)==don & p{4}(:,2)==acc,:) = [];
end

% save
guidata(h.figure_itgExpOpt,p);

% update GUI
ud_fretPanel(h_fig);
ud_sPanel(h_fig);

% set selection to last pair in list
l = size(p{3},1);
set(h.itgExpOpt.listbox_FRETcalc, 'Value', l);