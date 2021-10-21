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
set(h.popupmenu_colorMap, 'Value', curr.plot{1}(2));
str_map = get(h.popupmenu_colorMap,'string');
cm = colormap(eval(lower(str_map{curr.plot{1}(2)})));
colormap(h.axes_VP_vid,cm);

% set image count units
set(h.checkbox_int_ps, 'Value', curr.plot{1}(1));
