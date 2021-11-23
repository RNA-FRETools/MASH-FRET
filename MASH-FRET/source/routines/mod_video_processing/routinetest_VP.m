function routinetest_VP(varargin)
% routinetest_VP
% routinetest_VP(h_fig)
% routinetest_VP(h_fig,opt)
%
% h_fig: handle to main figure if it exists
% opt: panels to test ('all','visualization area','plot','experiment settings','edit and export video', 'molecule coordinates' or 'intensity integration');
%
% This routine execute main GUI-based actions performed when processing videos.
% The script can be executed from MATLAB's command window or from the routine menu of MASH.
% It deletes default_param.ini and runs MASH if executed from command window, test all uicontrol callbacks, video import and specific functionalities of each panel.

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
p = getDefault_VP;

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
    h = guidata(h_fig);

    % test video format
    nvid = size(p.vid_files,2);
    for f = 1:nvid
        disp(['test video format ',p.vid_files{f},'...']);

        subprefix = '>> >> ';
        
        [~,~,fmt] = fileparts(p.vid_files{f});
        
        p.nChan = p.nChan_def;
        p.nL = p.nL_def;
        name = strrep(p.vid_files{f},'.','_');
        p.tracecurs_file = [name,'_pointITT.png'];
        p.exp_axes = [name,'_graph'];
        p.exp_traceFile{p.nL,p.nChan} = [name,'.mash'];

        p.es{p.nChan,p.nL}.div.projttl = ...
            sprintf(name,'_%ichan%iexc',p.nChan,p.nL);
        p.es{p.nChan,p.nL}.imp.vfile = p.vid_files{f};
        routinetest_VP_createProj(p,h_fig,subprefix);
        
        if strcmp(fmt,'.png') || strcmp(fmt,'.avi') || strcmp(fmt,'.coord')
            continue
        end
        
        % test intensity-time traces creation
        disp('>> test calculations of time traces...');
        impOpt = {reshape(1:(2*p.nChan),[2,p.nChan])',1};
        set_VP_impIntgrOpt(impOpt,h.pushbutton_TTgen_loadOpt,h_fig);
        [~,smcoordfile,~] = fileparts(p.coord_file{p.nChan});
        h = guidata(h_fig);
        proj = h.param.proj{h.param.curr_proj};
        smcoordfile = [smcoordfile,'_',num2str(proj.movie_dim(1)),'.coord'];
        pushbutton_TTgen_loadCoord_Callback({p.annexpth,smcoordfile},[],...
            h_fig);
        pushbutton_TTgen_create_Callback(h.pushbutton_TTgen_create,[],...
            h_fig);
        
        % test project saving
        disp('>> test project saving...');
        pushbutton_saveProj_Callback({p.dumpdir,...
            p.exp_traceFile{p.nL,p.nChan}},[],h_fig);

        % test visualization area
        if strcmp(opt,'all') || strcmp(opt,'visualization area')
            disp('>> test visualization area...');
            routinetest_VP_visualizationArea(h_fig,p,subprefix);
        end
    end

    name = strrep(p.vid_files{1},'.','_');
    p.exp_vid = [name,'_videxport'];
    
    % prepare interface
    if strcmp(opt,'all') || strcmp(opt,'plot') || ...
            strcmp(opt,'edit and export video')
        p.es{p.nChan,p.nL}.div.projttl = ...
            sprintf(name,'_%ichan%iexc',p.nChan,p.nL);
        p.es{p.nChan,p.nL}.imp.vfile = p.vid_files{1};
        routinetest_VP_createProj(p,h_fig,subprefix);
    end

    % test panel Plot
    if strcmp(opt,'all') || strcmp(opt,'plot')
        disp('>> test panel Plot...');
        routinetest_VP_plot(h_fig,p,subprefix);
    end

    % test panel Edit and export video
    if strcmp(opt,'all') || strcmp(opt,'edit and export video')
        disp('>> test panel Edit and export video...');
        routinetest_VP_editAndExportVideo(h_fig,p,subprefix);
    end

    for nChan = 1:p.nChan_max
        p.nChan = nChan;
        p.nL = p.nL_def;
        namechan = [name,'_',num2str(p.nChan),'chan'];
        p.exp_ave = [namechan,'_ave.png'];
        p.exp_spots = {[namechan,'_%i.spots'],...
            [namechan,'_%i_fit.spots']}; % exported spots file

        % prepare interface
        if strcmp(opt,'all') || ...
                strcmp(opt,'molecule coordinates') || ...
                strcmp(opt,'intensity integration')
            p.es{p.nChan,p.nL}.div.projttl = ...
                sprintf(name,'_%ichan%iexc',p.nChan,p.nL);
            p.es{p.nChan,p.nL}.imp.vfile = p.vid_files{1};
            routinetest_VP_createProj(p,h_fig,subprefix);
        end

        % test panel Molecule coordinates
        if strcmp(opt,'all') || strcmp(opt,'molecule coordinates')
            disp(['>> test panel Molecule coordinates for ',...
                num2str(nChan),' channels...']);
            routinetest_VP_moleculeCoordinates(h_fig,p,subprefix);
        end

        for nL = 1:p.nL_max
            p.nL = nL;
            
            p.exp_traceFile{p.nL,p.nChan} = ...
                [namechan,num2str(p.nL),'exc.mash'];

            % test panel Intensity integration
            if strcmp(opt,'all') || strcmp(opt,'intensity integration')
                disp(['>> test panel Intensity integration for ',...
                    num2str(nChan),' channels and ',num2str(nL),...
                    ' lasers...']);
                p.es{p.nChan,p.nL}.div.projttl = ...
                    sprintf(name,'_%ichan%iexc',p.nChan,p.nL);
                p.es{p.nChan,p.nL}.imp.vfile = p.vid_files{1};
                routinetest_VP_createProj(p,h_fig,subprefix);
                routinetest_VP_intensityIntegration(h_fig,p,subprefix);
            end
        
            % test project saving
            disp('>> test project saving...');
            pushbutton_saveProj_Callback({p.dumpdir,...
                p.exp_traceFile{p.nL,p.nChan}},[],h_fig);
        end
    end

    % empty project list
    nProj = numel(h.listbox_proj.String);
    for proj = nProj:-1:1
        set(h.listbox_proj,'value',proj);
        listbox_projLst_Callback(h.listbox_proj,[],h_fig);
        pushbutton_closeProj_Callback(h.pushbutton_closeProj,[],h_fig,...
            true);
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
        module = 'module Video processing';
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
