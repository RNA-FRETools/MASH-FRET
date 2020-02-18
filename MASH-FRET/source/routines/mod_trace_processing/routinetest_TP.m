function routinetest_TP(varargin)
% routinetest_TP
% routinetest_TP(h_fig)
% routinetest_TP(h_fig,opt)
%
% h_fig: handle to main figure if it exists
% opt: panels to test ('all','project management area','sample management','plot','sub-images','background','cross-talks','denoising','photobleaching','factor corrections','find'states',visualization area');
%
% This routine execute main GUI-based actions performed when processing videos.
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
p = getDefault_TP;

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
    switchPan(h.togglebutton_TP,[],h_fig);
    
    % empty project list
    disp('empty project list...');
    nProj = numel(get(h.listbox_traceSet,'string'));
    proj = nProj;
    while proj>0
        set(h.listbox_traceSet,'value',proj);
        listbox_traceSet_Callback(h.listbox_traceSet,[],h_fig);
        pushbutton_remTraces_Callback(h.pushbutton_remTraces,[],h_fig);
        proj = proj-1;
    end
    
    % import default project
    disp('import default project...');
    pushbutton_addTraces_Callback({p.annexpth,p.mash_files{p.nL,p.nChan}},...
        [],h_fig);

    % save project (and default processing parameters)
    pushbutton_expProj_Callback({p.annexpth,p.mash_files{p.nL,p.nChan}},[],...
        h_fig);

    % set interface defaults
    disp('test main callbacks...');
    setDefault_TP(h_fig,p);

    subprefix = '>> ';

    % test project management area
    if strcmp(opt,'all') || strcmp(opt,'project management area')
        disp('test project management area...');
        routinetest_TP_projectManagementArea(h_fig,p,subprefix);
    end

    % test panel sample management
    if strcmp(opt,'all') || strcmp(opt,'sample management')
        disp('test panel sample management...');
        routinetest_TP_sampleManagement(h_fig,p,subprefix);
    end

    % test panel plot
    if strcmp(opt,'all') || strcmp(opt,'plot')
        disp('test panel plot...');
        routinetest_TP_plot(h_fig,p,subprefix);
    end

    % test panel sub-images
    if strcmp(opt,'all') || strcmp(opt,'sub-images')
        disp('test panel sub-images...');
        routinetest_TP_subImages(h_fig,p,subprefix);
    end

    % test panel background
    if strcmp(opt,'all') || strcmp(opt,'background')
        disp('test panel background...');
        routinetest_TP_background(h_fig,p,subprefix);
    end

    % test panel cross-talks
    if strcmp(opt,'all') || strcmp(opt,'cross-talks')
        disp('test panel cross-talks...');
        routinetest_TP_crossTalks(h_fig,p,subprefix);
    end

    % test panel denoising
    if strcmp(opt,'all') || strcmp(opt,'denoising')
        disp('test panel denoising...');
        routinetest_TP_denoising(h_fig,p,subprefix);
    end

    % test panel photobleaching
    if strcmp(opt,'all') || strcmp(opt,'photobleaching')
        disp('test panel photobleaching...');
        routinetest_TP_photobleaching(h_fig,p,subprefix);
    end

    % test panel factor corrections
    if strcmp(opt,'all') || strcmp(opt,'factor corrections')
        disp('test panel factor corrections...');
        routinetest_TP_factorCorrections(h_fig,p,subprefix);
    end

    % test panel finde states
    if strcmp(opt,'all') || strcmp(opt,'find states')
        disp('test panel find states...');
        routinetest_TP_findStates(h_fig,p,subprefix);
    end

    % test visualization area
    if strcmp(opt,'all') || strcmp(opt,'visualization area')
        disp('test visualization area...');
        routinetest_TP_visualizationArea(h_fig,p,subprefix);
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
        module = 'module Trace processing';
    case 'project management area'
        module = cat(2,upper(opt(1)),opt(2:end));
    case 'visualization area'
        module = cat(2,upper(opt(1)),opt(2:end));
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
