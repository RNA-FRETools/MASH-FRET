function radiobutton_TDPstretch_Callback(obj, evd, h_fig)

h = guidata(h_fig);
p = h.param.TDP;
if isempty(p.proj)
    return
end

proj = p.curr_proj;
tpe = p.curr_type(proj);
tag = p.curr_tag(proj);
trs = p.proj{proj}.curr{tag,tpe}.kin_start{2}(2);
kin_k = p.proj{proj}.curr{tag,tpe}.kin_start{1};
if kin_k{trs,1}(1) ~= get(obj, 'Value') && ~kin_k{trs,1}(1)
    kin_k{trs,1}(1) = get(obj, 'Value');
    
    p.proj{proj}.curr{tag,tpe}.kin_start{1} = kin_k;

    h.param.TDP = p;
    guidata(h_fig, h);
end

ud_kinFit(h_fig);
