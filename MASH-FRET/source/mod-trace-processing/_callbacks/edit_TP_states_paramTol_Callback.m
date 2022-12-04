function edit_TP_states_paramTol_Callback(obj, evd, h_fig)

% Last update: by MH, 3.4.2019
% >> adjust selected data index in popupmenu, chan_in, to shorter 
%    popupmenu size when discretization is only applied to bottom traces
% >> correct destination for tolerance window size parameter: specific to
%    each bottom trace data

h = guidata(h_fig);
p = h.param;
proj = p.curr_proj;
mol = p.ttPr.curr_mol(proj);
chan_in = p.proj{proj}.TP.fix{3}(4);
method = p.proj{proj}.TP.curr{mol}{4}{1}(1);
toFRET = p.proj{proj}.TP.curr{mol}{4}{1}(2);

if toFRET
    return
end
val = round(str2num(get(obj, 'String')));
set(obj, 'String', num2str(val));
valMax = ...
    p.proj{proj}.nb_excitations*size(p.proj{proj}.intensities,1);
if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && ...
        val >= 0 && val <= valMax)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan(['Width of changing zone must be >= 0 and <= ' ...
        num2str(valMax)], h_fig, 'error');
    return
end

% corrected by MH, 3.4.2019
p.proj{proj}.TP.curr{mol}{4}{2}(method,4,chan_in) = val;

h.param = p;
guidata(h_fig, h);

ud_DTA(h_fig);
