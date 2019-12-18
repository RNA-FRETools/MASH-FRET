function impSimCoord(fname, pname, h_fig)
% Read molecule coordinates from an ASCII file, sort coordinates according to video dimensions and adjust simulation parameters upon successful import.
%
% fname: name of coordinates file (with extension)
% pname: path of folder containing the coordinates file (ended by a slash character)
% h_fig: handle to main MASH figure
%
% Requires external functions: setContPan, readCoordFromFile, sortSimCoord

% Last update by MH, 17.12.2019
% >> move scripts that (1) read coordinates from ASCII file, and (2) sort
%  coordinates to separate funcions (1) readCoordFromFile.m and (2)
%  sortSimCoord.m: this allows calls from external function resetSimCoord.m
% >> remove input & output argument "p" and save here the changes that were 
%  done in the structure h
%
% update: 22nd of May 2014 by Mélodie C.A.S. Hadzic

h = guidata(h_fig);
p = h.param.sim;

% check conflict with preset file
if p.impPrm && isfield(p.molPrm,'coord')
    setContPan(cat(2,'Coordinates are already imported from a preset ',...
        'file: to remove the preset file, press the correpsonding "rem." ',...
        'button.'), 'error', h_fig);
    return;
end

coord = readCoordFromFile([pname fname]);

if isempty(coord)
    setContPan('Unable to import coordinates.', 'error', h_fig);
    return
end

if p.impPrm
    N = p.molNb;
else
    N = 0;
end

[coord,errmsg] = sortSimCoord(coord,p.movDim,N);

if ~isempty(coord)
    p.coord = coord;
    p.molNb = size(coord,1);
    p.coordFile = [pname fname];
    p.genCoord = 0;
    p.matGauss = cell(1,4);
    
    h.param.sim = p;
    guidata(h_fig,h);
    
    setContPan('Coordinates successfully imported!','success',h_fig);
    
else
    setContPan(errmsg,'error',h_fig);
end

