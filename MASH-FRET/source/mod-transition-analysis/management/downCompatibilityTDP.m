function p_proj = downCompatibilityTDP(p_proj,tpe,tag)
% p_proj = downCompatibilityTDP(p_proj,tpe,tag)
%
% Re-arrange processing parameters and analysis results of older projects according to current MASH version.
%
% p_proj: structure containing project's data
% tpe: index in list of data type
% tag: index in list of molecule tag

def = p_proj.TA.def{tag,tpe};
prm = p_proj.TA.prm{tag,tpe};

if ~isstruct(prm)
    return
end

if isfield(prm,'plot') && size(prm.plot{1},1)<4
    prm.plot = def.plot;
end

% add boba parameters if none
if isfield(prm,'clst_start') && size(prm.clst_start,2)>=1 && ...
        size(prm.clst_start{1},2)<8
    prm.clst_start{1}(6:8) = def.clst_start{1}(6:8);
end

% restructure old fit results
if isfield(prm,'clst_res') && ~isempty(prm.clst_res{1}) && ...
        ~isstruct(prm.clst_res{1})

    % initialize new result structure
    Jmax = prm.clst_start{1}(3);
    Jopt = size(prm.clst_res{1}(:,1),1);
    model.mu = cell(1,Jmax);
    model.fract = cell(1,Jmax);
    model.clusters = cell(1,Jmax);

    % place old results in new structure
    model.mu{Jopt} = prm.clst_res{1}(:,1);
    model.fract{Jopt} = prm.clst_res{1}(:,2);
    model.clusters{Jopt} = prm.clst_res{2};

    method = prm.clst_start{1}(1);

    if method==1
        model.a = [];
        model.o = [];
        model.BIC = [];

    else
        model.a{Jopt} = prm.clst_res{3}.a;
        model.o{Jopt} = prm.clst_res{3}.o;
        model.BIC(Jopt) = prm.clst_res{3}.BIC;
    end

    prm.clst_res{1} = model;
    prm.clst_res{2} = prm.clst_res{3}.boba_k;
    prm.clst_res{3} = Jopt;
end

% 27.1.2020: move model used in kinetic analysis and current transition,
% add state-dependency option
if isfield(prm,'kin_start') && size(prm.kin_start,2)>=2
    if size(prm.kin_start,1)>0 && ~iscell(prm.kin_start{1})
        J = prm.clst_res{3};
        curr_k = prm.clst_start{1}(4);
        kin_start = prm.kin_start;
        prm.kin_start = cell(1,2);
        prm.kin_start{1} = kin_start;
        prm.kin_start{2} = [J,curr_k];
    elseif size(prm.kin_start,1)==0
        prm.kin_start{1} = cell(1,2);
        prm.kin_start{2} = [1,1];
        
    end
    if ~iscell(prm.kin_start{1})
        prm.clst_start{1}(4) = 1; % cluster constraint
    end
end

% 28.1.2020: add cluster diagonal and log likelihood options
if isfield(prm,'clst_start') && size(prm.clst_start,2)>=1 && ...
        size(prm.clst_start{1},2)<10
    prm.clst_start{1} = cat(2,prm.clst_start{1},[true 1]);
end

