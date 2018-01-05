function setCmap(h_fig, cmap)
h = guidata(h_fig);
axes(h.axes_TDPcmap);
colormap(cmap);
cmapFin = 0:1/99:1;
imagesc(cmapFin, 'Parent', h.axes_TDPcmap);
set(h.axes_TDPcmap, 'YTick', [], 'XLim', [0 100]);
