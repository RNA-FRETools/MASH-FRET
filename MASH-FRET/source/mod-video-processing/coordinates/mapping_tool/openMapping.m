function openMapping(img, lim_x, h_fig, fname)
% openMapping(img, lim_x, h_fig, fname)
%
% img: reference image
% lim_x: x-positions of channel splitting (in pixels)
% h_fig: handle to main figure
% fname: reference image file name

nMov = numel(img);
for mov = 1:nMov
    if size(img{mov},3) > 1
        img{mov} = img{mov}(:,:,1);
    end
end

buildMappingTool(img, lim_x, h_fig);

% initialize mapping
h = guidata(h_fig);
h.map.pnt = [];
h.map.lim_x = lim_x;
h.map.res_x = size(img{1},2);
h.map.refimgfile = fname;
guidata(h_fig,h);

beadsSelect(h_fig);

