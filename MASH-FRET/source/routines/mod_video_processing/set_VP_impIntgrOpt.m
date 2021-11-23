function set_VP_impIntgrOpt(prm,h_but,h_fig0)
% set_VP_impIntgrOpt(prm,h_but,h_fig)
%
% Set transformed coordinates import options to proper values and update interface parameters
%
% prm: {1-by-2} coordinates import settings with:
%  prm{1}: [nChan-by-2] column index in file where x- and y-coordinates in each channel are written
%  prm{2}: number of header lines in file
% h_but: handle to pushbutton that was pressed to open option window
% h_fig: handle to main figure

% open import option window
h0 = guidata(h_fig0);
if isfield(h0,'pushbutton_TTgen_loadOpt') && ...
        h_but==h0.pushbutton_TTgen_loadOpt
    pushbutton_TTgen_loadOpt_Callback(h0.pushbutton_TTgen_loadOpt,[],...
        h_fig0);
    
    % recover modified interface parameters
    h0 = guidata(h_fig0);
    q = h0.itgOpt;
    
elseif isfield(h0,'figure_setExpSet') && ishandle(h0.figure_setExpSet)
    h_fig = h0.figure_setExpSet;
    h = guidata(h_fig);
    push_setExpSet_impCoordOpt(h.push_impCoordOpt,[],h_fig,h_fig0);

    % recover modified interface parameters
    h = guidata(h_fig);
    q = h.itgOpt;
else
    disp('set_VP_impIntgrOpt: invalid button handle.')
    return
end

% set file columns
for c = 1:size(prm{1},1)
    set(q.edit_cColX(c),'string',num2str(prm{1}(c,1)));
    set(q.edit_cColY(c),'string',num2str(prm{1}(c,2)));
end

% set file header lines
set(q.edit_nHead,'string',num2str(prm{2}));

% save settings and close window

if isfield(h0,'pushbutton_TTgen_loadOpt') && ...
        h_but==h0.pushbutton_TTgen_loadOpt
    pushbutton_itgOpt_ok_Callback(q.pushbutton_itgOpt_ok,[],h_fig0,h_but);
else
    pushbutton_itgOpt_ok_Callback(q.pushbutton_itgOpt_ok,[],h_fig,h_but);
end
