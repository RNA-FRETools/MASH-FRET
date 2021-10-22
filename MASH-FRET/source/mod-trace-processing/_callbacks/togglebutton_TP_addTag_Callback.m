function togglebutton_TP_addTag_Callback(obj, evd, h_fig)

% defaults
green = [0.76 0.87 0.78];
grey = [240/255 240/255 240/255];

switch get(obj,'value')
    case 1
        set(obj, 'BackgroundColor', green);
    case 0
        set(obj, 'BackgroundColor', grey);
end

ud_trSetTbl(h_fig);
