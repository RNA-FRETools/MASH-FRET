function edit_intNpix_Callback(obj, evd, h_fig)

% get VP parameters
h = guidata(h_fig);
p = h.param;
curr = p.proj{p.curr_proj}.VP.curr;
pxdim = curr.gen_int{3}(1);

% retrieve value from edit field
nMax = pxdim^2;
val = round(str2double(get(obj,'String')));
if val>nMax
    val = nMax;
end
set(obj, 'String', num2str(val));
if ~(~isempty(val) && numel(val) == 1 && ~isnan(val) && val > 0)
    set(obj, 'BackgroundColor', [1 0.75 0.75]);
    updateActPan('Number of integrated pixels must be an integer > 0.', ...
        h_fig, 'error');
    return
end

% save number of brigthest pixels
curr.gen_int{3}(1) = val;
    
% save modifications
p.proj{p.curr_proj}.VP.curr = curr;
h.param = p;
guidata(h_fig, h);

% set GUI to proper values 
ud_VP_intIntegrPan(h_fig);

