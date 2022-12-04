function pushbutton_panelCollapse_Callback(obj,evd,h_fig)
% pushbutton_panelCollapse_Callback(obj,[],h_fig)
%
% obj: handle to one panel expand/collapse button
% h_fig: handle to main figure

switch obj.String
    case char(9660) % bottom-pointing triangle
        expandPanel(obj);
        isopen = true;
    case char(9650) % top-pointing triangle
        collapsePanel(obj);
        isopen = false;
    otherwise
        disp('pushbutton_panelCollapse_Callback: unknown button string')
        return
end

% retrieve interface parameters
h = guidata(h_fig);
p = h.param;

% update current panel index
[mod,panid] = getExpandPanelId(obj,h_fig);
if ~isopen
    panid = 0;
end
switch mod
    case 'S'
        p.sim.curr_pan(p.curr_proj) = panid;
    case 'VP'
        p.movPr.curr_pan(p.curr_proj) = panid;
    case 'TP'
        p.ttPr.curr_pan(p.curr_proj) = panid;
    case 'HA'
        p.thm.curr_pan(p.curr_proj) = panid;
    case 'TA'
        p.TDP.curr_pan(p.curr_proj) = panid;
    otherwise
        disp('pushbutton_panelCollapse_Callback: invalid module.');
        return
end

% save modifications
h.param = p;
guidata(h_fig,h);

% refresh panels
ud_extendedPanel(obj,h_fig);
