function proj = downCompatibilityTP(proj,n)
% Re-adjusts molecule and general parameters of old projects in order to be in accordance with current MASH version
%
% proj = downCompatibilityTP(proj,n)
% 
% proj: h.param.ttPr.proj{i), with h the structure saved in main figure's handle and i the project index in the project list
% n: molecule index in the project

% Last update: 13.1.2020 by MH
% >> manage down compatibility by moving cross-talks coefficients to
%  general parameters
%
% update: 10.1.2020 by MH
% >> manage down compatibility by moving factor correction in 6th cell and 
%  adding default parameters for ES regression
%
% update: 29.3.2019 by MH
% >> manage down-compatibility and adapt reorganization of cross-talk 
%    coefficients to new parameter structure (see 
%    project/setDefPrm_traces.m)

nChan = proj.nb_channel;
nExc = proj.nb_excitations;
chanExc = proj.chanExc;
nFRET = size(proj.FRET,1);
nS = size(proj.S,1);

% added by MH, 29.3.2019 reorder already-existing Bt coefficient values 
% into new format: sum Bt coefficients over the different excitations and 
% use as only Bt coefficients.
if size(proj.prm{n},2)>=5 && size(proj.prm{n}{5},2)>=2 && ...
        iscell(proj.prm{n}{5}{1})
    newBtPrm = zeros(nChan,nChan-1);
    for c = 1:nChan
        bts = zeros(nExc,nChan-1);
        for l = 1:nExc
            bts(l,:) = proj.prm{n}{5}{1}{l,c};
        end
        newBtPrm(c,:) = sum(bts,1);
    end
    proj.prm{n}{5}{1} = newBtPrm;
end

% added by MH, 29.3.2019
% reorder already-existing DE coefficient values into new format: use the 
% first non-zero DE coefficient as only DE coefficient.
if size(proj.prm{n},2)>=5 && size(proj.prm{n}{5},2)>=2 && ...
        iscell(proj.prm{n}{5}{2})
    newDePrm = zeros(nExc-1,nChan);
    for c = 1:nChan
        l0 = find(exc==chanExc(c));
        if isempty(l0)
            newDePrm(:,c) = 0;
            continue
        end

        l0 = l0(1);
        exc_dir = 0;
        for l = 1:nExc
            if l ~= l0
                exc_dir = exc_dir+1;
                val = find(proj.prm{n}{5}{2}{l,c}~=0);
                if isempty(val)
                    newDePrm(exc_dir,c) = 0;
                else
                    newDePrm(exc_dir,c) = proj.prm{n}{5}{2}{l,c}(val(1));
                end
            end
        end
    end
    proj.prm{n}{5}{2} = newDePrm;
end

% added by MH, 10.1.2020: move cross-talks to general parameters, move 
% factor corrections in 6th cell and add default parameters for ES 
% regression
if size(proj.prm{n},2)==5 && size(proj.prm{n}{5},2)==5
    factPrm =[proj.prm{n}{5}(3:end),proj.def.mol{6}{4}];
    proj.prm{n} = cat(2,proj.prm{n},{factPrm});
    if n==1
        proj.fix{4} = proj.prm{n}{5}(1:2);
    end
    proj.prm{n}{5} = [];
end

% added by MH, 13.1.2020: down compatibility by adding beta factors
if size(proj.prm{n},2)>=6 && size(proj.prm{n}{6},2)>=1 && ...
        size(proj.prm{n}{6}{1},1)==1
    proj.prm{n}{6}{1} = cat(1,proj.prm{n}{6}{1},...
        ones(1,size(proj.prm{n}{6}{1},2)));
end

