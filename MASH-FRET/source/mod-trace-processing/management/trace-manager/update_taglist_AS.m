function update_taglist_AS(h_fig)

h = guidata(h_fig);

str_lst = colorRangeList(h_fig);
R = numel(str_lst);
range = get(h.tm.listbox_ranges,'value');
if range>R
    range = R;
end
set(h.tm.listbox_ranges,'string',str_lst,'value',range);

str_lst = colorTagNames(h_fig);
nTag = numel(str_lst);
currTag = get(h.tm.popupmenu_defTagPop,'value');
if currTag>nTag
    currTag = nTag;
end
set(h.tm.popupmenu_defTagPop, 'String', str_lst, 'Value', currTag);

str_lst = colorTagLists_AS(h_fig,range);
nTag = numel(str_lst);
currTag = get(h.tm.listbox_popTag,'value');
if currTag>nTag
    currTag = nTag;
end
set(h.tm.listbox_popTag,'string',str_lst,'value',currTag);


