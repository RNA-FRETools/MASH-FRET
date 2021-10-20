function ud_lstBg(h_fig)
% ud_lstBg(h_fig)
%
% Update background correction list in panel "Video edit and export" of module Video processing
%
% h_fig: handle to main figure

h = guidata(h_fig);
p = h.param;
curr = p.proj{p.curr_proj}.VP.curr;
filtlst = curr.edit{1}{4};

% build list
str_methods = get(h.popupmenu_bgCorr, 'String');
str = {};
for i = 1:size(filtlst,1)
    str = cat(2, str, str_methods{filtlst{i,1}});
end

% adjust list selection
corr = get(h.listbox_bgCorr,'value');
if ~isempty(str) && corr==0
    corr = 1;
end
if corr>size(filtlst,1)
    corr = size(filtlst,1);
end

set(h.listbox_bgCorr, 'Value', corr, 'String', str);
