function pushbutton_viewClr_Callback(obj, evd, h_fig)

rgb = uisetcolor('Set a trace color');
if numel(rgb)==1
    return;
end

h = guidata(h_fig);
p = guidata(h.figure_itgExpOpt);

str_exc = get(h.itgExpOpt.popupmenu_dyeExc,'String');
str_chan = get(h.itgExpOpt.popupmenu_dyeChan,'String');
nExc = numel(str_exc)-1;
nChan = size(str_chan,1);

chan = get(h.itgExpOpt.popupmenu_clrChan, 'Value');
if chan <= size(p{3},1)
    p{5}{2}(chan,:) = rgb;

elseif chan <= size(p{3},1)+size(p{4},1)
    p{5}{3}((chan-size(p{3},1)),:) = rgb;

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
    p{5}{1}{l,c} = rgb;
end

guidata(h.figure_itgExpOpt, p);

% update pushutton color
if sum(rgb)>=1.5
    fntClr = 'black';
else
    fntClr = 'white';
end
set(h.itgExpOpt.pushbutton_viewClr,'backgroundcolor',rgb,'foregroundcolor',...
    fntClr);

% update color in trace list
exc = zeros(1,nExc);
for i = 1:size(str_exc,1)-1
    exc(i) = getValueFromStr('', str_exc{i,1});
end
str_clrChan = getStrPop('DTA_chan', {p{7}{2} p{3} p{4} exc p{5}});
val_clrChan = get(h.itgExpOpt.popupmenu_clrChan, 'Value');
if val_clrChan > size(str_clrChan,2)
    val_clrChan = size(str_clrChan,2);
end
set(h.itgExpOpt.popupmenu_clrChan,'Value',val_clrChan,'String',str_clrChan); 