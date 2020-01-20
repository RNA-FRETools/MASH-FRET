function edit_yup_Callback(obj,evd,h_fig)
h = guidata(h_fig);
p = h.param.ttPr;
proj = p.curr_proj;
nChan = p.proj{proj}.nb_channel;
nExc = p.proj{proj}.nb_excitations;
FRET = p.proj{proj}.FRET;
nFRET = size(FRET,1);
S = p.proj{proj}.S;
nS = size(S,1);

dat1 = get(h.tm.axes_ovrAll_1,'userdata');
dat2 = get(h.tm.axes_ovrAll_2,'userdata');
dat3 = get(h.tm.axes_histSort,'userdata');
ind = get(h.tm.popupmenu_selectData,'value');
j = get(h.tm.popupmenu_selectCalc,'value');

if j==1
    ylim_low = dat1.lim{ind}(2,1);
else
    ylim_low = dat3.lim{ind,j-1}(2,1);
end

ylim_sup = str2num(get(obj,'String'));

if ylim_sup<=ylim_low
    setContPan('Higher bound must be higher than lower bound.','error',...
        h_fig);
    return;
end

if j==1
    dat1.lim{ind}(2,2) = ylim_sup;
else
    dat3.lim{ind,j-1}(2,2) = ylim_sup;
end

if ind <= nChan*nExc+nFRET+nS
    if j==1
        [dat2.hist{ind},dat2.iv{ind}] = getHistTM(dat1.trace{ind},...
            dat1.lim{ind},dat1.niv(ind,1));
    else
        [dat3.hist{ind,j-1},dat3.iv{ind,j-1}] = getHistTM(...
            dat3.val{ind,j-1},dat3.lim{ind,j-1},dat3.niv(ind,1,j-1));
    end
    
else
    if j==1
        ES = [dat1.trace{ind-nFRET-nS},dat1.trace{ind-nS}];
        [dat2.hist{ind},dat2.iv{ind}] = getHistTM(ES,dat1.lim{ind},...
            dat1.niv(ind,[1,2]));
    else
        ES = [dat3.val{ind-nFRET-nS,j-1},dat3.val{ind-nS,j-1}];
        [dat3.hist{ind,j-1},dat3.iv{ind,j-1}] = getHistTM(ES,...
            dat3.lim{ind,j-1},dat3.niv(ind,[1,2],j-1));
    end
end

set(h.tm.axes_ovrAll_1, 'UserData', dat1);
set(h.tm.axes_ovrAll_2, 'UserData', dat2);
set(h.tm.axes_histSort, 'UserData', dat3);

plotData_autoSort(h_fig);
