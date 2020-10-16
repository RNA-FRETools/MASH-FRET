function checkbox_tdp_rearrSeq_Callback(obj,evd,h_fig)

h = guidata(h_fig);
p = h.param.TDP;
if isempty(p.proj)
    return
end

proj = p.curr_proj;
tpe = p.curr_type(proj);
tag = p.curr_tag(proj);
prm = p.proj{proj}.prm{tag,tpe};
curr = p.proj{proj}.curr{tag,tpe};

curr.lft_start{2}(5) = get(obj, 'Value');
prm.lft_start{2}(5) = curr.lft_start{2}(5);

% bin state values
J = prm.lft_start{2}(1);
bin = prm.lft_start{2}(3);
mat = prm.clst_start{1}(4);
clstDiag = prm.clst_start{1}(9);
stateVals = prm.clst_res{1}.mu{J};
nTrs = getClusterNb(J,mat,clstDiag);
[j1,j2] = getStatesFromTransIndexes(1:nTrs,J,mat,clstDiag);
[stateVals,~] = binStateValues(stateVals,bin,[j1,j2]);
V = numel(stateVals);

% recalculate histograms
prm.clst_res{4} = cell(V,V);
for v1 = 1:V
    k = 1;
    prm.clst_res{4}{v1,k} = updateDtHist(prm,[],v1);
    for v2 = 1:V
        if v1==v2
            continue
        end
        k = k+1;
        prm.clst_res{4}{v1,k} = updateDtHist(prm,[],v1,v2);
    end
end
curr.clst_res{4} = prm.clst_res{4};

p.proj{proj}.prm{tag,tpe} = prm;
p.proj{proj}.curr{tag,tpe} = curr;
h.param.TDP = p;
guidata(h_fig, h);

ud_kinFit(h_fig);
updateTAplots(h_fig,'kin');
