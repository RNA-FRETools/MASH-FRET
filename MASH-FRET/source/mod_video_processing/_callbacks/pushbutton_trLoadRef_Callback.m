function pushbutton_trLoadRef_Callback(obj, evd, h_fig)

% collect interface parameters
h = guidata(h_fig);
p = h.param.movPr;

if p.nChan<=1 || p.nChan>3
    updateActPan(['This functionality is available for 2 or 3 channels ',...
        'only.'], h_fig, 'error');
    return
end

% get reference coordinates file
[fname, pname, o] = uigetfile(...
    {'*.map;*.cpSelect','Coordinates File(*.map;*.cpSelect)'; ...
     '*.*',  'All Files (*.*)'}, 'Pick a co-localized coordinates file', ...
     setCorrectPath('mapping', h_fig));
if ~sum(fname)
    return
end
cd(pname);

% import coordinates
fDat = importdata([pname fname], '\n');
if isstruct(fDat)
    fDat = fDat.Sheet1;
end

% organize coordinate sin a column-wise fashion
res_x = p.trsf_coordLim(1);
mode = p.trsf_refImp_mode;
switch mode
    case 'rw'
        prm = p.trsf_refImp_rw;
    case 'cw'
        prm = p.trsf_refImp_cw;
end
coord_ref = orgCoordCol(fDat, mode, prm, p.nChan, res_x, h_fig);
if isempty(coord_ref) || size(coord_ref,2)~=(2*p.nChan)
    return
end

% save reference coordinates and file
p.trsf_coordRef = coord_ref;
p.trsf_coordRef_file = fname;
p.coord2plot = 2;

% save modifications
h.param.movPr = p;
guidata(h_fig,h);

% set GUI to proper values and refresh plot
updateFields(h_fig,'imgAxes');

% show action
updateActPan(['Reference coordinates were successfully imported from file:' ...
    ' ' pname fname], h_fig);

