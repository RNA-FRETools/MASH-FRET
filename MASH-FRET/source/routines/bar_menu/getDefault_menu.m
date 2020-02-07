function p = getDefault_menu
% p = getDefault_menu
%
% Generates default values for Menu bar parameters
%
% p: structure that contain default parameters

% general parameters
[pname,o,o] = fileparts(mfilename('fullpath'));
p.annexpth = cat(2,pname,filesep,'assets'); % path to annexed files
p.dumpdir = cat(2,pname,filesep,'test_data'); % path to exported data
if ~exist(p.dumpdir,'dir')
    mkdir(p.dumpdir);
end

p.dataset_restruct = {'dataset_2chan2exc','dataset_3chan2exc'};
p.wl = {[532,532,532,532],[532,532,638,638]};
p.expT = [0.5,1,2];
p.dataset_timebin = {'dataset_2chan1exc','dataset_2chan2exc',...
    'dataset_3chan2exc'};
p.headers{1} = {'timeat532nm','I_1at532nm(counts','I_2at532nm(counts)','FRET_1>2'};
p.headers{2} = {'timeat532nm','discr.I_1at532nm(counts)','discr.I_2at532nm(counts)','discr.FRET_1>2','discr.S_1>2','timeat638nm','discr.I_1at638nm(counts)','discr.I_2at638nm(counts)'};
p.headers{3} = {'frameat532nm','I_3at532nm(counts)','frameat638nm','I_3at638nm(counts)'};