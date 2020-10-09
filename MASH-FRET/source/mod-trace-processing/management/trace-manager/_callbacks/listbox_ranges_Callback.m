function listbox_ranges_Callback(obj,evd,h_fig)

h = guidata(h_fig);

range = get(obj,'value');
str = get(obj,'string');
if strcmp(str{range},'no range')
    return;
end

dat3 = get(h.tm.axes_histSort,'userdata');
prm = dat3.range(range,:);

set(h.tm.edit_xrangeLow,'string',num2str(prm{1}(1,1)));
set(h.tm.edit_xrangeUp,'string',num2str(prm{1}(1,2)));
set(h.tm.edit_yrangeLow,'string',num2str(prm{1}(2,1)));
set(h.tm.edit_yrangeUp,'string',num2str(prm{1}(2,2)));
set(h.tm.popupmenu_units,'value',prm{1}(3,1));
set(h.tm.popupmenu_cond,'value',prm{1}(3,2));
set(h.tm.edit_conf1,'string',num2str(prm{1}(4,1)));
set(h.tm.edit_conf2,'string',num2str(prm{1}(4,2)));

set(h.tm.popupmenu_selectXdata,'value',prm{2}(1,1));
set(h.tm.popupmenu_selectXval,'value',prm{2}(1,2));
set(h.tm.popupmenu_selectYdata,'value',prm{2}(2,1));
set(h.tm.popupmenu_selectYval,'value',prm{2}(2,2));

popupmenu_selectData_Callback(h.tm.popupmenu_selectXdata,[],h_fig);

