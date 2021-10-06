
function popupmenu_TA_clstMeth_Callback(obj,evd,h_fig)

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
curr.clst_start{1}(1) = val;

% update cluster starting guess and colors
[curr,colList] = ud_clstPrm(curr,colList);

p.proj{proj}.TA.curr{tag,tpe} = curr;
p.TDP.colList = colList;

h.param = p;
guidata(h_fig, h);

if val==2 % GM
    % deactivate selection tool if any
    tool = get(h.tooglebutton_TDPmanStart,'userdata');
    if tool==2
        tooglebutton_TDPselect_Callback(obj,evd,h_fig,1);
    end
end

updateFields(h_fig,'TDP');
