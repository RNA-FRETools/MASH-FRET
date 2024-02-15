function pushbutton_TA_refreshModel_Callback(obj,evd,h_fig)

% get interface parameters
h = guidata(h_fig);
p = h.param;
if ~isModuleOn(p,'TA')
    return
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
expT = p.proj{proj}.resampling_time;

V = prm.lft_start{2}(1);
mat = prm.clst_start{1}(4);
clstDiag = prm.clst_start{1}(9);
mu = prm.clst_res{1}.mu{V};
bin = prm.lft_start{2}(3);
dat = prm.clst_res{1}.clusters{V};
excl = prm.lft_start{2}(4);
rearr = prm.lft_start{2}(5);

guessMeth = prm.mdl_start{1}(1);
T_bw = curr.mdl_start{2};
states = prm.mdl_res{5};
J = numel(states);

% save starting parameters
prm.mdl_start{2} = curr.mdl_start{2};

% reset results
prm.mdl_res(1:4) = def.mdl_res(1:4);

% display process
setContPan(['Infer transition rate constants (refer to MATLAB''s command ',...
    'window for more details about the process'' progress)...'],'process',...
    h_fig);

% bin states
nTrs = getClusterNb(V,mat,clstDiag);
[j1,j2] = getStatesFromTransIndexes(1:nTrs,V,mat,clstDiag);
[vals,js] = binStateValues(mu,bin,[j1,j2]);
V = numel(vals);
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
    
    dat_new = cat(1,dat_new,dat_m);
end
dat = dat_new;
seq(exclmols) = [];

% get relative number of transitions
clstPop = zeros(V);
for v1 = 1:V
    for v2 = 1:V
        if v1==v2
            continue
        end
        clstPop(v1,v2) = size(dat(dat(:,7)==v1 & dat(:,8)==v2,:),1);
    end
end
clstPop = clstPop/sum(sum(clstPop));

if guessMeth==1 % determine guess from DPH fit & BIC model selection

    mdl = prm.mdl_res{6}{3};
    BIC = prm.mdl_res{6}{2};
    D = zeros(1,V);
    for v = 1:V
        [~,ind] = min(BIC(:,v+1));
        D(v) = BIC(ind,1);
    end
    J = sum(D);
    tp0 = zeros(J);
    j1 = 0;
    for v1 = 1:V
        tp0((j1+1):(j1+D(v1)),(j1+1):(j1+D(v1))) = ...
            mdl.tp_fit{v1}(:,1:end-1);
        p_exit = mdl.tp_fit{v1}(:,end);
        j2 = 0;
        for v2 = 1:V
            if v1~=v2
                tp0((j1+1):(j1+D(v1)),(j2+1):(j2+D(v2))) = ...
                    repmat(p_exit,[1,D(v2)]).*...
                    repmat(clstPop(v1,v2),[D(v1),D(v2)])/D(v2);
            end
            j2 = j2+D(v2);
        end
        j1 = j1+D(v1);
    end
    
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
                pop = prm.lft_res{v1,1}(:,1,2:end)./repmat(dec',[1,1,V-1]);
                pop = pop(:)';
            else
                dec = prm.lft_res{v1,2}(:,2,1)';
                pop = prm.lft_res{v1,2}(:,2,2:end)./repmat(dec',[1,1,V-1]);
                pop = pop(:)';
            end
            r = cat(2,r,1./dec);
            A = cat(2,A,pop/sum(pop));
            degen = cat(2,degen,repmat(v1,[1,numel(dec)]));

        end
    end

    % get starting transition probabilities based on number of transitions
    J_deg = numel(states);
    tp0 = zeros(J_deg);
    for j_deg1 = 1:J_deg
        for j_deg2 = 1:J_deg
            if j_deg1==j_deg2
                continue
            end
            tp0(j_deg1,j_deg2) = ...
                A(j_deg1)*A(j_deg2)*clstPop(degen(j_deg1),degen(j_deg2));
        end
    end
    tp0 = repmat(nL*expT*r',[1,J_deg]).*tp0./repmat(sum(tp0,2),[1,J_deg]); % transition prob
    tp0(~~eye(size(tp0))) = 1-sum(tp0,2); % transition prob
end
expPrm.expT = nL*expT;
expPrm.Ls = sum(p.proj{proj}.bool_intensities,1);
expPrm.dt = dat(:,[1,4,end-1,end]);
expPrm.excl = excl;
expPrm.seq = seq;

% eps = minpercent*nMol/sum(expPrm.Ls);
eps = 1/(sum(expPrm.Ls)-2*numel(expPrm.Ls));
schm = true(J);
tp = ones(J);
iter = 1;
while iter==1 || any(tp(schm)<eps)
    schm = schm & tp>=eps;
    [tp,err,ip,simdat] = optimizeProbMat(states,expPrm,tp0,T_bw,schm); % transition prob
    iter = iter+1;
end

prm.mdl_res(1:4) = {tp,err,ip,simdat};

% save modifications
p.proj{proj}.TA.prm{tag,tpe} = prm;
p.proj{proj}.TA.curr{tag,tpe}.mdl_res(1:4) = prm.mdl_res(1:4);

h.param = p;
guidata(h_fig,h);

ud_kinMdl(h_fig);
updateTAplots(h_fig,'mdl');

% bring simulation plot tab front
bringPlotTabFront('TAsim',h_fig);

% display process
setContPan('The kinetic model was successfully inferred!','success',h_fig);
