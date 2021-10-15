function impSimCoord(fname, pname, h_fig)
% Read molecule coordinates from an ASCII file, sort coordinates according to video dimensions and adjust simulation parameters upon successful import.
%
% fname: name of coordinates file (with extension)
% pname: path of folder containing the coordinates file (ended by a slash character)
% h_fig: handle to main MASH figure
%
% Requires external functions: setContPan, readCoordFromFile, sortSimCoord

% update by MH, 19.12.2019: (1) adjust code to new input/output structure of functions sortSimCoord (2) allow import of coordinates from ASCII file when all coordinates imported from preset file were discarded (all out-of-range) (3) maintain ASCII file in simulation parameters even if all coordinates were discarded (allows re-sorting when video dimensions change)
% update by MH, 17.12.2019: (1) move scripts that 1) read coordinates from ASCII file, and 2) sort coordinates to separate funcions 1) readCoordFromFile.m and 2) sortSimCoord.m: this allows calls from external function resetSimCoord.m (2) remove input & output argument "p" and save here the changes that were done in the structure h
% update by MH, 22.5.2014 

% retrieve project content
h = guidata(h_fig);
p = h.param;
curr = p.proj{p.curr_proj}.sim.curr;

% collect simulation parameters
isPresets = curr.gen_dt{3}{1};
presets = curr.gen_dt{3}{2};
N = curr.gen_dt{1}(1);
viddim = curr.gen_dat{1}{2}{1};

% check conflict with preset file
if isPresets && isfield(presets,'coord') && ~isempty(presets.coord)
    setContPan(cat(2,'Coordinates are already imported from a preset ',...
        'file: to remove the preset file, press the correpsonding "rem." ',...
        'button.'), 'error', h_fig);
    return
end

% read coordinates from file
coord = readCoordFromFile([pname fname]);
if isempty(coord)
    setContPan('Unable to import coordinates.', 'error', h_fig);
    return
end

% get sample size
if ~isPresets
    N = 0;
end

% sort coordinates according to video dimensions and sample size
[ferr,coord,errmsg] = sortSimCoord(coord,viddim,N);

if ferr || isempty(coord)
    setContPan(errmsg,'error',h_fig);
    if ~ferr
        % if error is **not** due to file data, keep file in field 
        % 'coordFile' to indicate that coordinates are present in file but 
        % are out of current video dimensions
        curr.gen_dat{1}{1}{3} = [pname fname];
    end
else
    curr.gen_dat{1}{1}{1} = 0;
    curr.gen_dat{1}{1}{3} = [pname fname];
    curr.gen_dat{1}{1}{2} = coord;
    curr.gen_dat{6}{3} = cell(1,4);
    if ~isPresets
        curr.gen_dt{1}(1) = size(coord,1);
    end

    setContPan('Coordinates successfully imported!','success',h_fig);
end

% save modifications
p.proj{p.curr_proj}.sim.curr = curr;
h.param = p;
guidata(h_fig,h);

