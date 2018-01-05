function plotFRET(plot_axis, dat, opts, n)
% last edited fall 2009 by Jonathan E Bronson (jeb2126@columbia.edu) for 
% http://vbfret.sourceforge.net


% set gray color
GRAY = 0.5*[1 1 1];

% if background is gray, set color
if isequal(opts.background,'e')
    opts.background = GRAY;
end

% clear axis if there's not data
%format background of plot
set(plot_axis,'YGrid',opts.grids);
set(plot_axis,'Color',opts.background);

if isempty(dat.labels)
    cla(plot_axis)
    return
%if trace hasn't been fit yet, just plot raw data
elseif isequal(opts.type,'a') && ( isempty(dat.x_hat{1,n})...
                                   || (opts.blur_rm &&...
                                       ~isempty(dat.z_hat_db)...
                                        &&  (length(dat.z_hat_db) < n... 
                                             || isempty(dat.x_hat_db{1,n})...
                                            )...
                                       )...
                                  )
    opts.type = 'r';
end

cla(plot_axis); %clear the axes
hold on

% get the info to be plotted
T=length(dat.FRET{n});
% no blur removal
if ~opts.blur_rm || isempty(dat.FRET_db) || length(dat.FRET_db) < n || isempty(dat.FRET_db{n})
    if opts.dim == 1
        data = dat.FRET{n};
        fit = dat.x_hat{1,n};
    else
        data = dat.raw{n};
        fit = dat.x_hat{2,n};
    end
    % string to denoted blur removed data
    CLEANED = '';
% if plotting blur removal
else
    if opts.dim == 1
        data = dat.FRET_db{n};
        fit = dat.x_hat_db{1,n};
    else
        data = dat.raw_db{n};
        % these don't always copy if all the traces haven't been analyzed
        if isempty(dat.x_hat_db{2,n})
            fit = dat.x_hat{2,n};
        else
            fit = dat.x_hat_db{2,n};
        end
    end
    % string to denoted blur removed data
    if any(dat.mod_list == n)
        CLEANED = 'cleaned ';
    else
        CLEANED = 'cleaned* ';
    end
end

%%%%%%%%%%%%%%%%%%%%%%%
%
% update the plots
%
%%%%%%%%%%%%%%%%%%%%%%%

% plot in 1D
if opts.dim == 1 
    % fix gray color if necessary 
    if isequal(opts.FRET.color,'e')
        opts.FRET.color = GRAY;
    end
    
    % plot FRET data
    plot(plot_axis,1:T,data,'Color',opts.FRET.color,'LineStyle',opts.FRET.lineStyle...
                 ,'LineWidth',opts.FRET.lineThickness);

    % plot FRET marker
    if opts.data_pts
        % fix gray color if necessary 
        if isequal(opts.FRET.markerColor,'e')
            opts.FRET.markerColor = GRAY;
        end
        
        plot(plot_axis,1:T,data,'LineStyle','none','Marker',opts.FRET.marker,'MarkerEdgeColor',...
        opts.FRET.markerColor,'MarkerFaceColor',opts.FRET.markerColor,'MarkerSize',opts.FRET.markerSize);
    end
    
    % plot fit of data
    if isequal(opts.type,'a')
        % needed for title
        keff = length(unique(fit));
        % fix gray color if necessary 
        if isequal(opts.FRETfit.color,'e')
            opts.FRETfit.color = GRAY;
        end
        
        plot(plot_axis,1:T,fit,'Color',opts.FRETfit.color,'LineStyle',opts.FRETfit.lineStyle...
                 ,'LineWidth',opts.FRETfit.lineThickness);             
             
        % plot fit marker
        if opts.fit_pts
            % fix gray color if necessary 
            if isequal(opts.FRETfit.markerColor,'e')
                opts.FRETfit.markerColor = GRAY;
            end
            
            plot(plot_axis,1:T,fit,'LineStyle','none','Marker',opts.FRETfit.marker,'MarkerEdgeColor',...
            opts.FRETfit.markerColor,'MarkerFaceColor',opts.FRETfit.markerColor,'MarkerSize',opts.FRETfit.markerSize);
        end
    end
    
    % set axis
    if isequal(opts.fixy,'on')
        axis([0 T+1 -0.1 1.1]);
        set(gca,'Ytick',[0 .2 .4 .6 .8 1]);
    else
        % set axis
        MIN = min(data(:));
        MAX = max(data(:));
        FRAC = 0.05;
        axis([0 T+1 MIN-FRAC*MAX MAX+FRAC*MAX]);
        set(gca,'YTickMode','auto')
    end

