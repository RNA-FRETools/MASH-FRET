function pth = setCorrectPath(folder, h_fig)
% Generate the correct path of the input folder name
% "folder" >> folder name
% "h_fig" >> MASH figure handle
% "pth" >> generated folder path

% Last update: 5th of February 2019 by Mélodie Hadzic
% --> modify "movie_processing" folder request in "video_processing" to
%     be consistent with the rest of the GUI

pth = [];
h = guidata(h_fig);

% --> modify "movie_processing" folder request into "video_processing"
if strcmp(folder, 'movie_processing')
    folder = 'video_processing';
end

if strcmp(folder, 'simulations')
    pth = [h.folderRoot filesep folder];
    
elseif (strcmp(folder, 'video_processing') || ...
        strcmp(folder, 'traces_processing') || ...
        strcmp(folder, 'tdp_analysis') || ...
        strcmp(folder, 'thermodynamics'))
    pth = [h.folderRoot filesep folder];
    
elseif (strcmp(folder, 'average_images') || ...
       strcmp(folder, 'coordinates') || ...
        strcmp(folder, 'exported_graphics'))

    pth1 = setCorrectPath('video_processing', h_fig);
    pth = [pth1 folder];

elseif (strcmp(folder, 'spotfinder') || ...
        strcmp(folder, 'mapping') || ...
        strcmp(folder, 'transformed'))

    pth1 = setCorrectPath('coordinates', h_fig);
    pth = [pth1 folder];
    
elseif (strcmp(folder, 'clustering') || ...
        strcmp(folder, 'kinteics'))

    pth1 = setCorrectPath('tdp_analysis', h_fig);
    pth = [pth1 folder];
    
else
    pth = folder;
end

if ~isempty(pth) && ~exist(pth, 'dir')
    try
        mkdir(pth);
    catch err
        if strcmp(err.identifier, 'MATLAB:MKDIR:OSError')
            warndlg(sprintf(['The access to the root folder is refused' ...
                '\n\nPlease set another root folder']), ...
                'Access to folder denied');
            pth = [];
            return;
        else
            throw(err);
        end
    end
end

pth = [pth filesep];


