function [T,B,ip,logL] = baumwelch(T0,B0,seq,vals,ip0)

% default
dLmin = 1E-6; % convergence criterion on logL
dmin = 1E-8; % convergence criterion on parameters (SMACKS)
M = 100000; % maximum number of EM iterations
m = 0;

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
[alpha,~,~] = fwdprob(seq,T,B,vals,ip);
[beta,~] = bwdprob(seq,T,B,vals);

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
    T = zeros(J,J);
    B = zeros(V,J);
    xi_denom = zeros();
    b_denom = zeros();
    for n = 1:N
        ip = ip + gamma{n}(1,:)/N;
        T = T + sum(xi{n},3);
        for v = 1:V
            B(v,:) = B(v,:) + sum(gamma{n}(seq_vals{n}==v,:),1);
        end
        xi_denom = xi_denom + sum(gamma{n},1)-gamma{n}(end,:);
        b_denom = b_denom + sum(gamma{n},1);
    end
    B = B./repmat(b_denom,[V,1]);
    T = T./repmat(xi_denom',[1,J]);
    
    [alpha,~,~] = fwdprob(seq,T,B,vals,ip);
    [beta,~] = bwdprob(seq,T,B,vals);
    
    logL = calcBWlogL(alpha,beta);
    
    % check for convergence
    if (logL-logL_prev)<dLmin || (~sum(sum(abs(T-T_prev)>=dmin)) && ...
            ~sum(sum(abs(B-B_prev)>=dmin)) && ~sum(abs(ip-ip_prev)>=dmin))
        logL = logL_prev;
        T = T_prev;
        B = B_prev;
        ip = ip_prev;
        break
    end
end

