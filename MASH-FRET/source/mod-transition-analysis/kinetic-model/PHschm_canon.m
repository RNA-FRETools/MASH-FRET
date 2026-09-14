function [can,refcan,reftp] = PHschm_canon(D,PHtype,refcan,reftp)
% [schm,refcan,reftp] = PHschm_canon(D,PHtype,refcan,reftp)
%
% Determine/collect from reference the canonical forms of the reaction 
% scheme matrices for a given number of states.
%
% D: nb. of states.
% PHtype: 1 to sort discrete distributions, 2 for continuous
% refcan: {1-by-D_big}[D+2-by-D+2-by-S1] already-calculated canonical 
%       schemes.
% reftp: {1-by-D_big}{1-by-ntp_big}[D+2-by-D+2-by-S2] already calculated 
%        transition schemes organized by nb. of transition probabilities.
% canon: [D+2-by-D+2-by-S3] canonical schemes for the given nb. of states.

% defaults
tau1 = 10; % shortest state lifetime
fact = 20; % lifetime multiplication factor
tol = 1E-10; % tolerance on eigenvalues (double precision)
Pmin = eps("double"); % minimum PDF for calculation
sortwght = true; % identify distributions according to individual component's integral

% initializes output
can = [];

% collects form reference if any
if numel(refcan)>=D && ~isempty(refcan{D})
    can = refcan{D};
    return
end

% determine canonical forms (time intensive for D>=5)
fprintf('\nlooking for canonical connectivities for D=%i...\n',D);
if D>=5
    fprintf(['\n[WARNING: this process is time intensive for more than 4 ',...
        'degenerate states and will take hours-to-days to complete.\nTo ',...
        'cancel, press Ctrl+C in MATLAB command window.]\n\n']);
end

% collect all possible schemes
fprintf('>> collect all possible connectivity schemes...\n');
[schm,reftp] = collectsAllSchm(D,2*D-1,reftp);

% get all possible permutations of states
tauorder = determinetauorder(D);

