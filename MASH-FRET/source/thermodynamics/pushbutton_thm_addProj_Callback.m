function pushbutton_thm_addProj_Callback(obj, evd, h)
defPth = h.folderRoot;
[fname,pname,o] = uigetfile({'*.mash', 'MASH project(*.mash)'; ...
    '*path.dat', 'HaMMy path files (*path.dat)'; '*.*', ...
    'All files(*.*)'}, ...
    'Select data files', defPth, 'MultiSelect', 'on');

if ~isempty(fname) && ~isempty(pname) && sum(pname)
    if ~iscell(fname)
        fname = {fname};
    end
    [dat ok] = loadProj(pname, fname, 'intensities', h.figure_MASH);
    if ~ok
        return;
    end
    p = h.param.thm;
    p.proj = [p.proj dat];

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
        
        if nTpe>size(prm,2)
            prm = cell(1,nTpe);
        end
        
        for tpe = 1:nTpe
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
                    if size(p.proj{i}.prmTT{i_m},2)<5
                        p.proj{i}.prmTT{i_m} = cell(1,5);
                    end
                    if size(p.proj{i}.prmTT{i_m}{5},2)<3
                        p.proj{i}.prmTT{i_m}{5} = cell(1,3);
                    end
                    if size(p.proj{i}.prmTT{i_m}{5}{3}) ~= nFRET
                        p.proj{i}.prmTT{i_m}{5}{3} = ones(1,nFRET);
                    end
                    gamma = [gamma; repmat(p.proj{i}.prmTT{i_m}{5}{3},N,1)];
                end
                allFRET = calcFRET(nChan, nExc, allExc, chanExc, FRET, ...
                    I_re, gamma);
                trace = allFRET(:,i_f);
                trace = reshape(trace, [N nMol]);
                
            elseif tpe <= 2*nChan*nExc+2*nFRET % FRET
                i_f = tpe - 2*nChan*nExc - nFRET;
                trace = FRET_discr(:,i_f:nFRET:end);

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
                
            elseif tpe <= 2*nChan*nExc + 2*nFRET + 2*nS % Stoichiometry
                i_s = tpe - 2*nChan*nExc - 2*nFRET - nS;
                trace = S_discr(:,i_s:nS:end);
            end
            trace = trace(:,incl);
            
            prm{tpe} = setDefPrm_thm(prm{tpe}, trace, p.colList);
        end
        p.proj{i}.prm = prm;
        p.curr_tpe(i) = 1;
    end

    p.curr_proj = size(p.proj,2);
    
    p = ud_projLst(p, h.listbox_thm_projLst);
    
    h.param.thm = p;
    guidata(h.figure_MASH, h);
    
    str_files = 'file';
    if size(fname,2) > 1
        str_files = [str_files 's'];
    end
    str_files = [str_files ': '];
    for i = 1:size(fname,2)
        str_files = [str_files fname{i} '\n'];
    end
    
    setContPan(['Project successfully imported from ' ...
        str_files 'in folder: ' pname], 'success', h.figure_MASH);
    cla(h.axes_hist1);
    cla(h.axes_hist2);
    updateFields(h.figure_MASH, 'thm');
end
