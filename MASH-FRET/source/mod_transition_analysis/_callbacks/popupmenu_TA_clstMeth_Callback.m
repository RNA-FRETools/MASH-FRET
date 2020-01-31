function popupmenu_TA_clstMeth_Callback(obj,evd,h_fig)

h = guidata(h_fig);
p = h.param.TDP;
if isempty(p.proj)
    return
end

proj = p.curr_proj;
tpe = p.curr_type(proj);
tag = p.curr_tag(proj);

val = get(obj,'value');
p.proj{proj}.curr{tag,tpe}.clst_start{1}(1) = val;

% update cluster starting guess and colors
[p.proj{proj}.curr{tag,tpe},p.colList] = ...
    ud_clstPrm(p.proj{proj}.curr{tag,tpe},p.colList);

h.param.TDP = p;
guidata(h_fig, h);

if val==2 % GM
    % deactivate selection tool if any
    tool = get(h.tooglebutton_TDPmanStart,'userdata');
    if tool==2
        tooglebutton_TDPselect_Callback(obj,evd,h_fig,1);
    end
end

updateFields(h_fig,'TDP');
