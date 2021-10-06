function popupmenu_dyeChan_Callback(obj, evd, h_fig)
h = guidata(h_fig);
p = guidata(h.figure_itgExpOpt);
chan = get(obj, 'Value');
for v = 1:size(p{7}{1},2)
    if isequal(p{7}{1}{v},p{7}{2}{chan})
        break;
    end
end
exc_str = get(h.itgExpOpt.popupmenu_dyeExc, 'String');
for u = 1:size(exc_str,1)
    if getValueFromStr('', exc_str{u,1}) == p{6}(chan)
        break;
    end
end
set(h.itgExpOpt.popupmenu_dyeLabel, 'Value', v);
set(h.itgExpOpt.popupmenu_dyeExc, 'Value', u);