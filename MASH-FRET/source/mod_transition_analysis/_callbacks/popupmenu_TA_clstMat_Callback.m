function popupmenu_TA_clstMat_Callback(obj,evd,h_fig)

h = guidata(h_fig);
p = h.param.TDP;
if isempty(p.proj)
    return
end

proj = p.curr_proj;
tpe = p.curr_type(proj);
tag = p.curr_tag(proj);
curr = p.proj{proj}.curr{tag,tpe};
val = get(obj, 'Value');

if val~=1 % not matrix
    curr.clst_start{1}(9) = false; % diagonal clusters
end
curr.clst_start{1}(4) = get(obj,'Value');

% update cluster starting guess and colors
[curr,p.colList] = ud_clstPrm(curr,p.colList);

p.proj{proj}.curr{tag,tpe} = curr;
h.param.TDP = p;
guidata(h_fig, h);

updateFields(h_fig,'TDP');