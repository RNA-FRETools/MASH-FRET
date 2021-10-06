function prm = resetSimCoord(prm,h_fig)
% p = resetSimCoord(p,h_fig)
%
% Reset PSF factor matrix and erases previous coordinates if randomly generated or re-sort coordinates according to video dimensions if imported from file.
%
% p: simulation parameter structure to be updated after coordinates reset/resort
% h_fig: handle to main MASH figure

% Last update by MH, 19.12.2019
% >> adjust code to new input/output structure of functions sortSimCoord
% >> allow import of coordinates from ASCII file when all coordinates
%  imported from preset file were discarded (all out-of-range)
% >> maintain empty field "molPrm.coord" even if all coordinates in presets 
%  file were discarded (allows re-sorting when video dimensions change)
% >> maintain ASCII file in simulation parameters even if all coordinates
%  in ASCII file were discarded (allows re-sorting when video dimensions change)
% >> show error potential messages returned by setSimPrm
%
% created by MH, 17.12.2019

% save current coordinates
coord_prev = prm.coord;

% resort coordinates if imported from preset file
if prm.impPrm && isfield(prm.molPrm,'coord')
    setContPan(cat(2,'Re-sorting coordinates imported from the preset ',...
        'file according to the new video dimensions...'),'process',h_fig);
    
    % read original coordinates from file
    [prm.molPrm,errmsg] = setSimPrm(load(prm.prmFile,'-mat'), prm.movDim);
    if ~isempty(errmsg)
        setContPan(errmsg,'error',h_fig);
    end

    if ~isfield(prm.molPrm,'coord') || (isfield(prm.molPrm,'coord') && ...
            isempty(prm.molPrm.coord))
        % upon import/sorting failure, default is set to random coordinates
        prm.genCoord = 1;
        
    else
        if ~isempty(prm.coordFile)
            % discard ASCII file if any
            prm.coordFile = [];
            setContPan(cat(2,'Coordinates are now imported from the preset',...
                ' file: the coordinates file was automaticaly discarded.'),...
                'warning',h_fig);
        end
        
        % set new sample size and coordinates
        prm.molNb = prm.molPrm.molNb;
        prm.genCoord = 0;
        prm.coord = prm.molPrm.coord;
        setContPan(cat(2,'Re-sorting completed!'),'success',h_fig);
    end
end

% resort coordinates if imported from ASCII file
if ~isempty(prm.coordFile)
    setContPan(cat(2,'Re-sorting coordinates imported from the ASCII ',...
        'file according to the new video dimensions...'),'process',h_fig);
    
    % read original coordinates from file
    coord_0 = readCoordFromFile(prm.coordFile);
    
    % set sample size
    if prm.impPrm
        N = prm.molNb;
    else
        N = 0;
    end
    
    % sort coordinates according to video dimensions and sample size
    [ferr,prm.coord,errmsg] = sortSimCoord(coord_0, prm.movDim, N);

    if isempty(prm.coord)
        % show import/sorting failure messages
        setContPan(errmsg,'error',h_fig);
        
        % coordinates are from now on randomly generated
        prm.genCoord = 1;
        
        if ferr
            % discard file if import error
            prm.coordFile = [];
        end
    else
        % set new sample size
        prm.molNb = size(prm.coord,1);
        setContPan(cat(2,'Re-sorting completed!'),'success',h_fig);
    end
end

% clear coordinates if randomly generated
if prm.genCoord
    prm.coord = [];
end

% clear PSF factorization matrix if coordinates changed after resorting/clearing
if ~isequal(prm.coord,coord_prev) || isempty(prm.coord)
    prm.matGauss = cell(1,4);
end

