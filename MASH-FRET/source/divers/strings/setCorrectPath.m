function pth = setCorrectPath(folder, h_fig)
% | Create directory and return correct path.
% |
% | pth = setCorrectPath(folder, h_fig)
% | folder >> directory name
% | h_fig >> MASH figure handle
% | pth >> directory path

% Last update: 28th of March 2019 by Melodie Hadzic
% --> add "intensities" folder request in "video_processing"
%
% update: 17th of February 2019 by M�lodie Hadzic
% --> modify "thermodynamic" folder request in "histogram_analysis" and
%     "tdp_analysis" to "transition_analysis" to be consistent with the GUI

pth = [];
h = guidata(h_fig);

% --> modify "movie_processing" folder request into "video_processing"
if strcmp(folder, 'movie_processing')
    folder = 'video_processing';
end
% --> modify "thermodynamic" folder request into "histogram_analysis"
if strcmp(folder, 'thermodynamics')
    folder = 'histogram_analysis';
end
% --> modify "tdp_analysis" folder request into "transition_analysis"
if strcmp(folder, 'tdp_analysis')
    folder = 'transition_analysis';
end

if (strcmp(folder, 'simulations') || ...
        strcmp(folder, 'video_processing') || ...
        strcmp(folder, 'traces_processing') || ...
        strcmp(folder, 'transition_analysis') || ...
        strcmp(folder, 'histogram_analysis'))
    pth = [h.folderRoot filesep folder];

elseif (strcmp(folder, 'average_images') || ...
       strcmp(folder, 'coordinates') || ...
        strcmp(folder, 'exported_graphics') || ...
        strcmp(folder, 'intensities'))

    pth1 = setCorrectPath('video_processing', h_fig);
    pth = [pth1 folder];

elseif (strcmp(folder, 'spotfinder') || ...
        strcmp(folder, 'mapping') || ...
        strcmp(folder, 'transformed'))

    pth1 = setCorrectPath('coordinates', h_fig);
    pth = [pth1 folder];

elseif (strcmp(folder, 'clustering') || ...
        strcmp(folder, 'lifetimes') || ...
        strcmp(folder, 'kinetic model'))

    pth1 = setCorrectPath('transition_analysis', h_fig);
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
