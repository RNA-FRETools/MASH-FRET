function [a,T,logL,actstr] = trainPH_matlab(PH_type,a0,T0,P)

% default
M = 1E5; % maximum number of EM iterations
dL_min = 1E-6; % convergeance criteria on likelihood (faster)
d_min = 1E-8; % convergeance criteria on parameters (from SMACKS)

N = sum(P(2,:));

a_start = a0;
T_start = T0;
S = size(a_start,1);
for s = 1:S
    m = 0;
    a = a_start(s,:);
    T = T_start(:,:,s);
    logL = -Inf;
    while m<M
        a_prev = a;
        T_prev = T;
        logL_prev = logL;

        % E-step
        [B,Z,Nij,Ni] = PH_Estep(PH_type,a,T,P);

        % M-step
        [a,T,t] = PH_Mstep(PH_type,B,Z,Nij,Ni,N);
        
        % likelihood
        logL = PH_likelihood(PH_type,a,T,P);
        
        % check for convergence
%         if (logL-logL_prev)<dL_min || ...
%                 all(all(abs(T-T_prev)<d_min)) && all(abs(a-a_prev)<d_min)
        if (logL-logL_prev)<dL_min
            actstr = 'EM successfully converged';
            break
        end

        m = m+1;
        if m==M
            actstr = 'maximum number of iterations as been reached';
        end
    end

%     fprintf('Best fit: logL=%d, %i iterations\n',logL,m);

    if m>=M
        a = [];
        T = [];
        logL = -Inf;
        actstr = 'The maximum number of iteration has been reached';
    end
end


function [B,Z,Nij,Ni] = PH_Estep(PH_type,a,T,data)

x = data(1,:);
count = data(2,:);
J = numel(a);
N = numel(x);

% initialization
Nij = zeros(J);
B = Nij(1,:);
Z = Nij(1,:);
Ni = Nij(:,1);
E = eye(J);
v_e = ones(J,1);
denom = zeros(1,N);

if PH_type==1 % discrete PH
    % preliminary calculations
    t = v_e-T*v_e;
    Ty_pow = zeros(J,J,N);
    Kij = zeros(J,J,N);
    for n = 1:N
        if x(n)>1
            mat = [T,t*a;zeros(J),T]^(x(n)-1);
            Ty_pow(:,:,n) = mat(1:J,1:J);
            Kij(:,:,n) = mat(1:J,(J+1):end);
        else
            Ty_pow(:,:,n) = T^0;
        end

        denom(n) = a*(Ty_pow(:,:,n)*t);
    end

    % expectation calculation
    for j = 1:J
        for n = 1:N
            B(j) = B(j)+...
                count(n)*a(j)*(E(j,:)*(Ty_pow(:,:,n)*t))/denom(n);
            for j2 = 1:J
                if x(n)>1
                    Nij(j,j2) = Nij(j,j2)+ ...
                        count(n)*(T(j,j2)*Kij(j2,j,n))/denom(n);
                end
            end
            Ni(j) = Ni(j)+...
                count(n)*a*(Ty_pow(:,:,n)*(E(:,j)*t(j)))/denom(n);
        end
    end
    
elseif PH_type==2% continuous PH
    % preliminary calculations
    t = -T*v_e;
    exp_Ty = zeros(J,J,N);
    Jij = zeros(J,J,N);
    for n = 1:N
        mat = expm([T,t*a;zeros(J),T]*x(n));
        exp_Ty(:,:,n) = mat(1:J,1:J);
        Jij(:,:,n) = mat(1:J,(J+1):end);

        denom(n) = a*(exp_Ty(:,:,n)*t);
    end

    % expectation calculation
    for j = 1:J
        for n = 1:N
            B(j) = B(j)+count(n)*a(j)*(E(j,:)*(exp_Ty(:,:,n)*t))/denom(n);
            Z(j) = Z(j)+count(n)*Jij(j,j,n)/denom(n);
            for j2 = 1:J
                if j==j2
                    continue
                end
                Nij(j,j2) = Nij(j,j2)+...
                    count(n)*T(j,j2)*Jij(j2,j,n)/denom(n);
            end
            Ni(j) = Ni(j)+...
                count(n)*a*(exp_Ty(:,:,n)*(E(:,j)*t(j)))/denom(n);
        end
    end
end


function [a,T,t] = PH_Mstep(PH_type,B,Z,Nij,Ni,totcount)

J = numel(B);

a = B/totcount;

if PH_type==2 % continuous PH
    T = Nij./repmat(Z',[1,J]); 
    t = Ni./Z';

    js = 1:J;
    for j = 1:J
        j2s = js(js~=j);
        T(j,j) = -sum(T(j,j2s))-t(j);
    end
elseif PH_type==1 % discrete PH
    T = zeros(J);
    t = zeros(J,1);
    for j1 = 1:J
        t(j1) = Ni(j1)/(Ni(j1)+sum(Nij(j1,:)));
        for j2 = 1:J
            T(j1,j2) = Nij(j1,j2)/(Ni(j1)+sum(Nij(j1,:)));
        end
    end
end


function logL = PH_likelihood(PH_type,a,T,data)
x = data(1,:);
count = data(2,:);
N = numel(x);
J = numel(a);

if PH_type==2 % continuous PH
    t = -T*ones(J,1);
    logL = 0;
    for n = 1:N
        logL = logL + count(n)*log(a*(expm(T*x(n))*t));
    end
    
elseif PH_type==1 % discrete PH
    t = ones(J,1)-T*ones(J,1);
    logL = 0;
    for n = 1:N
        logL = logL + count(n)*log(a*(T^(x(n)-1)*t));
    end
end