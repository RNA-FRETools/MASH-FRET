function resetSimPrm(h_fig)

% defaults
Jmax = 5; % maximum number of states allowed in GUI

h = guidata(h_fig);
p = h.param.sim;

if isfield(p.molPrm, 'nbStates')
    % adjust number of states to maximum allowed
    if p.nbStates>Jmax
        
        p.nbStates = Jmax;
        
        h.param.sim = p;
        guidata(h_fig,h);
        
        updateSimStates(h_fig);
        
        h = guidata(h_fig);
        p = h.param.sim;
    end
end

if isfield(p.molPrm, 'coord')
    if ~(isempty(p.molPrm.coord) && ~isempty(p.coordFile))
        % clear coordinates and PSF factorization matrix if imported from preset file
        p.coord = [];
        p.matGauss = cell(1,4);
        
        % set default to random coordinates
        p.genCoord = 1;
    else
        % resort coordinates imported from ASCII file (sample size can increases)
        p = resetSimCoord(p,h_fig);
    end
end

if isfield(p.molPrm, 'psf_width')
    % keep PSF widths of the first molecule as simulation parameters
    p.PSFw = p.PSFw(1,:);
    % clear PSF factorization matrix
    p.matGauss = cell(1,4);
end

if isfield(p.molPrm, 'molNb')
    if ~isempty(p.coordFile)
        % resort coordinates imported from ASCII file (sample size can increases)
        p = resetSimCoord(p,h_fig);
    end
end

% reset parameters of presets file
p.molPrm = [];
p.impPrm = 0;
p.prmFile = [];

% save modifications
h.param.sim = p;
guidata(h_fig,h);

