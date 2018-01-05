function edit_TDPiniVal_Callback(obj, evd, h)
p = h.param.TDP;
if ~isempty(p.proj)
    val = str2num(get(obj, 'String'));
    set(obj, 'String', num2str(val));
    
    if ~(numel(val)==1 && ~isnan(val))
        set(obj, 'BackgroundColor', [1 0.75 0.75]);
        setContPan('State values must be numeric.', 'error', ...
            h.figure_MASH);
        
    else
        proj = p.curr_proj;
        tpe = p.curr_type(proj);
        state = get(h.popupmenu_TDPstate, 'Value');
        p.proj{proj}.prm{tpe}.clst_start{2}(state,1) = val;
        h.param.TDP = p;
        guidata(h.figure_MASH, h);
        updateFields(h.figure_MASH, 'TDP');
    end
end