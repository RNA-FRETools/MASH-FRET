function ud_VP_coordTransfPan(h_fig)
% ud_VP_coordTransfPan(h_fig)
%
% Set panel "Coordinates transformation" in module Video processing to proper values
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
curr = p.proj{p.curr_proj}.VP.curr;
coord2tr = curr.res_crd{1};
tr = curr.res_crd{2};
coordref = curr.res_crd{3};

if ~prepPanel(h.uipanel_VP_coordinatesTransformation,h)
    return
end

if ~all(cellfun('isempty',coord2tr))
    h.text_VP_checkCoord2tr.String = str_yes;
    h.text_VP_checkCoord2tr.ForegroundColor = clr_yes;
else
    h.text_VP_checkCoord2tr.String = str_no;
    h.text_VP_checkCoord2tr.ForegroundColor = clr_no;
end

if ~isempty(tr)
    h.text_VP_checkTrsf.String = str_yes;
    h.text_VP_checkTrsf.ForegroundColor = clr_yes;
else
    h.text_VP_checkTrsf.String = str_no;
    h.text_VP_checkTrsf.ForegroundColor = clr_no;
end

if ~isempty(coordref)
    h.text_VP_checkCoordref.String = str_yes;
    h.text_VP_checkCoordref.ForegroundColor = clr_yes;
else
    h.text_VP_checkCoordref.String = str_no;
    h.text_VP_checkCoordref.ForegroundColor = clr_no;
end

