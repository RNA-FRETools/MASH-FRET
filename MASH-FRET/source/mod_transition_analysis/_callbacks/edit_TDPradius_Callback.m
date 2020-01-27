function edit_TDPradius_Callback(obj, evd, h_fig)

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
meth = p.proj{proj}.curr{tag,tpe}.clst_start{1}(1);

if ~(numel(val)==1 && ~isnan(val) && val >= 0)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    switch meth
        case 1 % kmean
            str = 'Tolerance radii';
        case 2 % gaussian model based
            str = 'Min. Gaussian standard deviation.';
    end
    setContPan([str ' must be >= 0.'], 'error', h_fig);
    return
end


switch meth
    case 1 % kmean
        state = get(h.popupmenu_TDPstate, 'Value');
        p.proj{proj}.curr{tag,tpe}.clst_start{2}(state,2) = val;

    case 2 % gaussian model based
        p.proj{proj}.curr{tag,tpe}.clst_start{2}(1,2) = val;
end

h.param.TDP = p;
guidata(h_fig, h);

updateFields(h_fig, 'TDP');

