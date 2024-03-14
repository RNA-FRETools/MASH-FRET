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
proj = p.curr_proj;
nChan = p.proj{proj}.nb_channel;
curr = p.proj{proj}.VP.curr;
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

if nChan==1
    set([h.pushbutton_impCoord,h.pushbutton_trGo,h.pushbutton_expTrsfCoord,...
        h.text_VP_checkTrsf,h.text_VP_checkTrsf,h.text_VP_transfFile,...
        h.pushbutton_trLoad,h.pushbutton_calcTfr,h.pushbutton_checkTr,...
        h.pushbutton_saveTfr,h.text_VP_checkCoordref,h.text_VP_calcTransfo,...
        h.pushbutton_trLoadRef,h.pushbutton_trMap,h.pushbutton_trSaveRef,...
        h.pushbutton_trOpt],'visible','off','enable','off');
end

