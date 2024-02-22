function edit_TP_sampling_time_Callback(obj,evd,h_fig)

% defaults
nsample = 10;

h = guidata(h_fig);
p = h.param;
proj = p.curr_proj;
expT0 = p.proj{proj}.sampling_time;
[L,~,nExc] = size(p.proj{proj}.intensities);

val = str2num(get(obj, 'String'));
minval = expT0;
maxval = L*nExc*expT0/nsample;
set(obj, 'String', num2str(val));
if ~(numel(val)==1 && ~isnan(val) && val>=minval && val<=maxval)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan(['Trajectory sampling time must be >= ' num2str(minval) ...
        ' and <= ' num2str(maxval)], h_fig, 'error');
    return
end
if val==p.proj{proj}.TP.fix{5}
    return
end

p.proj{proj}.TP.fix{5} = val;
p.proj{proj}.intensities_bin = NaN(size(p.proj{proj}.intensities_bgCorr));

h.param = p;
guidata(h_fig, h);

ud_sampling(h_fig);
