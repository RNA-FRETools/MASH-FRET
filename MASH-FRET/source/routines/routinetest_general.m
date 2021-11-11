function h_fig = routinetest_general(varargin)
% h_fig = routinetest_general
% h_fig = routinetest_general(h_fig)
%
% This routine execute main GUI-based actions performed when setting up the working area.
% The script can be executed from MATLAB's command window or from the routine menu of MASH.
% It deletes default_param.ini, runs MASH (if executed from comand window) and tests figure resize,.
% 
% h_fig: handle to main figure

% defaults
fileprm = '..\..\default_param.ini';

% get existing figure
h_fig = [];
if ~isempty(varargin)
    h_fig = varargin{1};
end

if isempty(h_fig)
    % delete default_param.ini
    [pth,o,o] = fileparts(mfilename('fullpath'));
    if exist([pth,filesep,fileprm],'file')
        delete([pth,filesep,fileprm]);
    end
    
    % run MASH
    h_fig = MASH;
end

% test figure resizing function
figure_MASH_SizeChangedFcn(h_fig,[]);

