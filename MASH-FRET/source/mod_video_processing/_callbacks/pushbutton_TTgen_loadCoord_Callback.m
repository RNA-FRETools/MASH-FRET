function pushbutton_TTgen_loadCoord_Callback(obj, evd, h_fig)
% pushbutton_TTgen_loadCoord_Callback([], [], h_fig)
% pushbutton_TTgen_loadCoord_Callback(coordfile, [], h_fig)
%
% h_fig: handle to main figure
% coordfile: {1-by-2} source folder and source file containing coordinates used in intensity integration

% Last update by MH, 28.3.2019: (1) Fix error when calling orgCoordCol.m with too few input arguments (2) Remove action "Unable to import coordinates" to avoid double action with orgCoordCol

% get interface parameters
h = guidata(h_fig);
p = h.param.movPr;

if ~isfield(h,'movie')
    setContPan(['The access to the video dimensions is needed: please ',...
        'load the corresponding video first.'],'error',h_fig);
    return
end

% get coordinates file
if iscell(obj)
    pname = obj{1};
    fname = obj{2};
    if ~strcmp(pname(end),filesep)
        pname = [pname,filesep];
    end
else
    [fname,pname,o] = uigetfile({...
        '*.coord;*.spots;*.map','Coordinates File(*.coord;*.spots;*.map)'; ...
        '*.*', 'All Files (*.*)'},'Select a coordinates file', ...
        setCorrectPath('coordinates', h_fig));
end
if ~sum(fname)
    return
end
cd(pname);

% import coordinates form file
setContPan('Load coordinates ...','process',h_fig);
fDat = importdata([pname fname], '\n');

% organize coordinates in a column-wise fashion
coord_itg = orgCoordCol(fDat, 'cw', p.itg_impMolPrm, p.nChan, ...
    h.movie.pixelX, h_fig);
if isempty(coord_itg) || size(coord_itg, 2)~=(2*p.nChan)
    return
end

% set coordinates and file for intensity integration
p.coordItg = coord_itg;
p.coordItg_file = fname;
p.itg_coordFullPth = [pname fname];
p.coord2plot = 5;

% save modifications
h.param.movPr = p;
guidata(h_fig, h);

% set GUI to proper values and refresh plot
updateFields(h_fig,'imgAxes');

% show action
setContPan(cat(2,'Coordinates were successfully imported from file: ',...
    pname,fname),'success',h_fig);

