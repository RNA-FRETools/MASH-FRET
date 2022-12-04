function pushbutton_trLoad_Callback(obj, evd, h_fig)
% pushbutton_trLoad_Callback([], [], h_fig)
% pushbutton_trLoad_Callback(coordfile, [], h_fig)
%
% h_fig: handle to main figure
% coordfile: {1-by-2} source folder and source file containing transformation

% collect interface parameters
h = guidata(h_fig);
p = h.param;
nChan = p.proj{p.curr_proj}.nb_channel;
curr = p.proj{p.curr_proj}.VP.curr;

% control nb of channels
if nChan<=1 || nChan>3
    setContPan('This functionality is available for 2 or 3 channels only.',...
        'error', h_fig);
    return
end

% get transformation file
if iscell(obj)
    pname = obj{1};
    fname = obj{2};
    if ~strcmp(pname(end),filesep)
        pname = [pname,filesep];
    end
else
    [fname, pname, o] = uigetfile({'*.mat','Matlab files(*.mat)'; ...
        '*.*',  'All Files (*.*)'}, 'Select a transformation file:', ...
        setCorrectPath('transformed', h_fig));
end
if ~sum(fname)
    return
end
cd(pname);
[o, o, fExt] = fileparts(fname);
if ~strcmp(fExt, '.mat')
    setContPan('Wrong file format.', 'error', h_fig);
    return
end

% display process
setContPan(['Import transformation from file ',fname,pname,' ...'],...
    'process',h_fig);

% import transformation
TFORM = open([pname fname]);
if isfield(TFORM, 'tr') && ~isempty(TFORM.tr)
    tr = TFORM.tr;
else
    setContPan('Unable to load transformations.', 'error', h_fig);
    return
end

% save transformation and file
curr.res_crd{2} = tr;
curr.gen_crd{3}{3}{3} = fname;

% save modifications
p.proj{p.curr_proj}.VP.curr = curr;
h.param = p;
guidata(h_fig, h);

% set GUI to proper values
ud_VP_coordTransfPan(h_fig);

% display success
setContPan('Transformation successfully imported!', 'success', h_fig);

