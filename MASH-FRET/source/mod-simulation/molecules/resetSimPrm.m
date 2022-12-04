function resetSimPrm(h_fig)

% defaults
Jmax = 5; % maximum number of states allowed in GUI

% retrieve project content
h = guidata(h_fig);
p = h.param;
proj = p.curr_proj;
curr = p.proj{proj}.sim.curr;

% collect simulation parameters
J = curr.gen_dt{1}(3);
presets = curr.gen_dt{3}{2};
coordfile = curr.gen_dat{1}{1}{3};
PSFw = curr.gen_dat{6}{2};

if isfield(presets, 'nbStates')
    % adjust number of states to maximum allowed
    if J>Jmax
        curr.gen_dt{1}(3) = Jmax;
        p.proj{proj}.sim.curr = curr;
        h.param = p;
        guidata(h_fig,h);
        
        updateSimStates(h_fig);
        
        h = guidata(h_fig);
        p = h.param;
        curr = p.proj{proj}.sim.curr;
    end
end

if isfield(presets, 'coord')
    if ~(isempty(presets.coord) && ~isempty(coordfile))
        % clear coordinates and PSF factorization matrix if imported from preset file
        curr.gen_dat{1}{1}{2} = [];
        curr.gen_dat{6}{3} = cell(1,4);
        
        % set default to random coordinates
        curr.gen_dat{1}{1}{1} = 1;
    else
        % resort coordinates imported from ASCII file (sample size can increases)
        curr = resetSimCoord(curr,h_fig);
    end
end

if isfield(presets, 'psf_width')
    % keep PSF widths of the first molecule as simulation parameters
    curr.gen_dat{6}{2} = PSFw(1,:);
    % clear PSF factorization matrix
    curr.gen_dat{6}{3} = cell(1,4);
end

if isfield(presets, 'molNb')
    if ~isempty(coordfile)
        % resort coordinates imported from ASCII file (sample size can increases)
        curr = resetSimCoord(curr,h_fig);
    end
end

% reset parameters of presets file
curr.gen_dt{3}{1} = 0;
curr.gen_dt{3}{2} = [];
curr.gen_dt{3}{3} = '';

% save modifications
p.proj{proj}.sim.curr = curr;
h.param = p;
guidata(h_fig,h);

