function push_setExpSet_clr(obj,evd,h_fig)

% retrieve interface content
h = guidata(h_fig);

% retieve project parameters
proj = h_fig.UserData;

% open color picker
clr = uisetcolor('Set a trace color');
if numel(clr)==1
    return
end

% save color in project parameters
chan = get(h.popup_chanClr,'value');
nFRET = size(proj.FRET,1);
nS = size(proj.S,1);
if chan<=nFRET
    proj.colours{2}(chan,:) = clr;
elseif chan<=(nFRET+nS)
    s = chan-nFRET;
    proj.colours{3}(s,:) = clr;
else
    I = chan-nFRET-nS;
    l = ceil(I/proj.nb_channel);
    c = I-(l-1)*proj.nb_channel;
    proj.colours{1}{l,c} = clr;
end
h_fig.UserData = proj;

% update panel "Divers"
ud_setExpSet_tabFstrct(h_fig);
ud_setExpSet_tabDiv(h_fig);
