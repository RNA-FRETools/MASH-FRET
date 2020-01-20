function pushbutton_remPopTag_Callback(obj,evd,h_fig)

h = guidata(h_fig);
range = get(h.tm.listbox_ranges,'value');
str_range = get(h.tm.listbox_ranges,'string');
if strcmp(str_range{range},'no range')
    return;
end

tag = get(h.tm.listbox_popTag,'value');
str_tag = get(h.tm.listbox_popTag,'string');
if strcmp(str_tag{tag},'no tag')
    return;
end

dat3 = get(h.tm.axes_histSort,'userdata');
tagid = find(dat3.rangeTags(range,:));
dat3.rangeTags(range,tagid(tag)) = false;
set(h.tm.axes_histSort,'userdata',dat3);

update_taglist_AS(h_fig);
