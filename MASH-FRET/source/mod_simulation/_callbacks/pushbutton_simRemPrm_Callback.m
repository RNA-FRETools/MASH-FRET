function pushbutton_simRemPrm_Callback(obj, evd, h_fig)

% Last update by MH, 19.12.2019
% >> review reset of coordinates in case import is done from ASCII file
%  (only possible if coordinates from preset file could not be imported/
%  were all out-of-video range)
% >> reset PSF factor matrix only if PSF widths were imported from presets
%
% update by MH, 12.12.2019:
% >> update coordinates after removing pre-sets

% defaults
Jmax = 5; % maximum number of states allowed in GUI

% collect parameters
h = guidata(h_fig);
p = h.param.sim;

if isfield(p.molPrm, 'nbStates')
    % adjust number of states to maximum allowed
    if h.param.sim.nbStates>Jmax
        set(h.edit_nbStates,'string',num2str(Jmax));
        edit_nbStates_Callback(h.edit_nbStates,[],h_fig);
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

% reset parameters of presets file
p.molPrm = [];
p.impPrm = 0;
p.prmFile = [];

% save changes
h.param.sim = p;
guidata(h_fig, h);

% display potentially new coordinates
setSimCoordTable(h.param.sim,h.uitable_simCoord);

% set GUI to proper values
updateFields(h_fig, 'sim');
