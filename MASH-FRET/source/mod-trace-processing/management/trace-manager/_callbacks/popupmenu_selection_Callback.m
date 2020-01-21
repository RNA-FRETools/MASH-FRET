function popupmenu_selection_Callback(obj, evd, h_fig)
% Change the current selection according to selected menu

% Created by MH, 24.4.2019
%
%

h = guidata(h_fig);

meth = get(obj,'value');

if meth>1
    choice = questdlg({cat(2,'After applying the automatic selection mode, ',...
        'the current selection will be lost'),'',cat(2,'Do you want to ',...
        'continue and overwrite the current selection?')},...
        'Change molecule selection','Yes, modify the current selection',...
        'Cancel','Cancel');
    if ~strcmp(choice,'Yes, modify the current selection')
        return;
    end
else
    return;
end

switch meth
    case 2 % all
        h.tm.molValid(1:end) = true;
    case 3 % none
        h.tm.molValid(1:end) = false;
    case 4 % inverse
        h.tm.molValid = ~h.tm.molValid; 
end

if meth>4
    nTag = numel(h.tm.molTagNames);
    
    if meth<=4+nTag % add tag-based selection
        tag = meth - 4;
        h.tm.molValid(h.tm.molTag(:,tag)') = true;
        
    else % remove tag-based selection
        tag = meth - 4 - nTag;
        h.tm.molValid(h.tm.molTag(:,tag)') = false;
    end
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

