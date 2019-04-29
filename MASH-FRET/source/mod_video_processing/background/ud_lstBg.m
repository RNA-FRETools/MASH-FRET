function ud_lstBg(h_fig)
h = guidata(h_fig);
str_methods = get(h.popupmenu_bgCorr, 'String');
str = {};
for i = 1:size(h.param.movPr.bgCorr,1)
    str = {str{:}, str_methods{h.param.movPr.bgCorr{i,1}}};
end
set(h.listbox_bgCorr, 'Value', 1, 'String', str);