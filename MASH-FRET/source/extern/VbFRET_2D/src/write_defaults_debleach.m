function write_defaults_debleach(settings,folder)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% create debleach_defaults.m using current settings
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% last edited fall 2009 by Jonathan E Bronson (jeb2126@columbia.edu) for 
% http://vbfret.sourceforge.net

if isunix
    fid = fopen([folder '/debleach_defaults.m'],'w');
else
    fid = fopen([folder '\debleach_defaults.m'],'w');
end

% write the file
fprintf(fid,'function [debleach] = debleach_defaults()\n\n');
fprintf(fid,'%% creates a handle, debleach, containing all default settings for how to\n');
fprintf(fid,'%% truncate traces due to photobleaching.\n\n');
fprintf(fid,'%%1 = 1D transformed\n%%2 = Single channel\n%%3 = Summed channel\n');
fprintf(fid,'debleach.type = %g;\n\n',settings.debleach.type);
fprintf(fid,'%%truncate data when first data point is greater than 1 or 0 by this much:\n');
fprintf(fid,'debleach.cutoff_1D = %g;\n\n',settings.debleach.cutoff_1D);
fprintf(fid,'%%truncate data when channel 1 or channel 2 first falls below:\n');
fprintf(fid,'debleach.cutoff_either = %g;\n\n',settings.debleach.cutoff_either);
fprintf(fid,'%%truncate data when channel 1 or channel 2 first falls below:\n');
fprintf(fid,'debleach.cutoff_sum = %g;\n\n',settings.debleach.cutoff_sum);
fprintf(fid,'%%smooth data 0 = no, 1 = yes\n');
fprintf(fid,'debleach.smooth = %g;\n\n',settings.debleach.smooth);
fprintf(fid,'%%how many time steps will the data be smoothed over\n');
fprintf(fid,'debleach.smooth_steps = %g;\n\n',settings.debleach.smooth_steps);
fprintf(fid,'%%make non-zero if you want delete extra data points before the first\n');
fprintf(fid,'%%identified photobleached data point.\n');
fprintf(fid,'debleach.xtra = %g;\n\n',settings.debleach.xtra);
fprintf(fid,'%%minimum trace length that is allowed to be analyzed\n');
fprintf(fid,'debleach.min_length = %g;\n\n',settings.debleach.min_length);
% fprintf(fid,'%\n');
% close the analysis settings file now that it's fully written
fclose(fid);