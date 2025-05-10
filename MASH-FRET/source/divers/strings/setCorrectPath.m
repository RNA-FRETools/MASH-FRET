function pth = setCorrectPath(folder, fig)
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

[pth,~] = getCorrectPath(folder,fig);

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
