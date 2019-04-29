function pushbutton_impCoord_Callback(obj, evd, h)

if h.param.movPr.nChan > 1 && h.param.movPr.nChan <= 3
    defPname = setCorrectPath('spotfinder', h.figure_MASH);
    [fname,pname,o] = uigetfile({'*.spots','Coordinates File(*.spots)'; ...
        '*.*',  'All Files (*.*)'}, 'Select a coordinates file', defPname);

    if ~isempty(fname) && sum(fname)
        cd(pname);
        fData = importdata([pname fname], '\n');
        p = h.param.movPr.trsf_coordImp;
        col_x = p(1);
        col_y = p(2);
        nCoord = size(fData,1);
        nCol = size(str2num(fData{1,1}),2);
        coord = [];
        for i = 1:nCoord
            l = str2num(fData{i,1});
            if ~isempty(l)
                coord(size(coord,1)+1,1:2) = l(1,[col_x col_y]);
            end
        end

        if isempty(coord)
            updateActPan(['No coordinates imported.' ...
                '\nPlease check the import options.'], ...
                h.figure_MASH, 'error');
            return;
        end

        h.param.movPr.coordMol = coord;
        h.param.movPr.coordMol_file = fname;
        guidata(h.figure_MASH, h);
        updateActPan(['Molecule coordinates imported from file: ' fname ...
            '\nin folder: ' pname], h.figure_MASH, 'success');
        updateFields(h.figure_MASH, 'movPr');
    end

else
    updateActPan(['This functionality is available for 2 or 3 ' ...
        channels only.'], h.figure_MASH, 'error');
end