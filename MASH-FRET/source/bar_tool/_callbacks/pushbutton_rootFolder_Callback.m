function pushbutton_rootFolder_Callback(obj, evd, h_fig)
h = guidata(h_fig);
folderRoot = uigetdir(h.folderRoot, 'Choose a root folder:');
if ~isempty(folderRoot) && sum(folderRoot)
    h.folderRoot = folderRoot;
    h.param.movPr.folderRoot = folderRoot;
    cd(h.folderRoot);
    guidata(h_fig, h);
    set(h.edit_rootFolder, 'String', folderRoot);
    updateActPan(['Root folder set to:\n' folderRoot], h_fig);
end