function [p,opt] = resetMol(m, p)

proj = p.curr_proj;
nC = p.proj{proj}.nb_channel;
nF = size(p.proj{proj}.FRET,1);
nS = size(p.proj{proj}.S,1);

curr = p.proj{proj}.curr{m};
prm = p.proj{proj}.prm{m};

if isempty(prm)
    opt = 'ttPr';
    p.proj{proj}.intensities_bgCorr(:,((m-1)*nC+1):m*nC,:) = NaN;
    
elseif ~isequal(curr{3},prm{3})
    opt = 'ttBg';
    p.proj{proj}.intensities_bgCorr(:,((m-1)*nC+1):m*nC,:) = NaN;
    
elseif ~isequal(curr{5},prm{5})
    opt = 'corr';
    p.proj{proj}.intensities_crossCorr(:,((m-1)*nC+1):m*nC,:) = NaN;
    
elseif ~isequal(curr{1},prm{1})
    opt = 'denoise';
    p.proj{proj}.intensities_denoise(:,((m-1)*nC+1):m*nC,:) = NaN;
    
elseif ~isequal(curr{2},prm{2})
    opt = 'debleach';
    p.proj{proj}.intensities_DTA(:,((m-1)*nC+1):m*nC,:) = NaN;
    if nF > 0
        p.proj{proj}.FRET_DTA(:,((m-1)*nF+1):m*nF) = NaN;
    end
    if nS > 0
        p.proj{proj}.S_DTA(:,((m-1)*nS+1):m*nS) = NaN;
    end
% modified by MH, 10.1.2020: factor correction in 6th cell
% % modified by MH, 27.3.2019 (data are reset in gammaCorr.m called in updateTraces.m)
% % % added by FS, 8.1.2018 (check if anything changed in the gamma correction panel, => opt = 'gamma' for updateTraces    
% % elseif ~isequal(prm_curr{5}(3:5), prm_prev{5}(3:5))
% %     opt = 'gamma';
% %     p.proj{proj}.intensities_DTA(:,((m-1)*nC+1):m*nC,:) = NaN;
% %     p.proj{proj}.FRET_DTA(:,((m-1)*nF+1):m*nF) = NaN;
% elseif ~isequal(prm_curr{5}(3:5), prm_prev{5}(3:5))
%     opt = 'gamma';
elseif ~isequal(curr{6}, prm{6})
    opt = 'gamma';
    p.proj{proj}.intensities_DTA(:,((m-1)*nC+1):m*nC,:) = NaN;
    if nF > 0
        p.proj{proj}.FRET_DTA(:,((m-1)*nF+1):m*nF) = NaN;
    end
elseif ~(~isempty(prm{4}) && ...
        isequaln(curr{4}([1 2 4]),prm{4}([1 2 4])))
    opt = 'DTA';
    p.proj{proj}.intensities_DTA(:,((m-1)*nC+1):m*nC,:) = NaN;
    if nF > 0
        p.proj{proj}.FRET_DTA(:,((m-1)*nF+1):m*nF) = NaN;
    end
    if nS > 0
        p.proj{proj}.S_DTA(:,((m-1)*nS+1):m*nS) = NaN;
    end
else
    opt = 'plot';
end

% cancelled by MH, 11.1.2020: move to updatTrace.m
% modified by MH, 10.1.2020: add 6th cell
% p.proj{proj}.prm{m}(1:5) = prm_curr(1:5);
% p.proj{proj}.prm{m}(1:6) = curr(1:6);


