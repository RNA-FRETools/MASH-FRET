function [pth,pthex] = getCorrectPath(folder,h_fig)
% Return path to proper dump directory and to highest existing level
% 
% [pth,pthex] = getCorrectPath(folder, h_fig)
%
% folder: directory name
% h_fig: MASH figure handle
% pth: directory path
% pthex: path to highest level existing directory

h = guidata(h_fig);
p = h.param;
if isempty(p.proj)
    folderRoot = p.folderRoot;
else
    proj = p.curr_proj;
    folderRoot = p.proj{proj}.folderRoot;
end
if folderRoot(end)==filesep
    folderRoot = folderRoot(1:end-1);
end

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
    pthex = folderRoot;
    pth = [folderRoot filesep folder];

elseif (strcmp(folder, 'average_images') || ...
       strcmp(folder, 'coordinates') || ...
        strcmp(folder, 'exported_graphics') || ...
        strcmp(folder, 'intensities'))

    [pth1,pthex] = getCorrectPath('video_processing', h_fig);
    pth = [pth1 folder];

elseif (strcmp(folder, 'spotfinder') || ...
        strcmp(folder, 'mapping') || ...
        strcmp(folder, 'transformed'))

    [pth1,pthex] = getCorrectPath('coordinates', h_fig);
    pth = [pth1 folder];

elseif (strcmp(folder, 'clustering') || ...
        strcmp(folder, 'lifetimes') || ...
        strcmp(folder, 'kinetic model'))

    [pth1,pthex] = getCorrectPath('transition_analysis', h_fig);
    pth = [pth1 folder];

else
    pth = folder;
    pthex = folder;
    while ~isempty(pthex) && ~exist(pthex,'dir')
        pthex = fileparts(pthex);
    end
end

pth = [pth filesep];
if exist(pth,'dir')
    pthex = pth;
end
