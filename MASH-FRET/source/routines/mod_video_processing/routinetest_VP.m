function routinetest_VP(varargin)
% routinetest_VP
% routinetest_VP(h_fig)
% routinetest_VP(h_fig,opt)
%
% h_fig: handle to main figure if it exists
% opt: panels to test ('all','plot','experiment settings','edit and export video', 'molecule coordinates' or 'intensity integration');
%
% This routine execute main GUI-based actions performed when processing videos.
% The script can be executed from MATLAB's command window or from the routine menu of MASH.
% It deletes default_param.ini and runs MASH if executed from command window, test all uicontrol callbacks, video import and specific functionalities of each panel.

% defaults
opt = 'all';

% get input arguments
h_fig = [];
if ~isempty(varargin)
    h_fig = varargin{1};
    if size(varargin,2)>=2 && ischar(varargin{2})
        opt = varargin{2};
    end
end

% get defaults parameters
p = getDefault_VP;

% test main working area
h_fig = routinetest_general(p.annexpth,h_fig);
h = guidata(h_fig);

% switch to video processing module
switchPan(h.togglebutton_VP,[],h_fig);

subprefix = '>> ';

% set interface defaults
disp('test main callbacks...');
setDefault_VP(h_fig,p);

% test visualization area
if strcmp(opt,'all') || strcmp(opt,'visualization area')
    disp('test visualization area...');
    routinetest_VP_visualizationArea(h_fig,p,subprefix);
end

% test panel Plot
if strcmp(opt,'all') || strcmp(opt,'plot')
    disp('test panel Plot...');
    routinetest_VP_plot(h_fig,p,subprefix);
end

% test panel Experimental settings
if strcmp(opt,'all') || strcmp(opt,'experiment settings')
    disp('test panel Experiment settings...');
    routinetest_VP_experimentSettings(h_fig,p,subprefix);
end

% test panel Edit and export video
if strcmp(opt,'all') || strcmp(opt,'edit and export video')
    disp('test panel Edit and export video...');
    routinetest_VP_editAndExportVideo(h_fig,p,subprefix);
end

% test panel Molecule coordinates
if strcmp(opt,'all') || strcmp(opt,'molecule coordinates')
    disp('test panel Molecule coordinates...');
    routinetest_VP_moleculeCoordinates(h_fig,p,subprefix);
end

% test panel Intensity integration
if strcmp(opt,'all') || strcmp(opt,'intensity integration')
    disp('test panel Intensity integration...');
    routinetest_VP_intensityIntegration(h_fig,p,subprefix);
end

% close figure if executed from command window
if isempty(varargin)
    close(h_fig);
end

switch opt
    case 'all'
        module = 'module Video processing';
    otherwise
        module = cat(2,'panel ',upper(opt(1)),opt(2:end));
end
disp(cat(2,module,' was successfully tested !'));
