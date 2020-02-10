function pushbutton_impCoord_Callback(obj, evd, h_fig)

% collect interface parameters
h = guidata(h_fig);
p = h.param.movPr;

if p.nChan<=1 || p.nChan>3
    updateActPan(['This functionality is available for 2 or 3 channels ',...
        'only.'], h_fig, 'error');
    return
end

% get coordinates file to transform
defPname = setCorrectPath('spotfinder', h_fig);
[fname,pname,o] = uigetfile({'*.spots','Coordinates File(*.spots)'; ...
    '*.*',  'All Files (*.*)'}, 'Select a coordinates file', defPname);
if ~sum(fname)
    return
end
cd(pname);

% import coordinates
fData = importdata([pname fname], '\n');
prm = h.param.movPr.trsf_coordImp;
col_x = prm(1);
col_y = prm(2);
nCoord = size(fData,1);
coord = [];
for i = 1:nCoord
    fline = str2num(fData{i,1});
    if ~isempty(fline) && ~(numel(fline)==1 && isnan(fline))
        coord = cat(1,coord,fline(1,[col_x col_y]));
    end
end
if isempty(coord)
    updateActPan(cat(2,'No coordinates imported: please check the import ',...
        'options.'),h_fig,'error');
    return
end

% save coordiantes and file
p.coordMol = coord;
p.coordMol_file = fname;
p.coord2plot = 3;

% save modifications
h.param.movPr = p;
guidata(h_fig, h);

% set GUI to proper values and refresh plot
updateFields(h_fig,'imgAxes');

% show action
updateActPan(['Molecule coordinates imported from file: ',pname,fname], ...
    h_fig,'success');
