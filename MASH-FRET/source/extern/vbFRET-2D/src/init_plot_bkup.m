function plot = init_plot_bkup()
% last edited fall 2009 by Jonathan E Bronson (jeb2126@columbia.edu) for 
% http://vbfret.sourceforge.net

% set default plotting to be in 1D
plot.dim = 1;
% plot raw 'r' or analyzed 'a'
plot.type = 'r';
% show individual data points in the plot
plot.data_pts = 0;
% show individual data points in the best fit line
plot.fit_pts = 0;
% plot blur state removed data (if analysis complete)
plot.blur_rm = 1;
% make 'relabel traces' default when loading data
plot.relabel_checkbox = 0;
% make 'sort traces' default when loading data
plot.sort_checkbox = 1;
% make 'relabel traces' default when deleting data
plot.delete_sort_checkbox = 0;


% Main plot display formatting

% Plot gridlines
plot.grids = 'off';
% fix Y-axis
plot.fixy = 'on';
% background color of plot
plot.background = 'w';
% remember which line type was last used
plot.cur_lineType = 1;

% FRET Data line color
plot.FRET.color = 'b';
% FRET Data line style
plot.FRET.lineStyle = '-';
% FRET Data line thickness 
plot.FRET.lineThickness = 0.5;
% FRET Data marker symbol
plot.FRET.marker = 'x';
% FRET Data marker size
plot.FRET.markerSize = 6;
% FRET Data marker color
plot.FRET.markerColor = 'b';

% FRET Fit line color
plot.FRETfit.color = 'r';
% FRET Fit line style
plot.FRETfit.lineStyle = '-';
% FRET Fit line thickness 
plot.FRETfit.lineThickness = 1.5;
% FRET Fit marker symbol
plot.FRETfit.marker = 'x';
% FRET Fit marker size
plot.FRETfit.markerSize = 6;
% FRET Fit marker color
plot.FRETfit.markerColor = 'r';

% Donor Data line color
plot.donor.color = 'g';
% Donor Data line style
plot.donor.lineStyle = '-';
% Donor Data line thickness 
plot.donor.lineThickness = 0.5;
% Donor Data marker symbol
plot.donor.marker = 'x';
% Donor Data marker size
plot.donor.markerSize = 6;
% Donor Data marker color
plot.donor.markerColor = 'g';

% Donor Fit line color
plot.donorFit.color = 'm';
% Donor Fit line style
plot.donorFit.lineStyle = '--';
% Donor Fit line thickness 
plot.donorFit.lineThickness = 1.5;
% Donor Fit marker symbol
plot.donorFit.marker = 'x';
% Donor Fit marker size
plot.donorFit.markerSize = 6;
% Donor Fit marker color
plot.donorFit.markerColor = 'm';

% Acceptor Data line color
plot.acceptor.color = 'r';
% Acceptor Data line style
plot.acceptor.lineStyle = '-';
% Acceptor Data line thickness 
plot.acceptor.lineThickness = 0.5;
% Acceptor Data marker symbol
plot.acceptor.marker = 'x';
% Acceptor Data marker size
plot.acceptor.markerSize = 6;
% Acceptor Data marker color
plot.acceptor.markerColor = 'r';

% Acceptor Fit line color
plot.acceptorFit.color = 'b';
% Acceptor Fit line style
plot.acceptorFit.lineStyle = '--';
% Acceptor Fit line thickness 
plot.acceptorFit.lineThickness = 1.5;
% Acceptor Fit marker symbol
plot.acceptorFit.marker = 'x';
% Acceptor Fit marker size
plot.acceptorFit.markerSize = 6;
% Acceptor Fit marker color
plot.acceptorFit.markerColor = 'b';