% 29.1.2020: reformat (state,radius) to (state x,state y,radius x,radius y)
if isfield(prm,'clst_start') && size(prm.clst_start,2)>=2 && ...
        size(prm.clst_start{2},2)==2
    cfg = prm.clst_start{2};
    J = size(cfg,1);
    nTrs = getClusterNb(J,true,true);
    [j1,j2] = getStatesFromTransIndexes(1:nTrs,J,true,true);
    prm.clst_start{2} = [cfg(j1,1),cfg(j2,1),cfg(j1,2),cfg(j2,2)];
    
    nClr = size(prm.clst_start{3},1);
    if nClr<nTrs
        prm.clst_start{3} = cat(1,prm.clst_start{3},rand(nTrs-nClr,3));
    end

    if isfield(prm,'clst_res') && size(prm.clst_res,2)>=2 && ...
            isfield(prm.clst_res{1},'mu')
        for J = 1:size(prm.clst_res{1}.mu,2)
            nTrs = getClusterNb(J,true,true);
            [j1,j2] = getStatesFromTransIndexes(1:nTrs,J,true,true);
            mu = prm.clst_res{1}.mu{J};
            if size(mu,2)==1
                prm.clst_res{1}.mu{J} = [mu(j1,1),mu(j2,1)];
            end
        end
    
        J = prm.kin_start{2}(1);
        nTrs = getClusterNb(J,true,true);
        if isfield(prm,'kin_start') && size(prm.kin_start,2)>=2 && ...
                size(prm.kin_start{1},1)~=nTrs
            isRes = false;
            if isfield(prm,'kin_res') && size(prm.kin_res,2)>=4 && ...
                    size(prm.kin_res,1)>1
                isRes = true;
            end

            % re-arrange existing clusters
            nTrs_old = J*(J-1);
            [j1_old,j2_old] = getStatesFromTransIndexes(1:nTrs_old,J,true,...
                false);
            [j1,j2] = getStatesFromTransIndexes(1:nTrs,J,true,true);
            newkinstart = cell(nTrs,2);
            newkinres = cell(nTrs,5);
            newclstres = repmat(def.clst_res(4),1,nTrs);
            for k = 1:nTrs_old
                incl = j1==j1_old(k) & j2==j2_old(k);
                newclstres(incl) = prm.clst_res{4}(k);
                newkinstart(incl,:) = prm.kin_start{1}(k,:);
                if isRes
                    newkinres(incl,:) = prm.kin_res(k,:);
                end
            end

            % update missing diagonal clusters
            clst = prm.clst_res{1}.clusters{J};
            for k = 1:nTrs
                if ~isempty(newkinstart{k,1})
                    continue
                end

                % set fitting parameters
                newkinstart(k,:) = prm.kin_def;

                % build histogram
                wght = newkinstart{k,1}(4)*newkinstart{k,1}(1);
                excl = newkinstart{k,1}(8);
                mols = unique(clst(:,4));
                newclstres{k} = getDtHist(clst, [j1(k),j2(k)], mols, excl, ...
                    wght);
            end

            % save modifications
            prm.clst_res{4} = newclstres;
            prm.kin_start{1} = newkinstart;
            prm.kin_res = newkinres;
        end
    end
end

% 30.1.2020: add cluster relative popuplations in results
if isfield(prm,'clst_res') && size(prm.clst_res,2)>=1 && ...
        isfield(prm.clst_res{1},'mu') && ~isfield(prm.clst_res{1},'pop')
    Jmax = size(prm.clst_res{1}.mu,2);
    for J = 1:Jmax
        if ~isempty(prm.clst_res{1}.mu{J})
            K = size(prm.clst_res{1}.mu{J},1);
            prm.clst_res{1}.pop{J} = NaN(K,1);
            mat = prm.clst_start{1}(4);
            clstDiag = prm.clst_start{1}(9);
            clst = prm.clst_res{1}.clusters{J};
            [j1,j2] = getStatesFromTransIndexes(1:K,J,mat,clstDiag);
            N = 0;
            for k = 1:K
                Nk = size(clst(clst(:,7)==j1(k) & clst(:,8)==j2(k),:),1);
                prm.clst_res{1}.pop{J}(k,1) = Nk;
                N = N + Nk;
            end
            prm.clst_res{1}.pop{J} = prm.clst_res{1}.pop{J}/N;
        end
    end
end

% 31.1.2020: adjust cluster constraint with "symmetrical" option
if isfield(prm,'clst_start') && size(prm.clst_start,2)>=1 && ...
        size(prm.clst_start{1},2)>=4
    if islogical(prm.clst_start{1}(4))
        if prm.clst_start{1}(4)
            prm.clst_start{1}(4) = 1;
        else
            prm.clst_start{1}(4) = 0;
        end
    elseif prm.clst_start{1}(4)==0
        prm.clst_start{1}(4) = 3;
    end
