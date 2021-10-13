function push_setExpSet_next(obj,evd,h_fig,n)

h = guidata(h_fig);
switch n
    case 1
        h.tabg.SelectedTab = h.tab_chan;
    case 2
        h.tabg.SelectedTab = h.tab_exc;
    case 3
        h.tabg.SelectedTab = h.tab_calc;
    case 4
        h.tabg.SelectedTab = h.tab_div;
    otherwise
        disp('argument ''n'' is out of range')
end

