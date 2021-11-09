function push_setExpSet_impOpt(obj,evd,h_fig,h_fig0)
% push_setExpSet_impOpt([],[],h_fig,h_fig0)
%
% h_fig: handle to "Experiment settings" figure
% h_fig0: handle to main figure

% open import options
h_opt = openTrImpOpt(h_fig,h_fig0);
uiwait(h_opt);

% delete import options figure data
h = guidata(h_fig);
if isfield(h,'trImpOpt_ok')
    h = rmfield(h,'trImpOpt_ok');
    guidata(h_fig,h);
end