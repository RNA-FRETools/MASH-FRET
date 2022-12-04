function [ok,str_action] = exportResults(h_fig,varargin)
% Write simulated data and/or parameters to files.
%
% h_fig: handle to main figure
% varargin: (only if called from a script routine) {1} path to destination folder, {2} root name of files to export
%
% ok: execution success (1) or failure (0)
% str_action: export action string

% update 5.12.2019 by MH: (1) use separate functions for creating the background image, intensity-time traces and video frames; this allows to call the same scripts from here and plotExample.m, preventing unilateral modifications (2) use separate functions for writing in .sira and .avi files; this allows to call the same script from both modules Video processing and Simulation, preventing unilateral modifications (3) use separate function exportSimLogFile.m to write .log files
% update 20.2.2019 by MH: (1) add headers to dwell-time files (2) modify dwell-times file name for coherence with trace processing
% created the 23.4.2014 by MH

% initialize output arguments
ok = 0;
str_action = {};

% retrieve project content
h = guidata(h_fig);
p = h.param;
proj = p.curr_proj;
prm = p.proj{proj}.sim.prm;

% check simulated state sequences
if ~(isfield(prm,'res_dt') && ~isempty(prm.res_dt{1}))
    setContPan({'Error: State sequences have to be generated first.',...
        'Push the "Generate" button to do so.'},'error',h_fig);
    ok = 0;
    return
end

% identify function call from script routine
fromRoutine = size(varargin,2)==2;

% apply current export options to project
prm.exp = p.proj{proj}.sim.curr.exp;
p.proj{proj}.sim.prm = prm;
h.param = p;
guidata(h_fig,h);

% collect export options
isPrm = prm.exp{1}(1); % export simulation parameters (0/1)
isAsciiTr = prm.exp{1}(2); % export ASCII traces (0/1)
isMatTr = prm.exp{1}(3); % export Matlab traces (0/1)
isDt = prm.exp{1}(4); % export dwell-times (0/1)
isMov = prm.exp{1}(5); % export movie (0/1)
isAvi = prm.exp{1}(6); % export movie (0/1)
isCrd = prm.exp{1}(7); % export coordinates (0/1)
isFile = isPrm | isAsciiTr | isMatTr | isDt | isMov | isAvi | isCrd;

% get file name and destination for export
if isFile
    if fromRoutine
        pname = varargin{1};
        fname = varargin{2};
    else
        defpname = setCorrectPath('simulations',h_fig);
        if defpname(end)~=filesep
            defpname = [defpname,filesep];
        end
        deffname = p.proj{proj}.exp_parameters{1,2};
        [fname,pname] = uiputfile({'*.*','All files (*.*)'}, ...
            'Define a root name for file export',[defpname,deffname]);
    end
    if ~(~isempty(fname) && sum(fname))
        return
    end
    cd(pname);
    [~,fname,~] = fileparts(fname);
end

% collect simulation parameters
N = prm.gen_dt{1}(1);
rate = prm.gen_dt{1}(4);
isPresets = prm.gen_dt{3}{1};
presets = prm.gen_dt{3}{2};
coord =  prm.gen_dat{1}{1}{2};
viddim = prm.gen_dat{1}{2}{1};
FRETval = prm.gen_dat{2}(1,:);
outun = prm.exp{2};

% collect simulated state sequences and coordinates
Idon = permute(prm.res_dat{1}(:,1,:),[1,3,2]);
Iacc = permute(prm.res_dat{1}(:,2,:),[1,3,2]);
Idon_id = permute(prm.res_dat{1}(:,3,:),[1,3,2]);
Iacc_id = permute(prm.res_dat{1}(:,4,:),[1,3,2]);
discr_blurr = permute(prm.res_dat{2}(:,1,:),[1,3,2]);
discr = permute(prm.res_dat{2}(:,2,:),[1,3,2]);
discr_seq = permute(prm.res_dat{2}(:,3,:),[1,3,2]);

