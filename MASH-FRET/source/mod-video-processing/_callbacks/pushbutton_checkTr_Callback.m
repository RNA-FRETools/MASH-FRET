function pushbutton_checkTr_Callback(obj, evd, h_fig)
% pushbutton_checkTr_Callback([],[],h_fig)
% pushbutton_checkTr_Callback(imgfiles,[],h_fig)
%
% h_fig: handle to main figure
% imgfiles: {2-by-2} source and destination files with:
%  imgfiles(1,:): source folder and file for reference image
%  imgfiles(2,:): destination folder and file for transformed image

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

if iscell(obj)
    pname = obj{1,1};
    fname = obj{1,2};
    if ~strcmp(pname(end),filesep)
        pname = [pname,filesep];
    end
    fromRoutine = true;
else
    % ask user for image to transform
    [fname,pname,o] = uigetfile({...
        '*.png;*.tif','Image files(*.png;*.tif)'; ...
        '*.*', 'All files(*.*)'}, ...
        'Select an image to transform',...
        setCorrectPath('average_images', h_fig));
    fromRoutine = false;
end
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
h_fig2 = figure('NumberTitle','off','Name','Transformed image','visible',...
    'off');
h_axes = axes('Parent', h_fig2);
imagesc(imgtrsf, 'Parent', h_axes);
axis(h_axes, 'image');

% save image and close figure
if fromRoutine
    pname_out = obj{2,1};
    fname_out = obj{2,2};
    if ~strcmp(pname_out(end),filesep)
        pname_out = [pname_out,filesep];
    end
    print(h_fig2,[pname_out,fname_out],'-dpng');
    close(h_fig2);
else
    set(h_fig2,'visible','on');
end

