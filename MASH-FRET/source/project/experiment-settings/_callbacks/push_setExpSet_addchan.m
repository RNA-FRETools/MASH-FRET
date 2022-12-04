function push_setExpSet_addchan(obj,evd,h_fig,h_fig0)

h = guidata(h_fig);
proj = h_fig.UserData;

nChan = proj.nb_channel+1;
if nChan>10
    nChan = 10;
end

h.edit_nChan.String = num2str(nChan);
edit_setExpSet_nChan(h.edit_nChan,[],h_fig,h_fig0);