L = size(Idon,1);
dat = p.proj{proj};
dat.FRET_DTA = discr;
dat.FRET_DTA_import = discr;
dat.intensities = NaN(L,2*N);

 % check for file overwriting (one file exported per format)
if isMov
    fname_sira = [fname '.sira'];
    fname_sira = overwriteIt(fname_sira,pname,h_fig);
    if isempty(fname_sira)
        setContPan('Process interrupted.','error',h_fig);
        return;
    end
end
if isAvi
    fname_avi = [fname '.avi'];
    fname_avi = overwriteIt(fname_avi,pname,h_fig);
    if isempty(fname_avi)
        setContPan('Process interrupted.','error',h_fig);
        return;
    end
end
if isMatTr
    fname_mat = [fname '.mat'];
    fname_mat = overwriteIt(fname_mat,pname,h_fig);
    if isempty(fname_mat)
        setContPan('Process interrupted.','error',h_fig);
        return;
    end
end
if isCrd
    if ~exist([pname 'coordinates'], 'dir')
        mkdir([pname 'coordinates']);
    end
    fname_coord = [fname '.coord'];
    fname_coord = overwriteIt(fname_coord,[pname 'coordinates'],h_fig);
    if isempty(fname_coord)
        setContPan('Process interrupted.','error',h_fig);
        return;
    end
end
if isPrm
    fname_log = [fname '_param.log'];
    fname_log = overwriteIt(fname_log,pname,h_fig);
    if isempty(fname_log)
        setContPan('Process interrupted.','error',h_fig);
        return;
    end
end

% create folders if not existing (one file exported per molecule)
if isAsciiTr
    pname_proc = setCorrectPath(cat(2,pname,'traces_ASCII'),h_fig);
end
if isDt
    pname_dt = setCorrectPath(cat(2,pname,'dwell-times'), h_fig);
end

% display action
setContPan('Create background image ...', 'process', h_fig);

% get background image
[img_bg,err] = getBackgroundImage(prm);
if isempty(img_bg)
    % abort if background image can not be created
    updateActPan(err, h_fig, 'error');
    return
end

% export SMV
if isMov || isAvi % sira or avi file 

    % display action
    setContPan('Write video to file ...', 'process', h_fig);

    % open blank movie file
    if isMov
        % get MASH-FRET version
        figname = get(h_fig,'Name');
        vers = figname(length('MASH-FRET '):end);
        
        % write sira file headers
        f = writeSiraFile('init',[pname,fname_sira],vers,...
            [1/rate,viddim,L]);
        if f==-1
            setContPan(['Enable to open file ',fname_sira],'error',h_fig);
            return;
        end
        
        % get number of pixels in one frame
        nPix = viddim(1)*viddim(2);
    end

    if isAvi
        v = writeAviFile('init',[pname,fname_avi],1/rate);
    end

    for l = 1:L % number of frames
        
        % initialize time count at second frame
        if l==2 && ~fromRoutine
            t = tic;
        end
        
        % create video frame
        [img,~,err] = createVideoFrame(l,Idon,Iacc,coord,img_bg,prm,outun);
        if isempty(img)
            % abort if video frame can not be created
            updateActPan(err, h_fig, 'error');
            return
        end
        
        % write pixel data to file
        if isMov
            writeSiraFile('append',f,img,nPix);
        end
        if isAvi
            v = writeAviFile('append',v,img);
        end

        % display estimated processing time and ask confirmation to user
        if l==2 && ~fromRoutine
            t_remain = (L-2)*toc(t);
            ok = dispProcessTime(t_remain,'Do you want to continue?');
            if ~ok
                if isMov
                    fclose(f);
                    delete([pname fname_sira]);
                end
                if isAvi
                    close(v);
                    delete([pname fname_avi]);
                end
                setContPan('Process interrupted.','error',h_fig);
                return;
            end
        end
    end
    
    % append action string
    if isMov
        str_action = cat(2,str_action,['Video written to file: ',...
            fname_sira,' in folder: ',pname]);
        fclose(f);
    end
    if isAvi
        str_action = cat(2,str_action,['Video written to AVI file ',...
            fname_avi,' in folder:',pname]);
        close(v);
    end
