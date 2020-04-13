function figure_MASH_SizeChangedFcn(obj, evd)

h = guidata(obj);

% re-adjust text wrapping in control panels
h_edit = [h.edit_simContPan,h.edit_TDPcontPan,h.edit_thmContPan];
for he = h_edit
    str = wrapActionString('resize',he,[h.figure_dummy,h.text_dummy]);
    set(he,'String',str);
end

% re-position help buttons
if ~isfield(h,'pushbutton_help')
    return;
end
for o = 1:numel(h.pushbutton_help)
    data = get(h.pushbutton_help(o),'userdata');

    un_but = get(h.pushbutton_help(o),'units');
    un_pan = get(data{1},'units');

    set(data{1},'units','pixels');
    set(h.pushbutton_help(o),'units','pixels');

    pos_pan = get(data{1},'position');
    pos_but = get(h.pushbutton_help(o),'position');
    
    % shift position according to reference object
    if data{3}(1)==0 % baseline is left border
        pos_but(1) = pos_pan(1) + data{2}(1);
    else % baseline is right border
        pos_but(1) = pos_pan(1) + pos_pan(3) + data{2}(1);
    end
    if data{3}(2)==0 % baseline is bottom border
        pos_but(2) = pos_pan(2) + data{2}(2);
    else % baseline is top border
        pos_but(2) = pos_pan(2) + pos_pan(4) + data{2}(2);
    end
    
    % do not resize buttons
    pos_but([3,4]) = data{2}([3,4]);

    set(h.pushbutton_help(o),'position',pos_but);

    set(data{1},'units',un_pan);
    set(h.pushbutton_help(o),'units',un_but);
end