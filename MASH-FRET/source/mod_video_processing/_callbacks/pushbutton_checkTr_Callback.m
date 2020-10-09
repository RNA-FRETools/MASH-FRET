function pushbutton_checkTr_Callback(obj, evd, h_fig)
h = guidata(h_fig);
if h.param.movPr.nChan > 1 && h.param.movPr.nChan <= 3
    if isfield(h.param.movPr, 'trsf_tr') && ~isempty(h.param.movPr.trsf_tr)

        [fname,pname,o] = uigetfile({...
            '*.png;*.tif', 'Image files(*.png;*.tif)'; ...
            '*.*', 'All files(*.*)'}, ...
            'Select an image to transform', ...
            setCorrectPath('average_images', h_fig));

        if ~isempty(fname) && sum(fname)
            cd(pname);
            img = imread([pname fname]);
            [img_final ok] = constrTrafoImage(h.param.movPr.trsf_tr, ...
                img, h_fig);
            if ~isempty(img_final)
                h_fig = figure('NumberTitle','off','Name',...
                    'Transformed image');
                h_axes = axes('Parent', h_fig);
                imagesc(img_final, 'Parent', h_axes);
                axis(h_axes, 'image');
            end
        end
    else
        updateActPan('No Transformation loaded.', h_fig, 'error');
    end
else
    updateActPan(['This functionality is available for 2 or 3 ' ...
        'channels only.'], h_fig, 'error');
end