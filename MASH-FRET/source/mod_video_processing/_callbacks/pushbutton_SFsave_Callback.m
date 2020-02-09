function pushbutton_SFsave_Callback(obj, evd, h_fig)

% collect interface parameters
h = guidata(h_fig);
p = h.param.movPr;

if isempty(p.SFres)
    updateActPan('Start a "spotfinder" procedure first.', h_fig, 'error');
    return
end
if p.SF_method<=1
    return
end

% save spots coordinates to file
[coord,pname,fname,avImg,p] = saveSpots(p,h_fig);
if isempty(coord)
    return
end
h.movie.avImg = avImg;

p.coordMol = coord(:,1:2);

% show action
if ~sum(fname)
    updateActPan('Spots coordinates loaded but not saved',h_fig,'process');
    p.coordMol_file = [];
    pname = [];
else
    p.coordMol_file = [fname '.spots'];
    updateActPan(['Spots coordinates have been successfully written to ',...
        'file: ',pname,fname,'.spots'], h_fig, 'success');
end

% set 1-channel coordinates file ready for intensity integration
if p.nChan==1 && isempty(p.coordItg)
    p.coordItg = p.coordMol(:,1:2);
    p.coordItg_file = p.coordMol_file;
    p.itg_coordFullPth = [pname p.coordMol_file];

% set coordinates file ready for transformation
elseif p.nChan>1 && p.nChan<=3 && isempty(p.coordTrsf)
    p.coordTrsf = p.coordMol(:,1:2);
    p.coordTrsf_file = p.coordMol_file;
end

% save modifications
h.param.movPr = p;
guidata(h_fig, h);

% set GUI to proper values
updateFields(h_fig, 'movPr');
