function checkbox_TA_clstDiag_Callback(obj,evd,h_fig)

h = guidata(h_fig);
p = h.param;
if ~isModuleOn(p,'TA')
    return
end

proj = p.curr_proj;
tpe = p.TDP.curr_type(proj);
tag = p.TDP.curr_tag(proj);
colList = p.TDP.colList;
curr = p.proj{proj}.TA.curr{tag,tpe};

val = get(obj,'value');

curr.clst_start{1}(9) = val;

% update cluster starting guess and colors
[curr,colList] = ud_clstPrm(curr,colList);

p.TDP.colList = colList;
p.proj{proj}.TA.curr{tag,tpe} = curr;
h.param = p;
guidata(h_fig, h);

updateFields(h_fig,'TDP');