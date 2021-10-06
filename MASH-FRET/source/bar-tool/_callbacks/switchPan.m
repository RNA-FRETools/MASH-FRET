function switchPan(obj,evd,h_fig)

h = guidata(h_fig);

green = [0.76 0.87 0.78];
grey = [240/255 240/255 240/255];

h_tb = [h.togglebutton_S,h.togglebutton_VP,h.togglebutton_TP,...
    h.togglebutton_HA,h.togglebutton_TA];
h_pan = [h.uipanel_S,h.uipanel_VP,h.uipanel_TP,h.uipanel_HA,h.uipanel_TA];

set(obj, 'BackgroundColor', green, 'Value', 1);
set(h_tb(h_tb~=obj), 'BackgroundColor', grey, 'Value', 0);

isVis = strcmp(get(h_pan(h_tb==obj),'Visible'),'on');
set(h_pan(h_tb==obj), 'Visible', 'on');
set(h_pan(h_tb~=obj), 'Visible', 'off');
if ~isVis
    setContPan(['Module "',get(obj,'string'),'" selected.'],'none',h_fig);
end

% set proper colormap
p = h.param;
switch obj
    case h.togglebutton_S
        if isModuleOn(p,'sim')
            cmaps = get(h.popupmenu_colorMap, 'String');
            cmap = cmaps{p.proj{p.curr_proj}.sim.cmap};
            colormap(cmap);
        end

    case h.togglebutton_VP
        if isModuleOn(p,'VP')
            cmaps = get(h.popupmenu_colorMap, 'String');
            cmap = cmaps{p.proj{p.curr_proj}.VP.cmap};
            colormap(cmap);
        end

    case h.togglebutton_TA
        if isModuleOn(p,'TA')
            proj = p.curr_proj;
            tag = p.TDP.curr_tag(proj);
            tpe = p.TDP.curr_type(proj);
            colormap(p.proj{proj}.TA.curr{tag,tpe}.plot{4});
        end
end