end

% 27.02.2020: add "re-arrange" option
if isfield(prm,'kin_def') && size(prm.kin_def,2)>=1 && ...
        size(prm.kin_def{1},2)<9
    prm.kin_def{1} = [prm.kin_def{1},false];
    if isfield(prm,'kin_start') && size(prm.kin_start,2)>=1
        for k = 1:size(prm.kin_start{1},1)
            if size(prm.kin_start{1}{k,1},2)<9
                prm.kin_start{1}{k,1} = [prm.kin_start{1}{k,1},false];
            end
        end
    end
end

% 7.3.2020: add bootstrap histograms
if isfield(prm,'kin_res') && size(prm.kin_res,2)==4
    prm.kin_res = cat(2,prm.kin_res,cell(size(prm.kin_res,1),1));
end

% 24.4.2020: adapt to new dwell time analysis procedure (lifetime+model)
excl = def.lft_start{2}(4);
rearr = def.lft_start{2}(5);
if isfield(prm,'kin_def') && ~isfield(prm,'lft_def')
    if size(prm.kin_def,2)>=1 && ~isempty(prm.kin_def{1})
        excl = prm.kin_def{1}(end-1);
        rearr = prm.kin_def{1}(end);
        prm.lft_def{1} = [def.lft_def{1}(1),prm.kin_def{1}(1:end-2)];
        if size(prm.kin_def,2)>=2
            prm.lft_def{2} = prm.kin_def{2};
        end
    end
    prm = rmfield(prm,'kin_def');
end
if isfield(prm,'kin_start') && ~isfield(prm,'lft_start')
    if isfield(prm,'clst_res') && size(prm.clst_res,2)>=4 && ...
            ~isempty(prm.clst_res{4}) && size(prm.kin_start,2)>=1 
        
        % reset start fit param
        J = prm.kin_start{2}(1);
        bin = def.lft_start{2}(3);
        mu = prm.clst_res{1}.mu{J};
        mat = prm.clst_start{1}(4);
        clstDiag = prm.clst_start{1}(9);
        nTrs = getClusterNb(J,mat,clstDiag);
        [j1,j2] = getStatesFromTransIndexes(1:nTrs,J,mat,clstDiag);
        [vals,~] = binStateValues(mu,bin,[j1,j2]);
        V = numel(vals);
        prm.lft_start{1} = repmat(def.lft_def,V,1);
        
        % add histogram parameters
        if size(prm.kin_start,2)>=2 && size(prm.kin_start{2},2>=2)
            prm.lft_start{2} = [prm.kin_start{2},bin,excl,rearr];
        end
        
        % adjust current state id after state binning
        if prm.lft_start{2}(2)>V
            prm.lft_start{2}(2) = V;
        end
        
        % recalculate histograms
        prm2 = ud_kinPrm(prm,def,J);
        prm.clst_res{4} = prm2.clst_res{4};
        
        
    else
        prm.lft_start = def.lft_start;
    end
    prm = rmfield(prm,'kin_start');
end
if isfield(prm,'kin_res') && ~isfield(prm,'lft_res') % reset fit results
    fprintf(['The dwell time analysis in the project is outdated: fitting',...
        ' results have been reset.\nTo access the old dwell time analysis',...
        ' results, please use MASH-FRET 1.3.1 or older (available at: ',...
        'https://github.com/RNA-FRETools/MASH-FRET/releases).\n'])
    prm.lft_res = def.lft_res;
    prm = rmfield(prm,'kin_res');
end

% 30.3.2021: add colormap
if isfield(prm,'plot') && size(prm.plot,2)==3
    prm.plot = [prm.plot,def.plot{4}];
end

if ~isfield(prm,'mdl_start')
    prm.mdl_start = def.mdl_start;
end

if ~isfield(prm,'mdl_res')
    prm.mdl_res = def.mdl_res;
end

p_proj.prm{tag,tpe} = prm;


