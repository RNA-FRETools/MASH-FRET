function p = resetSimCoord(p,h_fig)
% p = resetSimCoord(p,h_fig)
%
% Reset PSF factor matrix and erases previous coordinates if randomly generated or re-sort coordinates according to video dimensions if imported from file.
%
% p: simulation parameter structure to be updated after coordinates reset/resort
% h_fig: handle to main MASH figure

% created by MH, 17.12.2019

h = guidata(h_fig);
p.matGauss = cell(1,4);

if p.genCoord % randomly generated
    p.coord = [];
    
elseif p.impPrm && isfield(p.molPrm,'coord') % imported from preset
    setContPan(cat(2,'Re-sorting coordinates imported from the preset ',...
        'file according to the new video dimensions...'),'process',h_fig);
    
    p.molPrm = setSimPrm(load(p.prmFile,'-mat'), p.nbStates);
    
    if ~isfield(p.molPrm,'coord')
        p.genCoord = 1;
        p.coord = [];
    else
        p.molNb = p.molPrm.molNb;
        setContPan(cat(2,'Re-sorting completed!'),'success',h_fig);
    end
    
else % imported from coordinates file
    setContPan(cat(2,'Re-sorting coordinates imported from the ASCII ',...
        'file according to the new video dimensions...'),'process',h_fig);
    
    coord_0 = readCoordFromFile(p.coordFile);
    
    if p.impPrm
        N = p.molNb;
    else
        N = 0;
    end
    
    [p.coord,errmsg] = sortSimCoord(coord_0, p.movDim, N);
    
    if isempty(p.coord)
        setContPan(errmsg,'error',h_fig);
        p.genCoord = 1;
        p.coordFile = [];
    else
        p.molNb = size(p.coord,1);
        setContPan(cat(2,'Re-sorting completed!'),'success',h_fig);
    end
end

setSimCoordTable(p, h.uitable_simCoord);

