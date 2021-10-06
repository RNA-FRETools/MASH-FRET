function pushbutton_rootFolder_Callback(obj, evd, h_fig)

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
    folderRoot = uigetdir(folderRoot, 'Choose a root folder:');
end

if ~(~isempty(folderRoot) && sum(folderRoot))
    return
end

p = h.param;
if ~isempty(p.proj)
    proj = p.curr_proj;
    p.proj{proj}.folderRoot = folderRoot;
end
p.folderRoot = folderRoot;
h.param = p;
guidata(h_fig,h);

set(h.edit_rootFolder,'String',folderRoot,'HorizontalAlignment','right');
setContPan(['Root folder set to: ' folderRoot],'success',h_fig);
