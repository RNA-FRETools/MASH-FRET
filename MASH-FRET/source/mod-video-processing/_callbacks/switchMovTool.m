function switchMovTool(obj, evd, h_fig)

% update by MH, 19.12.2019: do not update image plot after change in order to preserve axis limits (preserving zoom for instance)

h = guidata(h_fig);
switch obj
    case h.togglebutton_target
        set(h.togglebutton_zoom, 'Value', 0);
        set(0, 'CurrentFigure', h_fig);
        zoom off;
        setbuttonfcn(h,{'imageMov','axes_VP_vid','aveImage',...
            'axes_VP_avimg'},{@pointITT, h_fig});

    case h.togglebutton_zoom
        set(h.togglebutton_target, 'Value', 0);
        
        setbuttonfcn(h,{'imageMov','axes_VP_vid','aveImage',...
            'axes_VP_avimg'},{});
        set(0, 'CurrentFigure', h_fig);
        zoom on;
end


function setbuttonfcn(s,name,fcn)
if ~iscell(name)
    name = {name};
end
N = numel(name);
for n = 1:N
    if isfield(s,name{n}) && all(ishandle(s.(name{n})))
        set(s.(name{n}),'ButtonDownFcn',fcn);
    end
end
