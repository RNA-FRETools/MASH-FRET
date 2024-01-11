function push_setExpSet_save(obj,evd,dat2import,h_fig,h_fig0)

% recover project settings from options window
proj = h_fig.UserData;

if strcmp(dat2import,'sim')
    proj.sim.from = 'S'; % tag project
    
    mod = 'S';
    
elseif strcmp(dat2import,'video')
    proj.VP.from = 'VP'; % tag project
    
    mod = 'VP';

elseif strcmp(dat2import,'trajectories')
    % read data from trajectory file
    setContPan('Read trajectories from files...','process',h_fig0);
    proj = h_fig.UserData;
    [proj,ok] = loadProj(proj.traj_files{1},proj.traj_files{2},proj,...
        h_fig0);
    if ~ok
        return
    end
    
    % tag project
    if proj.is_movie
        proj.VP.from = 'TP';
    end
    proj.TP.from = 'TP';
    proj.HA.from = 'TP';
    proj.TA.from = 'TP';
    
    mod = 'TP';
    
elseif strcmp(dat2import,'histogram')
    % read data from histogram file
    setContPan('Read histogram from file...','process',h_fig0);
    proj = h_fig.UserData;
    [proj,ok] = loadProj(proj.hist_file{1},proj.hist_file{2},proj,...
        h_fig0);
    if ~ok
        return
    end
    
    % tag project
    proj.HA.from = 'HA';
    
    mod = 'HA';
end

% retrieve interface's content
h = guidata(h_fig0);
p = h.param;

% load full-length video data in memory if possible
if ~strcmp(dat2import,'edit') && proj.is_movie && numel(proj.movie_file)==1 ...
        && ~isFullLengthVideo(proj.movie_file{1},h_fig)
    h.movie.movie = [];
    h.movie.file = '';
    guidata(h_fig,h);
    [dat,ok] = getFrames(proj.movie_file{1},'all',proj.movie_dat{1},h_fig,...
        true);
    if ~ok
        return
    end
    h = guidata(h_fig);
    if ~isempty(dat.movie)
        h.movie.movie = dat.movie;
        h.movie.file = proj.movie_file{1};
        guidata(h_fig,h);
        
    elseif ~isempty(h.movie.movie)
        h.movie.file = proj.movie_file{1};
        guidata(h_fig,h);
    end
end

if strcmp(dat2import,'sim') || strcmp(dat2import,'video') || ...
        strcmp(dat2import,'trajectories') || strcmp(dat2import,'histogram')
    % add project to list and initialize list indexes
    proj_id = numel(p.proj)+1;
    p.proj = [p.proj,proj];
    p.curr_proj = proj_id;
    p = adjustProjIndexLists(p,proj_id,{mod});

    % set processing parameters
    p = importSim(p,proj_id);
    p = importVP(p,proj_id);
    p = importTP(p,proj_id);
    p = importHA(p,proj_id);
    p = importTA(p,proj_id);

    % update project list
    p = ud_projLst(p, h.listbox_proj);

    % save modifications
    h.param = p;
    guidata(h_fig0,h);

    % update project-dependant TP interface
    ud_TTprojPrm(h_fig0);

    % make root folder current directory
    cd(p.proj{p.curr_proj}.folderRoot);

    % switch to proper module
    switchPan(eval(['h.togglebutton_',p.curr_mod{p.curr_proj}]),[],h_fig0);

    % bring project's current plot front
    bringPlotTabFront([p.sim.curr_plot(p.curr_proj),...
        p.movPr.curr_plot(p.curr_proj),p.ttPr.curr_plot(p.curr_proj),...
        p.thm.curr_plot(p.curr_proj),p.TDP.curr_plot(p.curr_proj)],h_fig0);

    % refresh interface
    updateFields(h_fig0);

    % display success
    setContPan(['Project "',p.proj{p.curr_proj}.exp_parameters{1,2},...
        '" ready!'],'success',h_fig0);
    
elseif strcmp(dat2import,'edit')

    % retrieve new project parameters
    nChan = proj.nb_channel;
    nExc = proj.nb_excitations;
    labels = proj.labels;
    clr = proj.colours;
    exc = proj.excitations;
    nFRET = size(proj.FRET,1);
    N = numel(proj.coord_incl);
    nS = size(proj.S,1);
    L = size(proj.bool_intensities,1);

    % re-adjust size of array containing state sequences
    if size(proj.FRET_DTA,2)<nFRET*N
        proj.FRET_DTA = [proj.FRET_DTA ...
            nan([L (nFRET*N-size(proj.FRET_DTA,2))])];
    elseif size(proj.FRET_DTA,2) > nFRET*N
        proj.FRET_DTA = proj.FRET_DTA(1:nFRET*N);
    end
    if size(proj.S_DTA,2)<nS*N
        proj.S_DTA = [proj.S_DTA nan([L (nS*N-size(proj.S_DTA,2))])];
    elseif size(proj.S_DTA,2) > nS*N
        proj.S_DTA = proj.S_DTA(1:nS*N);
    end

    % reset ES histograms
    if ~isequal(proj.FRET,proj.FRET) || ~isequal(proj.S,proj.S)
        if nFRET>0
            proj.ES = cell(1,nFRET);
        else
            proj.ES = {};
        end
    end

    p.proj{p.curr_proj} = proj;

    if isModuleOn(p,'TP')
        % resize default TP parameters
        p.ttPr.defProjPrm = setDefPrm_traces(p, p.curr_proj);
        p.proj{p.curr_proj}.TP.def.mol = adjustVal(...
            p.proj{p.curr_proj}.TP.def.mol,p.ttPr.defProjPrm.mol);

        % resize general TP parameters
        p.proj{p.curr_proj}.TP.fix = adjustVal(p.proj{p.curr_proj}.TP.fix, ...
            p.ttPr.defProjPrm.general);

        % adjust selection in the list of bottom traces in "Plot" panel
        if (nFRET+nS)>0
            str_bot = getStrPop('plot_botChan',{p.proj{p.curr_proj}.FRET,...
                p.proj{p.curr_proj}.S,exc,clr,labels});
            p.proj{p.curr_proj}.TP.fix{2}(3) = numel(str_bot);
        end

        % resize TP's export options
        p.proj{p.curr_proj}.TP.exp = setExpOpt(p.proj{p.curr_proj}.TP.exp,...
            p.proj{p.curr_proj});

        % resize TP's processing parameters
        for n = 1:N
            p.proj{p.curr_proj}.TP.curr{n} = adjustVal(...
                p.proj{p.curr_proj}.TP.prm{n},...
                p.proj{p.curr_proj}.TP.def.mol);
        end
    end
    if isModuleOn(p,'TA')
        if p.TDP.curr_type(p.curr_proj)>(nChan*nExc+nFRET+nS)
            p.TDP.curr_type(p.curr_proj) = nChan*nExc+nFRET+nS;
        end
    end

    % update project list
    p = ud_projLst(p, h.listbox_proj);

    % save modifications
    h.param = p;
    guidata(h_fig0, h);

    % update TP interface according to new parameters
    ud_TTprojPrm(h_fig0);

    % refresh interface
    updateFields(h_fig0);

    % display success
    setContPan('Experiment settings successfully modified!','success',...
        h_fig0);
end

% close options window and save options as interface's defaults
figure_setExpSet_CloseRequestFcn([],[],h_fig,h_fig0,[],1);