end

% export traces and dwell times
if isMatTr || isAsciiTr || isDt
    % display action
    setContPan('Write trace data to files ...', 'process', h_fig);
end
    
% get frame and time axis for trace export
frameAxis = (1:L)';
timeAxis = frameAxis/rate;

% initialize trace matrix for MATLAB file export
if isMatTr
    Trace_all = [frameAxis,timeAxis];
end

% get intensity units for trace file export
if isMatTr || isAsciiTr
    % output intensity units
    if strcmp(outun,'photon')
        units = 'photons';
    else
        units = 'a.u.';
    end
end

% get state configuration for dwell times export
if isDt
    if ~(isPresets && isfield(presets,'stateVal'))
        states = FRETval;
        J = numel(states);
    else
        J = size(presets.stateVal,2);
    end
end

for n = 1:N

    % create donor-acceptor intensity-time traces
    [Idon_out,Iacc_out,err] = createIntensityTraces(Idon(:,n),...
        Iacc(:,n),coord(n,:),img_bg,prm,outun);
    if isempty(Idon_out) || isempty(Iacc_out)
        % abort if traces can not be created
        updateActPan(err, h_fig, 'error');
        return
    end

    % update trace matrix for MATLAB file export
    if isMatTr
        Trace_all = cat(2,Trace_all,Idon_out,Iacc_out);
    end

    % export molecule traces to ASCII file
    if isAsciiTr
        % check for file overwriting (one file exported per molecule)
        fname_proc = cat(2,pname_proc,fname,'_mol',num2str(n),'of',...
            num2str(N),'.txt');
        fname_proc = overwriteIt(fname_proc,pname_proc,h_fig);
        if isempty(fname_proc)
            setContPan('Process interrupted.','error',h_fig);
            return
        end

        % format data
        FRET = Iacc_out./(Iacc_out+Idon_out);
        output = [timeAxis,frameAxis,Idon_out,Iacc_out,Idon_id(:,n),...
            Iacc_id(:,n),FRET,discr_blurr(:,n),dat.FRET_DTA(:,n),...
            discr_seq(:,n)];
        output = output(dat.FRET_DTA(:,n)>=0,:);
        fmt_coord = cat(2,'coordinates ',repmat('\t%0.2f',[1,4]),'\n');
        str_head = cat(2,'time(s)\tframe\tIdon(',units,...
            ')\tIacc(',units,')\tIdon ideal(',units,')\t',...
            'Iacc ideal(',units,')\tFRET\tFRET ideal (blurr)\t',...
            'FRET ideal\tstate sequence\n'); 
        str_output = repmat('%d\t',[1,size(output,2)]);
        str_output(end) = 'n';

        % write data to file
        f = fopen(fname_proc,'Wt');
        fprintf(f,fmt_coord,coord(n,:));
        fprintf(f,str_head);
        fprintf(f,str_output,output');
        fclose(f);
    end

    % export molecule dwell times to ASCII file
    if isDt
        fname_dt = cat(2,pname_dt,fname,'_mol',num2str(n),'of',...
            num2str(N),'_FRET1to2.dt');
        fname_dt = overwriteIt(fname_dt,pname_dt,h_fig);
        if isempty(fname_dt)
            setContPan('Process interrupted.','error',h_fig);
            return;
        end

        dt = prm.res_dt{3}{n};
        dt(:,1) = dt(:,1)/rate;
        if isPresets && isfield(presets,'stateVal')
            states = presets.stateVal(n,:);
        end
        statevals = dt(:,[2,3]);
        for j = 1:J
            statevals(dt(:,2)==j,1) = states(j);
            statevals(dt(:,3)==j,2) = states(j);
        end

        f = fopen(fname_dt,'Wt');
        fprintf(f,cat(2,'dwell-time (second)\tstate\t',...
            'state after transition\tFRET\tFRET after transition\n'));
        fprintf(f,'%d\t%d\t%d\t%d\t%d\n',[dt,statevals]');
        fclose(f);
    end
    
    dat.intensities(:,[2*(n-1)+1,2*n]) = [Idon_out,Iacc_out];
end

% append action string
if isAsciiTr
    str_action = cat(2,str_action,['Traces written to files in folder',...
        ': ',pname_proc]);
end
if isDt
    str_action = cat(2,str_action,['Dwell times written to files in ',...
        'folder: ',pname_dt]);
end

% export traces to MATLAB file
if isMatTr
    save([pname fname_mat],'coord','Trace_all','units');

    % append action string
    str_action = cat(2,str_action,['Traces written to Matlab file: ',...
        fname_mat,' in folder: ',pname]);
end

% export coordinates
if isCrd
    % display action
    setContPan('Write coordinates to file ...', 'process', h_fig);
    
    save([pname 'coordinates' filesep fname_coord], 'coord','-ascii');
    
    % append action string
    str_action = cat(2,str_action,['Molecule coordinates written to file:',...
        ' ',fname_coord,' in folder: ',pname,'coordinates',filesep]);
end

% export simulation parameters
if isPrm
    % display action
    setContPan('Write simulation parameters to file ...','process',h_fig);
    
    exportSimLogFile(cat(2,pname,fname_log),h_fig);
    
    % append action string
    str_action = cat(2,str_action,['Simulation parameters written to file',...
        ': ',fname_log,' in folder: ',pname]);
end

dat.date_last_modif = datestr(now);
dat.coord_file = []; % coordinates path/file
dat.coord_imp_param = []; % coordinates import parameters
dat.coord = []; % molecule coordinates in all channels
dat.coord_incl = true(1,N);
dat.is_coord = 0;

dat.frame_rate = 1/rate;
dat.pix_intgr = [1 1]; % intgr. area dim. + nb of intgr pix

dat.intensities_bgCorr = nan(L,2*N);
dat.intensities_crossCorr = nan(L,2*N);
dat.intensities_denoise = nan(L,2*N);
dat.ES = {};
dat.intensities_DTA = nan(L,2*N);
dat.S_DTA = [];
dat.bool_intensities = discr>0;

dat.molTag = false(N,numel(dat.molTagNames));

[dat,~] = checkField(dat,'',h_fig);
if isempty(dat)
    return
end
p.proj{proj} = dat;

% tag project
p.proj{proj}.TP.from = p.proj{proj}.sim.from;
p.proj{proj}.HA.from = p.proj{proj}.sim.from;
p.proj{proj}.TA.from = p.proj{proj}.sim.from;

% set default TP, HA and TA parameters
p = importTP(p,proj);
p = importHA(p,proj);
p = importTA(p,proj);

% set photobleaching cutoff
for m = 1:numel(p.proj{proj}.TP.curr)
    id = find(discr(:,m)>0);
    if isempty(id)
        cutoff = 1;
    else 
        cutoff = id(end);
    end
    p.proj{proj}.TP.curr{m}{2}{1}(1) = 1; % apply cutoff
    p.proj{proj}.TP.curr{m}{2}{1}(2) = 1; % manual method
    p.proj{proj}.TP.curr{m}{2}{1}(5) = cutoff; % cutoff frames
end

% save modifications
h = guidata(h_fig); % recover file overwrite options
p.proj{proj}.sim.prm = prm;
h.param = p;
guidata(h_fig,h);

% update project-dependant interface
ud_TTprojPrm(h_fig);

% update plots and GUI
updateFields(h_fig);

% return success
ok = 1;


