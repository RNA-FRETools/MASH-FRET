function [p,opt] = resetMol(m, ~, p)

proj = p.curr_proj;
nC = p.proj{proj}.nb_channel;
nF = size(p.proj{proj}.FRET,1);
nS = size(p.proj{proj}.S,1);

curr = p.proj{proj}.TP.curr{m};
prm = p.proj{proj}.TP.prm{m};

% identify reset of intensity calculations using general parameters
isCrossCorr = ~isempty(p.proj{proj}.intensities_crossCorr) && ...
    ~all(any(isnan(p.proj{proj}.intensities_crossCorr(:,...
    ((m-1)*nC+1):m*nC,:)),[2,3]));
isReSpl = ~isempty(p.proj{proj}.intensities_bin) && ...
    ~all(any(isnan(p.proj{proj}.intensities_bin(:,...
    ((m-1)*nC+1):m*nC,:)),[2,3]));
isBgCorr = ~isempty(p.proj{proj}.intensities_bgCorr) && ...
    ~all(any(isnan(p.proj{proj}.intensities_bgCorr(:,...
    ((m-1)*nC+1):m*nC,:)),[2,3]));

if isempty(prm)
    opt = 'ttPr';
    p.proj{proj}.ES = cell(1,nF);
    p.proj{proj}.intensities_bgCorr(:,((m-1)*nC+1):m*nC,:) = NaN;
    
elseif ~isBgCorr || ~isequal(curr{3},prm{3})
    opt = 'ttBg';
    p.proj{proj}.ES = cell(1,nF);
    p.proj{proj}.intensities_bgCorr(:,((m-1)*nC+1):m*nC,:) = NaN;

elseif ~isReSpl
    opt = 'resample';
    p.proj{proj}.ES = cell(1,nF);
    
elseif ~isCrossCorr
    opt = 'cross';
    p.proj{proj}.ES = cell(1,nF);
    
elseif ~isequal(curr{1},prm{1})
    opt = 'denoise';
    p.proj{proj}.ES = cell(1,nF);
    p.proj{proj}.intensities_denoise(:,((m-1)*nC+1):m*nC,:) = NaN;
    
elseif ~isequal(curr{2},prm{2})
    opt = 'debleach';
    p.proj{proj}.ES = cell(1,nF);
    p.proj{proj}.intensities_DTA(:,((m-1)*nC+1):m*nC,:) = NaN;
    if nF > 0
        p.proj{proj}.FRET_DTA(:,((m-1)*nF+1):m*nF) = NaN;
    end
    if nS > 0
        p.proj{proj}.S_DTA(:,((m-1)*nS+1):m*nS) = NaN;
    end

elseif ~isequaln(curr{6}, prm{6})
    opt = 'gamma';
    p.proj{proj}.intensities_DTA(:,((m-1)*nC+1):m*nC,:) = NaN;
    if nF > 0
        p.proj{proj}.FRET_DTA(:,((m-1)*nF+1):m*nF) = NaN;
    end
    if nS > 0
        p.proj{proj}.S_DTA(:,((m-1)*nS+1):m*nS) = NaN;
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



