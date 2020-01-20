function plotData_autoSort(h_fig)

h = guidata(h_fig);
p = h.param.ttPr;
proj = p.curr_proj;
nChan = p.proj{proj}.nb_channel;
nExc = p.proj{proj}.nb_excitations;
nFRET = size(p.proj{proj}.FRET,1);
nS = size(p.proj{proj}.S,1);

cla(h.tm.axes_histSort);

dat1 = get(h.tm.axes_ovrAll_1,'userdata');
dat2 = get(h.tm.axes_ovrAll_2,'userdata');
dat3 = get(h.tm.axes_histSort,'userdata');

if ~sum(dat3.slct)
    return;
end

ind = get(h.tm.popupmenu_selectData,'value');
j = get(h.tm.popupmenu_selectCalc,'value');
fcn = {@axes_histSort_ButtonDownFcn,h_fig};

if ind<=(nChan*nExc+nFRET+nS) % 1D histograms
    if j==1 % original data
        P = dat2.hist{ind};
        iv = dat2.iv{ind};
        
    else % calculated/discretized data
        if isempty(dat3.hist{ind,j-1})
            setContPan(cat(2,'No calculated data available: start ',...
                'calculation or select another type of calculation.'),...
                'error',h_fig);
            return;
        end
        P = dat3.hist{ind,j-1};
        iv = dat3.iv{ind,j-1};
    end
    
    % plot histogram
    bar(h.tm.axes_histSort,iv,P,'edgecolor',dat1.color{ind},'facecolor',...
        dat1.color{ind},'buttondownfcn',fcn);
    
    % set axis labels as in overall plot
    xlabel(h.tm.axes_histSort, dat2.xlabel{ind});
    ylabel(h.tm.axes_histSort, dat2.ylabel{ind});
    
    % set axis limits
    xlim(h.tm.axes_histSort, [iv(1),iv(end)]);
    ylim(h.tm.axes_histSort, 'auto');

    % add mask
    yaxis = get(h.tm.axes_histSort,'ylim');
    drawMask(h_fig,[iv(1) iv(end)],yaxis,1);
    
    str_d = '1D';
    
else % E-S histograms
    
    if j==1 % original data
        P2D = dat2.hist{ind};
        ivx = dat2.iv{ind}{1};
        ivy = dat2.iv{ind}{2};
        
    else % calculated/discretized data
        if isempty(dat3.hist{ind,j-1})
            setContPan(cat(2,'No calculated data available: start ',...
                'calculation or select another type of calculation.'),...
                'error',h_fig);
            return;
        end
        P2D = dat3.hist{ind,j-1};
        ivx = dat3.iv{ind,j-1}{1};
        ivy = dat3.iv{ind,j-1}{2};
    end
       
    imagesc([ivx(1),ivx(end)],[ivy(1),ivy(end)],P2D,'parent',...
        h.tm.axes_histSort,'buttondownfcn',fcn);
    
    % plot range
    drawMask(h_fig,[ivx(1) ivx(end)],[ivy(1) ivy(end)],2);
    
    if sum(sum(P2D))
        set(h.tm.axes_histSort,'CLim',[0,max(max(P2D))]);
    else
        set(h.tm.axes_histSort,'CLim',[0,1]);
    end

    xlabel(h.tm.axes_histSort,dat2.xlabel{ind});
    ylabel(h.tm.axes_histSort,dat2.ylabel{ind});

    xlim(h.tm.axes_histSort,[ivx(1),ivx(end)]);
    ylim(h.tm.axes_histSort,[ivy(1),ivy(end)]);
    
    str_d = '2D';
end

% display histogram parameters
if j==1
    lim = dat1.lim{ind};
    niv = dat1.niv(ind,:);
else
    lim = dat3.lim{ind,j-1};
    niv = dat3.niv(ind,:,j-1);
end
set(h.tm.edit_xlow,'string',num2str(lim(1,1)));
set(h.tm.edit_xup,'string',num2str(lim(1,2)));
set(h.tm.edit_xniv,'string',num2str(niv(1)));
if ind>(nChan*nExc+nFRET+nS)
    set(h.tm.edit_ylow,'string',num2str(lim(2,1)));
    set(h.tm.edit_yup,'string',num2str(lim(2,2)));
    set(h.tm.edit_yniv,'string',num2str(niv(2)));
    set([h.tm.text_ylow,h.tm.edit_ylow,h.tm.text_yup,h.tm.edit_yup,...
        h.tm.text_yniv,h.tm.edit_yniv],'enable','on');
else
    set([h.tm.edit_ylow,h.tm.edit_yup,h.tm.edit_yniv],'string','');
    set([h.tm.text_ylow,h.tm.edit_ylow,h.tm.text_yup,h.tm.edit_yup,...
        h.tm.text_yniv,h.tm.edit_yniv],'enable','off');
end

title(h.tm.axes_histSort,cat(2,str_d,...
    '-histogram for molecule selection at last update'));

