function prm = ud_VP_nL(prm)
% p = ud_VP_nL(p)
%
% Adjust Video processing parameters to number of lasers
%
% p: structure to update with new parameters

% collect processing parameters
nL = prm.itg_nLasers;

% adjust wavelength
if numel(prm.itg_wl)<nL
    for l = (numel(prm.itg_wl)+1):nL
        prm.itg_wl(l) = round(prm.itg_wl(l-1)*1.2);
    end
end
prm.itg_wl = prm.itg_wl(1:nL);

% adjust project's experimental conditions
[r,o,o] = find(strncmp(prm.itg_expMolPrm(:,1),'Power(',length('Power(')));
lasPrm = cell(nL,3);
for l = 1:nL
    prmVal = [];
    if size(prm.itg_expMolPrm,2)>=(r(1)+l-1)
        prmVal = prm.itg_expMolPrm{r(1)+l-1,2};
    end
    lasPrm{l,1} = ['Power(' num2str(round(prm.itg_wl(l))) 'nm)'];
    lasPrm{l,2} = prmVal;
    lasPrm{l,3} = 'mW';
end
defPrm = prm.itg_expMolPrm(1:(r(1)-1),:);
defPrm = reshape(defPrm, [numel(defPrm)/3 3]);
addPrm = prm.itg_expMolPrm((r(end)+1):end,:);
addPrm = reshape(addPrm, [numel(addPrm)/3 3]);
prm.itg_expMolPrm = [defPrm;lasPrm;addPrm];

% adjust emitter-specific excitations and associated FRET/S calculations
for c = 1:size(prm.chanExc,2)
    if isempty(find(prm.itg_wl==prm.chanExc(c),1))
        prm.chanExc(c) = 0;
        % remove associated FRET calculations
        if size(prm.itg_expFRET,1)>0
            prm.itg_expFRET(prm.itg_expFRET(:,1)==c,:) = [];
        end
        % remove associated S calculations
        if size(prm.itg_expS,1)>0
            prm.itg_expS(prm.itg_expS(:,1)==c | prm.itg_expS(:,2)==c,:) = [];
        end
    end
end
if sum(size(prm.itg_expFRET)==0)
    prm.itg_expFRET = [];
end
if sum(size(prm.itg_expS)==0)
    prm.itg_expS = [];
end

% adjust plot colors
clr_ref = getDefTrClr(nL,prm.itg_wl,prm.nChan,size(prm.itg_expFRET,1),...
    size(prm.itg_expS,1));
prm.itg_clr{1} = clr_ref{1}(1:numel(prm.itg_wl),:);
prm.itg_clr{2} = clr_ref{2}(1:size(prm.itg_expFRET,1),:);
prm.itg_clr{3} = clr_ref{3}(1:size(prm.itg_expS,1),:);

