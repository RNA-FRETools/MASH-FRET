function [w, mu, sigma] = calc_hypprm(h, v, shape, mu_0, mat, lim, ...
    clstDiag)

% default
minsigma = 1E-12;

J = size(mu_0,1);
if mat==1
    mu = zeros(J,1);
else
    mu = zeros(J,2);
end
sigma = ones(2,2,J);

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

nTrs = getClusterNb(J,mat,clstDiag);

% put center coordinates in order
if mat==1 % matrix
    [j1,j2] = getStatesFromTransIndexes(1:nTrs,J,mat,clstDiag);
    sum_k = zeros(1,J);
    for k = 1:nTrs
        mu(j1(k),1) = mu(j1(k),1) + sum(z.*h(k,:).*x);
        mu(j2(k),1) = mu(j2(k),1) + sum(z.*h(k,:).*y);
        sum_k(j1(k)) = sum_k(j1(k)) + sum(z.*h(k,:));
        sum_k(j2(k)) = sum_k(j2(k)) + sum(z.*h(k,:));
    end
    mu = mu./sum_k';
    
elseif mat==2 % symmetrical
    sum_k = zeros(1,J);
    for k = 1:nTrs
        if k<=J
            j = k;
            cols = [1,2];
        else
            j = k-J;
            cols = [2,1];
        end
        mu(j,cols) = mu(j,cols) + [sum(z.*h(k,:).*x) sum(z.*h(k,:).*y)];
        sum_k(j) = sum_k(j) + sum(z.*h(k,:));
    end
    mu = mu./repmat(sum_k',[1,2]);
    
else % free
    mu = [sum(repmat(z,[J,1]).*h.*repmat(x,[J,1]),2) ...
        sum(repmat(z,[J,1]).*h.*repmat(y,[J,1]),2)] ./ ...
        repmat(sum(repmat(z,[J,1]).*h,2),[1 2]);
end

for k = 1:nTrs
    
    if mat==1 % matrix
        d = [x;y]-repmat(mu([j1(k),j2(k)],1),[1,N]);
    elseif mat==2 % symmetrical
        if k<=J
            j = k;
            cols = [1,2];
        else
            j = k-J;
            cols = [2,1];
        end
        d = [x;y]-repmat(mu(j,cols)',[1,N]);
    else % free
        d = [x;y]-repmat(mu(k,:)',[1,N]);
    end

    if strcmp(shape, 'spherical')
        varX = sum(z.*h(k,:).*sqrt((prod(d,1).^2)))/sum(z.*h(k,:));
        varY = varX;
        sigma(:,:,k) = [varX covXY;covXY varY];

    elseif strcmp(shape, 'ellipsoid straight');
        varX = sum(z.*h(k,:).*(d(1,:).^2))/sum(z.*h(k,:));
        varY = sum(z.*h(k,:).*(d(2,:).^2))/sum(z.*h(k,:));
        sigma(:,:,k) = [varX covXY;covXY varY];


    elseif strcmp(shape, 'ellipsoid diagonal');
        % rotate data from pi/4, (matRotPos*d)
        dataRot = [matRotPos(1,1)*d(1,:)+matRotPos(1,2)*d(2,:); ...
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

for k = 1:size(sigma,3)
    if sum([sigma(1,1,k),sigma(2,2,k)]<minsigma)
        mu = [];
        return
    end
end

if size(mu,1)>1
    incl = true(size(mu,1),1);
    if mat==1
        for j1 = 1:J
            for j2 = 1:J
                if j1==j2
                    continue
                end
                if sum(abs(mu(j1,:)-mu(j2,:))<lim)
                    incl([j1 j2]) = false;
                end
            end
        end
    else
        for k = 1:size(mu,1)
            if abs(mu(k,1)-mu(k,2))<lim
                incl(k) = false;
            end
        end
    end
    mu = mu(incl,:);
end

