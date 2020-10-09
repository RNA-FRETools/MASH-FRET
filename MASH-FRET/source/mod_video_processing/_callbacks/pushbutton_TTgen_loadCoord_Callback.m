function pushbutton_TTgen_loadCoord_Callback(obj, evd, h_fig)

% Last update: 28th of March 2019 by Melodie Hadzic
% --> Fix error when calling orgCoordCol.m with too few input arguments
% --> Remove action "Unable to import coordinates" to avoid double action
%     with orgCoordCol

h = guidata(h_fig);
if ~isfield(h,'movie')
    setContPan('Need access to video dimensions. Load a video first.',...
        'error',h_fig);
    return;
end

updateFields(h_fig, 'movPr');
[fname, pname, o] = uigetfile(...
    {'*.coord;*.spots;*.map', ...
    'Coordinates File(*.coord;*.spots;*.map)'; ...
     '*.*', 'All Files (*.*)'}, 'Select a coordinates file', ...
     setCorrectPath('coordinates', h_fig));

if ~isempty(fname) && sum(fname)
    
    setContPan('Load coordinates ...','process',h_fig);
    
    cd(pname);
    fDat = importdata([pname fname], '\n');
    coord_itg = orgCoordCol(fDat, 'cw', h.param.movPr.itg_impMolPrm, ...
        h.param.movPr.nChan, h.movie.pixelX, h_fig);

    if isempty(coord_itg) || ...
            size(coord_itg, 2) ~= 2*h.param.movPr.nChan
        return;
    end

    setContPan(cat(2,'Coordinates successfully loaded from file: ',fname,...
        ' in folder: ',pname),'success',h_fig);
    h.param.movPr.coordItg = coord_itg;
    h.param.movPr.coordItg_file = fname;
    h.param.movPr.itg_coordFullPth = [pname fname];
    guidata(h_fig, h);
    updateFields(h_fig, 'movPr');

end
