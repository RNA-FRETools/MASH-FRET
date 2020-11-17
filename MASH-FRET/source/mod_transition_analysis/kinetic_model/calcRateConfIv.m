function err = calcRateConfIv(T0,seq,B,vals,ip,logL1)

% default
step = 0.01;
LRmax = 1.96^2; % 95th percentile of chi2 (1.96~97.5% normal pdf)

[~,J] = size(B);
err = zeros(J,J,2);

% [~,~,logL1] = fwdprob(seq,T0,B,vals,ip);

for j1 = 1:J
    for j2 = 1:J
        if j1==j2
            continue
        end
        
        % up variation
        [LR1,LR2,k1,k2] = varyRate(T0,j1,j2,step*T0(j1,j2),LRmax,seq,B,vals,ip,logL1);
        if k2~=k1
            a = (LR2-LR1)/(k2-k1);
            b = LR2-a*k2;
            err(j1,j2,1) = (LRmax-b)/a-T0(j1,j2);
        else
            err(j1,j2,1) = k2-T0(j1,j2);
        end
        
        % down variation
        [LR1,LR2,k1,k2] = varyRate(T0,j1,j2,-step*T0(j1,j2),LRmax,seq,B,vals,ip,logL1);
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

[alpha,~,~] = fwdprob(seq,T,B,vals,ip);
[beta,~] = bwdprob(seq,T,B,vals);

logL2 = calcBWlogL(alpha,beta);
LR = 2*(logL1-logL2);

