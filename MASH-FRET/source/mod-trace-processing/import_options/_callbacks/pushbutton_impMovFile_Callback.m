function pushbutton_impMovFile_Callback(obj, evd, h_fig)
% pushbutton_impMovFile_Callback([],[], h_fig)
% pushbutton_impMovFile_Callback(coord_file,[], h_fig)
%
% h_fig: handle to main figure
% coord_file: {1-by-2} source folder and file for coordinates import

% Last update, 28.3.2019 by MH: fix error when importing coordinates from file

if iscell(obj)
    pname = obj{1};
    fname = obj{2};
    if ~strcmp(pname,filesep)
        pname = [pname,filesep];
    end
else
    % ask for video file
    [fname, pname, o] = uigetfile({ ...
        '*.sif;*.sira;*.tif;*.gif;*.png;*.spe;*.pma', ...
        ['Supported Graphic File Format' ...
        '(*.sif,*.sira,*.tif,*.gif,*.png,*.spe,*.pma)']; ...
        '*.*', 'All File Format(*.*)'}, 'Select a graphic file:');
end
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



