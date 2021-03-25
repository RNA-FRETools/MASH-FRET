function edit_param_Callback(obj, evd, i, h_fig)
h = guidata(h_fig);
p = guidata(h.figure_itgExpOpt);
val = get(obj,'String');
if ~sum(double(i == [1 2]))
    if ~isempty(val)
        val = str2num(val);
        set(obj, 'String', num2str(val));
        if ~(numel(val) == 1 && ~isnan(val))
            set(obj, 'BackgroundColor', [1 0.75 0.75]);
            updateActPan('Parameter values must be numeric.', h_fig, ...
                'error');
        else
            set(obj, 'BackgroundColor', [1 1 1]);
            p{1}{i,2} = val;
            guidata(h.figure_itgExpOpt, p);
        end
    else
        set(obj, 'BackgroundColor', [1 1 1]);
        p{1}{i,2} = val;
        guidata(h.figure_itgExpOpt, p);
    end
else
    p{1}{i,2} = val;
    guidata(h.figure_itgExpOpt, p);
end