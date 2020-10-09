function pushbutton_TDPaddProj_Callback(obj, evd, h_fig)
h = guidata(h_fig);
defPth = h.folderRoot;
[fname,pname,o] = uigetfile({'*.mash', 'MASH project(*.mash)'; ...
    '*path.dat', 'HaMMy path files (*path.dat)'; '*.*', ...
    'All files(*.*)'}, ...
    'Select data files', defPth, 'MultiSelect', 'on');

if ~isempty(fname) && ~isempty(pname) && sum(pname)
    if ~iscell(fname)
        fname = {fname};
    end
    
    p = h.param.TDP;
    
    % check if the project file is not already loaded
    excl_f = false(size(fname));
    str_proj = get(h.listbox_TDPprojList,'string');
    if isfield(p,'proj')
        for i = 1:numel(fname)
            for j = 1:numel(p.proj)
                if strcmp(cat(2,pname,fname{i}),p.proj{j}.proj_file)
                    excl_f(i) = true;
                    disp(cat(2,'project "',str_proj{j},'" is already ',...
                        'opened (',p.proj{j}.proj_file,').'));
                end
            end
        end
    end
    fname(excl_f) = [];
    
    % stop if no file is left
    if isempty(fname)
        return;
    end
    
    % load project data
    [dat,ok] = loadProj(pname, fname, 'intensities', h_fig);
    if ~ok
        return;
    end
    p.proj = [p.proj dat];
    
    % define data processing parameters applied (prm)
    for i = (size(p.proj,2)-size(dat,2)+1):size(p.proj,2)
        nChan = p.proj{i}.nb_channel;
        nExc = p.proj{i}.nb_excitations;
        nFRET = size(p.proj{i}.FRET,1);
        nS = size(p.proj{i}.S,1);
        nTpe = nChan*nExc + nFRET + nS;
        N = numel(p.proj{i}.coord_incl);
        
        if ~isfield(p.proj{i}, 'prmTDP')
            p.proj{i}.prm = cell(1,nTpe);
        else
            p.proj{i}.prm = p.proj{i}.prmTDP;
            p.proj{i} = rmfield(p.proj{i}, 'prmTDP');
        end
        if ~isfield(p.proj{i}, 'expTDP')
            p.proj{i}.exp = [];
        else
            p.proj{i}.exp = p.proj{i}.expTDP;
            p.proj{i} = rmfield(p.proj{i}, 'expTDP');
        end
        prm = p.proj{i}.prm;
        
        for tpe = 1:nTpe
            isRatio = 0;
            if tpe <= nChan*nExc % intensity
                i_c = mod(tpe,nChan); i_c(i_c==0) = nChan;
                i_l = ceil(tpe/nChan);
                trace = p.proj{i}.intensities_DTA(:,i_c:nChan:end,i_l);

                if p.proj{i}.cnt_p_sec
                    trace = trace/p.proj{i}.frame_rate;
                end
                if p.proj{i}.cnt_p_pix
                    trace = trace/p.proj{i}.pix_intgr(2);
                end

            elseif tpe <= nChan*nExc+nFRET % FRET
                i_f = tpe - nChan*nExc;
                trace = p.proj{i}.FRET_DTA(:,i_f:nFRET:end);
                isRatio = 1;

            elseif tpe <= nChan*nExc + nFRET + nS % Stoichiometry
                i_s = tpe - nChan*nExc - nFRET;
                trace = p.proj{i}.S_DTA(:,i_s:nS:end);
                isRatio = 1;
            end
            
            prm{tpe} = setDefPrm_TDP(prm{tpe},trace,isRatio,p.colList,N);
        end
        p.proj{i}.prm = prm;
        p.curr_type(i) = 1;
    end
    
    % set last-imported project as current project
    p.curr_proj = size(p.proj,2);
    
    % update project list
    p = ud_projLst(p, h.listbox_TDPprojList);
    h.param.TDP = p;
    guidata(h_fig, h);
    
    % display action
    if size(fname,2) > 1
        str_files = 'files:\n';
    else
        str_files = 'file: ';
    end
    for i = 1:size(fname,2)
        str_files = cat(2,str_files,pname,fname{i},'\n');
    end
    str_files = str_files(1:end-2);
    setContPan(['Project successfully imported from ' str_files],'success',...
        h_fig);
    
    % clear axes
    cla(h.axes_TDPplot1);
    
    % update calculations and GUI
    updateFields(h_fig, 'TDP');
end
