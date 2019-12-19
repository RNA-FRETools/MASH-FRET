function p = resetSimCoord(p,h_fig)
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

% collect parameters
h = guidata(h_fig);

% save current coordinates
coord_prev = p.coord;

% resort coordinates if imported from preset file
if p.impPrm && isfield(p.molPrm,'coord')
    setContPan(cat(2,'Re-sorting coordinates imported from the preset ',...
        'file according to the new video dimensions...'),'process',h_fig);
    
    % read original coordinates from file
    [p.molPrm,errmsg] = setSimPrm(load(p.prmFile,'-mat'), p.movDim);
    if ~isempty(errmsg)
        setContPan(errmsg,'error',h_fig);
    end

    if ~isfield(p.molPrm,'coord') || (isfield(p.molPrm,'coord') && ...
            isempty(p.molPrm.coord))
        % upon import/sorting failure, default is set to random coordinates
        p.genCoord = 1;
        
    else
        if ~isempty(p.coordFile)
            % discard ASCII file if any
            p.coordFile = [];
            setContPan(cat(2,'Coordinates are now imported from the preset',...
                ' file: the coordinates file was automaticaly discarded.'),...
                'warning',h_fig);
        end
        
        % set new sample size and coordinates
        p.molNb = p.molPrm.molNb;
        p.genCoord = 0;
        p.coord = p.molPrm.coord;
        setContPan(cat(2,'Re-sorting completed!'),'success',h_fig);
    end
end

% resort coordinates if imported from ASCII file
if ~isempty(p.coordFile)
    setContPan(cat(2,'Re-sorting coordinates imported from the ASCII ',...
        'file according to the new video dimensions...'),'process',h_fig);
    
    % read original coordinates from file
    coord_0 = readCoordFromFile(p.coordFile);
    
    % set sample size
    if p.impPrm
        N = p.molNb;
    else
        N = 0;
    end
    
    % sort coordinates according to video dimensions and sample size
    [ferr,p.coord,errmsg] = sortSimCoord(coord_0, p.movDim, N);

    if isempty(p.coord)
        % show import/sorting failure messages
        setContPan(errmsg,'error',h_fig);
        
        % coordinates are from now on randomly generated
        p.genCoord = 1;
        
        if ferr
            % discard file if import error
            p.coordFile = [];
        end
    else
        % set new sample size
        p.molNb = size(p.coord,1);
        setContPan(cat(2,'Re-sorting completed!'),'success',h_fig);
    end
end

% clear coordinates if randomly generated
if p.genCoord
    p.coord = [];
end

% clear PSF factorization matrix if coordinates changed after resorting/clearing
if ~isequal(p.coord,coord_prev) || isempty(p.coord)
    p.matGauss = cell(1,4);
end

% show potentially new coordinates in table
setSimCoordTable(p, h.uitable_simCoord);

