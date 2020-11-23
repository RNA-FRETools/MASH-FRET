function err = calcRateConfIv(T0,seq,B,vals,ip)

% default
step_prob_min = 1E-4;
step = 0.01;
LRmax = 1.96^2; % 95th percentile of chi2 (1.960~97.5% normal pdf)
% step = 0.1;
% LRmax = 2.576^2; % 99th percentile of chi2 (2.576~99.5% normal pdf)

[~,cl] = fwdprob(seq,T0,B,vals,ip,true);
logL1 = calcBWlogL(cl);

[~,J] = size(B);
err = zeros(J,J,2);

for j1 = 1:J
    for j2 = 1:J
        if j1==j2
            continue
        end
        
        fprintf('>> interval for transition %i->%i...\n',j1,j2);
        
        step_prob = step*T0(j1,j2);
        if step_prob<step_prob_min
            step_prob = step_prob_min;
        end
        
        % up variation
        [LR1,LR2,k1,k2] = varyRate(T0,j1,j2,step_prob,LRmax,seq,B,vals,ip,logL1);
        if k2~=k1
            a = (LR2-LR1)/(k2-k1);
            b = LR2-a*k2;
            err(j1,j2,1) = (LRmax-b)/a-T0(j1,j2);
        else
            err(j1,j2,1) = k2-T0(j1,j2);
        end
        
        % down variation
        [LR1,LR2,k1,k2] = varyRate(T0,j1,j2,-step_prob,LRmax,seq,B,vals,ip,logL1);
        if k2~=k1
            a = (LR1-LR2)/(k1-k2);
            b = LR2-a*k2;
            err(j1,j2,2) = abs((LRmax-b)/a-T0(j1,j2));
        else
            err(j1,j2,2) = abs(k2-T0(j1,j2));
        end
    end
end


function [LR1,LR2,k1,k2] = varyRate(T0,j1,j2,step,LRmax,seq,B,vals,ip,logL1)
LR2 = 0;
LR1 = 0;
k2 = T0(j1,j2);
J = size(T0,2);
while LR2<LRmax
    T = T0;
    LR1 = LR2;
    k1 = k2;
    if k2==1 || k2==0
        break
    end
    k2 = k2+step;
    if k2>1
        k2 = 1;
    end
    if k2<0
        k2 = 0;
    end
    T(j1,j2) = k2;
    T(j1,(1:J)~=j2) = (1-k2)*T(j1,(1:J)~=j2)/sum(T(j1,(1:J)~=j2));
    LR2 = likelihoodRatio(seq,T,B,vals,ip,logL1);
end


function LR = likelihoodRatio(seq,T,B,vals,ip,logL1)

[~,cl] = fwdprob(seq,T,B,vals,ip,true);
logL2 = calcBWlogL(cl);
LR = 2*(logL1-logL2);

