function pushbutton_impCoord_Callback(obj, evd, h_fig)
% pushbutton_impCoord_Callback([], [], h_fig)
% pushbutton_impCoord_Callback(coordfile, [], h_fig)
%
% h_fig: handle to main figure
% coordfile: {1-by-2} source folder and source file containing coordinates to transform

% collect parameters
h = guidata(h_fig);
p = h.param;
nChan = p.proj{p.curr_proj}.nb_channel;
curr = p.proj{p.curr_proj}.VP.curr;
impprm = curr.gen_crd{3}{1}{3};

% control number of channels
if nChan<=1 || nChan>3
    updateActPan(['This functionality is available for 2 or 3 channels ',...
        'only.'], h_fig, 'error');
    return
end

% get coordinates file to transform
if iscell(obj)
    pname = obj{1};
    fname = obj{2};
    if ~strcmp(pname(end),filesep)
        pname = [pname,filesep];
    end
else
    defPname = setCorrectPath('spotfinder', h_fig);
    [fname,pname,o] = uigetfile({'*.spots','Coordinates File(*.spots)'; ...
        '*.*',  'All Files (*.*)'}, 'Select a coordinates file', defPname);
end
if ~sum(fname)
    return
end
cd(pname);

% import coordinates
fData = importdata([pname fname], '\n');
col_x = impprm(1);
col_y = impprm(2);
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
curr.res_crd{1} = coord;
curr.gen_crd{3}{1}{2} = fname;
curr.plot{1}(3) = 3;

% save modifications
p.proj{p.curr_proj}.VP.curr = curr;
h.param = p;
guidata(h_fig, h);

% set GUI to proper values and refresh plot
updateFields(h_fig,'imgAxes');

% show action
updateActPan(['Molecule coordinates imported from file: ',pname,fname], ...
    h_fig,'success');
