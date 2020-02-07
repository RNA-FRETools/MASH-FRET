function routinetest_menu(varargin)
% routinetest_menu
% routinetest_menu(h_fig)
% routinetest_menu(h_fig,opt)
%
% h_fig: handle to main figure if it exists
% opt: menus to test ('all','view','options' or 'tools');
%
% This routine execute main GUI-based actions performed when using menus in MASH's menu bar
% The script can be executed from MATLAB's command window or from the routine menu of MASH.
% It deletes default_param.ini and runs MASH if executed from command window, test callbacks and specific functionalities of each menu (appart from the Routine menu).

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
p = getDefault_menu;

% test main working area
h_fig = routinetest_general(p.annexpth,h_fig);
h = guidata(h_fig);

% test history view
if strcmp(opt,'all') || strcmp(opt,'view')
    disp('test menu View...');
    routinetest_menu_view(h_fig)
end

% test file overwriting options
if strcmp(opt,'all') || strcmp(opt,'options')
    disp('test menu Options...');
    routinetest_menu_options(h_fig)
end

% test tools
if strcmp(opt,'all') || strcmp(opt,'tools')
    disp('test menu Tools...');
    routinetest_menu_tools(h_fig,p,'>> ')
end

% close figure if executed from command window
if isempty(varargin)
    close(h_fig);
end

switch opt
    case 'all'
        module = 'all menus were';
    otherwise
        module = cat(2,'menu ',upper(opt(1)),opt(2:end),' was');
end
disp(cat(2,module,' successfully tested !'));
