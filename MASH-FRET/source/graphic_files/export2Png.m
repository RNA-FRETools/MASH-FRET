function ok = export2Png(h_fig, nameMain, pathName)
% Export the movie / image with background corrections to a .png file
%
% Requires functions: loading_bar, updateActPan, updateBgCorr.

h = guidata(h_fig);

startFrame = h.param.movPr.mov_start;

[dat ok] = getFrames([h.movie.path h.movie.file], startFrame, ...
    {h.movie.speCursor, [h.movie.pixelX h.movie.pixelY], ...
    h.movie.framesTot}, h_fig);
if ~ok
    return;
end
img = dat.frameCur;

% Apply background corrections if exist
if isfield(h.param.movPr, 'bgCorr')
    img = updateBgCorr(img, h_fig);
end
imwrite(uint16(65535*(img-min(min(img)))/ ...
    (max(max(img))-min(min(img)))), [pathName nameMain], 'png', ...
    'BitDepth', 16, 'Description', [num2str(h.movie.cyctime) ' ' ...
    num2str(max(max(img))) ' ' num2str(min(min(img)))]);