% state sequences were previously calculated
if size(proj.prm{n},2)>=4 && size(proj.prm{n}{4},2)>=2

    % reshape old format
    if size(proj.prm{n}{4}{2},2)==8
        for j = 1:size(proj.prm{n}{4}{2},3)
            proj.prm{n}{4}{2}(1,1:6,j) = ...
                proj.prm{n}{4}{2}(1,[2,1,5,8,3,4],j);
            proj.prm{n}{4}{2}(2,1:6,j) = ...
                proj.prm{n}{4}{2}(2,[1,2,5,8,3,4],j);
            proj.prm{n}{4}{2}(3,1:6,j) = ...
                proj.prm{n}{4}{2}(3,[1,2,5,8,3,4],j);
            proj.prm{n}{4}{2}(4,1:6,j) = ...
                proj.prm{n}{4}{2}(4,[5,6,7,8,3,4],j);
            proj.prm{n}{4}{2}(5,1:6,j) = ...
                proj.prm{n}{4}{2}(5,[2,1,5,8,3,4],j);
        end
        proj.prm{n}{4}{2} = ...
            proj.prm{n}{4}{2}(:,1:6,:);

    % add parameter for method "deblurr"
    elseif size(proj.prm{n}{4}{2},2)==6
        cat(2,proj.prm{n}{4}{2},zeros(size(proj.prm{n}{4}{2},1),1,...
            size(proj.prm{n}{4}{2},3)));
    end
end

% if the molecule parameter "window size" does not belong to 
% the background correction parameters
if proj.is_movie && size(proj.prm{n},2)>=3
    for l = 1:nExc
        for c = 1:nChan
            if size(proj.prm{n}{3},2)>=4 && proj.prm{n}{3}(4)>0
                proj.prm{n}{3}{3}{l,c}(proj.prm{n}{3}{3}{l,c}(:,2)'==0,2) = ...
                    proj.prm{n}{3}(4);
            elseif proj.fix{1}(2)>0
                proj.prm{n}{3}{3}{l,c}(proj.prm{n}{3}{3}{l,c}(:,2)'==0,2) = ...
                    proj.fix{1}(2);
            else
                proj.prm{n}{3}{3}{l,c}(proj.prm{n}{3}{3}{l,c}(:,2)'==0,2) = ...
                    20;
            end
            % for histothresh, the parameter should be <= 1.
            if proj.prm{n}{3}{3}{l,c}(5,1)>1
                proj.prm{n}{3}{3}{l,c}(5,1) = 0.5;
            end
            % for median, the parameter should be 1 or 2.
            if ~(proj.prm{n}{3}{3}{l,c}(7,1)==1 || ...
                    proj.prm{n}{3}{3}{l,c}(7,1)==2)
                proj.prm{n}{3}{3}{l,c}(7,1) = 2;
            end
        end
    end
    if size(proj.prm{n}{3},2)>=4
        proj.prm{n}{3}(4) = [];
    end
end

% remove impossible stoichiometry calculations (accroding to new
% stoichiometry definition)
if size(proj.prm{n},2)>=2 && ...
        size(proj.prm{n}{2}{2},1)~=(nFRET+nS+2+nExc*nChan)
    sz = size(proj.prm{n}{2}{2},1);
    diffsz = sz-(nFRET+nS+2+nExc*nChan);
    id_s = (nFRET+1):(sz-2-nExc*nChan);
    id_excl = id_s((end-diffsz+1):end);
    if ~isempty(id_excl)
        proj.prm{n}{2}{2}(id_excl,:) = []; % re-arrange photobleaching
        proj.prm{n}{4}{2}(:,:,id_excl) = []; % rearrange DTA (param)
        proj.prm{n}{4}{3}(id_excl,:) = []; % rearrange DTA (states)
        proj.prm{n}{4}{4}(:,:,id_excl) = []; % rearrange DTA (thresh)
    end
end

% recover gamma/beta correction method
if size(proj.prm{n},2)>=6 && size(proj.prm{n}{6},2)>=2 && ...
        size(proj.prm{n}{6}{2},2)<nFRET
   proj.prm{n}{6}{2} = repmat(proj.prm{n}{6}{2}(1),1,nFRET);
end
