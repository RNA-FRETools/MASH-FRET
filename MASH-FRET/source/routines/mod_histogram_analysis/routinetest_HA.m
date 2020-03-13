function routinetest_HA(varargin)
% routinetest_HA
% routinetest_HA(h_fig)
% routinetest_HA(h_fig,opt)
%
% h_fig: handle to main figure if it exists
% opt: panels to test ('all','project management','histogram and plot','state configuration','state populations','visualization'
%
% This routine execute main GUI-based actions performed when analyzing histograms.
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
p = getDefault_HA;

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
    h_fig = routinetest_general(p.annexpth,h_fig);
    h = guidata(h_fig);

    % switch to trace processing module
    switchPan(h.togglebutton_HA,[],h_fig);

    % set interface defaults
    disp('test main callbacks...');
    setDefault_HA(h_fig,p);

    subprefix = '>> ';

    % test project management area
    if strcmp(opt,'all') || strcmp(opt,'project management')
        disp('test project management area...');
        routinetest_HA_projectManagementArea(h_fig,p,subprefix);
    end

    % test panel transition density plot
    if strcmp(opt,'all') || strcmp(opt,'histogram and plot')
        disp('test panel histogram and plot...');
        routinetest_HA_histogramAndPlot(h_fig,p,subprefix);
    end

    % test panel state configuration
    if strcmp(opt,'all') || strcmp(opt,'state configuration')
        disp('test panel state configuration...');
        routinetest_HA_stateConfiguration(h_fig,p,subprefix);
    end

    % test panel state populations
    if strcmp(opt,'all') || strcmp(opt,'state populations')
        disp('test panel state populations...');
        routinetest_HA_statePopulations(h_fig,p,subprefix);
    end
    
    % test visuaöization area
    if strcmp(opt,'all') || strcmp(opt,'visualization')
        disp('test visualization area...');
        routinetest_HA_visualizationArea(h_fig,p,subprefix);
    end
    
catch err
    % display error and stop logs
    disp(' ');
    dispMatlabErr(err)
    diary off;
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
    case 'visualization'
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
