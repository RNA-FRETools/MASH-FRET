function ok = pushbutton_export_Callback(obj, evd, h_fig)
% ok = pushbutton_export_Callback([],[],h_fig)
% ok = pushbutton_export_Callback(file_out,[],h_fig)
%
% h_fig: handle to main figure
% obj: {1-by-2} destination folder and file

% collect interface parameters
h = guidata(h_fig);

if ~isfield(h, 'movie')
    return
end

% export video/image
if isfield(h.movie, 'path') && exist(h.movie.path, 'dir')
    cd(h.movie.path);
end

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

