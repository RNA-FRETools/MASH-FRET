function set_VP_spotFinder(meth,gaussfit,sfall,prm,h_fig)
% set_VP_spotFinder(meth,gaussfit,sfall,prm,h_fig)
%
% Set panel Spot finder to proper values and update interface parameters
%
% meth: spot finder method
% gaussfit: (1) fit spots with Gaussians, (0) otherwise
% sfall: (1) apply spotfinder to all video frames, (0) to current frame
% prm: spot finder parameters
% h_fig: handle to main figure

% collect interface parameters
h = guidata(h_fig);

% set method settings
set(h.popupmenu_SF,'value',meth);
popupmenu_SF_Callback(h.popupmenu_SF,[],h_fig);

set(h.checkbox_SFgaussFit,'value',gaussfit);
checkbox_SFgaussFit_Callback(h.checkbox_SFgaussFit,[],h_fig);

set(h.checkbox_SFall,'value',sfall);
checkbox_SFall_Callback(h.checkbox_SFall,[],h_fig);

% set parameters
if meth~=1
    set(h.edit_SFintThresh,'string',num2str(prm(meth,1)));
    edit_SFintThresh_Callback(h.edit_SFintThresh,[],h_fig);
    if meth~=4
        set(h.edit_SFparam_darkW,'string',num2str(prm(meth,2)));
        edit_SFparam_darkW_Callback(h.edit_SFparam_darkW,[],h_fig);
    end
    if meth~=5
        set(h.edit_SFparam_darkH,'string',num2str(prm(meth,3)));
        edit_SFparam_darkH_Callback(h.edit_SFparam_darkH,[],h_fig);
    end
    if gaussfit
        set(h.edit_SFparam_w,'string',num2str(prm(meth,4)));
        edit_SFparam_w_Callback(h.edit_SFparam_w,[],h_fig);

        set(h.edit_SFparam_h,'string',num2str(prm(meth,5)));
        edit_SFparam_h_Callback(h.edit_SFparam_h,[],h_fig);
    end
end

% set selection rules
if meth~=1
    set(h.edit_SFparam_maxN,'string',num2str(prm(meth,6)));
    edit_SFparam_maxN_Callback(h.edit_SFparam_maxN,[],h_fig);
    
    set(h.edit_SFparam_minI,'string',num2str(prm(meth,7)));
    edit_SFparam_minI_Callback(h.edit_SFparam_minI,[],h_fig);

    set(h.edit_SFparam_minDspot,'string',num2str(prm(meth,8)));
    edit_SFparam_minDspot_Callback(h.edit_SFparam_minDspot,[],h_fig);
    
    set(h.edit_SFparam_minDedge,'string',num2str(prm(meth,9)));
    edit_SFparam_minDedge_Callback(h.edit_SFparam_minDedge,[],h_fig);
    
    if gaussfit
        set(h.edit_SFparam_minHWHM,'string',num2str(prm(meth,10)));
        edit_SFparam_minHWHM_Callback(h.edit_SFparam_minHWHM,[],h_fig);

        set(h.edit_SFparam_maxHWHM,'string',num2str(prm(meth,11)));
        edit_SFparam_maxHWHM_Callback(h.edit_SFparam_maxHWHM,[],h_fig);

        set(h.edit_SFparam_maxAssy,'string',num2str(prm(meth,12)));
        edit_SFparam_maxAssy_Callback(h.edit_SFparam_maxAssy,[],h_fig);
    end
end

