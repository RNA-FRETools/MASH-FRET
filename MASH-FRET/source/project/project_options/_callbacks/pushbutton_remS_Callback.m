function pushbutton_remS_Callback(obj, evd, h_fig)
h = guidata(h_fig);
slct = get(h.itgExpOpt.listbox_Scalc, 'Value');
p = guidata(h.figure_itgExpOpt);

if ~isempty(p{4})
    p{4}(slct,:) = [];
    guidata(h.figure_itgExpOpt,p);
    ud_sPanel(h_fig);
    l = size(p{4},1);
    set(h.itgExpOpt.listbox_Scalc, 'Value', l);
end