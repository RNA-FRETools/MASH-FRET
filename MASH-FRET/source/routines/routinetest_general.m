function h_fig = routinetest_general(varargin)
% h_fig = routinetest_general
% h_fig = routinetest_general(rootFolder)
% h_fig = routinetest_general(rootFolder,h_fig)
%
% This routine execute main GUI-based actions performed when setting up the working area.
% The script can be executed from MATLAB's command window or from the routine menu of MASH.
% It deletes default_param.ini, runs MASH (if executed from comand window), tests figure resize, module access and root folder settings.
% 
% rootFolder: path to dump directory
% h_fig: main figure

% defaults
defRoot = 'test_data';
fileprm = '..\..\default_param.ini';

% get and set root folder
[pth,o,o] = fileparts(mfilename('fullpath'));
pname_root = [pth,filesep,defRoot];
h_fig = [];
if ~isempty(varargin)
    pname_root = varargin{1};
    if size(varargin,2)>=2
        h_fig = varargin{2};
    end
end
if ~exist(pname_root,'dir')
    mkdir(pname_root);
end

if isempty(h_fig)
    % delete default_param.ini
    if exist([pth,filesep,fileprm],'file')
        delete([pth,filesep,fileprm]);
    end
    
    % run MASH
    h_fig = MASH;
end

% test figure resizing function
figure_MASH_SizeChangedFcn(h_fig,[]);

% test history window and corresponding menu
h = guidata(h_fig);
figureActPan_ResizeFcn(h.figure_actPan,[]);
figureActPan_CloseRequestFcn(h.figure_actPan,[]);

% test access to modules
switchPan(h.togglebutton_S,[],h_fig);
switchPan(h.togglebutton_VP,[],h_fig);
switchPan(h.togglebutton_TP,[],h_fig);
switchPan(h.togglebutton_HA,[],h_fig);
switchPan(h.togglebutton_TA,[],h_fig);

% test root folder
pushbutton_rootFolder_Callback({pname_root},[],h_fig);

