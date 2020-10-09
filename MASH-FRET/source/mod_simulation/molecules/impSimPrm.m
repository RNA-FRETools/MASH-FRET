function impSimPrm(fname, pname, h_fig)
% Read simulation parameters from a presets file, sort coordinates according to video dimensions and adjust simulation parameters upon successful import.
%
% fname: name of presets file (with extension)
% pname: path of folder containing the presets file (ended by a slash character)
% h_fig: handle to main MASH figure

% Last update by MH, 18.12.2019: (1)remove input & output arguments "p" and "pres" and save here the changes that were done in the structure h, (2) modify input and output arguments of setSimPrm according to new definition
% update: 19.4.2019 by MH: (1) correct recovering of number of states from presets, (2) manage communication with user by including a tip in error message when loading corrupted file, and by changing error message to warning when loading emtpy file

try
    s = load([pname fname], '-mat');
catch err
    if strcmp(err.identifier,'MATLAB:load:notBinaryFile')
        setContPan(cat(2,'Parameter file for simulation must be a binary ', ...
            '*.mat file.\nUse the template located at MASH-FRET/',...
            'createSimPrm.m to create a pre-set parameter file.'),'error',...
            h_fig);
        return
    else
        throw(err);
    end
end

h = guidata(h_fig);
p = h.param.sim;

[prm,errmsg] = setSimPrm(s, p.movDim);
if ~isempty(errmsg)
    setContPan(errmsg, 'error', h_fig);
end
if isempty(prm)
    setContPan('Pre-set parameter file is empty.', 'warning', h_fig);
    return
end


% reset previous presets
resetSimPrm(h_fig);
h = guidata(h_fig);
p = h.param.sim;

p.molPrm = prm;
p.impPrm = 1;
p.prmFile = cat(2,pname,fname);
p.molNb = prm.molNb;

if isfield(prm,'nbStates')
    p.nbStates = prm.nbStates;
    
    h.param.sim = p;
    guidata(h_fig, h);
    
    updateSimStates(h_fig)
    
    h = guidata(h_fig);
    p = h.param.sim;
end

if isfield(prm, 'coord')
    % check conflict with ASCII coordinates file
    if ~isempty(prm.coord) 
        p.genCoord = 0;
        if ~isempty(p.coordFile)
            p.coordFile = [];
            setContPan(cat(2,'Coordinates are now imported from the preset',...
                ' file: the coordinates file was automaticaly discarded.'),...
                'warning',h_fig);
        end
    else
        p.genCoord = 1;
    end
    p.coord = prm.coord;
    p.matGauss = cell(1,4);
end

if isfield(prm, 'psf_width')
    p.PSF = 1;
    p.PSFw = prm.psf_width;
    p.matGauss = cell(1,4);
end

if isfield(p,'molNb')
    if p.genCoord
        coord = [];
    elseif p.impPrm && isfield(p.molPrm,'coord')
        coord = p.molPrm.coord;
    else
        coord = p.coord;
    end
    [ferr,coord,errmsg] = sortSimCoord(coord, p.movDim, p.molNb);

    if ferr || isempty(coord)
        if iscell(errmsg)
            for i = 1:numel(errmsg)
                disp(errmsg{i});
            end
        else
            disp(errmsg);
        end
        if ~ferr
            % if error is not due to file data, keep empty field 
            % 'coord' in structure to indicates that coordinates are 
            % present in file but are out of current video dimensions
            p.coord = [];
            p.genCoord = 1;
            p.matGauss = cell(1,4);
        end
    end
end

% save results
h.param.sim = p;
guidata(h_fig, h);

setContPan(cat(2,'Simulation pre-sets successfully loaded from file ',...
    fname),'success',h_fig);
