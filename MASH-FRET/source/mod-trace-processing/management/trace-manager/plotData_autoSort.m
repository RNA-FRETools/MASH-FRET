function plotData_autoSort(h_fig)

h = guidata(h_fig);

cla(h.tm.axes_histSort);

dat1 = get(h.tm.axes_ovrAll_1,'userdata');
dat3 = get(h.tm.axes_histSort,'userdata');

if ~sum(dat3.slct)
    return
end

indx = get(h.tm.popupmenu_selectXdata,'value');
indy = get(h.tm.popupmenu_selectYdata,'value')-1;
is2D = indy>0;
jx = get(h.tm.popupmenu_selectXval,'value')-1;
jy = get(h.tm.popupmenu_selectYval,'value')-1;
isTDP = (indx==indy & jx==9 & jy==9);

if ~is2D % 1D histograms
    if jx==0
        trace_x = dat1.trace{indx};
        limx = dat1.lim(indx,:);
        nivx = dat1.niv(indx);
    else
        if sum(jx==[9,10]) % state-wise
            trace_x = dat3.val{indx,jx}(:,1);
        else
            trace_x = dat3.val{indx,jx};
        end
        limx = dat3.lim(indx,:,jx);
        nivx = dat3.niv(jx,indx);
    end
    [P,iv] = getHistTM(trace_x,limx,nivx);
    
    if isempty(P)
        setContPan(cat(2,'No calculated data available: start calculation',...
            ' or select another type of calculation.'),'error',h_fig);
    end
    
    % plot histogram
    bar(h.tm.axes_histSort,iv,P,'edgecolor',dat1.color{indx},'facecolor',...
        dat1.color{indx},'hittest','off','pickableparts','none');
    
    % set axis labels as in overall plot
    if jx==0
        xlabel(h.tm.axes_histSort, dat1.ylabel{indx});
    else
        xlabel(h.tm.axes_histSort, dat3.label{indx});
    end
    ylabel(h.tm.axes_histSort, 'Frequency count');
    
    % set axis limits
    xlim(h.tm.axes_histSort, [iv(1),iv(end)]);
    ylim(h.tm.axes_histSort, 'auto');

    % add mask
    yaxis = get(h.tm.axes_histSort,'ylim');
    drawMask(h_fig,[iv(1) iv(end)],yaxis,1);
    
    str_d = '1D';
    
else % E-S histograms
    
    % control coherence of x- and y-data
    if ~checkXYdataCoherence(indx,indy,jx,jy)
        return
    end
    
    if isTDP % TDP
        trace_x = dat3.val{indx,jx}(:,1);
        trace_y = [dat3.val{indy,jy}(2:end,1);dat3.val{indy,jy}(end,1)];
        nivx = dat1.niv(indx);
        limx = dat1.lim(indx,:);
        nivy = nivx;
        limy = limx;
    else
        if jx==0 
            trace_x = dat1.trace{indx};
            nivx = dat1.niv(indx);
            limx = dat1.lim(indx,:);
        else
            if sum(jx==(9:10)) % state-wise (2nd column = molecule index)
                trace_x = dat3.val{indx,jx}(:,1);
            else
                trace_x = dat3.val{indx,jx};
            end
            nivx = dat3.niv(jx,indx);
            limx = dat3.lim(indx,:,jx);
        end
        if jy==0 
            trace_y = dat1.trace{indy};
            nivy = dat1.niv(indy);
            limy = dat1.lim(indy,:);
        else
            if sum(jx==(9:10)) % state-wise (2nd column = molecule index)
                trace_y = dat3.val{indy,jy}(:,1);
            else
                trace_y = dat3.val{indy,jy};
            end
            nivy = dat3.niv(jy,indy);
            limy = dat3.lim(indy,:,jy);
        end
    end
    
    [P2D,iv] = getHistTM([trace_x,trace_y],[limx;limy],[nivx,nivy]);
    ivx = iv{1};
    ivy = iv{2};

    if isempty(P2D)
        setContPan(cat(2,'No calculated data available: start calculation',...
            ' or select another type of calculation.'),'error',h_fig);
    end
       
    imagesc([ivx(1),ivx(end)],[ivy(1),ivy(end)],P2D,'parent',...
        h.tm.axes_histSort,'hittest','off','pickableparts','none');
    
    % plot range
    drawMask(h_fig,[ivx(1) ivx(end)],[ivy(1) ivy(end)],2);
    
    if sum(sum(P2D))
        set(h.tm.axes_histSort,'CLim',[0,max(max(P2D))]);
    else
        set(h.tm.axes_histSort,'CLim',[0,1]);
    end

    if jx==0
        xlabel(h.tm.axes_histSort,dat1.ylabel{indx});
    else
        xlabel(h.tm.axes_histSort,dat3.label{indx,jx});
    end
    if jy==0
        ylabel(h.tm.axes_histSort,dat1.ylabel{indy});
    else
        ylabel(h.tm.axes_histSort,dat3.label{indy,jy});
    end

    xlim(h.tm.axes_histSort,[ivx(1),ivx(end)]);
    ylim(h.tm.axes_histSort,[ivy(1),ivy(end)]);
    
    str_d = '2D';
end

% display histogram parameters
set(h.tm.edit_xlow,'string',num2str(limx(1)));
set(h.tm.edit_xup,'string',num2str(limx(2)));
set(h.tm.edit_xniv,'string',num2str(nivx));

if is2D && ~isTDP
    set(h.tm.edit_ylow,'string',num2str(limy(1)));
    set(h.tm.edit_yup,'string',num2str(limy(2)));
    set(h.tm.edit_yniv,'string',num2str(nivy));
    set([h.tm.text_ylow,h.tm.edit_ylow,h.tm.text_yup,h.tm.edit_yup,...
        h.tm.text_yniv,h.tm.edit_yniv],'enable','on');
else
    set([h.tm.edit_ylow,h.tm.edit_yup,h.tm.edit_yniv],'string','');
    set([h.tm.text_ylow,h.tm.edit_ylow,h.tm.text_yup,h.tm.edit_yup,...
        h.tm.text_yniv,h.tm.edit_yniv],'enable','off');
end

title(h.tm.axes_histSort,cat(2,str_d,...
    '-histogram for molecule selection at last update'));