% classify distribution parameters of each scheme
fprintf('>> determine scheme equivalence:\n');
S = size(schm,3);
tau0 = tau1*fact.^(0:D-1);
res = [];
nfpmin = [];
allschm = {};
nb = 0;
for s = 1:S
    nb = dispProgress([sprintf('>>>> process scheme %i/%i...',s,S),'\n'],...
        nb);
    schm_s = double(schm(:,:,s));

    % uses uniform initial state probabilities
    ip = schm_s(1,2:end-1)/sum(schm_s(1,2:end-1));

    % uses uniform transition proportions
    w = schm_s(2:end-1,2:end)./...
        repmat(sum(schm_s(2:end-1,2:end),2),[1,D+1]);

    for ord = 1:size(tauorder,1)
        tau = tau0(tauorder(ord,:));

        % calculates distribution parameters
        Q = w./repmat(tau',[1,D+1]);
        switch PHtype
            case 1 % PH
                Q(~~eye(D)) = 1-sum(Q,2);
            case 2 % CPH
                Q(~~eye(D)) = -sum(Q,2);
            otherwise
                disp('PHschm_canon: unknown distribution type.')
                return
        end
        Q = Q(:,1:D);
        [a,eigval] = calcexpweight(Q,ip,tol,PHtype);

        % ignore models yielding non distinct eigenvalues or null weights
        if isempty(eigval) 
            continue
        end

        % builds distribution's barcode
        eigvalr = rnd2tol(eigval,tol);
        evcmplx = imag(eigvalr')~=0;
        evsign = -double(eigvalr'<0)+double(eigvalr'>0);
        [~,evord] = sort(abs(real(eigvalr)));
        evord = evord';
        
        [itg,itgord] = sortitg(PHtype,a,eigval,tol);
        itgsign = -double(itg<0)+double(itg>0);
        if ~sortwght
            itgcode = itgsign;
        else
            itgcode = itgsign.*itgord;
        end
        
        barcode = [itgcode(evord),evsign(evord),evcmplx(evord)];
        
        % calculate probabilities with spectral decomposition formula
        switch PHtype
            case 1 % DPH
                [~,prob] = calcDPHPMF(a,eigval,Pmin);
            case 2 % CPH
                [~,prob] = calcCPHPDF(a,eigval,Pmin);
        end
        prob = rnd2tol(prob,tol);

        % skip negative or complex probabilities
        if any(imag(prob)~=0 | prob<0)
            continue
        end

        % classifies distribution by equality in their barcode
        if isempty(res)
            res = cell(1,2);
            res{1} = barcode;
            nfpmin = sum(schm_s(:));
            allschm = {int8(schm_s)};
        else
            id = findbarcode(res{1},barcode,D);
            if isempty(id)
                res{1} = cat(1,res{1},barcode);
                allschm = cat(1,allschm,{int8(schm_s)});
                nfpmin = cat(2,nfpmin,sum(schm_s(:)));
            else
                allschm{id} = cat(3,allschm{id},int8(schm_s));
                if sum(schm_s(:))<nfpmin(id)
                    nfpmin(id) = sum(schm_s(:));
                end
            end
        end
    end
end

% collects all minimal complexity schemes
fprintf(['>> find schemes of minimal complexity in each equivalent ',...
    'class...\n']);
[minid,minschm] = collectsminschm(res{1},allschm,nfpmin);
isim = any(res{1}(:,(2*D+1):(3*D)),2);

% determines final set of canonical forms
fprintf('>> determine canonical schemes...\n');
nCat = size(res{1},1);
schm_c = cell(1,nCat);
for c = 1:nCat
    schm_c{c} = minschm(:,:,minid==c);
end
schm_c(cellfun(@isempty,schm_c)) = [];
[can,~] = collectscanonschm(schm_c,isim);

% update reference with newly calculated canonical schemes
if numel(refcan)<D
    refcan = cat(2,refcan,cell(1,D-numel(refcan)));
end
refcan{D} = can;

% show success
fprintf(['%i canonical forms were successfully found for %i degenerate ',...
    'states!\n'],size(can,3),D);


function [catid,schm] = collectsminschm(barcodes,allschm,nfpmin)
%% [catid,schm] = collectsminschm(barcodes,allschm,nfpmin)
%
% Identifies and collects all minimal complexity schemes represented by
% each barcode.
%
% barcodes: [nCat-by-nCodes] distincts barcode.
% allschm: {1-by-nCat}[D+2-by-D+2-by-Sc] reaction schemes having the same 
%          barcode.
% nfpmin: [1-by-nCat] minimum model complexity for each barcode (number of
%         striclty positive probabilities in scheme)
% catid: [S-by-1] barcode indexes of each minimal scheme
% schm: [D+2-by-D+2-by-S] minimal schemes
%%

catid = [];
schm = [];
nCat = size(barcodes,1);
D = size(allschm{1},1)-2;
nb = 0;
for c = 1:nCat
    nb = dispProgress([...
        sprintf('>>>> process class %i/%i...',c,nCat),'\n'],nb);
    if ~all(barcodes(c,1:D)~=0)
        continue
    end
    
    schm_cell = double(allschm{c});
    
    % collects equivalent schemes of same complexity
    nfp_c = permute(sum(sum(schm_cell,1),2),[1,3,2]);
    schm_c0 = schm_cell(:,:,nfp_c==nfpmin(c));
    
    % check for uniquness of scheme
    Sc = size(schm_c0,3);
    schm_c = [];
    for s = 1:Sc
        if isempty(schm_c)
            schm_c = schm_c0(:,:,s);
            continue
        end
        if ~any(isequalschm(schm_c,schm_c0(:,:,s)))
            schm_c = cat(3,schm_c,schm_c0(:,:,s));
        end
    end
    schm = cat(3,schm,schm_c);
    Sc = size(schm_c,3);
    
    % lists schemes' category
    catid = cat(2,catid,repmat(c,[1,Sc]));
end


function [schm,isim] = collectscanonschm(minschm,minisim)
%% [schm,isim] = collectscanonschm(minschm,minisim)
%
% Identifies and collects canonical schemes. Canonical schemes are of
% minimum complexity and describe as many barcodes as possible with the
% less schemes possible. In case multiple canonical schemes are equivalent
% in that sense, the ones with the least number of transitions between
% aggregate states are retained.
%
% minschm: {1-by-nCat}[D+2-by-D+2-by-Sc] minimal reaction schemes having 
%          the same barcode.
% minisim: [nCat-by-1] logical true for imaginary eigenvalues, false 
%          otherwise
% schm: [D+2-by-D+2-by-S] canonical schemes
% isim: [1-by-S] -1 if scheme describes categories with purely real 
%       eigenvalues, 1 with purely imaginary eigenvalues, and 0 if a mix of
%       both.
%%

Sc = cellfun('size',minschm,3);
[~,catord] = sort(Sc);
minschm = minschm(catord);
minisim = minisim(catord);

nCat = numel(minschm);
leftcat = 1:nCat;
schm = [];
isim = [];
nb = 0;
for c = 1:nCat
    nb = dispProgress([...
        sprintf('>>>> process scheme category %i/%i...',c,nCat),'\n'],nb);
    if ~any(leftcat==c)
        continue
    end
    Sc = size(minschm{c},3);
    N = zeros(1,Sc);
    simcat = cell(1,Sc);
    isim_s = zeros(1,Sc);
    for s = 1:Sc
        isim_c2 = [];
        for c2 = leftcat
            id = find(isequalschm(minschm{c2},minschm{c}(:,:,s)));
            N(s) = N(s)+numel(id);
            if ~isempty(id)
                isim_c2 = cat(2,isim_c2,minisim(c2));
                simcat{s} = cat(2,simcat{s},c2);
            end
        end
        if all(isim_c2==0)
            isim_s(s) = -1;
        elseif all(isim_c2==1)
            isim_s(s) = 1;
        end
    end
    
    [~,bestid] = max(N);
    
    schm = cat(3,schm,minschm{c}(:,:,bestid));
    isim = cat(2,isim,isim_s(bestid));
    for c2 = simcat{bestid}
        leftcat(leftcat==c2) = [];
    end
end


function tauorder = determinetauorder(D)
%% tauorder = determinetauorder(D)
%
% Determine all possible sorting order of lifetimes.
%
% D: number of lifetimes
% tauorder: [nOrder-by-D] sorting indexes
%%

tauorder = eval(['allcomb(1:D',repmat(',1:D',[1,D-1]),')']);
nOrd = size(tauorder,1);
excl = false(1,nOrd);
for ord = 1:nOrd
    vals = unique(tauorder(ord,:));
    valmax = max(vals);
    if valmax>numel(vals)
        excl(ord) = true;
    end
end
tauorder(excl,:) = [];


function id = findbarcode(ref,barcode,D)
%% id = findbarcode(ref,barcode,D)
%
% Look for any permutation of input barcode in table. Returns row index if 
% found, empty array otherwise.
%
% ref: [nCode-by-N*D] barcode table.
% barcode: [1-by-N*D] barcode to look for.
% D: aggregate size.
% id: row index in table where barcode was found, or empty if not found.
%%

% generates all possible permutaions
N = size(barcode,2)/D;
allperm = perms(1:D);
nPerm = size(allperm,1);
allperm = repmat(allperm,[1,N])+...
    repmat(reshape(repmat(0:(N-1),[D,1]),1,[]).*(D*ones(1,N*D)),nPerm,1);

% look for equivalent barcode in table
R = size(ref,1);
P = size(allperm,1);
ids = repmat(allperm,[1,1,R])+...
    (N*D)*repmat(permute(0:R-1,[1,3,2]),[P,N*D,1]);
ref = permute(ref,[3,2,1]);
id = find(permute(any(all(ref(ids)==repmat(barcode,[P,1,R]),2),1),[1,3,2]),...
    1,'first');


function iseq = isequalschm(schm0,schm)
%% iseq = isequalschm(schm0,schm)
%
% Check whether the input transition scheme or a permutation is found in 
% the input list of schemes.
%
% schm0: [D+2-by-D+2-by-S] reference list of schemes
% schm: [D+2-by-D+2] input scheme
% iseq: [1-by-S] logical (1) if entry of schm0 is a permutation of the 
%       input scheme (0) otherwise.
%%

S = size(schm0,3);
D = size(schm,1)-2;
iseq = false(1,S);
for s = 1:S
    stateperm = perms(2:D+1);
    for d = 1:size(stateperm,1)
        schmperm = reorderMat(schm,[1,stateperm(d,:),D+2]);
        iseq(s) = isequal(schmperm,schm0(:,:,s));
        if iseq(s)
            break
        end
    end
end


function [itg,itgord] = sortitg(PHtype,a,eigval,tol)
%% [itg,itgord] = sortitg(PHtype,a,eigval,tol)
%
% Sort integreals of exponential compoenents. If complex integrals are 
% found, their values are summed up.
%
% PHtype: 1 for discrete distribution, 2 for continuous
% a: weights of exponential components in spectral decomposition of PDF
% eigval: exponential constants in spectral decomposition of PDF
% tol: precision on integral values
% itg: integral values
% itgord: sorting order of integral values
%%

itg = rnd2tol(calcitg(a,eigval,PHtype),tol);

% itg(imag(itg)~=0) = 2*real(itg(imag(itg)~=0))+...
%     1i*imag(itg(imag(itg)~=0));
iscmplx = imag(itg)~=0;
itg(iscmplx) = sum(itg(iscmplx));

[~,~,itgord] = unique(abs(real(itg)));
itgord = itgord';

