function popupmenu_clrChan_Callback(obj, evd, h_fig)
h = guidata(h_fig);
p = guidata(h.figure_itgExpOpt);
str_chan = get(h.itgExpOpt.popupmenu_dyeChan,'String');
nChan = size(str_chan,1);
str_exc = get(h.itgExpOpt.popupmenu_dyeExc,'String');
nExc = size(str_exc,1)-1;

chan = get(obj, 'Value');

if chan <= size(p{3},1)
    clr = p{5}{2}(chan,:);

elseif chan <= size(p{3},1)+size(p{4},1)
    clr = p{5}{3}((chan-size(p{3},1)),:);

else
    ind = chan-size(p{3},1)-size(p{4},1);
    i = 0;
    for l = 1:nExc
        for c = 1:nChan
            i = i + 1;
            if ind == i
                break;
            end
        end
        if ind == i
            break;
        end
    end
    clr = p{5}{1}{l,c};
end

if sum(clr)>=1.5
    fntClr = 'black';
else
    fntClr = 'white';
end
set(h.itgExpOpt.pushbutton_viewClr,'backgroundcolor',clr,'foregroundcolor',...
    fntClr);