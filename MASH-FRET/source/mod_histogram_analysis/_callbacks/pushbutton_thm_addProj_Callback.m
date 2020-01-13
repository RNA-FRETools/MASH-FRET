function pushbutton_thm_addProj_Callback(obj, evd, h_fig)

% Last update: 28.3.2019 by MH
% --> Define "isratio" variable and pass it to "setDefPrm_thm" to define
%     ratio-specific parameters

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
    
    p = h.param.thm;
    
    % check if the project file is not already loaded
    excl_f = false(size(fname));
    str_proj = get(h.listbox_thm_projLst,'string');
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
        allExc = p.proj{i}.excitations;
        chanExc = p.proj{i}.chanExc;
        nFRET = size(p.proj{i}.FRET,1);
        nS = size(p.proj{i}.S,1);
        nTpe = 2*nChan*nExc + 2*nFRET + 2*nS;
        I = p.proj{i}.intensities_denoise;
        I_discr = p.proj{i}.intensities_DTA;
        incl = p.proj{i}.coord_incl;
        FRET = p.proj{i}.FRET;
        FRET_discr = p.proj{i}.FRET_DTA;
        S = p.proj{i}.S;
        S_discr = p.proj{i}.S_DTA;
        N = size(I,1); nMol = size(I,2)/nChan;
        
        if ~isfield(p.proj{i}, 'prmThm')
            p.proj{i}.prm = cell(1,nTpe);
        else
            p.proj{i}.prm = p.proj{i}.prmThm;
            p.proj{i} = rmfield(p.proj{i}, 'prmThm');
        end
        if ~isfield(p.proj{i}, 'expThm')
            p.proj{i}.exp = [];
        else
            p.proj{i}.exp = p.proj{i}.expThm;
            p.proj{i} = rmfield(p.proj{i}, 'expThm');
        end
        prm = p.proj{i}.prm;
        
        % project was not processed in Trace processing
        if ~isfield(p.proj{i},'prmTT')
            p.proj{i}.prmTT = cell(1,nMol);
            I = p.proj{i}.intensities;
        end
        
        if nTpe>size(prm,2)
            prm = cell(1,nTpe);
        end
        
        for tpe = 1:nTpe
            
            % current data isn't an intensity ratio
            isratio = 0;
            
            if tpe <= nChan*nExc % intensity
                i_c = mod(tpe,nChan); i_c(i_c==0) = nChan;
                i_l = ceil(tpe/nChan);
                trace = I(:,i_c:nChan:end,i_l);
                
            elseif tpe <= 2*nChan*nExc % discr. intensity
                i_c = mod(tpe-nChan*nExc,nChan); i_c(i_c==0) = nChan;
                i_l = ceil((tpe-nChan*nExc)/nChan);
                trace = I_discr(:,i_c:nChan:end,i_l);

            elseif tpe <= 2*nChan*nExc+nFRET % FRET
                I_re = nan(N*nMol,nChan,nExc);
                for c = 1:nChan
                    I_re(:,c,:) = reshape(I(:,c:nChan:end,:), ...
                        [nMol*N 1 nExc]);
                end
                i_f = tpe - 2*nChan*nExc;

                gamma = [];
                for i_m = 1:nMol
                    if size(p.proj{i}.prmTT{i_m},2)==5 && ...
                            size(p.proj{i}.prmTT{i_m}{5},2)==5
                        gamma_m = p.proj{i}.prmTT{i_m}{5}{3};
                    elseif size(p.proj{i}.prmTT{i_m},2)==6 && ...
                            size(p.proj{i}.prmTT{i_m}{6},2)>=1 && ...
                            size(p.proj{i}.prmTT{i_m}{6}{1},2)==nFRET
                        gamma_m = p.proj{i}.prmTT{i_m}{6}{1}(1,:);
                    else
                        gamma_m = ones(1,nFRET);
                    end
                    gamma = [gamma; repmat(gamma_m,N,1)];
                end
                allFRET = calcFRET(nChan, nExc, allExc, chanExc, FRET, ...
                    I_re, gamma);
                trace = allFRET(:,i_f);
                trace = reshape(trace, [N nMol]);
                
                % current data is an intensity ratio
                isratio = 1;
                
            elseif tpe <= 2*nChan*nExc+2*nFRET % FRET
                i_f = tpe - 2*nChan*nExc - nFRET;
                trace = FRET_discr(:,i_f:nFRET:end);
                
                % current data is an intensity ratio
                isratio = 1;

            elseif tpe <= 2*nChan*nExc + 2*nFRET + nS % Stoichiometry
                i_s = tpe - 2*nChan*nExc - 2*nFRET;
                i_c = S(i_s);
                [o,i_l,o] = find(allExc==chanExc(i_c));
                I_re = nan(N*nMol,nChan,nExc);
                for c = 1:nChan
                    I_re(:,c,:) = reshape(I(:,c:nChan:end,:), ...
                        [nMol*N 1 nExc]);
                end
                trace = sum(I_re(:,:,i_l),2)./sum(sum(I_re,2),3);
                trace = reshape(trace, [N nMol]);
                
                % current data is an intensity ratio
                isratio = 1;
                
            elseif tpe <= 2*nChan*nExc + 2*nFRET + 2*nS % Stoichiometry
                i_s = tpe - 2*nChan*nExc - 2*nFRET - nS;
                trace = S_discr(:,i_s:nS:end);
                
                % current data is an intensity ratio
                isratio = 1;
            end
            
            trace = trace(:,incl);
            
            prm{tpe} = setDefPrm_thm(prm{tpe}, trace, isratio, p.colList);
        end
        p.proj{i}.prm = prm;
        p.curr_tpe(i) = 1;
        p.curr_tag(i) = 0;
    end

    % set last-imported project as current project
    p.curr_proj = size(p.proj,2);
    
    % update project list
    p = ud_projLst(p, h.listbox_thm_projLst);
    h.param.thm = p;
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
    cla(h.axes_hist1);
    cla(h.axes_hist2);
    
    % update calculations and GUI
    updateFields(h_fig, 'thm');
end
