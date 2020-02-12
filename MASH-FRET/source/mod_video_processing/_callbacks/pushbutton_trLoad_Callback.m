function pushbutton_trLoad_Callback(obj, evd, h_fig)
% pushbutton_trLoad_Callback([], [], h_fig)
% pushbutton_trLoad_Callback(coordfile, [], h_fig)
%
% h_fig: handle to main figure
% coordfile: {1-by-2} source folder and source file containing transformation

% collect interface parameters
h = guidata(h_fig);
p = h.param.movPr;

if p.nChan<=1 || p.nChan>3
    updateActPan(['This functionality is available for 2 or 3 channels ',...
        'only.'], h_fig, 'error');
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
    updateActPan('Wrong file format.', h_fig, 'error');
    return
end

% import transformation
TFORM = open([pname fname]);
if isfield(TFORM, 'tr') && ~isempty(TFORM.tr)
    tr = TFORM.tr;
else
    updateActPan('Unable to load transformations.', h_fig, 'error');
    return
end

updateActPan(['Spatial transformation has been successfully imported from',...
    ' file: ' fname '\nin folder: ' pname], h_fig, 'success');
p.trsf_tr = tr;
p.trsf_tr_file = fname;

% save modifications
h.param.movPr = p;
guidata(h_fig, h);

% set GUI to proper values
ud_VP_coordTransfPan(h_fig);

