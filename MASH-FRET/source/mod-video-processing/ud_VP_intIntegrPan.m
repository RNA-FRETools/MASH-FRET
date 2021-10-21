function ud_VP_intIntegrPan(h_fig)
% ud_VP_intIntegrPan
%
% Set panel "Intensity integration" in module Video processing to proper values
%
% h_fig: handle to main figure

% default
str_yes = char(10004);
str_no = char(10006);
clr_yes = [0,0.5,0];
clr_no = 'red';

% collect interface parameters
h = guidata(h_fig);
p = h.param;

if ~prepPanel(h.uipanel_VP_intensityIntegration,h)
    return
end

% retrieve parameters
proj = p.curr_proj;
curr = p.proj{proj}.VP.curr;
coordsm = curr.res_crd{4};

if ~isempty(coordsm)
    h.text_VP_checkCoordsm.String = str_yes;
    h.text_VP_checkCoordsm.ForegroundColor = clr_yes;
else
    h.text_VP_checkCoordsm.String = str_no;
    h.text_VP_checkCoordsm.ForegroundColor = clr_no;
end

% set parameters
set(h.edit_TTgen_dim, 'String', num2str(curr.gen_int{3}(1)));
set(h.edit_intNpix, 'String', num2str(curr.gen_int{3}(2)));
set(h.checkbox_meanVal, 'Value', curr.gen_int{3}(3));


