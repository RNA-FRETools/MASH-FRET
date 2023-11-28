function plotData_autoSort(h_fig)

% default
xlogbin = false;
ylogbin = false;

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
        trace_x = dat1.trace{indx}(:,1);
        limx = dat1.lim(indx,:);
        nivx = dat1.niv(indx);
    else
        trace_x = dat3.val{indx,jx}(:,1);
        limx = dat3.lim(indx,:,jx);
        nivx = dat3.niv(jx,indx);
    end
    [P,iv] = getHistTM(trace_x,limx,nivx,xlogbin);
    
    if isempty(P)
        setContPan(cat(2,'No calculated data available: start calculation',...
            ' or select another type of calculation.'),'error',h_fig);
    end
    
    % plot histogram
    histogram(h.tm.axes_histSort,'binedges',iv,'bincounts',P,'edgecolor',...
        dat1.color{indx},'facecolor',dat1.color{indx},'hittest','off',...
        'pickableparts','none');
    
    % set axis scales
    if xlogbin
        h.tm.axes_histSort.XScale = 'log';
    else
        h.tm.axes_histSort.XScale = 'linear';
    end
    h.tm.axes_histSort.YScale = 'linear';
    
    % set axis labels as in overall plot
    if jx==0
        xlabel(h.tm.axes_histSort, dat1.ylabel{indx});
    else
        xlabel(h.tm.axes_histSort, dat3.label{indx,jx});
    end
    ylabel(h.tm.axes_histSort, 'Frequency count');
    
    % set axis limits
    xlim(h.tm.axes_histSort, limx);
    ylim(h.tm.axes_histSort, 'auto');

    % add mask
    yaxis = get(h.tm.axes_histSort,'ylim');
    drawMask(h_fig,limx,yaxis,1);
    
    str_d = '1D';
    
else % 2D histograms
    
    % control coherence of x- and y-data
    if ~checkXYdataCoherence(indx,indy,jx,jy)
        return
    end
    if isTDP % TDP
        trace_x = [];
        trace_y = [];
        mols = [];
        for m = unique(dat3.val{indx,jx}(:,2))'
            val_m = dat3.val{indx,jx}(dat3.val{indx,jx}(:,2)==m,:);
            if size(val_m,1)==1
                trace_x = cat(1,trace_x,val_m(1,1));
                trace_y = cat(1,trace_y,val_m(1,1));
                mols = cat(1,mols,val_m(1,2));
            else
                trace_x = cat(1,trace_x,val_m(1:end-1,1));
                trace_y = cat(1,trace_y,val_m(2:end,1));
                mols = cat(1,mols,val_m(1:end-1,2));
            end
        end
        nivx = dat1.niv(indx);
        limx = dat1.lim(indx,:);
        nivy = nivx;
        limy = limx;
    else
        if jx==0 
            trace_x = dat1.trace{indx}(:,1);
            mols = dat1.trace{indx}(:,2);
            nivx = dat1.niv(indx);
            limx = dat1.lim(indx,:);
        else
            trace_x = dat3.val{indx,jx}(:,1);
            if size(dat3.val{indx,jx},2)>=2
                mols = dat3.val{indx,jx}(:,2);
            else
                mols = (1:size(dat3.val{indx,jx},1))';
            end
            nivx = dat3.niv(jx,indx);
            limx = dat3.lim(indx,:,jx);
        end
        if jy==0 
            trace_y = dat1.trace{indy}(:,1);
            nivy = dat1.niv(indy);
            limy = dat1.lim(indy,:);
        else
            trace_y = dat3.val{indy,jy}(:,1);
            nivy = dat3.niv(jy,indy);
            limy = dat3.lim(indy,:,jy);
        end
    end
    if h.tm.checkbox_AS_datcnt.Value
        P2D = [];
        for m = unique(mols)'
            id = (mols==m)';
            [P2D_m,iv] = getHistTM([trace_x(id,:),trace_y(id,:)],...
                [limx;limy],[nivx,nivy],[xlogbin,ylogbin]);
            if isempty(P2D)
                P2D = double(~~P2D_m);
            else
                P2D = P2D+double(~~P2D_m);
            end
        end
        ivx = iv{1};
        ivy = iv{2};
    else
        [P2D,iv] = getHistTM([trace_x,trace_y],[limx;limy],[nivx,nivy],...
            [xlogbin,ylogbin]);
        ivx = iv{1};
        ivy = iv{2};
    end
    
    if h.tm.checkbox_AS_gauss.Value
        P2D = gconvTDP(P2D,[-0.2,1.2],0.01);
    end

    if isempty(P2D)
        setContPan(cat(2,'No calculated data available: start calculation',...
            ' or select another type of calculation.'),'error',h_fig);
    end
    
    histogram2(h.tm.axes_histSort,'xbinedges',ivx,'ybinedges',...
        ivy,'bincounts',P2D','DisplayStyle','tile');
    
    % set axis scales
    if xlogbin
        h.tm.axes_histSort.XScale = 'log';
    else
        h.tm.axes_histSort.XScale = 'linear';
    end
    if ylogbin
        h.tm.axes_histSort.YScale = 'log';
    else
        h.tm.axes_histSort.YScale = 'linear';
    end
    
    % plot range
    drawMask(h_fig,limx,limy,2);
    
%     if sum(sum(P2D))
%         set(h.tm.axes_histSort,'CLim',[0,max(max(P2D))]);
%     else
%         set(h.tm.axes_histSort,'CLim',[0,1]);
%     end

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

    xlim(h.tm.axes_histSort,limx);
    ylim(h.tm.axes_histSort,limy);
    
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
if is2D
    set([h.tm.checkbox_AS_gauss,h.tm.checkbox_AS_datcnt],'enable','on');
else
    set([h.tm.checkbox_AS_gauss,h.tm.checkbox_AS_datcnt],'enable','off',...
        'value',0);
end

title(h.tm.axes_histSort,cat(2,str_d,...
    '-histogram for molecule selection at last update'));

