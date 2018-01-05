function exeRoutine(h_fig)

folder = uigetdir('Select a folder the input files', h.param.folderRoot);

if ~isempty(folder) && sum(folder)
    flist = dir([folder '*.sif']);
    for i_f = 1:size(fList,1)
        
    end
end