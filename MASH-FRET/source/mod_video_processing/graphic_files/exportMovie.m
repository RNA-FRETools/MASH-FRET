function exportMovie(h_fig)
% Export movie to current frame to .tif or .sira file according to file
% format chosen by user.
%
% Requires external functions: setCorrectPath, setCorrectFname,
%                              export2Sira, export2Tiff.

h = guidata(h_fig);
ok = 0;

[o, movName, o] = fileparts(h.movie.file);
str_format = {'*.sira', 'SIRA Graphic File Format(*.sira)'; ...
              '*.tif', 'Tagged Image File Format(*.tif)'; ...
              '*.gif', 'Graphics Interchange Format(*.gif)'; ...
              '*.mat', 'Matlab File(*.mat)'; ...
              '*.avi', 'AVI File(*.avi)'};
          
startFrame = h.param.movPr.mov_start;
lastFrame = h.param.movPr.mov_end;
if lastFrame==startFrame
    str_format{size(str_format,1)+1, 1} = '*.png';
    str_format{size(str_format,1), 2} = 'Portable Network Graphics(*.png)';
end

[fName, pName, fIndex] = uiputfile(str_format, ...
    'Select a movie format: ', movName);

if ~isempty(fName) && sum(fName)
    cd(pName);
    fName = getCorrName(fName, pName, h_fig);
    switch fIndex
        case 1
            ok = export2Sira(h_fig, fName, pName);
        case 2
            ok = export2Tiff(h_fig, fName, pName);
        case 3
            ok = export2Gif(h_fig, fName, pName);
        case 4
            ok = export2Mat(h_fig, fName, pName);
        case 5
            ok = export2Avi(h_fig, fName, pName);
        case 6
            ok = export2Png(h_fig, fName, pName);
    end
    
    if ~ok
        return;
    end
    
    startFrame = h.param.movPr.mov_start;
    lastFrame = h.param.movPr.mov_end;
    if numel(startFrame:lastFrame) > 1
        grType = 'Movie ';
    else
        grType = 'Image ';
    end
    
    str_bg = [];
    if isfield(h.param.movPr, 'bgCorr')  && ~isempty(h.param.movPr.bgCorr)
        str_bg = 'with corrections: ';
        bgCorr = get(h.listbox_bgCorr, 'String');
        for i = 1:numel(bgCorr)
            str_bg = [str_bg '"' bgCorr{i} '", '];
        end
    end
    
    updateActPan([grType str_bg ...
        'has been successfully exported to file: ' fName ...
        '\nin folder: ' pName], h_fig, 'success');
end
