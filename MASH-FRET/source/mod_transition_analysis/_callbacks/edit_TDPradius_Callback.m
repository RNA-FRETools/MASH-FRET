function edit_TDPradius_Callback(obj, evd, ind, h_fig)

h = guidata(h_fig);
p = h.param.TDP;
if isempty(p.proj)
    return
end

val = str2num(get(obj, 'String'));
set(obj, 'String', num2str(val));
proj = p.curr_proj;
tpe = p.curr_type(proj);
tag = p.curr_tag(proj);
curr = p.proj{proj}.curr{tag,tpe};
meth = curr.clst_start{1}(1);

if ~sum(meth==[1,3]) % k-mean or manual
    return
end

if ~(numel(val)==1 && ~isnan(val) && val >= 0)
    setContPan('Tolerance radii must be >= 0.', 'error', h_fig);
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
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
    p.proj{proj}.curr{tag,tpe}.clst_start{2}(kx,3) = val;
    p.proj{proj}.curr{tag,tpe}.clst_start{2}(ky,4) = val;
    
elseif mat==2 % symmetrical
    k = get(h.popupmenu_TDPstate, 'Value');
    kinv = k+J;
    indinv = find([3,4]~=(ind+2))+2;
    p.proj{proj}.curr{tag,tpe}.clst_start{2}(k,ind+2) = val;
    p.proj{proj}.curr{tag,tpe}.clst_start{2}(kinv,indinv) = val;
    
else
    k = get(h.popupmenu_TDPstate, 'Value');
    p.proj{proj}.curr{tag,tpe}.clst_start{2}(k,2+ind) = val;
end

h.param.TDP = p;
guidata(h_fig, h);

updateFields(h_fig, 'TDP');

