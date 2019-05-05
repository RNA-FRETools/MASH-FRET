function ok = export2Png(h_fig, nameMain, pathName)
% Export the movie / image with background corrections to a .png file
%
% Requires functions: loading_bar, updateActPan, updateBgCorr.

% defaults
isMov = 0;
isBgCorr = 0;
ok = 1;

h = guidata(h_fig);

if isfield(h,'movie') && isfield(h.movie,'movie') && ...
    ~isempty(h.movie.movie)
    isMov = 1;
end
if isfield(h.param.movPr, 'bgCorr') && ~isempty(h.param.movPr.bgCorr)
    isBgCorr = 1;
end

startFrame = h.param.movPr.mov_start;

if isMov
    img = h.movie.movie(:,:,startFrame);
else
    [dat,ok] = getFrames([h.movie.path h.movie.file], startFrame, ...
        {h.movie.speCursor, [h.movie.pixelX h.movie.pixelY], ...
        h.movie.framesTot}, h_fig);
    if ~ok
        return;
    end
    img = dat.frameCur;
end

% Apply background corrections if exist
if isBgCorr
    img = updateBgCorr(img, h_fig);
end

imwrite(uint16(65535*(img-min(min(img)))/ ...
    (max(max(img))-min(min(img)))), [pathName nameMain], 'png', ...
    'BitDepth', 16, 'Description', [num2str(h.movie.cyctime) ' ' ...
    num2str(max(max(img))) ' ' num2str(min(min(img)))]);

