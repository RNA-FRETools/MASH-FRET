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
vidfile = p.proj{p.curr_proj}.movie_file;
viddim = p.proj{p.curr_proj}.movie_dim;
curr = p.proj{p.curr_proj}.VP.curr;
impprm = curr.gen_crd{3}{1}{3};
multichanvid = isscalar(vidfile);

chansplit = cell(1,nChan);
if multichanvid
    resx = viddim{1}(1);
    for c = 1:nChan
        chansplit{c} = ((c-1):c)*round(resx/nChan);
    end
else
    for c = 1:nChan
        chansplit{c} = [0,viddim{c}(1)];
    end
end

% control number of channels
if nChan<=1 || nChan>3
    setContPan(['This functionality is available for 2 or 3 channels ',...
        'only.'], 'error', h_fig);
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
    [~,defPname] = getCorrectPath('spotfinder', h_fig);
    [fname,pname,o] = uigetfile({'*.spots','Coordinates File(*.spots)'; ...
        '*.*',  'All Files (*.*)'}, 'Select a coordinates file', defPname);
end
if ~sum(fname)
    return
end
cd(pname);


% display progress
setContPan(['Import coordinates to transform from file: ',pname,fname],...
    'process',h_fig);

% import coordinates
fData = importdata([pname fname], '\n');
col_x = impprm(1);
col_y = impprm(2);
nCoord = size(fData,1);
coord = [];
for i = 1:nCoord
    fline = str2num(fData{i,1});
    if ~isempty(fline) && ~(numel(fline)==1 && isnan(fline))
        coord = cat(1,coord,fline(1,[col_x,col_y,end]));
    end
end
if isempty(coord)
    setContPan(cat(2,'No coordinates imported: please check the import ',...
        'options.'),'error',h_fig);
    return
end
spots = cell(1,nChan);
for c = 1:nChan
    if multichanvid
        spots{c} = coord(coord(:,1)>=chansplit{c}(1) & ...
            coord(:,1)<chansplit{c}(2),[1,2]);
    else
        spots{c} = coord(coord(:,3)==c,[1,2]);
    end
end

% save coordiantes and file
curr.res_crd{1} = spots;
curr.gen_crd{3}{1}{2} = fname;
curr.plot{1}(2) = 3;

% save modifications
p.proj{p.curr_proj}.VP.curr = curr;
h.param = p;
guidata(h_fig, h);

% bring average image plot tab front
bringPlotTabFront('VPave',h_fig);

% set GUI to proper values and refresh plot
updateFields(h_fig,'imgAxes');

% show action
setContPan('Coordinates to transform successfully imported!','success',...
    h_fig);
