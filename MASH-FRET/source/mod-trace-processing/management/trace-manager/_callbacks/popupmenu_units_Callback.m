function popupmenu_units_Callback(obj,evd,h_fig)

h = guidata(h_fig);
conf1 = str2num(get(h.tm.edit_conf1,'string'));
conf2 = str2num(get(h.tm.edit_conf2,'string'));
units = get(obj,'value');
if units==1 % percentage
    if conf1>100
        disp('warning: confidence level 1 is greater than 100%');
    end
    if conf2>100
        disp('warning: confidence level 2 is greater than 100%');
    end
end

ud_panRanges(h_fig);
