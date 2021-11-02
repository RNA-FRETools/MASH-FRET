function ud_VP_plotPan(h_fig)
% ud_VP_plotPan(h_fig)
%
% Set panel "Plot" in module Video processing to proper values
%
% h_fig: handle to main figure

% collect interface parameters
h = guidata(h_fig);
p = h.param;

if ~prepPanel(h.uipanel_VP_plot,h)
    return
end

% retrieve parameters
proj = p.curr_proj;
curr = p.proj{proj}.VP.curr;

% set color map menu
set(h.popupmenu_colorMap, 'Value', curr.plot{1}(1));

