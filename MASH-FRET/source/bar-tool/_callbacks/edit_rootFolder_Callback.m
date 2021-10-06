function edit_rootFolder_Callback(obj,evd,h_fig)

h = guidata(h_fig);
p = h.param;

if iscell(obj)
    folderRoot = obj{1};
else
    if ~isempty(p.proj)
        proj = p.curr_proj;
        folderRoot = p.proj{proj}.folderRoot;
    else
        folderRoot = p.folderRoot;
    end
end

set(obj,'string',folderRoot,'horizontalalignment','right');