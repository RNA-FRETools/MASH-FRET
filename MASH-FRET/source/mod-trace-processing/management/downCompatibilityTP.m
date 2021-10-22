function p_proj = downCompatibilityTP(p_proj,n)
% Re-adjusts molecule and general parameters of old projects in order to be in accordance with current MASH version
%
% proj = downCompatibilityTP(proj,n)
% 
% proj: h.param.ttPr.proj{i), with h the structure saved in main figure's handle and i the project index in the project list
% n: molecule index in the project

% Last update 23.12.2020 by MH: add vbFRET 2D
% update 13.1.2020 by MH: manage down compatibility by moving cross-talks coefficients to general parameters
% update 10.1.2020 by MH: manage down compatibility by moving factor correction in 6th cell and adding default parameters for ES regression
% update 29.3.2019 by MH: manage down-compatibility and adapt reorganization of cross-talk coefficients to new parameter structure (see project/setDefPrm_traces.m)

nChan = p_proj.nb_channel;
exc = p_proj.excitations;
nExc = p_proj.nb_excitations;
chanExc = p_proj.chanExc;
nFRET = size(p_proj.FRET,1);
nS = size(p_proj.S,1);

% added by MH, 29.3.2019 reorder already-existing Bt coefficient values 
% into new format: sum Bt coefficients over the different excitations and 
% use as only Bt coefficients.
if size(p_proj.TP.prm{n},2)>=5 && size(p_proj.TP.prm{n}{5},2)>=2 && ...
        iscell(p_proj.TP.prm{n}{5}{1})
    newBtPrm = zeros(nChan,nChan-1);
    for c = 1:nChan
        bts = zeros(nExc,nChan-1);
        for l = 1:nExc
            bts(l,:) = p_proj.TP.prm{n}{5}{1}{l,c};
        end
        newBtPrm(c,:) = sum(bts,1);
    end
    p_proj.TP.prm{n}{5}{1} = newBtPrm;
end

% added by MH, 29.3.2019
% reorder already-existing DE coefficient values into new format: use the 
% first non-zero DE coefficient as only DE coefficient.
if size(p_proj.TP.prm{n},2)>=5 && size(p_proj.TP.prm{n}{5},2)>=2 && ...
        iscell(p_proj.TP.prm{n}{5}{2})
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
                val = find(p_proj.TP.prm{n}{5}{2}{l,c}~=0);
                if isempty(val)
                    newDePrm(exc_dir,c) = 0;
                else
                    newDePrm(exc_dir,c) = ...
                        p_proj.TP.prm{n}{5}{2}{l,c}(val(1));
                end
            end
        end
    end
    p_proj.TP.prm{n}{5}{2} = newDePrm;
end

% added by MH, 4.4.2020
% move gamma factors to 6th cell and cross-talks to general parameters
if size(p_proj.TP.prm{n},2)>=5 && size(p_proj.TP.prm{n}{5},2)>=3
    p_proj.TP.prm{n}{6}{1} = p_proj.TP.prm{n}{5}{3};
    p_proj.TP.prm{n}{6}{2} = 0;
    p_proj.TP.prm{n}{6}{3} = p_proj.TP.def.mol{6}{3};
    p_proj.TP.prm{n}{6}{4} = p_proj.TP.def.mol{6}{4};
    if n==1
        p_proj.TP.fix{4} = p_proj.TP.prm{n}{5}(1:2);
    end
    p_proj.TP.prm{n}{5} = [];
end

% added by MH, 10.1.2020: move cross-talks to general parameters, move 
% factor corrections in 6th cell and add default parameters for ES 
% regression
if size(p_proj.TP.prm{n},2)==5 && size(p_proj.TP.prm{n}{5},2)==5
    factPrm =[p_proj.TP.prm{n}{5}(3:end),p_proj.TP.def.mol{6}{4}];
    p_proj.TP.prm{n} = cat(2,p_proj.TP.prm{n},{factPrm});
    if n==1
        p_proj.TP.fix{4} = p_proj.TP.prm{n}{5}(1:2);
    end
    p_proj.TP.prm{n}{5} = [];
end

if size(p_proj.TP.prm{n},2)>=6 
    % added by MH, 13.1.2020: down compatibility by adding beta factors
    if size(p_proj.TP.prm{n}{6},2)>=1 && size(p_proj.TP.prm{n}{6}{1},1)==1
        p_proj.TP.prm{n}{6}{1} = cat(1,p_proj.TP.prm{n}{6}{1},...
            ones(1,size(p_proj.TP.prm{n}{6}{1},2)));
    end
    
    % added by MH, 14.1.2020: recover gamma/beta correction method
    if size(p_proj.TP.prm{n}{6},2)>=2 && ...
            size(p_proj.TP.prm{n}{6}{2},2)<nFRET
        p_proj.TP.prm{n}{6}{2} = ...
            repmat(p_proj.TP.prm{n}{6}{2}(1),1,nFRET);
    end
    
    % added by MH, 15.1.2020: recover param for photobleaching-based gamma 
    % calculation, change "show cuttoff" to default laser for pb detection 
    % and insert default tolerance (= 3)
    if size(p_proj.TP.prm{n}{6},2)>=3 && ...
            size(p_proj.TP.prm{n}{6}{3},2)>0 && ...
            size(p_proj.TP.prm{n}{6}{3},2)<8
        ldon = ones(nFRET,1);
        for i = 1:nFRET
            ldon(i,1) = find(exc==chanExc(p_proj.FRET(i,1)));
        end
        p_proj.TP.prm{n}{6}{3} = [ldon,p_proj.TP.prm{n}{6}{3}(:,2:5),...
            3*ones(nFRET,1),p_proj.TP.prm{n}{6}{3}(:,6:end)];
    end
