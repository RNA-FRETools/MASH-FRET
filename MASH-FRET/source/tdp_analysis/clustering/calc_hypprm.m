function [w, mu, sigma] = calc_hypprm(h, v, shape, mu_0, corr, lim)
K = size(mu_0,1);
if corr
    mu = zeros(K,1);
else
    mu = zeros(K,2);
end
sigma = ones(2,2,K);

z = v(3,:); x = v(1,:); y = v(2,:);
N = size(v,2);
w = sum(h.*repmat(v(3,:),[size(h,1),1]),2)/sum(z);

if strcmp(shape, 'ellipsoid diagonal');
    % from http://www.visiondummy.com/2014/04/geometric- ...
    % interpretation-covariance-matrix/
    matRotPos = [cos(pi/4),-sin(pi/4);sin(pi/4),cos(pi/4)];
    R = [cos(-pi/4),-sin(-pi/4);sin(-pi/4),cos(-pi/4)];

elseif strcmp(shape, 'spherical') || ...
        strcmp(shape, 'ellipsoid straight')
    covXY = 0;
end

if corr
    k = 0;
    sum_k = zeros(1,K);
    for k1 = 1:K
        for k2 = 1:K
            k = k+1;
            mu(k1,1) = mu(k1,1) + sum(z.*h(k,:).*x);
            mu(k2,1) = mu(k2,1) + sum(z.*h(k,:).*y);
            sum_k(k1) = sum_k(k1) + sum(z.*h(k,:));
            sum_k(k2) = sum_k(k2) + sum(z.*h(k,:));
        end
    end
    mu = mu./sum_k';
    [mu,id] = sort(mu);
    
    k = 0;
    k_new = zeros(size(id,1),3);
    for k1 = id'
        for k2 = id'
            k = k+1;
            k_new(k,1:3) = [k k1 k2];
        end
    end

    k_old = 0;
    for k1 = 1:K
        for k2 = 1:K
            k_old = k_old+1; k1_old = id(k1); k2_old = id(k2);
            k = k_new(k_new(:,2)==k1_old & k_new(:,3)==k2_old,1);
            
            d = [x;y]-repmat(mu([k1_old k2_old],1),[1,N]);
            
            if strcmp(shape, 'spherical')
                varX = sum(z.*h(k_old,:).*sqrt((prod(d,1).^2)))/ ...
                    sum(z.*h(k_old,:));
                varY = varX;
                sigma(:,:,k) = [varX covXY;covXY varY];
                
            elseif strcmp(shape, 'ellipsoid straight');
                varX = sum(z.*h(k_old,:).*(d(1,:).^2))/sum(z.*h(k_old,:));
                varY = sum(z.*h(k_old,:).*(d(2,:).^2))/sum(z.*h(k_old,:));
                sigma(:,:,k) = [varX covXY;covXY varY];
                

            elseif strcmp(shape, 'ellipsoid diagonal');
                % rotate data from pi/4, (matRotPos*d)
                dataRot = [matRotPos(1,1)*d(1,:)+matRotPos(1,2)*d(2,:); ...
                    matRotPos(2,1)*d(1,:)+matRotPos(2,2)*d(2,:)];
                varXrot = sum(z.*h(k_old,:).*(dataRot(1,:).^2))/sum(z.*h(k_old,:));
                varYrot = sum(z.*h(k_old,:).*(dataRot(2,:).^2))/sum(z.*h(k_old,:));
                % rotate cov matrix from -pi/4, sig = RSSR'
                varX = (R(1,1)^2)*varXrot + (R(1,2)^2)*varYrot;
                varY = (R(2,1)^2)*varXrot + (R(2,2)^2)*varYrot;
                covXY = R(2,1)*R(1,1)*varXrot + R(2,2)*R(1,2)*varYrot;
                sigma(:,:,k) = [varX covXY;covXY varY];

            elseif strcmp(shape, 'free');
                varX = sum(z.*h(k_old,:).*(d(1,:).^2))/sum(z.*h(k_old,:));
                varY = sum(z.*h(k_old,:).*(d(2,:).^2))/sum(z.*h(k_old,:));
                covXY = sum(z.*h(k_old,:).*prod(d,1))/sum(z.*h(k_old,:));
                sigma(:,:,k) = [varX covXY;covXY varY];
            end
        end
    end
    
else
    mu = [sum(repmat(z,[K,1]).*h.*repmat(x,[K,1]),2) ...
        sum(repmat(z,[K,1]).*h.*repmat(y,[K,1]),2)] ./ ...
        repmat(sum(repmat(z,[K,1]).*h,2),[1 2]);
    
    for k = 1:K
        d = [x;y]-repmat(mu(k,:)',[1,N]);
        
        if strcmp(shape, 'spherical')
            varX = sum(z.*h(k,:).*sqrt((prod(d,1).^2)))/ ...
                sum(z.*h(k,:));
            varY = varX;
            sigma(:,:,k) = [varX covXY;covXY varY];

        elseif strcmp(shape, 'ellipsoid diagonal');
            % rotate data from pi/4, (matRotPos*d)
            dataRot = [matRotPos(1,1)*d(1,:) + matRotPos(1,2)*d(2,:); ...
                matRotPos(2,1)*d(1,:)+matRotPos(2,2)*d(2,:)];
            varXrot = sum(z.*h(k,:).*(dataRot(1,:).^2))/sum(z.*h(k,:));
            varYrot = sum(z.*h(k,:).*(dataRot(2,:).^2))/sum(z.*h(k,:));
            % rotate cov matrix from -pi/4, sig = RSSR'
            varX = (R(1,1)^2)*varXrot + (R(1,2)^2)*varYrot;
            varY = (R(2,1)^2)*varXrot + (R(2,2)^2)*varYrot;
            covXY = R(2,1)*R(1,1)*varXrot + R(2,2)*R(1,2)*varYrot;
            sigma(:,:,k) = [varX covXY;covXY varY];

        elseif strcmp(shape, 'free');
            varX = sum(z.*h(k,:).*(d(1,:).^2))/sum(z.*h(k,:));
            varY = sum(z.*h(k,:).*(d(2,:).^2))/sum(z.*h(k,:));
            covXY = sum(z.*h(k,:).*prod(d,1))/sum(z.*h(k,:));
            sigma(:,:,k) = [varX covXY;covXY varY];
        end
    end
end

if size(mu,1)>1
    incl = true(size(mu,1),1);
    for k1 = 1:size(mu,1)
        for k2 = 1:size(mu,1)
            if k1~=k2
                if sum(abs(mu(k1,:)-mu(k2,:))<lim)
                    incl([k1 k2]) = false;
                end
            end
        end
    end
    mu = mu(incl,:);
end

