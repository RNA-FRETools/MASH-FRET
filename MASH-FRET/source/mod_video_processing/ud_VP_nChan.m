function p = ud_VP_nChan(p)
% p = ud_VP_nChan(p)
%
% Adjust Video processing parameters to number of channels
%
% p: structure to update with new parameters

% collect processing parameters
nC = p.nChan;

% update background corrections
if size(p.movBg_p,2)<nC
    p.movBg_p = cat(2,p.movBg_p,...
        repmat(p.movBg_p(:,end),[1,nC-size(p.movBg_p,2)]));
end
p.movBg_p = p.movBg_p(:,1:nC);

% update plot colors
clr = getDefTrClr(p.itg_nLasers,p.itg_wl,nC,size(p.itg_expFRET,1),...
    size(p.itg_expS,1));
if size(p.itg_clr{1},2)<nC
    p.itg_clr{1} = cat(2,p.itg_clr{1},clr{1}(:,(size(p.itg_clr{1},2)+1):end));
end

% update default emitter labels
if size(p.labels_def,2)<nC
    for c = (size(p.labels_def,2)+1):nC
        p.labels_def{c} = sprintf('Cy%i', (2*c+1));
    end
end
p.labels = p.labels_def(1:nC);

% update channel-specific excitations
if size(p.chanExc,2)<nC
    for c = (size(p.chanExc,2)+1):nC
        if c > size(p.chanExc,2)
            if c <= p.itg_nLasers
                p.chanExc(c) = p.itg_wl(c);
            else
                p.chanExc(c) = 0;
            end
        end
    end
end
p.chanExc = p.chanExc(1:nC);

% remove ill-defined FRET and stoichiometry calculations
[excl,o,o] = find(p.itg_expFRET>nC);
p.itg_expFRET(excl,:) = [];
[excl,o,o] = find(p.itg_expS>nC);
p.itg_expS(excl,:) = [];

% adjust spot finder parameters
if size(p.SF_minI,2)<nC
    nadd = nC-size(p.SF_minI,2);
    p.SF_minI = cat(2,p.SF_minI,repmat(p.SF_minI(end),[1,nadd]));
    p.SF_intThresh = cat(2,p.SF_intThresh,...
        repmat(p.SF_intThresh(end),[1,nadd]));
    p.SF_intRatio = cat(2,p.SF_intRatio,...
        repmat(p.SF_intRatio(end),[1,nadd]));
    p.SF_w = cat(2,p.SF_w,repmat(p.SF_w(end),[1,nadd]));
    p.SF_h = cat(2,p.SF_h,repmat(p.SF_h(end),[1,nadd]));
    p.SF_darkW = cat(2,p.SF_darkW,repmat(p.SF_darkW(end),[1,nadd]));
    p.SF_darkH = cat(2,p.SF_darkH,repmat(p.SF_darkH(end),[1,nadd]));
    p.SF_maxN = cat(2,p.SF_maxN,repmat(p.SF_maxN(end),[1,nadd]));
    p.SF_minHWHM = cat(2,p.SF_minHWHM,repmat(p.SF_minHWHM(end),[1,nadd]));
    p.SF_maxHWHM = cat(2,p.SF_maxHWHM,repmat(p.SF_maxHWHM(end),[1,nadd]));
    p.SF_maxAssy = cat(2,p.SF_maxAssy,repmat(p.SF_maxAssy(end),[1,nadd]));
    p.SF_minDspot = cat(2,p.SF_minDspot,...
        repmat(p.SF_minDspot(end),[1,nadd]));
    p.SF_minDedge = cat(2,p.SF_minDedge,...
        repmat(p.SF_minDedge(end),[1,nadd]));
end

% adjust coordinates transformation parameters
if size(p.trsf_refImp_rw{1},1)<nC
    for c = (size(p.trsf_refImp_rw{1},1)+1):nC
        p.trsf_refImp_rw{1}(c,1) = p.trsf_refImp_rw{1}(c-1,1) + ...
            p.trsf_refImp_rw{1}(c-1,2) - 1;
        p.trsf_refImp_rw{1}(c,3) = nC;
        p.trsf_refImp_cw{1}(c,1:2) = p.trsf_refImp_cw{1}(c-1,1:2) + 2;
    end
end

% adjust intensity integration import parameters
if size(p.itg_impMolPrm{1},1)<nC
    for c = 1:nC
        if c>size(p.itg_impMolPrm{1},1)
            p.itg_impMolPrm{1}(c,1:2) = p.itg_impMolPrm{1}(c-1,1:2) + 2;
        end
    end
end

% reset spot finder results
p.SFres = {};
    