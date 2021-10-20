function ok = isFullLengthVideo(h_fig)

h = guidata(h_fig);
p = h.param;

ok = isfield(h,'movie') && isfield(h.movie,'proj') && ...
    h.movie.proj==p.curr_proj && isfield(h.movie,'movie') && ...
    ~isempty(h.movie.movie);