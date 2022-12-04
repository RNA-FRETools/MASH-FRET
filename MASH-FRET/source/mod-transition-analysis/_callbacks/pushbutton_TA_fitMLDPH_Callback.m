function pushbutton_TA_fitMLDPH_Callback(obj,evd,h_fig)
% pushbutton_TA_fitMLDPH_Callback([],[],h_fig)
% pushbutton_TA_fitMLDPH_Callback({sumexp,saveit},[],h_fig)
%
% h_fig: handle to main figure
% sumexp: (1) to fit sum of exponential, (0) for DPH
% saveit: (1) to save fit curves and parameters to files, (0) otherwise

% get interface parameters
h = guidata(h_fig);
p = h.param;
if ~isModuleOn(p,'TA')
    return
end

sumexp = false;
saveit = false;
if iscell(obj)
    sumexp = obj{1};
    saveit = obj{2};
end

 proj = p.curr_proj;
tag = p.TDP.curr_tag(proj);
tpe = p.TDP.curr_type(proj);
prm = p.proj{proj}.TA.prm{tag,tpe};
curr = p.proj{proj}.TA.curr{tag,tpe};
def = p.proj{proj}.TA.def{tag,tpe};

% control clustering results
if ~(isfield(prm,'clst_res') && ~isempty(prm.clst_res{1}))
    setContPan(['No state configuration detected. Please infer a state ',...
        'configuration by pressing "Start" in panel "State ',...
        'configuration".'],'error',h_fig);
    return
end

% get project parameters
nL = p.proj{proj}.nb_excitations;
expT = p.proj{proj}.frame_rate;

J = prm.lft_start{2}(1);
mat = prm.clst_start{1}(4);
clstDiag = prm.clst_start{1}(9);
mu = prm.clst_res{1}.mu{J};
bin = prm.lft_start{2}(3);
dat = prm.clst_res{1}.clusters{J};
excl = prm.lft_start{2}(4);
rearr = prm.lft_start{2}(5);

guessMeth = curr.mdl_start{1}(1);
dt_bin = curr.mdl_start{1}(2);
Dmax = curr.mdl_start{1}(3);
T_mldph = curr.mdl_start{1}(4);

% save start parameters
prm.mdl_start{1} = curr.mdl_start{1};

% reset results
prm.mdl_res = def.mdl_res;

% display process
setContPan('Infer a kinetic model...','process',h_fig);

% bin states
nTrs = getClusterNb(J,mat,clstDiag);
[j1,j2] = getStatesFromTransIndexes(1:nTrs,J,mat,clstDiag);
[states,js] = binStateValues(mu,bin,[j1,j2]);
V = numel(states);
dat_new = dat;
for val = 1:V
    for j = 1:numel(js{val})
        dat_new(dat(:,end-1)==js{val}(j),end-1) = val;
        dat_new(dat(:,end)==js{val}(j),end) = val;
    end
end
dat = dat_new;

% get state sequences
[mols,o,o] = unique(dat(:,4));
dat_new = [];
nMol = numel(mols);
seq = cell(1,nMol);
exclmols = false(1,nMol);
for m = 1:nMol
    dat_m = dat(dat(:,4)==mols(m),:);
    if size(dat_m,1)<=1 % exclude statics because irreversible transitions give illed distributions
        exclmols(m) = true;
        continue
    end

    % get state sequences
    seq{m} = getDiscrFromDt(dat_m(:,[1,7,8]),nL*expT);
    if all(seq{m}==0)
        exclmols(m) = true;
        continue
    end
    
    % replace "0" in state sequences
    for l = 1:numel(seq{m})
        if l==1 && seq{m}(1)==0
            for l2 = 2:numel(seq{m})
                if seq{m}(l2)~=0
                    seq{m}(1) = seq{m}(l2);
                    break
                end
            end
        elseif seq{m}(l)==0
            seq{m}(l)= seq{m}(l-1);
        end
    end
    
    % re-arrange dwell times by cancelling transitions belonging to diagonal clusters
    if rearr
        dat_m = adjustDt(dat_m);
        if size(dat_m,1)<=0
            exclmols(m) = true;
            continue
        end
    end
    
    % remove first and last dwell times
    if excl
        dat_m([1,end],:) = [];
        if size(dat_m,1)<=0
            exclmols(m) = true;
            continue
        end
    end
    dat_new = cat(1,dat_new,dat_m);
end
dat = dat_new;

if guessMeth==1 % determine guess from DPH fit & BIC model selection

    % display process
    setContPan(['Determine state degeneracies (refer to MATLAB''s command',...
        ' window for more details about the process'' progress)...'],...
        'process',h_fig);
    
    if saveit
        pname = p.proj{proj}.folderRoot;
        if pname(end)~=filesep
            pname = [pname,filesep];
        end
        pname = [pname,'kinetic model',filesep];
        if ~exist(pname,'dir')
            mkdir(pname);
        end
    else
        pname = '';
    end

    [D,mdl,cmb,BIC_cmb,BIC] = ...
        script_findBestModel(dat(:,[1,4,7,8]),Dmax,states,nL*expT,dt_bin,...
        T_mldph,sumexp,pname);
    h = guidata(h_fig); % computation time of tph test stored in h.t_dphtest
    
    % export DPH fit parameters and computation time
    if saveit
        fname = [p.proj{proj}.exp_parameters{1,2},'_mldphfitres.mat'];
        save([pname,fname],'mdl','-mat');
    end

    degen = [];
    for v1 = 1:V
        degen = cat(2,degen,repmat(v1,[1,D(v1)]));
    end
    states = states(degen);
    prm.mdl_res{6} = {[cmb,BIC_cmb'],[1:Dmax;BIC]',mdl};

    % bring DPH plot tab front
    bringPlotTabFront('TAdph',h_fig);
    
else % use guess from panel "Exponential fit"
    % check for state lifetimes
    r = [];
    degen = [];
    A = [];
    if ~(isfield(prm,'lft_res') && ~isempty(prm.lft_res) && ...
            size(prm.lft_res,1)>=V && size(prm.lft_res,2)>=2)
        setContPan('State lifetime analysis must first be performed.',...
            'error',h_fig);
        return
    end
    for v1 = 1:V
        boba = prm.lft_start{1}{v1,1}(5);
        if ~((boba && size(prm.lft_res{v1,1},2)>=4) || ...
                (~boba && size(prm.lft_res{v1,2},2)>=2))
            setContPan(['State lifetime analysis is missing for state ',...
                'value n°:',num2str(v1),'.'],'error',h_fig);
            return
        else
            % get restricted rate coefficients
            if boba
                dec = prm.lft_res{v1,1}(:,3,1)';
            else
                dec = prm.lft_res{v1,2}(:,2,1)';
            end
            degen = cat(2,degen,repmat(v1,[1,numel(dec)]));
        end
    end
    states = states(degen);

    % bring model plot tab front
    bringPlotTabFront('TAmdl',h_fig);
end
prm.mdl_res{5} = states;

% save modfications
p.proj{proj}.TA.prm{tag,tpe} = prm;
p.proj{proj}.TA.curr{tag,tpe}.mdl_res{5} = prm.mdl_res{5};
p.proj{proj}.TA.curr{tag,tpe}.mdl_res{6} = prm.mdl_res{6};
h.param = p;
guidata(h_fig,h);

updateTAplots(h_fig,'mdl');
ud_kinMdl(h_fig);

% display success
setContPan('State degeneracy was successfully determined!','success',...
    h_fig);

