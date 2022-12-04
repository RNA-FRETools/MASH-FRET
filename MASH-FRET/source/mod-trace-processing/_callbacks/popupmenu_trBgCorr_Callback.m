function popupmenu_trBgCorr_Callback(obj, evd, h_fig)

h = guidata(h_fig);
p = h.param;
proj = p.curr_proj;
mol = p.ttPr.curr_mol(proj);
nExc = p.proj{proj}.nb_excitations;
nChan = p.proj{proj}.nb_channel;
selected_chan = p.proj{proj}.TP.fix{3}(6);

% get channel and laser corresponding to selected data
chan = 0;
for l = 1:nExc
    for c = 1:nChan
        chan = chan+1;
        if chan==selected_chan
            break
        end
    end
    if chan==selected_chan
        break
    end
end

p.proj{proj}.TP.curr{mol}{3}{2}(l,c) = get(obj, 'Value');

h.param = p;
guidata(h_fig, h);

ud_ttBg(h_fig);