% plot in 2D
else
    % fix gray color if necessary 
    if isequal(opts.donor.color,'e')
        opts.donor.color = GRAY;
    end
    if isequal(opts.acceptor.color,'e')
        opts.acceptor.color = GRAY;
    end

    % plor donor
    plot(plot_axis,1:T,data(:,1),'Color',opts.donor.color,'LineStyle',opts.donor.lineStyle...
                 ,'LineWidth',opts.donor.lineThickness);
    % plot acceptor
    plot(plot_axis,1:T,data(:,2),'Color',opts.acceptor.color,'LineStyle',opts.acceptor.lineStyle...
                 ,'LineWidth',opts.acceptor.lineThickness);
             
    % plot FRET marker
    if opts.data_pts
            % fix gray color if necessary 
            if isequal(opts.donor.markerColor,'e')
                opts.donor.markerColor = GRAY;
            end
            if isequal(opts.acceptor.markerColor,'e')
                opts.acceptor.markerColor = GRAY;
            end

            plot(plot_axis,1:T,data(:,1),'LineStyle','none','Marker',opts.donor.marker,'MarkerEdgeColor',...
            opts.donor.markerColor,'MarkerFaceColor',opts.donor.markerColor,'MarkerSize',...
            opts.donor.markerSize);
        
            plot(plot_axis,1:T,data(:,2),'LineStyle','none','Marker',opts.acceptor.marker,'MarkerEdgeColor',...
            opts.acceptor.markerColor,'MarkerFaceColor',opts.acceptor.markerColor,'MarkerSize',...
            opts.acceptor.markerSize);
    end

    % plot fit of data
    if isequal(opts.type,'a')
        % needed for title
        keff = length(unique(fit(:,1)));
        
        % fix gray color if necessary 
        if isequal(opts.donorFit.color,'e')
            opts.donorFit.color = GRAY;
        end
        if isequal(opts.acceptorFit.color,'e')
            opts.acceptorFit.color = GRAY;
        end
        
        % plot 2D fit
        plot(plot_axis,1:T,fit(:,1),'Color',opts.donorFit.color,'LineStyle',opts.donorFit.lineStyle...
                 ,'LineWidth',opts.donorFit.lineThickness);

        plot(plot_axis,1:T,fit(:,2),'Color',opts.acceptorFit.color,'LineStyle',opts.acceptorFit.lineStyle...
                 ,'LineWidth',opts.acceptorFit.lineThickness);    

         % plot 2D markers
        if opts.fit_pts
            % fix gray color if necessary 
            if isequal(opts.donorFit.markerColor,'e')
                opts.donorFit.markerColor = GRAY;
            end
            if isequal(opts.acceptorFit.markerColor,'e')
                opts.acceptorFit.markerColor = GRAY;
            end

            plot(plot_axis,1:T,fit(:,1),'LineStyle','none','Marker',opts.donorFit.marker,'MarkerEdgeColor',...
            opts.donorFit.markerColor,'MarkerFaceColor',opts.donorFit.markerColor,'MarkerSize',...
            opts.donorFit.markerSize);
            
            plot(plot_axis,1:T,fit(:,2),'LineStyle','none','Marker',opts.acceptorFit.marker,'MarkerEdgeColor',...
            opts.acceptorFit.markerColor,'MarkerFaceColor',opts.acceptorFit.markerColor,'MarkerSize',...
            opts.acceptorFit.markerSize);  
        end
    end

    % set axis
    MIN = min(data(:));
    MAX = max(data(:));
    FRAC = 0.05;
    axis([0 T+1 MIN-FRAC*MAX MAX+FRAC*MAX]);
    set(gca,'YTickMode','auto')
end

% set title
if isequal(opts.type,'r')
    title(sprintf('Raw Data for %strace %s',CLEANED,dat.labels{n}),'interpreter','none')
else
    title(sprintf('Best fit of %strace %s: %d states fit to data',CLEANED,dat.labels{n},keff),'interpreter','none')    
end