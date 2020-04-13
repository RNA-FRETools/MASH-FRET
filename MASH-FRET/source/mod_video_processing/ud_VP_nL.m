function p = ud_VP_nL(p)
% p = ud_VP_nL(p)
%
% Adjust Video processing parameters to number of lasers
%
% p: structure to update with new parameters

% collect processing parameters
nL = p.itg_nLasers;

% adjust wavelength
if numel(p.itg_wl)<nL
    for l = (numel(p.itg_wl)+1):nL
        p.itg_wl(l) = round(p.itg_wl(l-1)*1.2);
    end
end
p.itg_wl = p.itg_wl(1:nL);

% adjust project's experimental conditions
[r,o,o] = find(strncmp(p.itg_expMolPrm(:,1),'Power(',length('Power(')));
lasPrm = cell(nL,3);
for l = 1:nL
    prmVal = [];
    if size(p.itg_expMolPrm,2)>=(r(1)+l-1)
        prmVal = p.itg_expMolPrm{r(1)+l-1,2};
    end
    lasPrm{l,1} = ['Power(' num2str(round(p.itg_wl(l))) 'nm)'];
    lasPrm{l,2} = prmVal;
    lasPrm{l,3} = 'mW';
end
defPrm = p.itg_expMolPrm(1:(r(1)-1),:);
defPrm = reshape(defPrm, [numel(defPrm)/3 3]);
addPrm = p.itg_expMolPrm((r(end)+1):end,:);
addPrm = reshape(addPrm, [numel(addPrm)/3 3]);
p.itg_expMolPrm = [defPrm;lasPrm;addPrm];

% adjust emitter-specific excitations and associated FRET/S calculations
for c = 1:size(p.chanExc,2)
    if isempty(find(p.itg_wl==p.chanExc(c),1))
        p.chanExc(c) = 0;
        % remove associated FRET calculations
        if size(p.itg_expFRET,1)>0
            p.itg_expFRET(p.itg_expFRET(:,1)==c,:) = [];
        end
        % remove associated S calculations
        if size(p.itg_expS,1)>0
            p.itg_expS(p.itg_expS(:,1)==c | p.itg_expS(:,2)==c,:) = [];
        end
    end
end
if sum(size(p.itg_expFRET)==0)
    p.itg_expFRET = [];
end
if sum(size(p.itg_expS)==0)
    p.itg_expS = [];
end

% adjust plot colors
clr_ref = getDefTrClr(nL,p.itg_wl,p.nChan,size(p.itg_expFRET,1),...
    size(p.itg_expS,1));
p.itg_clr{1} = clr_ref{1}(1:numel(p.itg_wl),:);
p.itg_clr{2} = clr_ref{2}(1:size(p.itg_expFRET,1),:);
p.itg_clr{3} = clr_ref{3}(1:size(p.itg_expS,1),:);

