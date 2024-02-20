function ud_sampling(h_fig)

% collect interface parameters
h = guidata(h_fig);
p = h.param;

if ~prepPanel(h.uipanel_TP_sampling,h)
    return
end

% collect experiment settings and video parameters
proj = p.curr_proj;
fix = p.proj{proj}.TP.fix;

% set sampling time
set(h.edit_TP_sampling_time,'String',num2str(fix{5}));