function edit_TA_slBin_Callback(obj,evd,h_fig)

h = guidata(h_fig);
p = h.param;
if ~isModuleOn(p,'TA')
    return
end

proj = p.curr_proj;
tpe = p.TDP.curr_type(proj);
tag = p.TDP.curr_tag(proj);
def = p.proj{proj}.TA.def{tag,tpe};
curr = p.proj{proj}.TA.prm{tag,tpe};

val = str2num(get(obj, 'String'));
set(obj, 'String', num2str(val));
if ~(numel(val)==1 && ~isnan(val) && val>=0)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    setContPan('State binning must be null or positive','error',h_fig);
    return
end

curr.lft_start{2}(3) = val;

% recalculate histograms and reset fit results
J = curr.lft_start{2}(1);
curr = ud_kinPrm(curr,def,J);

p.proj{proj}.TA.prm{tag,tpe} = curr;
p.proj{proj}.TA.curr{tag,tpe} = curr;
h.param = p;
guidata(h_fig, h);

ud_kinFit(h_fig);
updateTAplots(h_fig,'kin');

