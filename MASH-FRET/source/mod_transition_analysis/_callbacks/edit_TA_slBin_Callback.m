function edit_TA_slBin_Callback(obj,evd,h_fig)

h = guidata(h_fig);
p = h.param.TDP;
if isempty(p.proj)
    return
end

val = str2num(get(obj, 'String'));
set(obj, 'String', num2str(val));
if ~(numel(val)==1 && ~isnan(val) && val>=0)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    setContPan('State binning must be null or positive','error',h_fig);
    return
end

proj = p.curr_proj;
tpe = p.curr_type(proj);
tag = p.curr_tag(proj);
prm = p.proj{proj}.prm{tag,tpe};
def = p.proj{proj}.def{tag,tpe};

prm.lft_start{2}(3) = val;

% recalculate histograms and reset fit results
J = prm.lft_start{2}(1);
prm = ud_kinPrm(prm,def,J);

p.proj{proj}.prm{tag,tpe} = prm;
p.proj{proj}.curr{tag,tpe} = prm;
h.param.TDP = p;
guidata(h_fig, h);

ud_kinFit(h_fig);
updateTAplots(h_fig,'kin');

