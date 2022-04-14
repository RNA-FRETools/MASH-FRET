function ud_expTDPopt(h_fig)
h = guidata(h_fig);
q = h.expTDPopt;
p = h.param;

proj = p.curr_proj;
tpe = p.TDP.curr_type(proj);
tag = p.TDP.curr_tag(proj);
prm = p.proj{proj}.TA.prm{tag,tpe};

opt = guidata(q.figure_expTDPopt);

% check presence of TDP
isTDP = true;
if ~(isfield(prm,'plot') && ~isnan(sum(sum(prm.plot{2}))) && ...
        sum(sum(prm.plot{2})))
    isTDP = false;
    opt{2}(1) = false;
    opt{2}(2) = false;
end

% check presence of clusters
isClst = true;
if ~(isfield(prm,'clst_res') && size(prm.clst_res,2)>=1 && ...
        ~isempty(prm.clst_res{1}))
    isClst = false;
    opt{2}(5) = false;
end

% check presence of dwell time histograms
isHist = true;
if ~isfield(prm,'clst_start')
    isHist = false;
    opt{3}(1) = false;
end

% check presence of fit
isFit = true;
if ~(isfield(prm,'lft_res') && size(prm.lft_res,2)>=2 && ...
        sum(~cellfun('isempty',prm.lft_res(:,2))))
    isFit = false;
    opt{3}(2) = false;
end

% check presence of boba fit
isBobaFit = true;
if ~(isfield(prm,'lft_res') && size(prm.lft_res,2)>=5 && ...
        sum(~cellfun('isempty',prm.lft_res(:,5))))
    isBobaFit = false;
    opt{3}(4) = false;
    opt{3}(3) = false;
end

% check presence of kinetic model 
isMdl = true;
if ~(isfield(prm,'mdl_res') && size(prm.mdl_res,2)>=1 && ...
        ~isempty(prm.mdl_res{1}))
    isMdl = false;
    opt{4}(2:3) = false;
end

% check presence of model selection
isMdlSlct = true;
if ~(isfield(prm,'mdl_res') && size(prm.mdl_res,2)>=6 && ...
        ~isempty(prm.mdl_res{6}))
    isMdlSlct = false;
    opt{4}(1) = false;
end

guidata(q.figure_expTDPopt,opt);

TDPascii = opt{2}(1);
TDPimg = opt{2}(2);
TDPascii_fmt = opt{2}(3);
TDPimg_fmt = opt{2}(4);
TDPclust = opt{2}(5);

kinDtHist = opt{3}(1);
kinFit = opt{3}(2);
kinBoba = opt{3}(3);
figBoba = opt{3}(4);

mdlBIC = opt{4}(1);
mdlPrm = opt{4}(2);
mdlSim = opt{4}(3);

set([q.checkbox_TDPascii q.popupmenu_TDPascii q.checkbox_TDPimg ...
    q.popupmenu_TDPimg q.checkbox_kinDthist q.checkbox_kinCurves ...
    q.checkbox_kinBOBA q.checkbox_figBOBA q.checkbox_mdlSlct ...
    q.checkbox_mdlOpt q.checkbox_mdlSim q.pushbutton_cancel ...
    q.pushbutton_next], 'Enable', 'on');

set(q.checkbox_TDPascii, 'Value', TDPascii);
if TDPascii
    set(q.popupmenu_TDPascii,'Value',TDPascii_fmt);
else
    set(q.popupmenu_TDPascii,'Enable','off');
end

set(q.checkbox_TDPimg, 'Value', TDPimg);
if TDPimg
    set(q.popupmenu_TDPimg,'Value',TDPimg_fmt);
else
    set(q.popupmenu_TDPimg,'Enable','off');
end

set(q.checkbox_TDPclust, 'Value', TDPclust);
set(q.checkbox_kinDthist, 'Value', kinDtHist);
set(q.checkbox_kinCurves, 'Value', kinFit);
set(q.checkbox_kinBOBA, 'Value', kinBoba);
set(q.checkbox_figBOBA, 'Value', figBoba);
set(q.checkbox_mdlSlct, 'Value', mdlBIC);
set(q.checkbox_mdlOpt, 'Value', mdlPrm);
set(q.checkbox_mdlSim, 'Value', mdlSim);
if ~isTDP
    set([q.checkbox_TDPascii,q.popupmenu_TDPascii q.checkbox_TDPimg ...
        q.popupmenu_TDPimg],'Enable','off');
end
if ~isClst
    set(q.checkbox_TDPclust,'Enable','off');
end
if ~isHist
    set(q.checkbox_kinDthist,'Enable','off');
end
if ~isFit
    set(q.checkbox_kinCurves,'Enable','off');
end
if ~isBobaFit
    set([q.checkbox_kinBOBA q.checkbox_figBOBA],'Enable','off');
end
if ~isMdl
    set([q.checkbox_mdlOpt q.checkbox_mdlSim],'Enable','off');
end
if ~isMdlSlct
    set(q.checkbox_mdlSlct,'Enable','off');
end

