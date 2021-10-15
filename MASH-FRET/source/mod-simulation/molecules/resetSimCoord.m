function curr = resetSimCoord(curr,h_fig)
% prm = resetSimCoord(prm,h_fig)
%
% Reset PSF factor matrix and erases previous coordinates if randomly generated or re-sort coordinates according to video dimensions if imported from file.
%
% p: simulation parameter structure to be updated after coordinates reset/resort
% h_fig: handle to main MASH figure

% update by MH, 19.12.2019: (1) adjust code to new input/output structure of functions sortSimCoord (2) allow import of coordinates from ASCII file when all coordinates imported from preset file were discarded (all out-of-range)(3) maintain empty field "molPrm.coord" even if all coordinates in presets file were discarded (allows re-sorting when video dimensions change) (4) maintain ASCII file in simulation parameters even if all coordinates in ASCII file were discarded (allows re-sorting when video dimensions change) (5) show error potential messages returned by setSimPrm
% created by MH, 17.12.2019

% collect simulation parameters
N = curr.gen_dt{1}(1);
isPresets = curr.gen_dt{3}{1};
presets = curr.gen_dt{3}{2};
presetsFile = curr.gen_dt{3}{3};
coord = curr.gen_dat{1}{1}{2};
coordFile = curr.gen_dat{1}{1}{3};
viddim = curr.gen_dat{1}{2}{1};

% save current coordinates
coord_prev = coord;

% resort coordinates if imported from preset file
if isPresets && isfield(presets,'coord')
    setContPan(cat(2,'Re-sorting coordinates imported from the preset ',...
        'file according to the new video dimensions...'),'process',h_fig);
    
    % read original coordinates from file
    [presets,errmsg] = setSimPrm(load(presetsFile,'-mat'), viddim);
    if ~isempty(errmsg)
        setContPan(errmsg,'error',h_fig);
    end

    if ~isfield(presets,'coord') || (isfield(presets,'coord') && ...
            isempty(presets.coord))
        % upon import/sorting failure, default is set to random coordinates
        curr.gen_dat{1}{1}{1} = 1;
        
    else
        if ~isempty(coordFile)
            % discard ASCII file if any
            curr.gen_dat{1}{1}{3} = [];
            setContPan(cat(2,'Coordinates are now imported from the preset',...
                ' file: the coordinates file was automaticaly discarded.'),...
                'warning',h_fig);
        end
        
        % set new sample size and coordinates
        curr.gen_dt{1}(1) = presets.molNb;
        curr.gen_dat{1}{1}{1} = 0;
        curr.gen_dat{1}{1}{2} = presets.coord;
        setContPan(cat(2,'Re-sorting completed!'),'success',h_fig);
    end
end

% resort coordinates if imported from ASCII file
if ~isempty(coordFile)
    setContPan(cat(2,'Re-sorting coordinates imported from the ASCII ',...
        'file according to the new video dimensions...'),'process',h_fig);
    
    % read original coordinates from file
    coord_0 = readCoordFromFile(coordFile);
    
    % set sample size
    if isPresets
        N = curr.gen_dt{1}(1);
    else
        N = 0;
    end
    
    % sort coordinates according to video dimensions and sample size
    [ferr,curr.gen_dat{1}{1}{2},errmsg] = sortSimCoord(coord_0, viddim, N);

    if isempty(curr.gen_dat{1}{1}{2})
        % show import/sorting failure messages
        setContPan(errmsg,'error',h_fig);
        
        % coordinates are from now on randomly generated
        curr.gen_dat{1}{1}{1} = 1;
        
        if ferr
            % discard file if import error
            curr.gen_dat{1}{1}{3} = [];
        end
    else
        % set new sample size
        curr.gen_dt{1}(1) = size(curr.gen_dat{1}{1}{2},1);
        setContPan(cat(2,'Re-sorting completed!'),'success',h_fig);
    end
end

% clear coordinates if randomly generated
if curr.gen_dat{1}{1}{1}
    curr.gen_dat{1}{1}{2} = [];
end

% clear PSF factorization matrix if coordinates changed after resorting/clearing
if ~isequal(curr.gen_dat{1}{1}{2},coord_prev) || ...
        isempty(curr.gen_dat{1}{1}{2})
    curr.gen_dat{6}{3} = cell(1,4);
end

