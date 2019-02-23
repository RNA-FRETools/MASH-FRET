function setContPan(str, state, h_fig)
% setContPan update the action "str" in the action panel "edit_contPan".
%
% Last update: 20th of February 2019 by Mélodie C.A.S Hadzic
% --> fix find edit fields to display action in

h = guidata(h_fig);
switch state
    case 'error'
        colBg = [1 0.5 0.5];
    case 'success'
        colBg = [0.5 1 0.5];
    case 'process'
        colBg = [1 1 0.5];
    case 'warning'
        colBg = [1 0.75 0.5];
    otherwise
        colBg = [1 1 1];
end

if ~iscell(str)
    n = strfind(str, '\n');
    if ~isempty(n)
        newStr{1,1} = str(1:n(1)-1);
        for i = 1:numel(n)-1
            newStr{size(newStr,1)+1,1} = str(n(i)+2:n(i+1)-1);
        end
        newStr{size(newStr,1)+1,1} = str(n(numel(n))+2:numel(str));
    else
        newStr{1,1} = str;
    end
    str = newStr;
end

curr_obj = get(h_fig, 'CurrentObject');
curr_panel = get(curr_obj, 'Parent');

while 1
    if isempty(curr_panel) || (isprop(curr_panel,'Parent') && ...
            (curr_panel == h.uipanel_simMov || ...
            curr_panel == h.uipanel_TDPana ||  ...
            curr_panel == h.uipanel_thm || ...
            curr_panel == h_fig || curr_panel == h.output || ...
            curr_panel == groot))
        break;
    else
        curr_panel = get(curr_panel, 'Parent');
    end
end

if ~isempty(curr_panel)
    switch curr_panel
        case h.uipanel_simMov
            h_edit = h.edit_simContPan;
        case h.uipanel_TDPana
            h_edit = h.edit_TDPcontPan;
        case h.uipanel_thm
            h_edit = h.edit_thmContPan;
        otherwise
            h_edit = [];
    end
else
    h_edit = [];
end

if ~isempty(h_edit)
    set(h_edit, 'String', textwrap(h_edit, str), 'BackgroundColor', colBg);
    drawnow;
end

updateActPan(str,h_fig,state);

guidata(h_fig, h);

