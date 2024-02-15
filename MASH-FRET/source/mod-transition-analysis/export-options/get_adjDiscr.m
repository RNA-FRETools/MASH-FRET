function adj = get_adjDiscr(p, str_tpe)

nChan = p.nb_channel;
exc = p.excitations;
chanExc = p.chanExc;
nExc = numel(exc);
FRET = p.FRET;
S = p.S;
perSec = p.cnt_p_sec;
rate = p.resampling_time;
nFRET = size(FRET,1);
nS = size(S,1);
N = size(p.intensities,1);
nMol = numel(p.coord_incl);
nTpe = nChan*nExc + nFRET + nS;


trace_tot = zeros(nMol*N,nChan,nExc);
incl = p.bool_intensities;

tpe = 0;
trace = cell(1,nTpe);

for l = 1:nExc
    for c = 1:nChan
        tpe = tpe+1;
        trace{tpe} = p.intensities_denoise(:,c:nChan:end,l);
        if perSec
            trace{tpe} = trace{tpe}/rate;
        end
        trace_tot(:,c,l) = reshape(trace{tpe},[numel(trace{tpe}) 1]);
    end
end

gamma = [];
for i_m = 1:nMol
    gamma = [gamma; repmat(p.prmTT{i_m}{5}{3},N,1)];
end
FRET_all = calcFRET(nChan, nExc, exc, chanExc, FRET, trace_tot, gamma);

for n = 1:nFRET
    tpe = tpe+1;
    trace{tpe} = reshape(FRET_all(:,n), [N nMol]);
end

clear('FRET_all');

for n = 1:nS
    tpe = tpe+1;
    [o,l_s,o] = find(exc==chanExc(S(n)));
    Inum = sum(trace_tot(:,:,l_s),2);
    Iden = sum(sum(trace_tot,2),3);
    trace{tpe} = reshape(Inum./Iden, [N nMol]);
end

trace_adj = cell(1,nTpe);

for t = 1:nTpe
    prm = p.prm{t};
    trace_adj{t} = nan(size(trace{t}));
    K = size(prm.clst_res{1},1);
    isTrans = 0;
    for m = 1:nMol
        if size(p.dt{m},1) > 1
            isTrans = 1;
            break;
        end
    end
    if K == 0 && isTrans
        disp(['no clustering for data:' str_tpe{t}]);
    elseif K == 0 && ~isTrans
        for m = 1:nMol
            trace_adj{t}(incl(:,m),m) = mean(trace{t}(incl(:,m),m));
        end
    else
        dt_adj = adjustDt(prm.clst_res{2});
        states = prm.clst_res{1}(:,1);
        dt_bin = prm.plot{3};

        for m = 1:nMol
            dt_bin_m = dt_bin(dt_bin(:,4)==m,:);
            clst_m = dt_adj(dt_adj(:,4)==m,:);
            if ~isempty(clst_m) && sum(sum(clst_m(:,(end-1):end),1))
                clst_m(clst_m(:,end-1)>0,2) = states(clst_m(clst_m(:,end-1)>0,end-1));
                clst_m(clst_m(:,end-1)<=0,2) = NaN;
                clst_m(clst_m(:,end-1)>0,3) = states(clst_m(clst_m(:,end-1)>0,end));
                clst_m(clst_m(:,end-1)<=0,3) = NaN;
                clst_m = clst_m(:,1:3);
%                 last_state = clst_m(end,end);
%                 clst_m = [clst_m; dt_bin_m(end,1) last_state NaN];
                clst_m(end,end) = NaN;
                clst_m = delFalseTrs(clst_m);

            else % statics
                [o,id] = min(abs(states-mean(trace{t}(incl(:,m),m))));
                clst_m = [numel(find(incl(:,m)))*rate states(id) NaN];
            end

            trace_adj{t}(incl(:,m),m) = getDiscrFromDt(clst_m, rate);
        end
    end
end

adj.intensities_DTA = nan(N,nChan*nMol,nExc);
adj.FRET_DTA = nan(N,nFRET*nMol);
adj.S_DTA = nan(N,nS*nMol);

tpe = 0;
for l = 1:nExc
    for c = 1:nChan
        tpe = tpe+1;
        if ~isempty(trace_adj{tpe})
            adj.intensities_DTA(:,c:nChan:end,l) = trace_adj{tpe};
        end
    end
end
if perSec
    adj.intensities_DTA = adj.intensities_DTA*rate;
end

for n = 1:nFRET
    tpe = tpe+1;
    if ~isempty(trace_adj{tpe})
        adj.FRET_DTA(:,n:nFRET:end) = trace_adj{tpe};
    end
end

for n = 1:nS
    tpe = tpe+1;
    if ~isempty(trace_adj{tpe})
        adj.S_DTA(:,n:nS:end) = trace_adj{tpe};
    end
end

