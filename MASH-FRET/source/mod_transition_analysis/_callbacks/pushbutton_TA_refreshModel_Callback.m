function pushbutton_TA_refreshModel_Callback(obj,evd,h_fig)

% get interface parameters
h = guidata(h_fig);
p = h.param.TDP;
proj = p.curr_proj;
if isempty(p.proj)
    return
end

% get project parameters
nL = p.proj{proj}.nb_excitations;
expT = p.proj{proj}.frame_rate;

% get processing parameters and analyiss results
tag = p.curr_tag(proj);
tpe = p.curr_type(proj);
prm = p.proj{proj}.prm{tag,tpe};
J = prm.lft_start{2}(1);
mat = prm.clst_start{1}(4);
clstDiag = prm.clst_start{1}(9);
mu = prm.clst_res{1}.mu{J};
bin = prm.lft_start{2}(3);
dat = prm.clst_res{1}.clusters{J};
excl = prm.lft_start{2}(4);
rearr = prm.lft_start{2}(5);

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

% re-arrange state sequences by cancelling transitions belonging to diagonal clusters
if rearr
    [mols,o,o] = unique(dat(:,4));
    dat_new = [];
    for m = mols'
        dat_m = dat(dat(:,4)==m,:);
        if isempty(dat_m)
            continue
        end
        dat_m = adjustDt(dat_m);
%         if size(dat_m,1)==1
%             continue
%         end
        if excl
            dat_m([1,end],:) = [];
        end
        dat_new = cat(1,dat_new,dat_m);
    end
    dat = dat_new;
end

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

% check for state lifetimes
r = [];
degen = [];
fitPrm = cell(1,V);
totalTime = zeros(V,1);
A = [];
if isfield(prm,'lft_res') && ~isempty(prm.lft_res) && ...
        size(prm.lft_res,1)>=V && size(prm.lft_res,2)>=2
    for v1 = 1:V
        boba = prm.lft_start{1}{v1,1}(5);
        if ~((boba && size(prm.lft_res{v1,1},2)>=4) || ...
                (~boba && size(prm.lft_res{v1,2},2)>=2))
            return
        else
            % get restricted rate coefficients
            if boba
                amp = prm.lft_res{v1,1}(:,1,1)';
                dec = prm.lft_res{v1,1}(:,3,1)';
                pop = prm.lft_res{v1,1}(:,1,2:end)./repmat(dec',[1,1,V-1]);
                pop = pop(:)';
            else
                amp = prm.lft_res{v1,1}(:,1,1)';
                dec = prm.lft_res{v1,1}(:,2,1)';
                pop = prm.lft_res{v1,1}(:,2,2:end)./repmat(dec',[1,1,V-1]);
                pop = pop(:)';
            end
            r_v = 1./dec;
            A_v = pop/sum(pop);
            
            fitPrm{v1} = reshape([amp;dec],1,numel([amp;dec]));
            
            r = cat(2,r,r_v);
            A = cat(2,A,A_v);
            degen = cat(2,degen,repmat(v1,[1,numel(r_v)]));
            
        end
        totalTime(v1) = sum(dat(dat(:,7)==v1,1));
    end
else
    return
end
states = states(degen);
totalTime = totalTime(degen);

% get starting transition probabilities based on number of transitions
J_deg = numel(states);
mat0 = zeros(J_deg);
for j_deg1 = 1:J_deg
    for j_deg2 = 1:J_deg
        if j_deg1==j_deg2
            continue
        end
        mat0(j_deg1,j_deg2) = ...
            A(j_deg1)*A(j_deg2)*clstPop(degen(j_deg1),degen(j_deg2));
    end
end
% mat0 = repmat(nL*expT*r',[1,J_deg]).*mat0./repmat(sum(mat0,2),[1,J_deg]); % transition prob
% mat0(~~eye(size(mat0))) = 1-sum(mat0,2); % transition prob
mat0 = mat0./repmat(sum(mat0,2),[1,J_deg]); % transition prob, diag = 0
% mat0 = mat0*size(dat(dat(:,7)~=dat(:,8)),1); % number of transitions
% mat0 = mat0*size(dat(dat(:,7)~=dat(:,8)),1)./repmat(totalTime,1,J_deg); % transition rate constants

expPrm.expT = nL*expT;
expPrm.Ls = sum(p.proj{proj}.bool_intensities,1);
expPrm.A = A;
expPrm.clstPop = clstPop;
expPrm.dt = dat(:,[1,4,end-1,end]);
expPrm.fitPrm = fitPrm;
expPrm.excl = excl;
% expPrm.trace = getTimeTrace_TA(tpe,tag,p.proj{proj});

% [w,err,simdat] = optimizeProbMat(r,states,expPrm,'tp',mat0); % transition prob
[w,err,simdat] = optimizeProbMat(r,states,expPrm,'w',mat0); % transition prob, diag = 0
% [w,err,simdat] = optimizeProbMat(r,states,expPrm,'n',mat0); % number of transitions
% [w,err,simdat] = optimizeProbMat(r,states,expPrm,'k',mat0); % transition rate constants

prm.mdl_res = {w,err,simdat,states};

p.proj{proj}.prm{tag,tpe} = prm;
p.proj{proj}.curr{tag,tpe} = prm;

h.param.TDP = p;
guidata(h_fig,h);

ud_kinMdl(h_fig);
updateTAplots(h_fig,'mdl');

