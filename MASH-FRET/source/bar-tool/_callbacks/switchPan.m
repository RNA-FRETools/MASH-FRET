function switchPan(obj,evd,h_fig)

h = guidata(h_fig);
p = h.param;

% defaults
green = [0.76 0.87 0.78];
grey = [240/255 240/255 240/255];
minMap = 0;
maxMap = 1;
n_map = 50;
mod = {'S','VP','TP','HA','TA'};

% set button enability and color
h_tb = [h.togglebutton_S,h.togglebutton_VP,h.togglebutton_TP,...
    h.togglebutton_HA,h.togglebutton_TA];
h_pan = [h.uipanel_S,h.uipanel_VP,h.uipanel_TP,h.uipanel_HA,h.uipanel_TA];
set(h_tb(h_tb==obj), 'BackgroundColor', green, 'Value', 1);
set(h_tb(h_tb~=obj), 'BackgroundColor', grey, 'Value', 0);

% set panel visibility
set(h_pan(h_tb==obj), 'Visible', 'on');
set(h_pan(h_tb~=obj), 'Visible', 'off');

% display action
if any(h_tb==obj) && ~strcmp(get(h_pan(h_tb==obj),'Visible'),'on')
    setContPan(['Module "',get(obj,'string'),'" selected.'],'none',h_fig);
end

% save current module of current project
if ~isempty(p.proj)
    p.curr_mod{p.curr_proj} = mod{h_tb==obj};
    h.param = p;
    guidata(h_fig,h);
end

% set proper colormap
switch obj
    case h.togglebutton_S
        if isModuleOn(p,'sim')
            cmaps = get(h.popupmenu_colorMap, 'String');
            cmap = cmaps{p.proj{p.curr_proj}.sim.curr.plot{1}};
            colormap(cmap);
        end

    case h.togglebutton_VP
        if isModuleOn(p,'VP')
            cmaps = get(h.popupmenu_colorMap, 'String');
            cmap = cmaps{p.proj{p.curr_proj}.VP.curr.plot{1}(1)};
            colormap(cmap);
        end
        
    case h.togglebutton_TP
        if isModuleOn(p,'TP')
            proj = p.curr_proj;
            brght = p.proj{proj}.TP.fix{1}(3); % [-1:1]
            ctrst = p.proj{proj}.TP.fix{1}(4); % [-1:1]
            x_map = linspace(minMap, maxMap, n_map);
            a = 1+(ctrst)^3;
            b = brght + (1-a)*0.5;
            r = (a*x_map + b)';
            r(r < 0) = 0;
            r(r > 1) = 1;
            colormap([r r r]);
        end

    case h.togglebutton_TA
        if isModuleOn(p,'TA')
            proj = p.curr_proj;
            tag = p.TDP.curr_tag(proj);
            tpe = p.TDP.curr_type(proj);
            cmaps = get(h.popupmenu_TDPcmap, 'String');
            cmap = cmaps{p.proj{proj}.TA.curr{tag,tpe}.plot{4}};
            colormap(cmap);
        end
end
