function edit_TDPiniVal_Callback(obj, evd, ind, h_fig)

h = guidata(h_fig);
p = h.param;
if ~isModuleOn(p,'TA')
    return
end

proj = p.curr_proj;
tpe = p.TDP.curr_type(proj);
tag = p.TDP.curr_tag(proj);
curr = p.proj{proj}.TA.curr{tag,tpe};

meth = curr.clst_start{1}(1);

val = str2num(get(obj, 'String'));
set(obj, 'String', num2str(val));

if ~sum(meth==[1,3]) % k-mean or manual
    return
end

if ~(numel(val)==1 && ~isnan(val))
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    setContPan('State values must be numeric.', 'error', h_fig);
    return
end

J = curr.clst_start{1}(3);
mat = curr.clst_start{1}(4);
clstDiag = curr.clst_start{1}(9);

% get cluster index(es)
if mat==1 % matrix
    state = get(h.popupmenu_TDPstate, 'Value');
    nTrs = getClusterNb(J,mat,clstDiag);
    [j1,j2] = getStatesFromTransIndexes(1:nTrs,J,mat,clstDiag);
    kx = j1==state;
    ky = j2==state;
    curr.clst_start{2}(kx,1) = val;
    curr.clst_start{2}(ky,2) = val;
    
elseif mat==2 % symmetrical
    k = get(h.popupmenu_TDPstate, 'Value');
    kinv = k+J;
    curr.clst_start{2}(k,ind) = val;
    curr.clst_start{2}(kinv,[1,2]~=ind) = val;
    
else
    k = get(h.popupmenu_TDPstate, 'Value');
    curr.clst_start{2}(k,ind) = val;
end

p.proj{proj}.TA.curr{tag,tpe} = curr;
h.param = p;
guidata(h_fig, h);

updateFields(h_fig, 'TDP');

