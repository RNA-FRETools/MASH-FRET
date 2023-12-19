function push_setExpSet_next(obj,evd,h_fig,n)

h = guidata(h_fig);
switch n
    case 1
        if isfield(h,'tab_chan') && ishandle(h.tab_chan)
            h.tabg.SelectedTab = h.tab_chan;
        else
            h.tabg.SelectedTab = h.tab_fstrct;
        end
    case 2
        h.tabg.SelectedTab = h.tab_exc;
    case 3
        h.tabg.SelectedTab = h.tab_calc;
    case 4
        if isfield(h,'tab_fstrct') && ishandle(h.tab_fstrct)
            h.tabg.SelectedTab = h.tab_fstrct;
        else
            h.tabg.SelectedTab = h.tab_div;
        end
    case 5
        h.tabg.SelectedTab = h.tab_div;
    otherwise
        disp('argument ''n'' is out of range')
end

