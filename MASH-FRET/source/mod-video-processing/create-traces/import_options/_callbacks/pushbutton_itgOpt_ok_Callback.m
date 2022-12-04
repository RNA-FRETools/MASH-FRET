function pushbutton_itgOpt_ok_Callback(obj, evd, h_fig, but_obj)

% update 28.3.2019 by MH: Correct parameter saving: if coordinates import option window is called from trace import options, parameters must be saved in figure_trImpOpt's handle instead of figure_MASH's handle.

% retrieve import options
h = guidata(h_fig);
if isfield(h,'pushbutton_TTgen_loadOpt') && ...
        but_obj==h.pushbutton_TTgen_loadOpt
    proj = h.param.proj{h.param.curr_proj};
    cio = proj.VP.curr.gen_int{2}{3};
elseif isfield(h,'push_impCoordOpt') && but_obj==h.push_impCoordOpt
    proj = h_fig.UserData;
    cio = proj.traj_import_opt{3}{3};
else
    return
end

% collect options modifications
nChan = proj.nb_channel;
for i = 1:nChan
    cio{1}(i,1:2) = [str2double(get(h.itgOpt.edit_cColX(i),'String')) ...
        str2double(get(h.itgOpt.edit_cColY(i),'String'))];
end
cio{2} = str2double(get(h.itgOpt.edit_nHead,'String'));

% save modifications
if isfield(h,'pushbutton_TTgen_loadOpt') && ...
    but_obj==h.pushbutton_TTgen_loadOpt
    proj.VP.curr.gen_int{2}{3} = cio;
    h.param.proj{h.param.curr_proj} = proj;
    guidata(h_fig, h);
else
    proj.traj_import_opt{3}{3} = cio;
    h_fig.UserData = proj;
end

% close import options window
close(h.figure_itgOpt);
