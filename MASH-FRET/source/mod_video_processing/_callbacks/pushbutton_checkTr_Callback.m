function pushbutton_checkTr_Callback(obj, evd, h_fig)

% collect interface parameters
h = guidata(h_fig);
p = h.param.movPr;

if p.nChan<=1 || p.nChan>3
    updateActPan(['This functionality is available for 2 or 3 ' ...
        'channels only.'], h_fig, 'error');
    return
end

if ~(isfield(p,'trsf_tr') && ~isempty(p.trsf_tr))
    updateActPan('No Transformation loaded.', h_fig, 'error');
    return
end

% ask user for image to transform
[fname,pname,o] = uigetfile({...
    '*.png;*.tif','Image files(*.png;*.tif)'; ...
    '*.*', 'All files(*.*)'}, ...
    'Select an image to transform',...
    setCorrectPath('average_images', h_fig));
if ~sum(fname)
    return
end

% get image
cd(pname);
img = imread([pname fname]);

% transform image
[imgtrsf,ok] = constrTrafoImage(p.trsf_tr, img, h_fig);
if ~ok || isempty(imgtrsf)
    return
end

% show transformed image
h_fig2 = figure('NumberTitle','off','Name','Transformed image');
h_axes = axes('Parent', h_fig2);
imagesc(imgtrsf, 'Parent', h_axes);
axis(h_axes, 'image');

