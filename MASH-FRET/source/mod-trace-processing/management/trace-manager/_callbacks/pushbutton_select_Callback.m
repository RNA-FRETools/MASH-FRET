function pushbutton_select_Callback(obj,evd,h_fig)

h = guidata(h_fig);

meth = get(h.tm.popupmenu_selection,'value');
tag = get(h.tm.popupmenu_selectTags,'value')-1;

if meth==1 % current
    return
end
if meth>4 && tag==0 % condition on tag
    return
end

switch meth
    case 2 % all
        h.tm.molValid(1:end) = true;
    case 3 % none
        h.tm.molValid(1:end) = false;
    case 4 % inverse
        h.tm.molValid = ~h.tm.molValid;
    case 5 % add tagged
        h.tm.molValid(~~h.tm.molTag(:,tag)') = true;
    case 6 % add not tagged
        h.tm.molValid(~h.tm.molTag(:,tag)') = true;
    case 7 % remove tagged
        h.tm.molValid(~~h.tm.molTag(:,tag)') = false;
    case 8 % remove not tagged
        h.tm.molValid(~h.tm.molTag(:,tag)') = false;
end

set(obj,'value',1);
guidata(h_fig,h);

% update view in panel "Molecule selection"
nDisp = numel(h.tm.axes_itt);
isBot = isfield(h.tm,'axes_frettt');
for i = 1:nDisp
    m = str2num(get(h.tm.checkbox_molNb(i),'string'));
    set(h.tm.checkbox_molNb(i),'value',h.tm.molValid(m));
    if h.tm.molValid(m)
        shad = [1,1,1];
    else
        shad = get(h.tm.checkbox_molNb(i),'backgroundcolor');
    end
    set([h.tm.axes_itt(i),h.tm.axes_itt_hist(i)],'color',shad);
    if isBot
        set([h.tm.axes_frettt(i),h.tm.axes_hist(i)],'color',shad);
    end
end

% update plot in "Video view"
plotData_videoView(h_fig);
