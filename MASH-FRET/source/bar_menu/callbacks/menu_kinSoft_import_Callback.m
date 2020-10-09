function menu_kinSoft_import_Callback(obj,evd,h_fig)

[fname,pname,~] = uigetfile({'*.mat','Analysis results'},...
    'Select an analysis file');
if ~sum(fname) || ~sum(pname)
    return
end

dat = load([pname,fname]);

h = guidata(h_fig);
h.kinsoft_res = dat.h_kinsoft_res;
h.kinsoft_res{1}{2} = pname;
guidata(h_fig,h);

disp(cat(2,'File ',fname,' successuflly imported!'));