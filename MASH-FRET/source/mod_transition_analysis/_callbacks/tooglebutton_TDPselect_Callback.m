function tooglebutton_TDPselect_Callback(obj,evd,h_fig,ind)

h = guidata(h_fig);

tool = get(h.tooglebutton_TDPmanStart,'userdata');

if sum((1:3)==ind) % selection tool
    if tool==ind
        tool = 0;
    else
        tool = ind;
    end
else % reset tool
    tool = 0;
end

set(h.tooglebutton_TDPmanStart,'userdata',tool);

ud_TDPmdlSlct(h_fig);