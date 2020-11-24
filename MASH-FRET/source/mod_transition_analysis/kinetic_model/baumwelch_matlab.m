function [T,B,ip,logL] = baumwelch_matlab(T0,B0,seq,vals,ip0)

% default
dLmin = 1E-6; % convergence criterion on logL
dmin = 1E-8; % convergence criterion on parameters (SMACKS)
M = 100000; % maximum number of EM iterations
m = 0; % initializes number of EM iterations
nb = 0; % initializes number of bytes written in command window

N = numel(seq);
[V,J] = size(B0);
T = T0;
B = B0;
ip = ip0;
logL = -Inf;

% get sequences of value indexes
seq_vals = cell(1,N);
for n = 1:N
    for v = 1:V
        seq_vals{n}(seq{n}==vals(v)) = v;
    end
end

% calculate forward and backward porbabilities
norm = false; % alpha and beta are not normalized at each time step (faster)
[alpha,~] = fwdprob(seq,T,B,vals,ip,norm);
beta = bwdprob(seq,T,B,vals,[]);

% E-M iterations
xi = cell(1,N);
gamma = cell(1,N);
while m<M
    
    m = m+1;
    
    logL_prev = logL;
    T_prev = T;
    B_prev = B;
    ip_prev = ip;
    
    for n = 1:N
        L = numel(seq{n});
        xi{n} = zeros(J,J,L-1);
        for i = 1:J
            for j = 1:J
                xi{n}(i,j,:) = permute(alpha{n}(1:L-1,i),[3,2,1])*T(i,j).*...
                    permute(beta{n}(j,2:L),[1,3,2]).*...
                    permute(B(seq_vals{n}(2:L),j),[3,2,1]);
            end
        end
        xi{n} = xi{n}./repmat(sum(sum(xi{n},1),2),[J,J,1]);
        gamma{n} = alpha{n}.*beta{n}';
        gamma{n} = gamma{n}./repmat(sum(gamma{n},2),[1,J]);
    end
    
    % M-step
    ip = zeros(1,J);
    Nij = zeros(J,J);
    B = zeros(V,J);
    Ni = ip;
    b_denom = ip;
    for n = 1:N
        ip = ip + gamma{n}(1,:)/N;
        Nij = Nij + sum(xi{n},3);
        for v = 1:V
            B(v,:) = B(v,:) + sum(gamma{n}(seq_vals{n}==v,:),1);
        end
        Ni = Ni + sum(gamma{n}(1:end-1,:),1);
        b_denom = b_denom + sum(gamma{n},1);
    end
    B = B./repmat(b_denom,[V,1]);
    T = Nij./repmat(Ni',[1,J]);
    
    if sum(isnan(B)) % state trajectories are too long, alpha and beta need to be normalized at each time step
        T = T_prev;
        B = B_prev;
        ip = ip_prev;
        norm = true; % computation time x 2
    end
    
    [alpha,cl] = fwdprob(seq,T,B,vals,ip,norm);
    if norm
        beta = bwdprob(seq,T,B,vals,cl);
        logL = calcBWlogL(cl);
    else
        beta = bwdprob(seq,T,B,vals,[]);
        logL = calcBWlogL(alpha,beta);
    end
    
    dTmax = max(max(abs(T-T_prev)));
    dBmax = max(max(abs(B-B_prev)));
    dipmax = max(abs(ip-ip_prev));

    nb = dispProgress(...
        sprintf(['iteration %i: d=%1.3e dL=%1.3e (dL_min=%1.0e)...\n',...
        repmat(['%0.5f',repmat('\t%0.5f',[1,J-1]),'\n'],[1,J])],...
        m,max([dTmax,dBmax,dipmax]),(logL-logL_prev),dLmin,T'),nb);
    
    % check for convergence
    if (logL-logL_prev)<dLmin
        logL = logL_prev;
        T = T_prev;
        ip = ip_prev;
        B = B_prev;
        fprintf('EM successfully converged after %i iterations!\n',m);
        break
    end
end

