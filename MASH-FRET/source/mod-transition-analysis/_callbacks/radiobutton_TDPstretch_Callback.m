function radiobutton_TDPstretch_Callback(obj, evd, h_fig)

% get interface parameters
h = guidata(h_fig);
p = h.param;
if ~isModuleOn(p,'TA')
    return
end

proj = p.curr_proj;
tag = p.TDP.curr_tag(proj);
tpe = p.TDP.curr_type(proj);
curr = p.proj{proj}.TA.curr{tag,tpe};

v = curr.lft_start{2}(2);
strtch = curr.lft_start{1}{v,1}(2);
if strtch~=get(obj,'Value') && ~strtch
    p.proj{proj}.TA.curr{tag,tpe}.lft_start{1}{v,1}(2) = get(obj,'Value');

    h.param = p;
    guidata(h_fig, h);
end

ud_fitSettings(h_fig);
