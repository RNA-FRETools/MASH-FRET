function setContPan(str, state, h_fig)
% setContPan update the action "str" in the action panel "edit_contPan".

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

keep = true;
while keep
    if ~(isprop(curr_panel, 'Parent') && ...
            get(curr_panel, 'Parent') ~= h_fig)
        keep = false;
        break;
    else
        curr_panel = get(curr_panel, 'Parent');
    end
end

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

if ~isempty(h_edit)
    str = textwrap(h_edit, str);
    set(h_edit, 'String', str, 'BackgroundColor', colBg);
    drawnow;
end

updateActPan(str,h_fig,state);

guidata(h_fig, h);

