function pushbutton_SFsave_Callback(obj, evd, h_fig)
% pushbutton_SFsave_Callback([],[],h_fig)
% pushbutton_SFsave_Callback(file_out,[],h_fig)
%
% h_fig: handle to main figure
% file_out: {1-by-2} destination folder and file for spots coordinates

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
if iscell(obj)
    pname = obj{1};
    fname = obj{2};
    if~strcmp(pname(end),filesep)
        pname = [pname,filesep];
    end
    [coord,pname,fname,avImg,p] = saveSpots(p,h_fig,pname,fname);
else
    [coord,pname,fname,avImg,p] = saveSpots(p,h_fig);
end
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

% set GUI to proper values and refresh plot
updateFields(h_fig,'imgAxes');
