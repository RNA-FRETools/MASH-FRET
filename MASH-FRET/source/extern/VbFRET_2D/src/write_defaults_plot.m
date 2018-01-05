function write_defaults_plot(settings,folder)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% create init_plot.m using current settings
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% last edited fall 2009 by Jonathan E Bronson (jeb2126@columbia.edu) for 
% http://vbfret.sourceforge.net

if isunix
    fid = fopen([folder '/init_plot.m'],'w');
else
    fid = fopen([folder '\init_plot.m'],'w');
end

% write the file
fprintf(fid,'function plot = init_plot()\n\n');
fprintf(fid,'%% set default plotting to be in 1D\n');
fprintf(fid,'plot.dim = %d;\n',settings.plot.dim);
fprintf(fid,'%% plot raw ''r'' or analyzed ''a''\n');
fprintf(fid,'plot.type = ''%s'';\n',settings.plot.type);
fprintf(fid,'%% show individual data points in the plot\n');
fprintf(fid,'plot.data_pts = %d;\n',settings.plot.data_pts);
fprintf(fid,'%% show individual data points in the best fit line\n');
fprintf(fid,'plot.fit_pts = %d;\n',settings.plot.fit_pts);
fprintf(fid,'%% plot blur state removed data (if analysis complete)\n');
fprintf(fid,'plot.blur_rm = %d;\n',settings.plot.blur_rm);
fprintf(fid,'%% make ''relabel traces'' default when loading data\n');
fprintf(fid,'plot.relabel_checkbox = %d;\n',settings.plot.relabel_checkbox);
fprintf(fid,'%% make ''sort traces'' default when loading data\n');
fprintf(fid,'plot.sort_checkbox = %d;\n',settings.plot.sort_checkbox);
fprintf(fid,'%% make ''relabel traces'' default when deleting data\n');
fprintf(fid,'plot.delete_sort_checkbox = %d;\n\n\n',settings.plot.delete_sort_checkbox);

fprintf(fid,'%% Main plot display formatting\n\n');

fprintf(fid,'%% Plot gridlines\n');
fprintf(fid,'plot.grids = ''%s'';\n',settings.plot.grids);
fprintf(fid,'%% fix Y-axis\n');
fprintf(fid,'plot.fixy = ''%s'';\n',settings.plot.fixy);
fprintf(fid,'%% background color of plot\n');
fprintf(fid,'plot.background = ''%s'';\n',settings.plot.background);
fprintf(fid,'%% remember which line type was last used\n');
fprintf(fid,'plot.cur_lineType = %d;\n\n',settings.plot.cur_lineType);

fprintf(fid,'%% FRET Data line color\n');
fprintf(fid,'plot.FRET.color = ''%s'';\n',settings.plot.FRET.color);
fprintf(fid,'%% FRET Data line style\n');
fprintf(fid,'plot.FRET.lineStyle = ''%s'';\n',settings.plot.FRET.lineStyle);
fprintf(fid,'%% FRET Data line thickness\n');
fprintf(fid,'plot.FRET.lineThickness = %g;\n',settings.plot.FRET.lineThickness);
fprintf(fid,'%% FRET Data marker symbol\n');
fprintf(fid,'plot.FRET.marker = ''%s'';\n',settings.plot.FRET.marker);
fprintf(fid,'%% FRET Data marker size\n');
fprintf(fid,'plot.FRET.markerSize = %g;\n',settings.plot.FRET.markerSize);
fprintf(fid,'%% FRET Data marker color\n');
fprintf(fid,'plot.FRET.markerColor = ''%s'';\n\n',settings.plot.FRET.markerColor);

fprintf(fid,'%% FRET Fit line color\n');
fprintf(fid,'plot.FRETfit.color = ''%s'';\n',settings.plot.FRETfit.color);
fprintf(fid,'%% FRET Fit line style\n');
fprintf(fid,'plot.FRETfit.lineStyle = ''%s'';\n',settings.plot.FRETfit.lineStyle);
fprintf(fid,'%% FRET Fit line thickness\n');
fprintf(fid,'plot.FRETfit.lineThickness = %g;\n',settings.plot.FRETfit.lineThickness);
fprintf(fid,'%% FRET Fit marker symbol\n');
fprintf(fid,'plot.FRETfit.marker = ''%s'';\n',settings.plot.FRETfit.marker);
fprintf(fid,'%% FRET Fit marker size\n');
fprintf(fid,'plot.FRETfit.markerSize = %g;\n',settings.plot.FRETfit.markerSize);
fprintf(fid,'%% FRET Fit marker color\n');
fprintf(fid,'plot.FRETfit.markerColor = ''%s'';\n\n',settings.plot.FRETfit.markerColor);

