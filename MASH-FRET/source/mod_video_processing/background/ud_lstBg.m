function ud_lstBg(h_fig)
% ud_lstBg(h_fig)
%
% Update background correction list in panel "Video edit and export" of module Video processing
%
% h_fig: handle to main figure

h = guidata(h_fig);
p = h.param.movPr;

% build list
str_methods = get(h.popupmenu_bgCorr, 'String');
str = {};
for i = 1:size(p.bgCorr,1)
    str = cat(2, str, str_methods{p.bgCorr{i,1}});
end

% adjust list selection
corr = get(h.listbox_bgCorr,'value');
if ~isempty(str) && corr==0
    corr = 1;
end
if corr>size(p.bgCorr,1)
    corr = size(p.bgCorr,1);
end

set(h.listbox_bgCorr, 'Value', corr, 'String', str);