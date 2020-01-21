function update_taglist_VV(h_fig)

h = guidata(h_fig);

nTag = numel(h.tm.molTagNames);
for t = 1:nTag
    checkbox_VV_tag_Callback(h.tm.checkbox_VV_tag(t),[],h_fig,t);
end
