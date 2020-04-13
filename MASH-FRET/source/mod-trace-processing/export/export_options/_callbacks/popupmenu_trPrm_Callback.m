function popupmenu_trPrm_Callback(obj, evd, h_fig)
val = get(obj, 'Value');
h = guidata(h_fig);

% added by MH, 10.4.2019
trFmt = h.param.ttPr.proj{h.param.ttPr.curr_proj}.exp.traces{1}(2);
if val==2 && sum(trFmt==[2,3,4,5,6])
    trFmt_txt = get(h.optExpTr.popupmenu_trFmt,'String');
    setContPan(cat(2,'Processing parameters can not be written in headers',...
        ' of files with format:',trFmt_txt{trFmt}),'error',h_fig);
    set(obj, 'Value', 1);
    return;
end

h.param.ttPr.proj{h.param.ttPr.curr_proj}.exp.traces{2}(5) = val;
guidata(h_fig, h);
ud_optExpTr('tr', h_fig);


