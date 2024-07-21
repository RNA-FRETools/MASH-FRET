function ud_subImg(h_fig)

% collect interface parameters
h = guidata(h_fig);
p = h.param;

if ~prepPanel(h.uipanel_TP_subImages,h)
    return
end

% collect experiment settings and video parameters
proj = p.curr_proj;
mol = p.ttPr.curr_mol(proj);
nExc = p.proj{proj}.nb_excitations;
nChan = p.proj{proj}.nb_channel;
coord = p.proj{proj}.coord;
isMov = p.proj{proj}.is_movie;
isCoord = p.proj{proj}.is_coord;
prm = p.proj{proj}.TP.prm{mol};
fix = p.proj{proj}.TP.fix;

% get channel and laser corresponding to selected data
selected_chan = fix{3}(6);
chan = 0;
for l = 1:nExc
    for c = 1:nChan
        chan = chan+1;
        if chan==selected_chan
            break
        end
    end
    if chan==selected_chan
        break
    end
end

if isCoord
    p_panel = fix{1};
    meth = prm{3}{2}(l,c);
    if size(prm{3}{3}{l,c},1)<meth
        meth = 1;
    end
    subdim = prm{3}{3}{l,c}(meth,2);
    set(h.popupmenu_subImg_exc, 'Value', p_panel(1));
%         set(h.checkbox_refocus, 'Value', refocus);
    set(h.edit_subImg_dim, 'String', num2str(subdim), ...
        'BackgroundColor', [1 1 1]);

    set(h.slider_brightness, 'Value', (p_panel(3)+1)/2);
    set(h.slider_contrast, 'Value', (p_panel(4)+1)/2);
    set(h.text_brightness, 'String', [num2str(100*p_panel(3)) '%']);
    set(h.text_contrast, 'String', [num2str(100*p_panel(4)) '%']);

    chan = get(h.popupmenu_TP_subImg_channel,'value');
    if chan>nChan
        chan = nChan;
        set(h.popupmenu_TP_subImg_channel,'value',chan);
    end
    if ~isempty(coord)
        set(h.edit_TP_subImg_x,'string',num2str(coord(mol,2*chan-1)), ...
        'backgroundcolor',[1 1 1]);
        set(h.edit_TP_subImg_y,'string',num2str(coord(mol,2*chan)), ...
        'backgroundcolor',[1 1 1]);
    else
        set([h.edit_TP_subImg_x h.edit_TP_subImg_y],'string','');
    end
end

if isMov && isCoord
    for c = 1:nChan
        set(h.axes_subImg(c),'FontUnits',get(h.axes_top,'FontUnits'),...
            'FontSize',get(h.axes_top,'FontSize'));
    end
    set([h.popupmenu_TP_subImg_channel,h.text_TP_subImg_channel,...
        h.text_TP_subImg_coordinates,h.edit_TP_subImg_x,h.edit_TP_subImg_y,...
        h.text_TP_subImg_x,h.text_TP_subImg_y,h.checkbox_refocus,...
        h.text_contrast,h.slider_contrast,h.text_brightness,...
        h.slider_brightness,h.popupmenu_subImg_exc,...
        h.text_TP_subImg_contrast,h.text_TP_subImg_brightness,...
        h.text_TP_subImg_exc],'enable','on');
else
    set([h.checkbox_refocus,h.text_contrast,h.slider_contrast,...
        h.text_brightness,h.slider_brightness,h.popupmenu_subImg_exc,...
        h.text_TP_subImg_contrast,h.text_TP_subImg_brightness,...
        h.text_TP_subImg_exc],'enable','off');
    if isCoord
        set([h.edit_TP_subImg_x,h.edit_TP_subImg_y],'enable','inactive');
        set([h.popupmenu_TP_subImg_channel,h.text_TP_subImg_channel,...
            h.text_TP_subImg_coordinates,h.text_TP_subImg_x,...
            h.text_TP_subImg_y],'enable','on');
    else
        set([h.popupmenu_TP_subImg_channel,h.text_TP_subImg_channel,...
            h.text_TP_subImg_coordinates,h.text_TP_subImg_x,...
            h.text_TP_subImg_y,h.edit_TP_subImg_x,h.edit_TP_subImg_y],...
            'enable','off');
    end
end

