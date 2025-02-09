function edit_TDPfit_decLow_Callback(obj, evd, h_fig)

h = guidata(h_fig);
p = h.param;
if ~isModuleOn(p,'TA')
    return
end

proj = p.curr_proj;
tpe = p.TDP.curr_type(proj);
tag = p.TDP.curr_tag(proj);
curr = p.proj{proj}.TA.curr{tag,tpe};

val = str2num(get(obj, 'String'));
set(obj, 'String', num2str(val));
if ~(numel(val)==1 && ~isnan(val) && val >= 0)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    setContPan('Exp. time decay must be >= 0', 'error', h_fig);
    return
end

v = curr.lft_start{2}(2);
strch = curr.lft_start{1}{v,1}(2);
if strch
    n = 1;
else
    n = curr.lft_start{1}{v,1}(4);
end

p.proj{proj}.TA.curr{tag,tpe}.lft_start{1}{v,2}(n,4) = val;

h.param = p;
guidata(h_fig, h);

ud_fitSettings(h_fig);

