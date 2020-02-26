function set_TP_BA(meth,prm,prm_screen,fixPrm1,fixImgw,h_fig)
% set_TP_BA(meth,prm,prm_screen,fixPrm1,fixImgw,h_fig)
%
% Set background analyzer to proper settings
%
% meth: index of background estimation method in list
% prm: [nMeth-by-6] method parameters as set in getDefault_TP
% prm_screen: [10-by-2-by-nMeth] screening values for method parameter 1 and sub-image widths
% fixPrm1: (1) to use only one value for parameter 1, (0) to screen values
% fixImgw: (1) to use only one value for sub-image width, (0) to screen values
% h_fig: handle to main figure

% collect interface parameters
h = guidata(h_fig);
q = guidata(h.figure_bgopt);

set(q.popupmenu_meth,'value',meth);
popupmenu_BA_meth_Callback(q.popupmenu_meth,[],h_fig);

if meth>1
    set(q.radiobutton_fix_subimdim,'value',fixImgw);
    radiobutton_BA_fix_subimdim_Callback(q.radiobutton_fix_subimdim,[],h_fig);
    
    if sum(meth==(3:7))
        set(q.radiobutton_fix_param1,'value',fixPrm1);
        radiobutton_BA_fix_param1_Callback(q.radiobutton_fix_param1,[],...
            h_fig);
    end
end

if sum(meth==(3:7))
    if fixPrm1
        set(q.edit_param1,'string',num2str(prm(1)));
        edit_BA_param1_Callback(q.edit_param1,[],h_fig,0);
    else
        nEdit = size(q.edit_param1_i,2);
        for n = 1:nEdit
            set(q.edit_param1_i(n),'string',num2str(prm_screen(n,2)));
            edit_BA_param1_Callback(q.edit_param1_i(n),[],h_fig,n);
        end
    end
end

if fixImgw
    set(q.edit_subimdim,'string',num2str(prm(2)));
    edit_BA_subimdim_Callback(q.edit_subimdim,[],h_fig,0);
else
    nEdit = size(q.edit_subimdim_i,2);
    for n = 1:nEdit
        set(q.edit_subimdim_i(n),'string',num2str(prm_screen(n,1)));
        edit_BA_subimdim_Callback(q.edit_subimdim_i(n),[],h_fig,n);
    end
end

if meth==1
    set(q.edit_chan,'string',num2str(prm(3)));
    edit_BA_chan_Callback(q.edit_chan,[],h_fig);
end

if meth==6
    set(q.checkbox_auto,'value',prm(6));
    checkbox_BA_auto_Callback(q.checkbox_auto,[],h_fig);
    if ~prm(6)
        set(q.edit_xdark,'string',num2str(prm(4)));
        edit_BA_xdark_Callback(q.edit_xdark,[],h_fig);

        set(q.edit_ydark,'string',num2str(prm(5)));
        edit_BA_ydark_Callback(q.edit_ydark,[],h_fig);
    end
end

