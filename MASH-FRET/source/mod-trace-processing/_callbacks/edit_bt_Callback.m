function edit_bt_Callback(obj, evd, h_fig)

% Last update by MH 29.3.2019
% >> adapt bleethrough coefficients to new parameter structure (see 
%    project/setDefPrm_traces.m)

h = guidata(h_fig);
p = h.param;
proj = p.curr_proj;
chan_in = p.proj{proj}.TP.fix{3}(2);
chan_out = p.proj{proj}.TP.fix{3}(3);

val = str2num(get(obj, 'String'));
if ~(~isempty(val) && numel(val)==1 && ~isnan(val) && val>=0 && val<=1)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan('Bleedthrough coefficient must be >= 0 and <= 1',h_fig,...
        'error');
    return
end

if val==p.proj{proj}.TP.fix{4}{1}(chan_in,chan_out)
    return
end

p.proj{proj}.TP.fix{4}{1}(chan_in,chan_out) = val;

%added by MH, 16.1.2020
p.proj{proj}.intensities_crossCorr = ...
    NaN(size(p.proj{proj}.intensities_crossCorr));

h.param = p;
guidata(h_fig, h);

ud_cross(h_fig);

