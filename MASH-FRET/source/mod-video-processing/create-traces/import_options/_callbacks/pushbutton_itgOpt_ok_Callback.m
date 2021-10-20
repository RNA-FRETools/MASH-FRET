function pushbutton_itgOpt_ok_Callback(obj, evd, h_fig, but_obj)

% update 28.3.2019 by MH: Correct parameter saving: if coordinates import option window is called from trace import options, parameters must be saved in figure_trImpOpt's handle instead of figure_MASH's handle.

h = guidata(h_fig);
p = h.param;
switch but_obj
    case h.pushbutton_TTgen_loadOpt
        nChan = p.proj{p.curr_proj}.nb_channel;
        impprm = p.proj{p.curr_proj}.VP.curr.gen_int{2}{3};
    case h.trImpOpt.pushbutton_impCoordOpt
        m = guidata(h.figure_trImpOpt);
        nChan = m{1}{1}(7);
        impprm = m{3}{3};
end

for i = 1:nChan
    impprm{1}(i,1:2) = ...
        [str2num(get(h.itgOpt.edit_cColX(i), 'String')) ...
        str2num(get(h.itgOpt.edit_cColY(i), 'String'))];
end
impprm{2} = str2num(get(h.itgOpt.edit_nHead, 'String'));

switch but_obj
    case h.pushbutton_TTgen_loadOpt
        p.proj{p.curr_proj}.VP.curr.gen_int{2}{3} = impprm;
        h.param = p;
        guidata(h_fig, h);
    case h.trImpOpt.pushbutton_impCoordOpt
        m{3}{3} = impprm;
        guidata(h.figure_trImpOpt,m);
end

close(h.figure_itgOpt);
