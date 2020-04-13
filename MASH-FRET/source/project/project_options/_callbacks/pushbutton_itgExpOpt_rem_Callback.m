function pushbutton_itgExpOpt_rem_Callback(obj, evd, but_obj, h_fig)
h = guidata(h_fig);
p_select = get(h.itgExpOpt.listbox_prm, 'Value');
if p_select > 0
    p_prev = guidata(h.figure_itgExpOpt);
    p = cell(1,3);
    str_exc = get(h.itgExpOpt.popupmenu_dyeExc,'String');
    nExc = size(str_exc,1)-1;
    for i = 1:size(p_prev{1},1)
        if i ~= p_select + 4 + nExc
            p{1} = [p{1};{p_prev{1}{i,1} p_prev{1}{i,2} p_prev{1}{i,3}}];
        end
    end
    p{3} = p_prev{3};
    p{4} = p_prev{4};
    p{5} = p_prev{5};
    p{6} = p_prev{6};
    p{7} = p_prev{7};
    guidata(h.figure_itgExpOpt, p);
    
    str_chan = get(h.itgExpOpt.popupmenu_dyeChan,'String');
    nChan = size(str_chan,1);
    str_exc = get(h.itgExpOpt.popupmenu_dyeExc,'String');
    nExc = size(str_exc,1)-1;
    
    buildWinOpt(p, nExc, nChan, but_obj, h_fig);
end