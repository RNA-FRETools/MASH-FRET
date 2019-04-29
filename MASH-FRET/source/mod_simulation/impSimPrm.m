function p = impSimPrm(fname, pname, p, h_fig)

% Last update: 19.4.2019 by MH
% >> correct recovering of number of states from presets
% >> Manage communication with user by including a tip in error message 
%    when loading corrupted file, and by changing error message to warning 
%    when loading emtpy file

h = guidata(h_fig);
try
    s = load([pname fname], '-mat');
catch err
    if strcmp(err.identifier,'MATLAB:load:notBinaryFile')
        setContPan(cat(2,'Parameter file for simulation must be a binary ', ...
            '*.mat file.\nUse the template located at MASH-FRET/',...
            'createSimPrm.m to create a pre-set parameter file.'),'error',...
            h_fig);
        return;
    else
        throw(err);
    end
end

prm = setSimPrm(s, p.movDim);
if isempty(prm)
    setContPan('Pre-set parameter file is empty.', 'warning', h_fig);
    return;
end

p.molPrm = prm;
p.impPrm = 1;
p.prmFile = cat(2,pname,fname);
p.molNb = prm.molNb;

if isfield(prm,'nbStates')
    p.nbStates = prm.nbStates;
    for i = 1:p.nbStates
        if i > size(p.stateVal,2)
            p.stateVal(i) = p.stateVal(i-1);
            p.FRETw(i) = p.FRETw(i-1);
        end
    end
    set(h.popupmenu_states, 'Value', 1);
    set(h.edit_stateVal, 'String', num2str(p.stateVal(1)));
end

if isfield(prm, 'coord')
    p.coordFile = [];
    p.genCoord = 0;
end

if isfield(prm, 'psf_width')
    p.PSF = 1;
    p.PSFw = prm.psf_width;
end

setContPan(cat(2,'Simulation pre-sets successfully loaded from file ',...
    fname),'success',h_fig);
