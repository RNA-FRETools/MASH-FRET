function routinetest_TA(varargin)
% routinetest_TA
% routinetest_TA(h_fig)
% routinetest_TA(h_fig,opt)
%
% h_fig: handle to main figure if it exists
% opt: panels to test ('all','project management','transition density plot','state configuration','state transition rates'
%
% This routine execute main GUI-based actions performed when analyzing transitions.
% The script can be executed from MATLAB's command window or from the routine menu of MASH.
% It deletes default_param.ini and runs MASH if executed from command window, test all uicontrol callbacks and specific functionalities of each panel.

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
p = getDefault_TA;

% start logs
logfile = [p.dumpdir,filesep,'_logs.txt'];
if exist(logfile,'file')
    try
        delete(logfile);
    catch err
        disp(datestr(now)); % append diary but show date
    end
end
diary(logfile);

try

    % test main working area
    h_fig = routinetest_general(h_fig);

    subprefix = '>> ';

    % test project management area
    if strcmp(opt,'all') || strcmp(opt,'project management')
        disp('test project management area...');
        routinetest_TA_projectManagementArea(h_fig,p,subprefix);
    end

    % test panel transition density plot
    if strcmp(opt,'all') || strcmp(opt,'transition density plot')
        disp('test panel transition density plot...');
        routinetest_TA_transitionDensityPlot(h_fig,p,subprefix);
    end

    % test panel state configuration
    if strcmp(opt,'all') || strcmp(opt,'state configuration')
        disp('test panel state configuration...');
        routinetest_TA_stateConfiguration(h_fig,p,subprefix);
    end

    % test panel state lifetimes
    if strcmp(opt,'all') || strcmp(opt,'state lifetimes')
        disp('test panel state lifetimes...');
        routinetest_TA_stateLifetimes(h_fig,p,subprefix);
    end

    % test panel kinetic model
    if strcmp(opt,'all') || strcmp(opt,'kinetic model')
        disp('test panel kinetic model...');
        routinetest_TA_kineticModel(h_fig,p,subprefix);
    end

    % test visualization area
    if strcmp(opt,'all') || strcmp(opt,'visualization area')
        disp('test visualization area...');
        routinetest_TA_visualizationArea(h_fig,p,subprefix);
    end
    
catch err
    % display error and stop logs
    disp(' ');
    dispMatlabErr(err)
    diary off;
    
    % close figures
    h = guidata(h_fig);
    if isfield(h,'expTDPopt') && isfield(h.expTDPopt,'figure_expTDPopt') && ...
            ishandle(h.expTDPopt.figure_expTDPopt)
        close(h.expTDPopt.figure_expTDPopt);
    end
    if isfield(h,'figure_setExpSet') && ishandle(h.figure_setExpSet)
        close(h.figure_setExpSet);
    end
    return
end

% close figure if executed from command window
if isempty(varargin)
    close(h_fig);
end

switch opt
    case 'all'
        module = 'module Transition analysis';
    case 'project management'
        module = cat(2,upper(opt(1)),opt(2:end),' area');
    otherwise
        module = cat(2,'panel ',upper(opt(1)),opt(2:end));
end
disp(' ');
disp(cat(2,module,' was successfully tested !'));
disp(' ');
disp('Generated test data are available at:')
disp(p.dumpdir);

% stop logs
diary off;
