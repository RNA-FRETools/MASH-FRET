function checkbox_TA_clstDiag_Callback(obj,evd,h_fig)

h = guidata(h_fig);
p = h.param.TDP;
if isempty(p.proj)
    return
end

proj = p.curr_proj;
tpe = p.curr_type(proj);
tag = p.curr_tag(proj);
curr = p.proj{proj}.curr{tag,tpe};
val = get(obj,'value');

curr.clst_start{1}(9) = val;

% update cluster starting guess and colors
[curr,p.colList] = ud_clstPrm(curr,p.colList);

p.proj{proj}.curr{tag,tpe} = curr;
h.param.TDP = p;
guidata(h_fig, h);

updateFields(h_fig,'TDP');