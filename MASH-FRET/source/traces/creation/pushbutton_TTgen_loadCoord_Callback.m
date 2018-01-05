function pushbutton_TTgen_loadCoord_Callback(obj, evd, h)
updateFields(h.figure_MASH, 'movPr');
[fname, pname, o] = uigetfile(...
    {'*.coord;*.spots;*.map', ...
    'Coordinates File(*.coord;*.spots;*.map)'; ...
     '*.*', 'All Files (*.*)'}, 'Select a coordinates file', ...
     setCorrectPath('coordinates', h.figure_MASH));

if ~isempty(fname) && sum(fname)
    cd(pname);
    fDat = importdata([pname fname], '\n');
    coord_itg = orgCoordCol(fDat, 'cw', h.param.movPr.itg_impMolPrm, ...
        h.param.movPr.nChan, h.movie.pixelX);

    if isempty(coord_itg) || ...
            size(coord_itg, 2) ~= 2*h.param.movPr.nChan
        updateActPan(['Unable to import coordinates.'...
            '\nPlease modify the import options.'], ...
            h.figure_MASH, 'error');
        return;
    end

    updateActPan(['Coordinates successfully loaded from file: ' fname ...
        '\nin folder: ' pname], h.figure_MASH);
    h.param.movPr.coordItg = coord_itg;
    h.param.movPr.coordItg_file = fname;
    h.param.movPr.itg_coordFullPth = [pname fname];
    guidata(h.figure_MASH, h);
    updateFields(h.figure_MASH, 'movPr');

end