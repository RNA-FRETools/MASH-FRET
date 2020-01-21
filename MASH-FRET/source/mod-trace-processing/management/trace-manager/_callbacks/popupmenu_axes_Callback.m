function popupmenu_axes_Callback(obj, evd, h_fig)

h = guidata(h_fig);

dat3 = get(h.tm.axes_histSort,'userdata');
if ~sum(dat3.slct)
    return;
end

p = h.param.ttPr;
proj = p.curr_proj;
nChan = p.proj{proj}.nb_channel;
nExc = p.proj{proj}.nb_excitations;
FRET = p.proj{proj}.FRET;
nFRET = size(FRET,1);
S = p.proj{proj}.S;
nS = size(S,1);

if obj==h.tm.popupmenu_axes2
    plot2 = get(obj, 'Value');
    if plot2 <= nChan*nExc+nFRET+nS
        dat1 = get(h.tm.axes_ovrAll_1, 'UserData');
        set(h.tm.edit_xlim_low, 'String', dat1.lim{plot2}(1));
        set(h.tm.edit_xlim_up, 'String', dat1.lim{plot2}(2));
        set(h.tm.edit_xnbiv, 'String', dat1.niv(plot2));
    else % double check RB 2018-01-04
        dat1 = get(h.tm.axes_ovrAll_1, 'UserData');
        set(h.tm.edit_xlim_low, 'String',  dat1.lim{plot2}(1,1));
        set(h.tm.edit_xlim_up, 'String', dat1.lim{plot2}(1,2));
        set(h.tm.edit_xnbiv, 'String', dat1.niv(plot2));
    end
end

if obj==h.tm.popupmenu_axes1 || obj==h.tm.popupmenu_AS_plot1
    plot1 = get(obj,'value');
    set([h.tm.popupmenu_axes1,h.tm.popupmenu_AS_plot1],'value',plot1);
end

plotData_overall(h_fig);

if obj==h.tm.popupmenu_axes1 || obj==h.tm.popupmenu_AS_plot1
    % refresh subpopulations & plot on concatenated traces
    ud_panRanges(h_fig);
end
    
