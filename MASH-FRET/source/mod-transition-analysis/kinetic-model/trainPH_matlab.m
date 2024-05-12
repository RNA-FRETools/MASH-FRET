function [a,T,logL,nb] = trainPH_matlab(PH_type,a0,T0,P,mute)

% default
M = 1E5; % maximum number of EM iterations
dm_disp = 1; % nb. of iterations between two displays
dL_min = 1E-3; % convergeance criteria on likelihood (faster)
d_min = 1E-8; % convergeance criteria on parameters (from SMACKS)
nb = 0;

N = sum(P(2,:));

a_start = a0;
T_start = T0;
[S,J] = size(a_start);
for s = 1:S
    m = 0;
    a = a_start(s,:);
    T = T_start(:,:,s);
    
    % pre-allocate memory
    nDt = numel(P(1,:));
    Ty = zeros(J,J,nDt);
    Mij = zeros(J,J,nDt);
    denom = zeros(1,nDt);
    mat = zeros(2*J,2*J);
    Nij0 = zeros(J);
    B0 = Nij0(1,:);
    Z0 = Nij0(1,:);
    Ni0 = Nij0(:,1);
    E = eye(J);
    v_e = ones(J,1);
    
    logL = -Inf;
    m_prev = 0;
    while m<M
        a_prev = a;
        T_prev = T;
        logL_prev = logL;

        % E-step
        [B,Z,Nij,Ni] = ...
            PH_Estep(PH_type,a,T,P,Ty,Mij,mat,denom,B0,Z0,Ni0,Nij0,E,v_e);

        % M-step
        [a,T,t] = PH_Mstep(PH_type,B,Z,Nij,Ni,N);
        
        % likelihood
        logL = PH_likelihood(PH_type,a,T,t,P);
        
        % check for convergence
        dmax = max([max(max(abs(T-T_prev))),max(abs(a-a_prev))]);
        dL = (logL-logL_prev)/N;
        cvg = dL<dL_min | dmax<d_min;
        
        % show progress
        if ~mute && (cvg || (m-m_prev)>=dm_disp)
            nb = dispProgress(...
                sprintf(['iteration %i: d=%.3E dL=%.3E\n',...
                repmat('%.3E ',1,J),'\n\n',...
                repmat(repmat('%.3E ',1,J),'\n',1,J)],m,dmax,dL,a,T'),nb);
            m_prev = m;
        end
        if cvg
            break
        end

        m = m+1;
    end

%     fprintf('Best fit: logL=%d, %i iterations\n',logL,m);

    if m>=M
        a = [];
        T = [];
        logL = -Inf;
        if ~mute
            nb = dispProgress(['maximum number of iterations has been ',...
                'reached'],nb);
        end
    end
end
fprintf('\n');


function [B,Z,Nij,Ni] = PH_Estep(...
    PH_type,a,T,data,Ty,Mij,mat,denom,B,Z,Ni,Nij,E,v_e)

J = numel(a);
N = numel(data(1,:));

if PH_type==1 % discrete PH
    % preliminary calculations
    t = v_e-T*v_e;
    for n = 1:N
        if data(1,n)>1
            mat(1:J,1:J)= T;
            mat(1:J,(J+1):2*J) = t*a;
            mat((J+1):2*J,1:J) = zeros(J);
            mat((J+1):2*J,(J+1):2*J) = T;
            mat = mat^(data(1,n)-1);
            Ty(:,:,n) = mat(1:J,1:J);
            Mij(:,:,n) = mat(1:J,(J+1):end);
        else
            Ty(:,:,n) = T^0;
        end

        denom(n) = a*(Ty(:,:,n)*t);
    end

    % expectation calculation
    for j = 1:J
        for n = 1:N
            B(j) = B(j)+...
                data(2,n)*a(j)*(E(j,:)*(Ty(:,:,n)*t))/denom(n);
            for j2 = 1:J
                if data(1,n)>1
                    Nij(j,j2) = Nij(j,j2)+ ...
                        data(2,n)*(T(j,j2)*Mij(j2,j,n))/denom(n);
                end
            end
            Ni(j) = Ni(j)+...
                data(2,n)*a*(Ty(:,:,n)*(E(:,j)*t(j)))/denom(n);
        end
    end
    
elseif PH_type==2% continuous PH
    % preliminary calculations
    t = -T*v_e;
    for n = 1:N
        mat(1:J,1:J)= T;
        mat(1:J,(J+1):2*J) = t*a;
        mat((J+1):2*J,1:J) = zeros(J);
        mat((J+1):2*J,(J+1):2*J) = T;
        mat = expm(mat*data(1,n));
        Ty(:,:,n) = mat(1:J,1:J);
        Mij(:,:,n) = mat(1:J,(J+1):end);

        denom(n) = a*(Ty(:,:,n)*t);
    end

    % expectation calculation
    for j = 1:J
        for n = 1:N
            B(j) = B(j)+data(2,n)*a(j)*(E(j,:)*(Ty(:,:,n)*t))/denom(n);
            Z(j) = Z(j)+data(2,n)*Mij(j,j,n)/denom(n);
            for j2 = 1:J
                if j==j2
                    continue
                end
                Nij(j,j2) = Nij(j,j2)+...
                    data(2,n)*T(j,j2)*Mij(j2,j,n)/denom(n);
            end
            Ni(j) = Ni(j)+...
                data(2,n)*a*(Ty(:,:,n)*(E(:,j)*t(j)))/denom(n);
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


function logL = PH_likelihood(PH_type,a,T,t,data)
N = numel(data(1,:));
J = numel(a);
logL = 0;

% switch PH_type
%     case 1 % discrete PH
%         t = ones(J,1)-T*ones(J,1);
%     case 2 % continuous PH
%         t = -T*ones(J,1);
% end

for n = 1:N
    switch PH_type
        case 1 % discrete PH
            likelihood_n = a*((T^(data(1,n)-1))*t);
        case 2 % continuous PH
            likelihood_n = a*(expm(T*data(1,n))*t);
    end
    if isnan(likelihood_n) || isinf(likelihood_n)
        continue
    end
    logL = logL + data(2,n)*log(likelihood_n);
end
