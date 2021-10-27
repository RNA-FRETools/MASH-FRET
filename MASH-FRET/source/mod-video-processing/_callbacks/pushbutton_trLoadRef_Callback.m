function pushbutton_trLoadRef_Callback(obj, evd, h_fig)
% pushbutton_trLoadRef_Callback([], [], h_fig)
% pushbutton_trLoadRef_Callback(coordfile, [], h_fig)
%
% h_fig: handle to main figure
% coordfile: {1-by-2} source folder and source file containing reference coordinates

% collect parameters
h = guidata(h_fig);
p = h.param;
nChan = p.proj{p.curr_proj}.nb_channel;
curr = p.proj{p.curr_proj}.VP.curr;
viddim = p.proj{p.curr_proj}.movie_dim;
impprm = curr.gen_crd{3}{2};

% control nb of channel
if nChan<=1 || nChan>3
    setContPan(['This functionality is available for 2 or 3 channels ',...
        'only.'], 'error', h_fig);
    return
end

% get reference coordinates file
if iscell(obj)
    pname = obj{1};
    fname = obj{2};
    if ~strcmp(pname(end),filesep)
        pname = [pname,filesep];
    end
else
    [fname,pname,o] = uigetfile(...
        {'*.map;*.cpSelect','Coordinates File(*.map;*.cpSelect)'; ...
         '*.*','All Files (*.*)'},'Pick a co-localized coordinates file', ...
         setCorrectPath('mapping', h_fig));
end
if ~sum(fname)
    return
end
cd(pname);

% display process
setContPan(['Import reference coordinates from file ',pname,fname,' ...'],...
    'process',h_fig);

% import coordinates
fDat = importdata([pname fname], '\n');
if isstruct(fDat)
    fDat = fDat.Sheet1;
end

% organize coordinate sin a column-wise fashion
res_x = viddim(1);
mode = impprm{3};
switch mode
    case 'rw'
        readprm = impprm{4};
    case 'cw'
        readprm = impprm{5};
end
coordref = orgCoordCol(fDat, mode, readprm, nChan, res_x, h_fig);
if isempty(coordref) || size(coordref,2)~=(2*nChan)
    return
end

% save reference coordinates and file
curr.res_crd{3} = coordref;
curr.gen_crd{3}{2}{2} = fname;
curr.plot{1}(3) = 2;

% save modifications
p.proj{p.curr_proj}.VP.curr = curr;
h.param = p;
guidata(h_fig,h);

% set GUI to proper values and refresh plot
updateFields(h_fig,'imgAxes');

% display success
setContPan('Reference coordinates successfully imported!','success',h_fig);

