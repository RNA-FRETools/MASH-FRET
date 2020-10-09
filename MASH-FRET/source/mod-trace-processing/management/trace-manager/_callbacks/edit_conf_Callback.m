function edit_conf_Callback(obj,evd,h_fig)

h = guidata(h_fig);
conf = str2num(get(obj,'string'));
units = get(h.tm.popupmenu_units,'value');
if units==1 % percentage
    if conf>100
        disp('warning: confidence level 1 is greater than 100%');
    end
    if conf>100
        disp('warning: confidence level 2 is greater than 100%');
    end
end

ud_panRanges(h_fig);
