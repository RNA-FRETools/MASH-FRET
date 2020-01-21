function pushbutton_addTag2pop_Callback(obj,evd,h_fig)

h = guidata(h_fig);
range = get(h.tm.listbox_ranges,'value');
str_range = get(h.tm.listbox_ranges,'string');
if strcmp(str_range{range},'no range')
    return;
end

tag = get(h.tm.popupmenu_defTagPop,'value');
str_tag = get(h.tm.popupmenu_defTagPop,'string');
if strcmp(str_tag{tag},'no default tag') || ...
        strcmp(str_tag{tag},'select tag')
    return;
else
    tag = tag-1;
end

dat3 = get(h.tm.axes_histSort,'userdata');
dat3.rangeTags(range,tag) = true;
set(h.tm.axes_histSort,'userdata',dat3);

set(h.tm.popupmenu_defTagPop,'value',1);

update_taglist_AS(h_fig);

