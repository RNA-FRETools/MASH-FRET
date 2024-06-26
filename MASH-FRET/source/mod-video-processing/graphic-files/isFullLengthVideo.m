function ok = isFullLengthVideo(filename,h_fig)

h = guidata(h_fig);

ok = isfield(h,'movie') && isfield(h.movie,'file') && ...
    strcmp(h.movie.file,filename) && isfield(h.movie,'movie') && ...
    ~isempty(h.movie.movie);