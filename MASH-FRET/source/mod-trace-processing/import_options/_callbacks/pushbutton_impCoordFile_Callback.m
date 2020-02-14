function pushbutton_impCoordFile_Callback(obj, evd, h_fig)

% Last update, 28.3.2019 by MH: fix error when importing coordinates from file

defPth = setCorrectPath('coordinates', h_fig);
[fname, pname, o] = uigetfile({...
    '*.coord;*.spots', 'Coordinates file(*.coord;*.spots)'; ...
    '*.*', 'All files(*.*)'}, 'Select a coordinates file:', defPth);
if ~sum(fname)
    return
end

h = guidata(h_fig);
m = guidata(h.figure_trImpOpt);

m{3}{2} = [pname fname];

guidata(h.figure_trImpOpt, m);

ud_trImpOpt(h_fig);