fprintf(fid,'%% Donor Data line color\n');
fprintf(fid,'plot.donor.color = ''%s'';\n',settings.plot.donor.color);
fprintf(fid,'%% Donor Data line style\n');
fprintf(fid,'plot.donor.lineStyle = ''%s'';\n',settings.plot.donor.lineStyle);
fprintf(fid,'%% Donor Data line thickness\n');
fprintf(fid,'plot.donor.lineThickness = %g;\n',settings.plot.donor.lineThickness);
fprintf(fid,'%% Donor Data marker symbol\n');
fprintf(fid,'plot.donor.marker = ''%s'';\n',settings.plot.donor.marker);
fprintf(fid,'%% Donor Data marker size\n');
fprintf(fid,'plot.donor.markerSize = %g;\n',settings.plot.donor.markerSize);
fprintf(fid,'%% Donor Data marker color\n');
fprintf(fid,'plot.donor.markerColor = ''%s'';\n\n',settings.plot.donor.markerColor);

fprintf(fid,'%% Donor Fit line color\n');
fprintf(fid,'plot.donorFit.color = ''%s'';\n',settings.plot.donorFit.color);
fprintf(fid,'%% Donor Fit line style\n');
fprintf(fid,'plot.donorFit.lineStyle = ''%s'';\n',settings.plot.donorFit.lineStyle);
fprintf(fid,'%% Donor Fit line thickness\n');
fprintf(fid,'plot.donorFit.lineThickness = %g;\n',settings.plot.donorFit.lineThickness);
fprintf(fid,'%% Donor Fit marker symbol\n');
fprintf(fid,'plot.donorFit.marker = ''%s'';\n',settings.plot.donorFit.marker);
fprintf(fid,'%% Donor Fit marker size\n');
fprintf(fid,'plot.donorFit.markerSize = %g;\n',settings.plot.donorFit.markerSize);
fprintf(fid,'%% Donor Fit marker color\n');
fprintf(fid,'plot.donorFit.markerColor = ''%s'';\n\n',settings.plot.donorFit.markerColor);

fprintf(fid,'%% Acceptor Data line color\n');
fprintf(fid,'plot.acceptor.color = ''%s'';\n',settings.plot.acceptor.color);
fprintf(fid,'%% Acceptor Data line style\n');
fprintf(fid,'plot.acceptor.lineStyle = ''%s'';\n',settings.plot.acceptor.lineStyle);
fprintf(fid,'%% Acceptor Data line thickness\n');
fprintf(fid,'plot.acceptor.lineThickness = %g;\n',settings.plot.acceptor.lineThickness);
fprintf(fid,'%% Acceptor Data marker symbol\n');
fprintf(fid,'plot.acceptor.marker = ''%s'';\n',settings.plot.acceptor.marker);
fprintf(fid,'%% Acceptor Data marker size\n');
fprintf(fid,'plot.acceptor.markerSize = %g;\n',settings.plot.acceptor.markerSize);
fprintf(fid,'%% Acceptor Data marker color\n');
fprintf(fid,'plot.acceptor.markerColor = ''%s'';\n\n',settings.plot.acceptor.markerColor);

fprintf(fid,'%% Acceptor Fit line color\n');
fprintf(fid,'plot.acceptorFit.color = ''%s'';\n',settings.plot.acceptorFit.color);
fprintf(fid,'%% Acceptor Fit line style\n');
fprintf(fid,'plot.acceptorFit.lineStyle = ''%s'';\n',settings.plot.acceptorFit.lineStyle);
fprintf(fid,'%% Acceptor Fit line thickness\n');
fprintf(fid,'plot.acceptorFit.lineThickness = %g;\n',settings.plot.acceptorFit.lineThickness);
fprintf(fid,'%% Acceptor Fit marker symbol\n');
fprintf(fid,'plot.acceptorFit.marker = ''%s'';\n',settings.plot.acceptorFit.marker);
fprintf(fid,'%% Acceptor Fit marker size\n');
fprintf(fid,'plot.acceptorFit.markerSize = %g;\n',settings.plot.acceptorFit.markerSize);
fprintf(fid,'%% Acceptor Fit marker color\n');
fprintf(fid,'plot.acceptorFit.markerColor = ''%s'';\n\n',settings.plot.acceptorFit.markerColor);

% close the analysis settings file now that it's fully written
fclose(fid);

% fprintf(fid,'%\n');
