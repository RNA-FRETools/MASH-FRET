function menu_projMenu_binTime_Callback(obj,evd,h_fig)
    
if iscell(evd)
    expt = evd{1};
else
    % build confirmation message box
    prompt = {'WARNING: The re-sampling process induces a loss of single ',...
        'molecule videos that were used in individual projects.',...
        ' It is therefore recommended to perform all adjustments of ',...
        'molecule positions and background corrections prior merging.'};
    del = questdlg([prompt,' ','Do you wish to continue?'],...
        'Re-sample trajectories','Yes','Cancel','Yes');
    if ~strcmp(del, 'Yes')
        return
    end
    
    expt = inputdlg('Please define a new sampling time (in seconds):',...
        'New sampling time');
    if isempty(expt)
        return
    end
    if numel(str2double(expt{1}))~=1
        disp('Sampling time is ill defined.');
        return
    end
    expt = str2double(expt{1});
end

% show process
setContPan(sprintf(['Resampling trajectories to %0.5f ','seconds'],expt),...
    'process',h_fig);

% collects project data
h = guidata(h_fig);
p = h.param;
proj = p.curr_proj;
nChan = p.proj{proj}.nb_channel;
nFRET = size(p.proj{proj}.FRET,1);
nS = size(p.proj{proj}.S,1);
expt0 = p.proj{proj}.sampling_time;
I0 = p.proj{proj}.intensities;
incl0 = p.proj{proj}.bool_intensities;

% gets molecule sample size
[nRow,nCol,nExc] = size(I0);
N = nCol/nChan;
L = nRow*nExc;

% calculates ALEX sampling time
expt_alex = expt*nExc; % multiple time bin for ALEX data
expt0_alex = expt0*nExc; % multiple time bin for ALEX data

% re-sampling
I = [];
incl = [];
for n = 1:N
    
    % formats data for time binning
    framenb = reshape(1:L,nExc,nRow)';
    dat = [];
    colt = [];
    for e = 1:nExc
        colt = cat(2,colt,size(dat,2)+1);
        dat = cat(2,dat,[expt0_alex*framenb(:,e),framenb(:,e),...
            I0(:,((n-1)*nChan+1):(nChan*n),e)]);
    end
    
    % bins data
    dat = binData([dat,incl0(:,n)],expt_alex,expt0_alex,colt,colt+1);
    if isempty(dat)
        return
    end
    
    % formats binned data and appends project data
    In = [];
    for e = 1:nExc
        In = cat(3,In,dat(:,((e-1)*(nChan+2)+3):(e*(nChan+2))));
    end
    I = cat(2,I,In);
    incl = cat(2,incl,floor(dat(:,end)));
end

% resets data in projects and processing parameters
[nRow,~] = size(I);
p.proj{proj}.intensities = I;
p.proj{proj}.bool_intensities = ~~incl;
p.proj{proj}.resampling_time = expt;
for n = 1:N
    p.proj{proj}.TP.prm{n} = [];
end
p.proj{proj}.intensities_bgCorr = nan(nRow,N*nChan,nExc);
p.proj{proj}.intensities_crossCorr = nan(nRow,N*nChan,nExc);
p.proj{proj}.intensities_denoise = nan(nRow,N*nChan,nExc);
p.proj{proj}.intensities_DTA = nan(nRow,N*nChan,nExc);
if nFRET>0
    p.proj{proj}.FRET_DTA = nan(nRow,N*nFRET);
end
if nS>0
    p.proj{proj}.S_DTA = nan(nRow,N*nS);
end
for i = 1:size(p.proj{proj}.ES,2)
    if ~(numel(p.proj{proj}.ES{i})==1 && isnan(p.proj{proj}.ES{i}))
        p.proj{proj}.ES{i} = [];
    end
end
p.proj{proj}.is_movie = false;
p.proj{proj}.movie_file = {[]};
p.proj{proj}.movie_dim = {[]};
p.proj{proj}.movie_dat = {[]};

% reset HA and TA
p = importHA(p,p.curr_proj);
p = importTA(p,p.curr_proj);
h.param = p;
guidata(h_fig,h);

% update project and interface
updateFields(h_fig,'ttPr');
ud_HA_histDat(h_fig);
ud_TDPdata(h_fig);

% show sucess
setContPan(sprintf(['Trajectories were successfully sampled to %0.5f ',...
    'seconds'],expt),'success',h_fig);

