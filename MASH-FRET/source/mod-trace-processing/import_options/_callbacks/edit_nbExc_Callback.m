function edit_nbExc_Callback(obj, evd, h_fig)
val = round(str2num(get(obj, 'String')));
set(obj, 'String', num2str(val));
if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val > 0)
    updateActPan('Number of excitation must be > 0', h_fig, 'error');
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
else
    set(obj, 'BackgroundColor', [1 1 1]);
    h = guidata(h_fig);
    m = guidata(h.figure_trImpOpt);
    m{1}{1}(8) = val;
    str_pop = {};
    for i = 1:val
        if i > numel(m{1}{2})
            m{1}{2}(i) = round(m{1}{2}(1)*(1 + 0.2*(i-1)));
        end
        str_pop = {str_pop{:} ['exc. ' num2str(i)]};
    end
    guidata(h.figure_trImpOpt, m);
    set(h.trImpOpt.popupmenu_exc, 'Value', 1, 'String', str_pop);
end


