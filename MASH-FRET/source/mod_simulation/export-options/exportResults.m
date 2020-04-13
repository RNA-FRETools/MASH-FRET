function [ok,str_action] = exportResults(h_fig,varargin)
% Write simulated data and/or parameters to files.
%
% h_fig: handle to main figure
% varargin: (only if called from a script routine) {1} path to destination folder, {2} root name of files to export
%
% ok: execution success (1) or failure (0)
% str_action: export action string

% Last update: 5.12.2019 by MH
% >> use separate functions for creating the background image, intensity-
%  time traces and video frames; this allows to call the same scripts from 
%  here and plotExample.m, preventing unilateral modifications
% >> use separate functions for writing in .sira and .avi files; this 
%  allows to call the same script from both modules Video processing and 
%  Simulation, preventing unilateral modifications
% >> use separate function exportSimLogFile.m to write .log files
%
% update: 20th of February 2019 by Mélodie Hadzic
% >> add headers to dwell-time files
% >> modify dwell-times file name for coherence with trace processing
%
% Created the 23rd of April 2014 by Mélodie C.A.S Hadzic

% initialize output arguments
ok = 0;
str_action = {};

% identify function call from script routine
fromRoutine = size(varargin,2)==2;

% get file name and destination for export
if fromRoutine
    pname = varargin{1};
    fname = varargin{2};
else
    [fname,pname] = uiputfile({'*.*','All files (*.*)'}, ...
        'Define a root name for file export', ...
        setCorrectPath('simulations',h_fig));
end
if ~(~isempty(fname) && sum(fname))
    return
end
cd(pname);
[~,fname,~] = fileparts(fname);

% collect simulation parameters and results
h = guidata(h_fig);
p = h.param.sim;
res = h.results.sim;

% collect export options
isPrm = p.export_param; % export simulation parameters (0/1)
isAvi = p.export_avi; % export movie (0/1)
isMov = p.export_movie; % export movie (0/1)
isMatTr = p.export_traces; % export Matlab traces (0/1)
isAsciiTr = p.export_procTraces; % export ASCII traces (0/1)
isCrd = p.export_coord; % export coordinates (0/1)
isDt = p.export_dt; % export dwell-times (0/1)

% abort if no export options are defined
if ~(isPrm || isAvi || isMov || isMatTr || isAsciiTr || isCrd || isDt)
    setContPan('Error: No saving option is defined for exporting data.',...
        'error',h_fig);
    return
end

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
    fname_coord = overwriteIt(fname_coord,[pname 'coordinates'],...
        h_fig);
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

% collect simulated state sequences and coordinates
dat = res.dat;
dat_id = res.dat_id;
Idon = dat{1};
Iacc = dat{2};
coord = dat{3};
Idon_id = dat_id{1};
Iacc_id = dat_id{2};
discr = dat_id{3};
discr_seq = dat_id{4};
L = size(Idon{1},1);

if isMov || isAvi || isMatTr || isAsciiTr
    
    % display action
    setContPan('Create background image ...', 'process', h_fig);
    
    % get background image
    [img_bg,err] = getBackgroundImage(p);
    if isempty(img_bg)
        % abort if background image can not be created
        updateActPan(err, h_fig, 'error');
        return
    end
    
    % determine camera saturation value
    [~,p.sat] = Saturation(p.bitnr);
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
        f = writeSiraFile('init',[pname,fname_sira],vers,[1/p.rate,...
            p.movDim,L]);
        if f==-1
            setContPan(['Enable to open file ',fname_sira],'error',h_fig);
            return;
        end
        
        % get number of pixels in one frame
        nPix = p.movDim(1)*p.movDim(2);
    end

    if isAvi
        v = writeAviFile('init',[pname,fname_avi],1/p.rate);
    end

    for l = 1:L % number of frames
        
        % initialize time count at second frame
        if l==2 && ~fromRoutine
            t = tic;
        end
        
        % create video frame
        [img,gaussMat,err] = createVideoFrame(l,Idon,Iacc,coord,img_bg,p);
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
    
    % get frame and time axis for trace export
    frameAxis = (1:L)';
    timeAxis = frameAxis/p.rate;
    
    % initialize trace matrix for MATLAB file export
    if isMatTr
        Trace_all = [frameAxis,timeAxis];
    end
    
    % get intensity units for trace file export
    if isMatTr || isAsciiTr
        % output intensity units
        if strcmp(p.intOpUnits,'photon')
            units = 'photons';
        else
            units = 'a.u.';
        end
    end
    
    % get state configuration for dwell times export
    if isDt
        if ~(p.impPrm && isfield(p.molPrm,'stateVal'))
            states = p.stateVal;
            J = numel(states);
        else
            J = size(p.molPrm.stateVal,2);
        end
    end

    for n = 1:p.molNb
        
        if isMatTr || isAsciiTr
            % create donor-acceptor intensity-time traces
            [Idon_out,Iacc_out,err] = createIntensityTraces(Idon{n},...
                Iacc{n},coord(n,:),img_bg,p);
            if isempty(Idon_out) || isempty(Iacc_out)
                % abort if traces can not be created
                updateActPan(err, h_fig, 'error');
                return
            end
        end
        
        % update trace matrix for MATLAB file export
        if isMatTr
            Trace_all = cat(2,Trace_all,Idon_out,Iacc_out);
        end
        
        % export molecule traces to ASCII file
        if isAsciiTr
            % check for file overwriting (one file exported per molecule)
            fname_proc = cat(2,pname_proc,fname,'_mol',num2str(n),'of',...
                num2str(p.molNb),'.txt');
            fname_proc = overwriteIt(fname_proc,pname_proc,h_fig);
            if isempty(fname_proc)
                setContPan('Process interrupted.','error',h_fig);
                return
            end
            
            % format data
            FRET = Iacc_out./(Iacc_out+Idon_out);
            output = [timeAxis,frameAxis,Idon_out,Iacc_out,Idon_id{n},...
                Iacc_id{n},FRET,discr{n},discr_seq{n}];
            fmt_coord = cat(2,'coordinates ',repmat('\t%0.2f',[1,4]),'\n');
            str_head = cat(2,'time(s)\tframe\tIdon noise(',units,...
                ')\tIacc noise(',units,')\tIdon ideal(',units,')\t',...
                'Iacc ideal(',units,')\tFRET\tFRET ideal\t',...
                'state sequence\n'); 
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
                num2str(p.molNb),'_FRET1to2.dt');
            fname_dt = overwriteIt(fname_dt,pname_dt,h_fig);
            if isempty(fname_dt)
                setContPan('Process interrupted.','error',h_fig);
                return;
            end
            
            dt = res.dt_final{n};
            if p.impPrm && isfield(p.molPrm,'stateVal')
                states = p.molPrm.stateVal(n,:);
            end
            for j = 1:J
                dt(dt(:,2)==j,2) = states(j);
                dt(dt(:,3)==j,3) = states(j);
            end
            
            f = fopen(fname_dt,'Wt');
            fprintf(f,cat(2,'dwell-time (second)\tstate\tstate after ',...
                'transition\n'));
            fprintf(f,'%d\t%d\t%d\n',dt');
            fclose(f);
        end
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
    
    exportSimLogFile(cat(2,pname,fname_log),h);
    
    % append action string
    str_action = cat(2,str_action,['Simulation parameters written to file',...
        ': ',fname_log,' in folder: ',pname]);
end

% return success
ok = 1;


