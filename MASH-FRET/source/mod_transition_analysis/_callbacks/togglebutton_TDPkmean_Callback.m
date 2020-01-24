function togglebutton_TDPkmean_Callback(obj, evd, h_fig)
h = guidata(h_fig);
p = h.param.TDP;
if ~isempty(p.proj)
    proj = p.curr_proj;
    tpe = p.curr_type(proj);
    tag = p.curr_tag(proj);
    p.proj{proj}.prm{tag,tpe}.clst_start{1}(1) = 1;
    h.param.TDP = p;
    guidata(h_fig, h);
    
    % reset previous clustering results if exist
    pushbutton_TDPresetClust_Callback(h.pushbutton_TDPresetClust,[],h_fig);
end