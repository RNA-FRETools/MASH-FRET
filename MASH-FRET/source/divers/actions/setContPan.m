function setContPan(str, state, h_fig)
% setContPan update the action "str" in the action panel "edit_contPan".
%
% Last update: 20th of February 2019 by Mélodie C.A.S Hadzic
% --> fix find edit fields to display action in

% default
colRed = [1 0.9 0.9];
colGreen = [0.9 1 0.9];
colYellow = [1 1 0.9];
colOrange = [1 0.95 0.9];
colWhite = [1 1 1];

h = guidata(h_fig);

if h.mute_actions
    return
end

switch state
    case 'error'
        colBg = colRed;
    case 'success'
        colBg = colGreen;
    case 'process'
        colBg = colYellow;
    case 'warning'
        colBg = colOrange;
    otherwise
        colBg = colWhite;
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
            (curr_panel == h.uipanel_S || ...
            curr_panel == h.uipanel_TA ||  ...
            curr_panel == h.uipanel_HA || ...
            curr_panel == h_fig || ...
            curr_panel == groot))
        break;
    else
        curr_panel = get(curr_panel, 'Parent');
    end
end

if ~isempty(curr_panel)
    switch curr_panel
        case h.uipanel_S
            h_edit = h.edit_simContPan;
        case h.uipanel_TA
            h_edit = h.edit_TDPcontPan;
        case h.uipanel_HA
            h_edit = h.edit_thmContPan;
        otherwise
            h_edit = [];
    end
else
    h_edit = [];
end

updateActPan(str,h_fig,state);

if ~isempty(h_edit)
    str = wrapActionString('none',h_edit,[h.figure_dummy,h.text_dummy],...
        str);
    set(h_edit, 'String', str, 'BackgroundColor', colBg);
    drawnow;
end

guidata(h_fig, h);

