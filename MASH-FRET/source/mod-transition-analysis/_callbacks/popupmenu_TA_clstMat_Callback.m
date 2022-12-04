function popupmenu_TA_clstMat_Callback(obj,evd,h_fig)

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

val = get(obj, 'Value');
if val~=1 % not matrix
    curr.clst_start{1}(9) = false; % diagonal clusters
end
curr.clst_start{1}(4) = get(obj,'Value');

% update cluster starting guess and colors
[curr,colList] = ud_clstPrm(curr,colList);

p.TDP.colList = colList;
p.proj{proj}.TA.curr{tag,tpe} = curr;

h.param = p;
guidata(h_fig, h);

updateFields(h_fig,'TDP');
