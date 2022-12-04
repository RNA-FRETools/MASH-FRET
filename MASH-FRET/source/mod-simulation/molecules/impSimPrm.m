function impSimPrm(fname, pname, h_fig)
% Read simulation parameters from a presets file, sort coordinates according to video dimensions and adjust simulation parameters upon successful import.
%
% fname: name of presets file (with extension)
% pname: path of folder containing the presets file (ended by a slash character)
% h_fig: handle to main MASH figure

% Last update by MH, 18.12.2019: (1)remove input & output arguments "p" and "pres" and save here the changes that were done in the structure h, (2) modify input and output arguments of setSimPrm according to new definition
% update: 19.4.2019 by MH: (1) correct recovering of number of states from presets, (2) manage communication with user by including a tip in error message when loading corrupted file, and by changing error message to warning when loading emtpy file

% load data from file
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

% retrieve project content
h = guidata(h_fig);
p = h.param;
proj = p.curr_proj;
curr = p.proj{proj}.sim.curr;

% collect simulation parameters
viddim = curr.gen_dat{1}{2}{1};

% build presets structure
[presets,errmsg] = setSimPrm(s,viddim);
if ~isempty(errmsg)
    setContPan(errmsg, 'error', h_fig);
end
if isempty(presets)
    setContPan('Pre-set parameter file is empty.', 'warning', h_fig);
    return
end

% reset previous presets
resetSimPrm(h_fig);
h = guidata(h_fig);
p = h.param;
curr = p.proj{proj}.sim.curr;

% save new presets
curr.gen_dt{1}(1) = presets.molNb;
curr.gen_dt{3}{1} = 1;
curr.gen_dt{3}{2} = presets;
curr.gen_dt{3}{3} = cat(2,pname,fname);

if isfield(presets,'nbStates')
    curr.gen_dt{1}(3) = presets.nbStates;
    
    p.proj{proj}.sim.curr = curr;
    h.param = p;
    guidata(h_fig, h);
    
    updateSimStates(h_fig)
    
    h = guidata(h_fig);
    p = h.param;
    curr = p.proj{proj}.sim.curr;
end

% collect simulation parameters
coordFile = curr.gen_dat{1}{1}{3};

if isfield(presets, 'coord')
    % check conflict with ASCII coordinates file
    if ~isempty(presets.coord) 
        curr.gen_dat{1}{1}{1} = 0;
        if ~isempty(coordFile)
            curr.gen_dat{1}{1}{3} = [];
            setContPan(cat(2,'Coordinates are now imported from the preset',...
                ' file: the coordinates file was automaticaly discarded.'),...
                'warning',h_fig);
        end
    else
        curr.gen_dat{1}{1}{1} = 1;
    end
    curr.gen_dat{1}{1}{2} = presets.coord;
    curr.gen_dat{6}{3} = cell(1,4);
end

if isfield(presets, 'psf_width')
    curr.gen_dat{6}{1} = 1;
    curr.gen_dat{6}{2} = presets.psf_width;
    curr.gen_dat{6}{3} = cell(1,4);
end

if isfield(presets,'molNb')
    if curr.gen_dat{1}{1}{1}
        coord = [];
    elseif curr.gen_dt{3}{1} && isfield(curr.gen_dt{3}{2},'coord')
        coord = curr.gen_dt{3}{2}.coord;
    else
        coord = curr.gen_dat{1}{1}{2};
    end
    [ferr,coord,errmsg] = sortSimCoord(coord,viddim,curr.gen_dt{1}(1));

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
            curr.gen_dat{1}{1}{1} = 1;
            curr.gen_dat{1}{1}{2} = [];
            curr.gen_dat{6}{3} = cell(1,4);
        end
    end
end

% save results
p.proj{proj}.sim.curr = curr;
h.param = p;
guidata(h_fig, h);

setContPan(cat(2,'Simulation pre-sets successfully loaded from file ',...
    fname),'success',h_fig);
