function pushbutton_saveRange_Callback(obj,evd,h_fig)

h = guidata(h_fig);
dat3 = get(h.tm.axes_histSort,'userdata');
data = get(h.tm.popupmenu_selectData,'value');
calc = get(h.tm.popupmenu_selectCalc,'value');
nTag = numel(h.tm.molTagNames);

dat3.range = [dat3.range;cell(1,2)];
dat3.range{end,1} = [str2num(get(h.tm.edit_xrangeLow,'string')), ...
    str2num(get(h.tm.edit_xrangeUp,'string'));...
    str2num(get(h.tm.edit_yrangeLow,'string')), ...
    str2num(get(h.tm.edit_yrangeUp,'string'));...
    get(h.tm.popupmenu_units,'value')...
    get(h.tm.popupmenu_cond,'value');...
    str2num(get(h.tm.edit_conf1,'string')), ...
    str2num(get(h.tm.edit_conf2,'string'))];
dat3.range{end,2} = [data,calc];
dat3.rangeTags = [dat3.rangeTags;false(1,nTag)];

set(h.tm.axes_histSort,'userdata',dat3);

R = size(dat3.range,1);
set(h.tm.listbox_ranges,'string',cellstr(num2str((1:R)'))','value',R);
ud_panRanges(h_fig);