end

% state sequences were previously calculated
if size(p_proj.TP.prm{n},2)>=4 && size(p_proj.TP.prm{n}{4},2)>=2

    % reshape old format
    if size(p_proj.TP.prm{n}{4}{2},2)==8
        for j = 1:size(p_proj.TP.prm{n}{4}{2},3)
            p_proj.TP.prm{n}{4}{2}(1,1:6,j) = ...
                p_proj.TP.prm{n}{4}{2}(1,[2,1,5,8,3,4],j);
            p_proj.TP.prm{n}{4}{2}(2,1:6,j) = ...
                p_proj.TP.prm{n}{4}{2}(2,[1,2,5,8,3,4],j);
            p_proj.TP.prm{n}{4}{2}(3,1:6,j) = ...
                p_proj.TP.prm{n}{4}{2}(3,[1,2,5,8,3,4],j);
            p_proj.TP.prm{n}{4}{2}(4,1:6,j) = ...
                p_proj.TP.prm{n}{4}{2}(4,[5,6,7,8,3,4],j);
            p_proj.TP.prm{n}{4}{2}(5,1:6,j) = ...
                p_proj.TP.prm{n}{4}{2}(5,[2,1,5,8,3,4],j);
        end
        p_proj.TP.prm{n}{4}{2} = ...
            p_proj.TP.prm{n}{4}{2}(:,1:6,:);
    end

    % add parameter for method "deblurr"
    if size(p_proj.TP.prm{n}{4}{2},2)==6
        p_proj.TP.prm{n}{4}{2} = cat(2,p_proj.TP.prm{n}{4}{2},zeros(...
            size(p_proj.TP.prm{n}{4}{2},1),1,...
            size(p_proj.TP.prm{n}{4}{2},3)));
    end
end

% if the molecule parameter "window size" does not belong to 
% the background correction parameters
if p_proj.is_movie && size(p_proj.TP.prm{n},2)>=3
    for l = 1:nExc
        for c = 1:nChan
            if size(p_proj.TP.prm{n}{3},2)>=4 && p_proj.TP.prm{n}{3}(4)>0
                p_proj.TP.prm{n}{3}{3}{l,c}(...
                    p_proj.TP.prm{n}{3}{3}{l,c}(:,2)'==0,2) = ...
                    p_proj.TP.prm{n}{3}(4);
            elseif p_proj.TP.fix{1}(2)>0
                p_proj.TP.prm{n}{3}{3}{l,c}(...
                    p_proj.TP.prm{n}{3}{3}{l,c}(:,2)'==0,2) = ...
                    p_proj.TP.fix{1}(2);
            else
                p_proj.TP.prm{n}{3}{3}{l,c}(...
                    p_proj.TP.prm{n}{3}{3}{l,c}(:,2)'==0,2) = 20;
            end
            % for histothresh, the parameter should be <= 1.
            if p_proj.TP.prm{n}{3}{3}{l,c}(5,1)>1
                p_proj.TP.prm{n}{3}{3}{l,c}(5,1) = 0.5;
            end
            % for median, the parameter should be 1 or 2.
            if ~(p_proj.TP.prm{n}{3}{3}{l,c}(7,1)==1 || ...
                    p_proj.TP.prm{n}{3}{3}{l,c}(7,1)==2)
                p_proj.TP.prm{n}{3}{3}{l,c}(7,1) = 2;
            end
        end
    end
    if size(p_proj.TP.prm{n}{3},2)>=4
        p_proj.TP.prm{n}{3}(4) = [];
    end
end

% remove impossible stoichiometry calculations (accroding to new
% stoichiometry definition)
if size(p_proj.TP.prm{n},2)>=2 && ...
        size(p_proj.TP.prm{n}{2}{2},1)~=(nFRET+nS+2+nExc*nChan)
    sz = size(p_proj.TP.prm{n}{2}{2},1);
    diffsz = sz-(nFRET+nS+2+nExc*nChan);
    id_s = (nFRET+1):(sz-2-nExc*nChan);
    id_excl = id_s((end-diffsz+1):end);
    if ~isempty(id_excl)
        p_proj.TP.prm{n}{2}{2}(id_excl,:) = []; % re-arrange photobleaching
        p_proj.TP.prm{n}{4}{2}(:,:,id_excl) = []; % rearrange DTA (param)
        p_proj.TP.prm{n}{4}{3}(id_excl,:) = []; % rearrange DTA (states)
        p_proj.TP.prm{n}{4}{4}(:,:,id_excl) = []; % rearrange DTA (thresh)
    end
end

% added by MH, 23.12.2020: add method vbFRET 2D
if size(p_proj.TP.prm{n},2)>=4 && size(p_proj.TP.prm{n}{4},2)>=2 && ...
        size(p_proj.TP.prm{n}{4}{2},1)<6
    if p_proj.TP.prm{n}{4}{1}(1)>2
        p_proj.TP.prm{n}{4}{1}(1) = p_proj.TP.prm{n}{4}{1}(1) + 1;
    end
    p_proj.TP.prm{n}{4}{2} = [p_proj.TP.prm{n}{4}{2}(1:2,:,:);...
        repmat([1,2,5,2,0,0,1],[1,1,size(p_proj.TP.prm{n}{4}{2},3)]);...
        p_proj.TP.prm{n}{4}{2}(3:end,:,:)];
end


