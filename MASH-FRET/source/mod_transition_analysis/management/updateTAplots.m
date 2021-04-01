function updateTAplots(h_fig,varargin)
% updateTAplots(h_fig)
% updateTAplots(h_fig,'all')
% updateTAplots(h_fig,'tdp')
% updateTAplots(h_fig,'kin')
% updateTAplots(h_fig,'mdl')
%
% Refresh plots in Transition analysis
%
% h_fig: handle to main figure
% 'all': refresh all plots
% 'tdp': refresh TDP plot only
% 'kin': refresh dwell time histogram only
% 'mdl': refresh kinetic model only

opt = 'all';
if ~isempty(varargin)
    opt = varargin{1};
end

h = guidata(h_fig);
p = h.param.TDP;
if isempty(p.proj)
    cla(h.axes_TDPplot1);
    cla(h.axes_tdp_BIC);
    cla(h.axes_TDPplot2);
    cla(h.axes_TDPplot3);
    h_arr = h.axes_TDPplot3.UserData;
    if ~isempty(h_arr)
        delete(h_arr);
    end
    cla(h.axes_TA_mdlDt);
    cla(h.axes_TA_mdlBIC);
    cla(h.axes_TA_mdlPop);
    cla(h.axes_TA_mdlTrans);
    return
end

proj = p.curr_proj;

tag = p.curr_tag(proj);
tpe = p.curr_type(proj);
def = p.proj{proj}.def{tag,tpe};
curr = p.proj{proj}.curr{tag,tpe};
prm = p.proj{proj}.prm{tag,tpe};
v_lft = curr.lft_start{2}(2);
v_mdl = get(h.popupmenu_TA_mdlDtState,'Value');
k = get(h.popupmenu_TA_slTrans,'value');

if strcmp(opt,'all') || strcmp(opt,'tdp')
    plotTDP([h.axes_TDPplot1,h.colorbar_TA,h.axes_tdp_BIC], curr, prm);
end
if strcmp(opt,'all') || strcmp(opt,'kin')
    plotKinFit(h.axes_TDPplot2, p, prm, tag, tpe, v_lft, k,...
        get(h.pushbutton_TDPfit_log, 'String'));
end
if strcmp(opt,'all') || strcmp(opt,'mdl')
    plotKinMdl([h.axes_TDPplot3,h.axes_TA_mdlPop,h.axes_TA_mdlTrans,...
        h.axes_TA_mdlDt,h.axes_TA_mdlBIC],prm,def,v_mdl);
end
