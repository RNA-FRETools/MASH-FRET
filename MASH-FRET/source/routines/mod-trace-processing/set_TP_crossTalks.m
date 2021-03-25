function set_TP_crossTalks(bt,de,chanExc,wl,h_fig)
% set_TP_crossTalks(bt,de,chanExc,wl,h_fig)
%
% Set cross-talk coefficients to proper values
%
% bt: [nChan-by-nChan] bleedthrought coefficients
% de: [nChan-by-nL] direct excitation coefficients
% chanExc: [1-by-nChan] emitter-specific excitation wavelength (in nm)
% wl: [1-by-nL] laser wavelength in a chronological order (in nm)
% h_fig: handle to main figure

% collect interface parameters
h = guidata(h_fig);

[nChan,nL] = size(de);

for c = 1:nChan
    set(h.popupmenu_corr_chan,'value',c);
    popupmenu_corr_chan_Callback(h.popupmenu_corr_chan,[],h_fig);
    
    chan_bt = 1:nChan;
    chan_bt(c) = [];
    for c2 = 1:size(chan_bt,2)
        set(h.popupmenu_bt,'value',c2);
        popupmenu_bt_Callback(h.popupmenu_bt,[],h_fig);

        set(h.edit_bt,'string',num2str(bt(c,chan_bt(c2))));
        edit_bt_Callback(h.edit_bt,[],h_fig);
    end
    
    l0 = find(wl==chanExc(c));
    if isempty(l0)
        continue
    end
    las_de = 1:nL;
    las_de(l0) = [];
    for l = 1:size(las_de,2)
        set(h.popupmenu_corr_exc,'value',l);
        popupmenu_corr_exc_Callback(h.popupmenu_corr_exc,[],h_fig);
        
        set(h.edit_dirExc,'string',num2str(de(c,las_de(l))));
        edit_dirExc_Callback(h.edit_dirExc,[],h_fig);
    end
end

