function edit_TDPnStates_Callback(obj, evd, h_fig)

h = guidata(h_fig);
p = h.param;
if ~isModuleOn(p,'TA')
    return
end

proj = p.curr_proj;
tpe = p.TDP.curr_type(proj);
tag = p.TDP.curr_tag(proj);
curr = p.proj{proj}.TA.curr{tag,tpe};
colList = p.TDP.colList;

mat = curr.clst_start{1}(4);

val = round(str2double(get(obj, 'String')));
set(obj, 'String', num2str(val));
if ~(numel(val)==1 && ~isnan(val))
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    setContPan('Ill-defined number.', 'error', h_fig);
    return
elseif mat==1 && val<2 % matrix 
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    setContPan(cat(2,'Max. number of states in a matrix of clusters must ',...
        'be at least 2.'), 'error', h_fig);
    return
elseif mat~=1 && val<0
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    setContPan(cat(2,'Max. number of clusters must be at least 1.'), ...
        'error', h_fig);
    return
end

% update number of states/clusters
curr.clst_start{1}(3) = val;

% update cluster starting guess and colors
[curr,colList] = ud_clstPrm(curr,colList);

% save changes
p.TDP.colList = colList;
p.proj{proj}.TA.curr{tag,tpe} = curr;

h.param = p;
guidata(h_fig, h);

updateFields(h_fig,'TDP');

