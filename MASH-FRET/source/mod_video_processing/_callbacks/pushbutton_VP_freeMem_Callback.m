function pushbutton_VP_freeMem_Callback(obj,evd,h)

if isfield(h,'movie') && isfield(h.movie,'movie') && ...
        ~isempty(h.movie.movie)
    h.movie.movie = [];
    guidata(h.figure_MASH,h);
    set(obj,'backgroundcolor',repmat(.94,1,3));
end