function pushbutton_rootFolder_Callback(obj, evd, h_fig)

h = guidata(h_fig);

if iscell(obj)
    folderRoot = obj{1};
else
    folderRoot = uigetdir(h.folderRoot, 'Choose a root folder:');
end

if ~(~isempty(folderRoot) && sum(folderRoot))
    return
end

h.folderRoot = folderRoot;
h.param.movPr.folderRoot = folderRoot;
cd(h.folderRoot);
guidata(h_fig, h);
set(h.edit_rootFolder, 'String', folderRoot);
updateActPan(['Root folder set to:\n' folderRoot], h_fig);
