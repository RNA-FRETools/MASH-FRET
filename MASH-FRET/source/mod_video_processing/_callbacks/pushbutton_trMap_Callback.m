function pushbutton_trMap_Callback(obj, evd, h_fig)

% get image file to map
[fname, pname, o] = uigetfile({'*.png;*.tif', 'Image file(*.png;*.tif)';
    '*.*',  'All Files (*.*)'},'Select an image file for mapping', ...
    setCorrectPath('average_images', h_fig));
if ~sum(fname)
    return
end
[o,o,fext] = fileparts(fname);
if ~(strcmp(fext,'.png') || strcmp(fext,'.tif'))
    updateActPan('Wrong file format. Only PNG and TIF files are supported', ...
        h_fig, 'success');
    return
end
cd(pname);

% collect interface parameters
h = guidata(h_fig);
p = h.param.movPr;

% import image
img = imread([pname fname]);

% open mapping tool
nC = p.nChan;
res_x = size(img,2);
lim_x = [0 (1:nC-1)*round(res_x/nC) res_x];

pnt = openMapping(img, lim_x);

% recover mapped coordinates
coord = zeros([numel(pnt)/2 2]);
if ~isempty(pnt)
    for i = 1:nC
        coord(i:nC:end,:) = pnt(:,2*i-1:2*i);
    end
end

if isempty(coord)
    return
end

% organise coordinates in a column-wise fashion
q{1}(:,1) = 1:nC;
q{1}(:,2) = nC;
q{1}(:,3) = zeros(1,nC);
q{2}(1) = 1;
q{2}(2) = 2;
coord_org = orgCoordCol(coord, 'rw', q, nC, res_x);

% set reference coordinates for transformation
if nC>1
    p.trsf_coordRef = coord_org;
    isItg = 0;
    
% set coordinates for intensity integration
elseif isempty(p.coordItg)
    p.coordItg = coord_org;
    isItg = 1;
end
p.coord2plot = 2;

% get destination coordinates file
saved = 1;
[o,defName,o] = fileparts(fname);
defName = [setCorrectPath('mapping', h_fig) defName '.map'];
[fname,pname,o] = uiputfile({'*.map', 'Mapped coordinates files(*.map)'; ...
    '*.*', 'All files(*.*)'},'Export coordinates', defName);
if ~sum(fname)
    saved = 0;
else
    cd(pname);
    [o,fname,o] = fileparts(fname);
    fname = getCorrName([fname '.map'], pname, h_fig);
    if ~sum(fname)
        saved = 0;
    end
end
if ~saved
    if nC > 1
        p.trsf_coordRef_file = [];
    elseif isItg
        p.coordItg_file = [];
        p.itg_coordFullPth = [];
    end
    
    % save modifications
    h.param.movPr = p;
    guidata(h_fig, h);
    
    % set GUI to proper values and refresh plot
    updateFields(h_fig,'imgAxes');
    
    updateActPan('Reference coordinates loaded but not saved', h_fig, ...
        'process');
    return
end

% save coordinates to file
f = fopen([pname fname], 'Wt');
fprintf(f, 'x\ty\n');
fprintf(f, '%d\t%d\n', coord');
fclose(f);
updateActPan(['Reference coordinates were successfully map and saved to ',...
    'file: ',pname,fname], h_fig, 'success');

% set reference coordinates file for transformation
if nC > 1
    p.trsf_coordRef_file = fname;
    
% set coordinates file for intensity integration
elseif isItg
    p.coordItg_file = fname;
    p.itg_coordFullPth = [pname fname];
end

% save modifications
h.param.movPr = p;
guidata(h_fig, h);

% set GUI to proper values and refresh plot
updateFields(h_fig,'imgAxes');
