function edit_photoblParam_03_Callback(obj, evd, h_fig)

h = guidata(h_fig);
p = h.param;
proj = p.curr_proj;
mol = p.ttPr.curr_mol(proj);
expT = p.proj{proj}.resampling_time;
inSec = p.proj{proj}.time_in_sec;
method = p.proj{proj}.TP.curr{mol}{2}{1}(2);

if method~=2 % Threshold
    return
end

chan = h.popupmenu_bleachChan.Value;
set(obj,'string',num2str(p.proj{proj}.TP.curr{mol}{2}{2}(chan,3)))
