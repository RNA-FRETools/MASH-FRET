function [schmopt,mdl] = MLDPH(dt,T,sumexp,Dmax)

% defaults
schmstr = {'hyper exponential','erlang'};

% ML-DPH inference: determine state degeneracy
BIC_all = [];
cvg_all = [];
mdl = [];
for D = 1:Dmax
    fprintf(['for ', num2str(D),' states (%i max.):\n'],Dmax);

    % collects hyperexponential and Erlang transition schemes
    schm_D = collectstransscheme(D,'hypexp');
    if (D>1 && ~sumexp)
        schm_D = cat(3,schm_D,collectstransscheme(D,'erlang'));
    end
    
    % test schemes one after the other
    for s = 1:size(schm_D,3)
        fprintf(['scheme ',schmstr{s},':\n']);
        mdl_sD = script_inferPH(dt,T,schm_D(:,:,s),'');

        % calculate BIC
        nfp = sum(sum(mdl_sD.schm))-1;
        mdl_sD.BIC = nfp*log(mdl_sD.N)-2*mdl_sD.logL;
        
        % check model divergence and state doublons
        mdl_sD.cvg = isdphvalid(mdl_sD.tp_fit) & ~isdoublon(mdl_sD.tp_fit);
        
        % append results
        mdl = cat(1,mdl,mdl_sD);
        BIC_all = cat(2,BIC_all,mdl_sD.BIC);
        cvg_all = cat(2,cvg_all,mdl_sD.cvg);
    end
end

% model selection
sopt = find(BIC_all==min(BIC_all(~~cvg_all)));
schmopt = mdl(sopt(1)).schm;


function cvg = isdphvalid(tp)

cvg = false;
if isempty(tp) || any(tp(~~eye(size(tp)))<exp(-0.5))
    return
end

cvg = true;


function dbl = isdoublon(tp)

% defaults
maxdiff = 1E-4; % maximum transition probability gap between different states

dbl = false;
V = size(tp,1);
for v1 = 1:V
    for v2 = 1:V
        if v2==v1
            continue
        end
        vs = 1:V;
        vs([v1,v2]) = [];
        maxdiff12 = max(abs(tp(v1,[v1,vs])-tp(v2,[v2,vs])));
        if maxdiff12<maxdiff
            dbl = true;
            return
        end
    end
end


function schm = collectstransscheme(D,type)
% schm = collectstransscheme(D,type)
%
% D: number of states
% type: 'hypexp', 'erlang' or 'all'
% schm: transition scheme

switch type
    case 'hypexp'
        ip = ones(1,D);
        ep = ones(D,1);
        tp = zeros(D);
        
    case 'erlang'
        ip = [1,zeros(1,D-1)];
        ep = [zeros(D-1,1);1];
        tp = zeros(D);
        for d = 1:D-1
            tp(d,d+1) = 1;
        end
        
    otherwise % all
        ip = [1,zeros(1,D-1)];
        ep = [zeros(D-1,1);1];
        tp = ones(D);
        tp(~~eye(D)) = 0;
end

schm = [0,ip,0; zeros(D,1),tp,ep; zeros(1,D+2)];


