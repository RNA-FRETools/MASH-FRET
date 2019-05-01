function pushbutton_TP_addTag_Callback(obj, evd, h)
p = h.param.ttPr;
if ~isempty(p.proj)
    green = [0.76 0.87 0.78];
    grey = [240/255 240/255 240/255];
    switch get(obj,'value')
        case 1
            set(obj, 'BackgroundColor', green);
        case 0
            set(obj, 'BackgroundColor', grey);
    end
    ud_trSetTbl(h.figure_MASH);
end