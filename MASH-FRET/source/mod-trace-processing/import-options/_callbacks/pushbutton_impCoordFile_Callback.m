function pushbutton_impCoordFile_Callback(obj, evd, h_fig)
% pushbutton_impCoordFile_Callback([],[], h_fig)
% pushbutton_impCoordFile_Callback(coord_file,[], h_fig)
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
    defPth = setCorrectPath('coordinates', h_fig);
    [fname, pname, o] = uigetfile({...
        '*.coord;*.spots', 'Coordinates file(*.coord;*.spots)'; ...
        '*.*', 'All files(*.*)'}, 'Select a coordinates file:', defPth);
end
if ~sum(fname)
    return
end

h = guidata(h_fig);
m = guidata(h.figure_trImpOpt);

m{3}{2} = [pname fname];

guidata(h.figure_trImpOpt, m);

ud_trImpOpt(h_fig);


