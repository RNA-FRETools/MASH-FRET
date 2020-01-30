function edit_TDPnStates_Callback(obj, evd, h_fig)

h = guidata(h_fig);
p = h.param.TDP;
if isempty(p.proj)
    return
end

val = round(str2num(get(obj, 'String')));
set(obj, 'String', num2str(val));
if ~(numel(val)==1 && ~isnan(val) && val > 1)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    setContPan('Max. number of states must be > 1', 'error', ...
        h_fig);
    return
end

proj = p.curr_proj;
tpe = p.curr_type(proj);
tag = p.curr_tag(proj);
curr = p.proj{proj}.curr{tag,tpe};

% update number of states/clusters
curr.clst_start{1}(3) = val;

% update cluster starting guess and colors
[curr,p.colList] = ud_clstPrm(curr,p.colList);

% save changes
p.proj{proj}.curr{tag,tpe} = curr;

h.param.TDP = p;
guidata(h_fig, h);

updateFields(h_fig, 'TDP');

