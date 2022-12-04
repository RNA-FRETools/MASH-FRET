function h_but = getHandlePanelExpandButton(opt,h_fig)
% h_but = getHandlePanelExpandButton(h_pan,h_fig)
% h_but = getHandlePanelExpandButton({module,panelid},h_fig)
%
% Returns "expand panel" button's handle using panel's handle or panel's 
% position index.
%
% h_pan: handle to expandable panel
% h_fig: handle to main figure
% module: 'S','VP','TP','HA' or 'TA'
% panelid: position index of expandable panel in module (ex: 1 for first panel)

% defaults
h_but = [];
modnames = {'S','VP','TP','HA','TA'};

% retrieve interface content
h = guidata(h_fig);

% gather module main panels
h_modpan = [h.uipanel_S,h.uipanel_VP,h.uipanel_TP,h.uipanel_HA,...
    h.uipanel_TA];

if ~iscell(opt)
    % control parent panel
    if ~any(h_modpan==opt.Parent)
        disp('getHandlePanelExpandButton: invalid parent panel.');
        return
    end

    % get button index
    butid = 0;
    for mod = 1:numel(h_modpan)
        hchld = h_modpan(mod).Children;
        for c = numel(hchld):-1:1
            if strcmp(hchld(c).Type,'uipanel')
                butid = butid+1;
                if hchld(c)==opt
                    break
                end
            end
        end
        if hchld(c)==opt
            break
        end
    end
    
else
    % control module
    mod = opt{1};
    h_mod = h_modpan(contains(modnames,mod));
    if isempty(h_mod)
        disp('getHandlePanelExpandButton: invalid module.');
    end

    % get button index
    panelid0 = opt{2};
    butid = 0;
    for mod = 1:numel(h_modpan)
        panelid = 0;
        hchld = h_modpan(mod).Children;
        for c = numel(hchld):-1:1
            if strcmp(hchld(c).Type,'uipanel')
                butid = butid+1;
                panelid = panelid+1;
                if h_modpan(mod)==h_mod && panelid==panelid0
                    break
                end
            end
        end
        if h_modpan(mod)==h_mod && panelid==panelid0
            break
        end
    end
end

% return button's handle
h_but = h.pushbutton_panelCollapse(butid);

