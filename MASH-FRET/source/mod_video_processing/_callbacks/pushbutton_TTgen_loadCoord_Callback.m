function pushbutton_TTgen_loadCoord_Callback(obj, evd, h)

% Last update: 28th of March 2019 by Melodie Hadzic
% --> Fix error when calling orgCoordCol.m with too few input arguments
% --> Remove action "Unable to import coordinates" to avoid double action
%     with orgCoordCol

if ~isfield(h,'movie')
    setContPan('Need access to video dimensions. Load a video first.',...
        'error',h.figure_MASH);
    return;
end

updateFields(h.figure_MASH, 'movPr');
[fname, pname, o] = uigetfile(...
    {'*.coord;*.spots;*.map', ...
    'Coordinates File(*.coord;*.spots;*.map)'; ...
     '*.*', 'All Files (*.*)'}, 'Select a coordinates file', ...
     setCorrectPath('coordinates', h.figure_MASH));

if ~isempty(fname) && sum(fname)
    
    setContPan('Load coordinates ...','process',h.figure_MASH);
    
    cd(pname);
    fDat = importdata([pname fname], '\n');
    coord_itg = orgCoordCol(fDat, 'cw', h.param.movPr.itg_impMolPrm, ...
        h.param.movPr.nChan, h.movie.pixelX, h.figure_MASH);

    if isempty(coord_itg) || ...
            size(coord_itg, 2) ~= 2*h.param.movPr.nChan
        return;
    end

    setContPan(cat(2,'Coordinates successfully loaded from file: ',fname,...
        ' in folder: ',pname),'success',h.figure_MASH);
    h.param.movPr.coordItg = coord_itg;
    h.param.movPr.coordItg_file = fname;
    h.param.movPr.itg_coordFullPth = [pname fname];
    guidata(h.figure_MASH, h);
    updateFields(h.figure_MASH, 'movPr');

end
