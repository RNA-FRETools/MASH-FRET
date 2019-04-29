function pushbutton_TM_Callback(obj, evd, h)
traceManager(h.figure_MASH);
h = guidata(h.figure_MASH);
uiwait(h.tm.figure_traceMngr);
h = guidata(h.figure_MASH);
if isfield(h, 'tm') && h.tm.ud
    ud_trSetTbl(h.figure_MASH);
    updateFields(h.figure_MASH, 'ttPr');
    close(h.tm.figure_traceMngr);
end
