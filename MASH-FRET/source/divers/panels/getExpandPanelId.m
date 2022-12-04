function [modname,panid] = getExpandPanelId(h_but,h_fig)
% [modname,panid] = getExpandPanelId(h_but,h_fig)
%
% Returns expandable panel's position index and parent module using "expand panel" button's handle.
%
% h_but: handle to button
% h_fig: handle to main figure
% modname: 'S','VP','TP','HA' or 'TA'
% panelid: position index of expandable panel in module (ex: 1 for first panel)

% defaults
modname = '';
panid = 0;
modnames = {'S','VP','TP','HA','TA'};

% retrieve interface content
h = guidata(h_fig);

% gather module main panels
h_modpan = [h.uipanel_S,h.uipanel_VP,h.uipanel_TP,h.uipanel_HA,...
    h.uipanel_TA];

% get button index
butid0 = find(h.pushbutton_panelCollapse==h_but,true);
if isempty(butid0)
    disp('getExpandPanelId: invalid button handle');
    return
end
butid = 0;
for mod = 1:numel(modnames)
    panid = 0;
    hchld = h_modpan(mod).Children;
    for c = numel(hchld):-1:1
        if strcmp(hchld(c).Type,'uipanel')
            butid = butid+1;
            panid = panid+1;
            if butid==butid0
                break
            end
        end
    end
    if butid==butid0
        break
    end
end
modname = modnames{mod};
