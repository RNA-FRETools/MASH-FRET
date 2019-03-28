function [p,opt] = resetMol(m, p)

proj = p.curr_proj;
nC = p.proj{proj}.nb_channel;
nF = size(p.proj{proj}.FRET,1);
nS = size(p.proj{proj}.S,1);

prm_curr = p.proj{proj}.curr{m};
prm_prev = p.proj{proj}.prm{m};

if isempty(prm_prev)
    opt = 'ttPr';
    p.proj{proj}.intensities_bgCorr(:,((m-1)*nC+1):m*nC,:) = NaN;
    
elseif ~isequal(prm_curr{3}, prm_prev{3})
    opt = 'ttBg';
    p.proj{proj}.intensities_bgCorr(:,((m-1)*nC+1):m*nC,:) = NaN;
    
elseif ~isequal(prm_curr{5}([1,2]), prm_prev{5}([1,2]))
    opt = 'corr';
    p.proj{proj}.intensities_crossCorr(:,((m-1)*nC+1):m*nC,:) = NaN;
    
elseif ~isequal(prm_curr{1}, prm_prev{1})
    opt = 'denoise';
    p.proj{proj}.intensities_denoise(:,((m-1)*nC+1):m*nC,:) = NaN;
    
elseif ~isequal(prm_curr{2}, prm_prev{2})
    opt = 'debleach';
    p.proj{proj}.intensities_DTA(:,((m-1)*nC+1):m*nC,:) = NaN;
    if nF > 0
        p.proj{proj}.FRET_DTA(:,((m-1)*nF+1):m*nF) = NaN;
    end
    if nS > 0
        p.proj{proj}.S_DTA(:,((m-1)*nS+1):m*nS) = NaN;
    end
    
elseif ~(~isempty(prm_prev{4}) && ...
        isequaln(prm_curr{4}([1 2 4]), prm_prev{4}([1 2 4])))
    opt = 'DTA';
    p.proj{proj}.intensities_DTA(:,((m-1)*nC+1):m*nC,:) = NaN;
    if nF > 0
        p.proj{proj}.FRET_DTA(:,((m-1)*nF+1):m*nF) = NaN;
    end
    if nS > 0
        p.proj{proj}.S_DTA(:,((m-1)*nS+1):m*nS) = NaN;
    end

% added by FS, 8.1.2018 (check if anything changed in the gamma correction panel, => opt = 'gamma' for updateTraces    
elseif ~isequal(prm_curr{5}(3:5), prm_prev{5}(3:5))
    opt = 'gamma';
    % edit by MH, 27.3.2019 (data are reset in gammaCorr.m called in
    % updateTraces.m)
%     p.proj{proj}.intensities_DTA(:,((m-1)*nC+1):m*nC,:) = NaN;
%     p.proj{proj}.FRET_DTA(:,((m-1)*nF+1):m*nF) = NaN;
else
    opt = 'plot';
end

p.proj{proj}.prm{m}(1:5) = prm_curr(1:5);


