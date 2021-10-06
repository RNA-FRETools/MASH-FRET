function prm = ud_VP_nChan(prm)
% p = ud_VP_nChan(p)
%
% Adjust Video processing parameters to number of channels
%
% p: structure to update with new parameters

% collect processing parameters
nC = prm.nChan;

% update background corrections
if size(prm.movBg_p,2)<nC
    prm.movBg_p = cat(2,prm.movBg_p,...
        repmat(prm.movBg_p(:,end),[1,nC-size(prm.movBg_p,2)]));
end
prm.movBg_p = prm.movBg_p(:,1:nC);
if ~isempty(prm.bgCorr)
    if size(prm.bgCorr,2)<(nC+1)
        prm.bgCorr = cat(2,prm.bgCorr,...
            repmat(prm.bgCorr(:,end),[1,(nC+1)-size(prm.bgCorr,2)]));
    end
    prm.bgCorr = prm.bgCorr(:,1:(nC+1));
end

% update plot colors
clr = getDefTrClr(prm.itg_nLasers,prm.itg_wl,nC,size(prm.itg_expFRET,1),...
    size(prm.itg_expS,1));
if size(prm.itg_clr{1},2)<nC
    prm.itg_clr{1} = cat(2,prm.itg_clr{1},clr{1}(:,(size(prm.itg_clr{1},2)+1):end));
end

% update default emitter labels
if size(prm.labels_def,2)<nC
    for c = (size(prm.labels_def,2)+1):nC
        prm.labels_def{c} = sprintf('Cy%i', (2*c+1));
    end
end
prm.labels = prm.labels_def(1:nC);

% update channel-specific excitations
if size(prm.chanExc,2)<nC
    for c = (size(prm.chanExc,2)+1):nC
        if c > size(prm.chanExc,2)
            if c <= prm.itg_nLasers
                prm.chanExc(c) = prm.itg_wl(c);
            else
                prm.chanExc(c) = 0;
            end
        end
    end
end
prm.chanExc = prm.chanExc(1:nC);

% remove ill-defined FRET and stoichiometry calculations
[excl,o,o] = find(prm.itg_expFRET>nC);
prm.itg_expFRET(excl,:) = [];
[excl,o,o] = find(prm.itg_expS>nC);
prm.itg_expS(excl,:) = [];

% adjust spot finder parameters
if size(prm.SF_minI,2)<nC
    nadd = nC-size(prm.SF_minI,2);
    prm.SF_minI = cat(2,prm.SF_minI,repmat(prm.SF_minI(end),[1,nadd]));
    prm.SF_intThresh = cat(2,prm.SF_intThresh,...
        repmat(prm.SF_intThresh(end),[1,nadd]));
    prm.SF_intRatio = cat(2,prm.SF_intRatio,...
        repmat(prm.SF_intRatio(end),[1,nadd]));
    prm.SF_w = cat(2,prm.SF_w,repmat(prm.SF_w(end),[1,nadd]));
    prm.SF_h = cat(2,prm.SF_h,repmat(prm.SF_h(end),[1,nadd]));
    prm.SF_darkW = cat(2,prm.SF_darkW,repmat(prm.SF_darkW(end),[1,nadd]));
    prm.SF_darkH = cat(2,prm.SF_darkH,repmat(prm.SF_darkH(end),[1,nadd]));
    prm.SF_maxN = cat(2,prm.SF_maxN,repmat(prm.SF_maxN(end),[1,nadd]));
    prm.SF_minHWHM = cat(2,prm.SF_minHWHM,repmat(prm.SF_minHWHM(end),[1,nadd]));
    prm.SF_maxHWHM = cat(2,prm.SF_maxHWHM,repmat(prm.SF_maxHWHM(end),[1,nadd]));
    prm.SF_maxAssy = cat(2,prm.SF_maxAssy,repmat(prm.SF_maxAssy(end),[1,nadd]));
    prm.SF_minDspot = cat(2,prm.SF_minDspot,...
        repmat(prm.SF_minDspot(end),[1,nadd]));
    prm.SF_minDedge = cat(2,prm.SF_minDedge,...
        repmat(prm.SF_minDedge(end),[1,nadd]));
end

% adjust coordinates transformation parameters
if size(prm.trsf_refImp_rw{1},1)<nC
    for c = (size(prm.trsf_refImp_rw{1},1)+1):nC
        prm.trsf_refImp_rw{1}(c,1) = prm.trsf_refImp_rw{1}(c-1,1) + ...
            prm.trsf_refImp_rw{1}(c-1,2) - 1;
        prm.trsf_refImp_rw{1}(c,3) = nC;
        prm.trsf_refImp_cw{1}(c,1:2) = prm.trsf_refImp_cw{1}(c-1,1:2) + 2;
    end
end

% adjust intensity integration import parameters
if size(prm.itg_impMolPrm{1},1)<nC
    for c = 1:nC
        if c>size(prm.itg_impMolPrm{1},1)
            prm.itg_impMolPrm{1} = ...
                cat(1,prm.itg_impMolPrm{1},prm.itg_impMolPrm{1}(end,1:2)+2);
        end
    end
end

% reset spot finder results
prm.SFres = {};

% set spotfinder parameters
for i = 1:prm.nChan
    if size(prm.SFprm,2)<(i+1)
        prm.SFprm = cat(2,prm.SFprm,[prm.SF_w(i),prm.SF_h(i); prm.SF_darkW(i),...
            prm.SF_darkH(i); prm.SF_intThresh(i),prm.SF_intRatio(i)]);
    end
end
prm.SFprm = prm.SFprm(1,1:(prm.nChan+1));
    