function ud_TDPplot(h_fig)

% Last update by MH, 26.1.2020: do not update plot anymore (done only when pressing "update") and adapt to current (curr) and last applied (prm) parameters
% update by MH, 12.12.2019: give the colorbar's handle in plotTDP's input to prevent dependency on MASH main figure's handle and allow external use.

% collect interface parameters
h = guidata(h_fig);
p = h.param;

h_pan = h.uipanel_TA_transitionDensityPlot;
if ~prepPanel(h.uipanel_TA_transitionDensityPlot,h)
    return
end

% collect experiment settings
proj = p.curr_proj;
tpe = p.TDP.curr_type(proj);
tag = p.TDP.curr_tag(proj);
curr = p.proj{proj}.TA.curr{tag,tpe};

% collect processing parameters
bin = curr.plot{1}(1,1);
lim = curr.plot{1}(1,2:3);
gconv = curr.plot{1}(3,2);
norm = curr.plot{1}(3,3);
onecount = curr.plot{1}(4,1);
rearrng = curr.plot{1}(4,2);
incldiag = curr.plot{1}(4,3);
TDP = curr.plot{2};
cmap = curr.plot{4};

if numel(TDP)==1 && isnan(TDP)
    setProp(get(h_pan,'children'),'enable','off');
    return
end

set(h.edit_TDPbin, 'String', num2str(bin));
set(h.edit_TDPmin, 'String', num2str(lim(1)));
set(h.edit_TDPmax, 'String', num2str(lim(2)));
set(h.checkbox_TDPgconv, 'Value', gconv);
set(h.checkbox_TDPnorm, 'Value', norm);
set(h.checkbox_TDP_onecount, 'Value', onecount);
set(h.checkbox_TDPignore, 'Value', rearrng);
set(h.checkbox_TDP_statics, 'Value', incldiag);
set(h.popupmenu_TDPcmap,'value',cmap);

guidata(h_fig,h);
