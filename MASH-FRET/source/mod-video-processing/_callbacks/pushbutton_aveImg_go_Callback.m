function pushbutton_aveImg_go_Callback(obj, evd, h_fig)
% pushbutton_aveImg_go_Callback([],[],h_fig)
% pushbutton_aveImg_go_Callback(file_out,[],h_fig)
%
% h_fig: handle to main figure
% file_out: {1-by-2} destination folder and file for average image

% collect parameters
h = guidata(h_fig);
p = h.param;
vidfile = p.proj{p.curr_proj}.movie_file;
viddat = p.proj{p.curr_proj}.movie_dat;
curr = p.proj{p.curr_proj}.VP.curr;
prm = p.proj{p.curr_proj}.VP.prm;
start = curr.gen_crd{1}(1);
stop = curr.gen_crd{1}(2);
iv = curr.gen_crd{1}(3);

% apply current parameters to project
prm.gen_crd{1} = curr.gen_crd{1};

% build average image
param.start = start;
param.stop = stop;
param.iv = iv;
param.file = vidfile;
param.extra = viddat;
[img_ave,ok] = createAveIm(param,true,true,h_fig);
if ~ok
    return
end

% save average image
prm.res_plot{2} = img_ave;

% save modifications
p.proj{p.curr_proj}.VP.prm = prm;
p.proj{p.curr_proj}.VP.curr.res_plot = prm.res_plot;

h.param = p;
guidata(h_fig,h);

% update calculations, plot and panels
updateFields(h_fig,'imgAxes');

% display success
setContPan(['The average image (' num2str(param.start) ':' ...
    num2str(param.iv) ':' num2str(param.stop) ') has been successfully ',...
    'created'], 'success', h_fig);

