function popupmenu_TDPstate_Callback(obj, evd, h)
p = h.param.TDP;
if ~isempty(p.proj)
    proj = p.curr_proj;
    tpe = p.curr_type(proj);
    val = get(obj, 'Value');
    meth = p.proj{proj}.prm{tpe}.clst_start{1}(1);
    switch meth
        case 1 % k-mean
            nStates = p.proj{proj}.prm{tpe}.clst_start{1}(3);
            if val > nStates
                set(obj, 'Value', 1);
            end
        case 2 % GMM
            p.proj{proj}.prm{tpe}.clst_start{1}(2) = val;
            h.param.TDP = p;
            guidata(h.figure_MASH, h);
    end
    updateFields(h.figure_MASH, 'TDP');
end