function edit_photoblParam_01_Callback(obj, evd, h_fig)

h = guidata(h_fig);
p = h.param;
proj = p.curr_proj;
mol = p.ttPr.curr_mol(proj);
method = p.proj{proj}.TP.curr{mol}{2}{1}(2);
chan = h.popupmenu_bleachChan.Value;

if method~=2 % Threshold
    return
end

val = str2num(get(obj, 'String'));
set(obj, 'String', num2str(val));
if ~(~isempty(val) && isscalar(val) && ~isnan(val) && val<=1)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan('Relative data threshold must be <=1.', h_fig, 'error');
    return
end
p.proj{proj}.TP.curr{mol}{2}{2}(chan,1) = val;

h.param = p;
guidata(h_fig, h);

ud_bleach(h_fig);
