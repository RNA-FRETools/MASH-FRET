function pushbutton_showDark_Callback(obj, evd, h_fig)
% pushbutton_showDark_Callback(obj, evd, h_fig)
% pushbutton_showDark_Callback(obj, evd, h_fig)
%
% h_fig: handle to main figure
% file_out: {1-by-1} destination image file to export dark trace to

% show process
setContPan('Calculating background trajectory...','process',h_fig);

if iscell(obj)
    file_out = obj{1};
    dispDarkTr(h_fig,file_out);
else
    dispDarkTr(h_fig);
end

% show success
setContPan('Background trajectory successfully calculated!','success',...
    h_fig);
