function ud_subImg(h_fig)
h = guidata(h_fig);
p = h.param.ttPr.proj;
if ~isempty(p)
    proj = h.param.ttPr.curr_proj;
    mol = h.param.ttPr.curr_mol(proj);
    refocus = p{proj}.fix{1}(5);
    nExc = p{proj}.nb_excitations;
    nChan = p{proj}.nb_channel;
    coord = p{proj}.coord;
    
    % get channel and laser corresponding to selected data
    selected_chan = p{proj}.fix{3}(6);
    chan = 0;
    for l = 1:nExc
        for c = 1:nChan
            chan = chan+1;
            if chan==selected_chan
                break;
            end
        end
        if chan==selected_chan
            break;
        end
    end
    
    if p{proj}.is_coord
        p_panel = p{proj}.fix{1};
        meth = p{proj}.prm{mol}{3}{2}(l,c);
        subdim = p{proj}.prm{mol}{3}{3}{l,c}(meth,2);
        set(h.popupmenu_subImg_exc, 'Value', p_panel(1));
        set(h.checkbox_refocus, 'Value', refocus);
        set(h.edit_subImg_dim, 'String', num2str(subdim), ...
            'BackgroundColor', [1 1 1]);
        
        set(h.slider_brightness, 'Value', (p_panel(3)+1)/2);
        set(h.slider_contrast, 'Value', (p_panel(4)+1)/2);
        set(h.text_brightness, 'String', [num2str(100*p_panel(3)) '%']);
        set(h.text_contrast, 'String', [num2str(100*p_panel(4)) '%']);
        
        chan = get(h.popupmenu_TP_subImg_channel,'value');
        if ~isempty(coord)
            set(h.edit_TP_subImg_x,'string',num2str(coord(mol,2*chan-1)));
            set(h.edit_TP_subImg_y,'string',num2str(coord(mol,2*chan)));
        else
            set([h.edit_TP_subImg_x h.edit_TP_subImg_y],'string','');
        end
    end
    
    if p{proj}.is_movie && p{proj}.is_coord
        for c = 1:nChan
            set(h.axes_subImg(c),'FontUnits',get(h.axes_top,'FontUnits'),...
                'FontSize',get(h.axes_top,'FontSize'));
        end
    end
end
