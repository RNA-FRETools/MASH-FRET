function ok = pushbutton_export_Callback(obj, evd, h_fig)
% ok = pushbutton_export_Callback([],[],h_fig)
% ok = pushbutton_export_Callback(file_out,[],h_fig)
%
% h_fig: handle to main figure
% obj: {1-by-2} destination folder and file

% collect parameters
h = guidata(h_fig);
p = h.param;
vidfile = p.proj{p.curr_proj}.movie_file;

% set current directory to video file location
[pname,~,~] = fileparts(vidfile{1});
cd(pname);

if iscell(obj)
    pname = obj{1};
    fname = obj{2};
    if ~strcmp(pname(end),filesep)
        pname = cat(2,pname,filesep);
    end
    ok = exportMovie(h_fig,pname,fname);
else
    ok = exportMovie(h_fig);
end

