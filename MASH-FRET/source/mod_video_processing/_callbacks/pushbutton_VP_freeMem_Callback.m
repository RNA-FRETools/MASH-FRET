function pushbutton_VP_freeMem_Callback(obj,evd,h_fig)
h = guidata(h_fig);
if isfield(h,'movie') && isfield(h.movie,'movie') && ...
        ~isempty(h.movie.movie)
    h.movie.movie = [];
    guidata(h_fig,h);
    set(obj,'backgroundcolor',get(obj,'userdata'));
end