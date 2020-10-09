function switchPan_TM(obj,evd,h_fig)
% Render the selected tool visible and other tools invisible

% Created by MH, 24.4.2019
%
%

h = guidata(h_fig);

green = [0.76 0.87 0.78];
grey = [240/255 240/255 240/255];

set(obj,'Value',1,'BackgroundColor',green);

switch obj
    case h.tm.togglebutton_overview
        set([h.tm.togglebutton_autoSorting,h.tm.togglebutton_videoView],...
            'Value',0,'BackgroundColor',grey);
        set([h.tm.uipanel_autoSorting,h.tm.uipanel_videoView],'Visible',...
            'off');
        set([h.tm.uipanel_overall,h.tm.uipanel_overview], 'Visible', 'on');
        
    case h.tm.togglebutton_autoSorting
        set([h.tm.togglebutton_overview,h.tm.togglebutton_videoView],...
            'Value',0,'BackgroundColor',grey);
        set([h.tm.uipanel_overall,h.tm.uipanel_overview,...
            h.tm.uipanel_videoView],'Visible','off');
        set(h.tm.uipanel_autoSorting, 'Visible', 'on');
        
    case h.tm.togglebutton_videoView
        set([h.tm.togglebutton_overview,h.tm.togglebutton_autoSorting],...
            'Value',0,'BackgroundColor',grey);
        set([h.tm.uipanel_overall,h.tm.uipanel_overview,...
            h.tm.uipanel_autoSorting],'Visible','off');
        set(h.tm.uipanel_videoView, 'Visible', 'on');
end
