function edit_ivMov_Callback(obj,evd,h_fig)

% default
redclr = [1,0.94,0.94];

% retrieve value from edit field
val = round(str2double(obj.String));
obj.String = num2str(val);
if ~(numel(val)==1 && val>0)
    setContPan('Frame interval must be strictly positive.','error',h_fig);
    set(obj,'backgroundcolor',redclr);
    return
end

% save modifications
h = guidata(h_fig);
p = h.param;

p.proj{p.curr_proj}.VP.curr.edit{2}(3) = val;

h.param = p;
guidata(h_fig,h);

% refresh panel
ud_VP_edExpVidPan(h_fig);