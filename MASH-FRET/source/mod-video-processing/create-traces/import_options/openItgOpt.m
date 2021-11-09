function openItgOpt(but_obj, evd, h_fig)
% openItgOpt(but_obj,[],h_fig)
%
% Opens "Coordinates import options" window.
%
% but_obj: handle to push button "Import options" in panel "Intensity integration" of module VP, or in tab "Import" of Window "Experiment settings".
% h_fig: handle to main figure or to window "Experiment settings"

% Last update by MH, 28.3.2019: Correct parameter saving (in pushbutton_itgOpt_ok_Callback) and import (openItgOpt.m) : if coordinates import option window is called from Trace import options's window, parameters must be saved in/imported from figure_trImpOpt's handle instead of figure_MASH's handle.

% collect coordinates import options
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

% control options size regarding number of channels
nChan = proj.nb_channel;
if size(cio{1},1)<nChan
    for i = (size(cio{1},1)+1):nChan
        cio{1} = [cio{1};cio{1}(i-1,end)+1,cio{1}(i-1,end)+2];
    end
end
cio{1} = cio{1}(1:nChan,:);

% build GUI
if isfield(h,'figure_itgOpt') && ishandle(h.figure_itgOpt)
    return
end
buildItgOpt(cio,but_obj,h_fig);

