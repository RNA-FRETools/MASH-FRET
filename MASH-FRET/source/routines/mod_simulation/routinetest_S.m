function routinetest_S(varargin)
% routinetest_S
% routinetest_S(h_fig)
% routinetest_S(h_fig,opt)
%
% h_fig: handle to main figure if it exists
% opt: panels to test ('all','video parameters','molecules','experimental setup' or 'export options');
%
% This routine execute main GUI-based actions performed when simulating data.
% The script can be executed from MATLAB's command window or from the routine menu of MASH.
% It deletes default_param.ini and runs MASH if executed from command window, test all uicontrol callbacks, state sequence generation, simulation update and specific functionalities of each panel.

% defaults
opt = 'all';

disp(' ');

% get input arguments
h_fig = [];
if ~isempty(varargin)
    h_fig = varargin{1};
    if size(varargin,2)>=2 && ischar(varargin{2})
        opt = varargin{2};
    end
end

% get defaults parameters
p = getDefault_S;

% test main working area
h_fig = routinetest_general(p.annexpth,h_fig);
h = guidata(h_fig);

% switch to simulation module
switchPan(h.togglebutton_S,[],h_fig);

% set interface defaults
disp('test main callbacks...');
setDefault_S(h_fig,p);

% generate state sequences with defaults
disp('test generation of state sequences...');
pushbutton_startSim_Callback(h.pushbutton_startSim,[],h_fig);

% update simulation with defaults
disp('test simulation update...');
pushbutton_updateSim_Callback(h.pushbutton_updateSim,[],h_fig);

% export data with defaults
disp('test simulation export...');
pushbutton_exportSim_Callback({p.dumpdir,'default'}, [], h_fig);

subprefix = '>> ';

% test panel Video parameters
if strcmp(opt,'all') || strcmp(opt,'video parameters')
    disp('test panel Video parameters...');
    routinetest_S_videoParameters(h_fig,p,subprefix);
end

% test panel Molecules
if strcmp(opt,'all') || strcmp(opt,'molecules')
    disp('test panel Molecules...');
    routinetest_S_molecules(h_fig,p,subprefix);
end

% test panel Experimental setup
if strcmp(opt,'all') || strcmp(opt,'experimental setup')
    disp('test panel Experimental setup...');
    routinetest_S_experimentalSetup(h_fig,p,subprefix);
end

% test panel Export options
if strcmp(opt,'all') || strcmp(opt,'export options')
    disp('test panel Export options...');
    routinetest_S_exportOptions(h_fig,p,subprefix);
end

% close figure if executed from command window
if isempty(varargin)
    close(h_fig);
end

switch opt
    case 'all'
        module = 'module Simulation';
    otherwise
        module = cat(2,'panel ',upper(opt(1)),opt(2:end));
end
disp(' ');
disp(cat(2,module,' was successfully tested !'));
disp(' ');
disp('Generated test data are available at:\n');
disp(p.dumpdir);
