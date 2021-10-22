function popupmenu_BA_data_Callback(obj, evd, h_fig)

h = guidata(h_fig);
g = guidata(h.bga.figure_bgopt);

p = h.param;
proj = p.curr_proj;
nChan = p.proj{proj}.nb_channel;
nExc = p.proj{proj}.nb_excitations;

selected_chan = get(obj, 'Value');

% get channel and laser corresponding to selected data
chan = 0;
for l = 1:nExc
    for c = 1:nChan
        chan = chan+1;
        if chan==selected_chan
            break;
        end
    end
    if chan==selected_chan
        break;
    end
end

g.curr_c = c;
g.curr_l = l;

% update g structure
guidata(g.figure_bgopt, g);
ud_BAfields(g.figure_bgopt);
plot_bgRes(g.figure_bgopt);


