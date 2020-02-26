function routinetest_TP_crossTalks(h_fig,p,prefix)
% routinetest_TP_crossTalks(h_fig,p,prefix)
%
% Tests bleedthrough and direct excitation coefficients
%
% h_fig: handle to main figure
% p: structure containing default as set by getDefault_TP
% prefix: string to add at the beginning of each action string (usually a specific indent)

h = guidata(h_fig);

setDefault_TP(h_fig,p);

disp(cat(2,prefix,'test bleedthrough coefficients...'));
for c = 1:p.nChan
    set(h.popupmenu_corr_chan,'value',c);
    popupmenu_corr_chan_Callback(h.popupmenu_corr_chan,[],h_fig);
    
    chan_bt = 1:p.nChan;
    chan_bt(c) = [];
    for c2 = 1:size(chan_bt,2)
        set(h.popupmenu_bt,'value',c2);
        popupmenu_bt_Callback(h.popupmenu_bt,[],h_fig);

        set(h.edit_bt,'string',num2str(p.bt(c,chan_bt(c2))));
        edit_bt_Callback(h.edit_bt,[],h_fig);
    end
end

disp(cat(2,prefix,'test direct excitation coefficients...'));
for c = 1:p.nChan
    set(h.popupmenu_corr_chan,'value',c);
    popupmenu_corr_chan_Callback(h.popupmenu_corr_chan,[],h_fig);
    
    l0 = find(p.wl(1:p.nL)==p.projOpt{p.nL,p.nChan}.chanExc(c));
    if isempty(l0)
        continue
    end
    las_de = 1:p.nL;
    las_de(l0) = [];
    for l = 1:size(las_de,2)
        set(h.popupmenu_corr_exc,'value',l);
        popupmenu_corr_exc_Callback(h.popupmenu_corr_exc,[],h_fig);
        
        set(h.edit_dirExc,'string',num2str(p.de(c,las_de(l))));
        edit_dirExc_Callback(h.edit_dirExc,[],h_fig);
    end
end

pushbutton_remTraces_Callback(h.pushbutton_remTraces,[],h_fig);

