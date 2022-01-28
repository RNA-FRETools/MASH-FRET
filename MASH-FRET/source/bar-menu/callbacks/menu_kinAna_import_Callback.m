function menu_kinAna_import_Callback(obj,evd,h_fig)

[fname,pname,~] = uigetfile({'*.mat','Analysis results'},...
    'Select an analysis file');
if ~sum(fname) || ~sum(pname)
    return
end

dat = load([pname,fname]);

h = guidata(h_fig);

if isfield(dat, 'h_kinsoft_res')
    h.kinana_res = dat.h_kinsoft_res;
elseif isfield(dat, 'h_kinana_res')
     h.kinana_res = dat.h_kinana_res;
else
    disp('The file is corrupted: previous analysis results were not found.');
    return
end
h.kinana_res{1}{2} = pname;

guidata(h_fig,h);

disp(cat(2,'File ',fname,' successuflly imported!'));