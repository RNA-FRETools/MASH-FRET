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
    incl = p{proj}.coord_incl;
    tags = p{proj}.molTag;
    tagsName = p{proj}.molTagNames;

    set(h.checkbox_TP_selectMol,'string',cat(2,'include molecule (',...
        num2str(sum(incl)),' included)'),'value',incl(mol));
    
    if incl(mol)
        colorlist = {'transparent','#4298B5','#DD5F32','#92B06A','#ADC4CC',...
            '#E19D29'};
        str_lst = cell(1,length(tagsName));
        str_lst{1} = tagsName{1};

        for k = 2:length(tagsName)
            str_lst{k} = ['<html><body  bgcolor="' colorlist{k} '">' ...
                '<font color="white">' tagsName{k} '</font></body></html>'];
        end
        set(h.popupmenu_TP_molLabel,'enable','on','string',str_lst,...
            'value',tags(mol));
        
    else
        set(h.popupmenu_TP_molLabel,'enable','off','value',1);
    end
    
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
end
