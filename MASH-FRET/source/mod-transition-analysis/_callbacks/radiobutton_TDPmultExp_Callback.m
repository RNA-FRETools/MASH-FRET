function radiobutton_TDPmultExp_Callback(obj, evd, h_fig)

h = guidata(h_fig);
p = h.param.TDP;
if isempty(p.proj)
    return
end

proj = p.curr_proj;
tpe = p.curr_type(proj);
tag = p.curr_tag(proj);
v = p.proj{proj}.curr{tag,tpe}.lft_start{2}(2);
strtch = p.proj{proj}.curr{tag,tpe}.lft_start{1}{v,1}(2);
if strtch==get(obj, 'Value') && strtch
    strtch = ~get(obj, 'Value');
    
    p.proj{proj}.curr{tag,tpe}.lft_start{1}{v,1}(2) = strtch;

    h.param.TDP = p;
    guidata(h_fig, h);
end

ud_fitSettings(h_fig);
