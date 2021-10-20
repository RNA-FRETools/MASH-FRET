function radiobutton_rw_Callback(obj, evd, h_fig)

% retrieve parameters
h = guidata(h_fig);
nChan = p.proj{p.curr_proj}.nb_channel;

switch get(obj, 'Value')
    case 0
        set(h.trsfOpt.radiobutton_cw, 'FontWeight', 'bold', 'Value', 1);
        set(h.trsfOpt.text_nHead, 'Enable', 'on');
        set(h.trsfOpt.edit_nHead, 'Enable', 'on');
        set(h.trsfOpt.text_cColY, 'Enable', 'on');
        set(h.trsfOpt.text_cColX, 'Enable', 'on');
        for i = 1:nChan
            set(h.trsfOpt.edit_cColY(i), 'Enable', 'on');
            set(h.trsfOpt.edit_cColX(i), 'Enable', 'on');
            set(h.trsfOpt.text_cChan(i), 'Enable', 'on');
        end
        
        set(h.trsfOpt.radiobutton_rw, 'FontWeight', 'normal');
        set(h.trsfOpt.edit_rColY, 'Enable', 'off');
        set(h.trsfOpt.text_rColY, 'Enable', 'off');
        set(h.trsfOpt.edit_rColX, 'Enable', 'off');
        set(h.trsfOpt.text_rColX, 'Enable', 'off');
        set(h.trsfOpt.text_stop, 'Enable', 'off');
        set(h.trsfOpt.text_iv, 'Enable', 'off');
        set(h.trsfOpt.text_start, 'Enable', 'off');
        for i = 1:nChan
            set(h.trsfOpt.edit_stop(i), 'Enable', 'off');
            set(h.trsfOpt.edit_iv(i), 'Enable', 'off');
            set(h.trsfOpt.edit_start(i), 'Enable', 'off');
            set(h.trsfOpt.text_rChan(i), 'Enable', 'off');
        end
        set(h.trsfOpt.text_infos, 'Enable', 'off');
        
    case 1
        set(h.trsfOpt.radiobutton_cw, 'FontWeight', 'normal', 'Value', 0);
        set(h.trsfOpt.text_nHead, 'Enable', 'off');
        set(h.trsfOpt.edit_nHead, 'Enable', 'off');
        set(h.trsfOpt.text_cColY, 'Enable', 'off');
        set(h.trsfOpt.text_cColX, 'Enable', 'off');
        for i = 1:nChan
            set(h.trsfOpt.edit_cColY(i), 'Enable', 'off');
            set(h.trsfOpt.edit_cColX(i), 'Enable', 'off');
            set(h.trsfOpt.text_cChan(i), 'Enable', 'off');
        end
        
        set(h.trsfOpt.radiobutton_rw, 'FontWeight', 'bold');
        set(h.trsfOpt.edit_rColY, 'Enable', 'on');
        set(h.trsfOpt.text_rColY, 'Enable', 'on');
        set(h.trsfOpt.edit_rColX, 'Enable', 'on');
        set(h.trsfOpt.text_rColX, 'Enable', 'on');
        set(h.trsfOpt.text_stop, 'Enable', 'on');
        set(h.trsfOpt.text_iv, 'Enable', 'on');
        set(h.trsfOpt.text_start, 'Enable', 'on');
        for i = 1:nChan
            set(h.trsfOpt.edit_stop(i), 'Enable', 'on');
            set(h.trsfOpt.edit_iv(i), 'Enable', 'on');
            set(h.trsfOpt.edit_start(i), 'Enable', 'on');
            set(h.trsfOpt.text_rChan(i), 'Enable', 'on');
        end
        set(h.trsfOpt.text_infos, 'Enable', 'on');
end
