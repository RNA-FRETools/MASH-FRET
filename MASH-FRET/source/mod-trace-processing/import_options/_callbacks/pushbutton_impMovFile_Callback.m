function pushbutton_impMovFile_Callback(obj, evd, h_fig)

% ask for video file
[fname, pname, o] = uigetfile({ ...
    '*.sif;*.sira;*.tif;*.gif;*.png;*.spe;*.pma', ...
    ['Supported Graphic File Format' ...
    '(*.sif,*.sira,*.tif,*.gif,*.png,*.spe,*.pma)']; ...
    '*.*', 'All File Format(*.*)'}, 'Select a graphic file:');
if ~sum(fname)
    return
end

% collect interface parameters
h = guidata(h_fig);
m = guidata(h.figure_trImpOpt);

m{2}{2} = [pname fname];

% save modifications
guidata(h.figure_trImpOpt, m);

% set GUI to proper values
ud_trImpOpt(h_fig);



