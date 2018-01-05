function routine_clustTDP(h_fig)

h = guidata(h_fig);

% define starting parameters
x_axis = [-0.2 0.028 1.2];
y_axis = [-0.2 0.028 1.2];
sgleCnt = 0;
gconv = 1;
norm = 1;
tpe = 3;
method = 2;
Jmax = 10;
T = 5;
shapes = 1:4;
boba = 1;
S = 100;

% extract quantities
p = h.param.TDP;
PROJ = size(p.proj,2);

% apply routine to each project
for proj = 1:PROJ
    
    % select project
    set(h.listbox_TDPprojList,'Value',proj);
    listbox_TDPprojList_Callback(h.listbox_TDPprojList, [], h);
    h = guidata(h_fig);
    
    % select FRET data type
    set(h.popupmenu_TDPdataType,'Value',tpe);
    popupmenu_TDPdataType_Callback(h.popupmenu_TDPdataType, [], h);
    h = guidata(h_fig);
    
    % reset previous clustering results
    pushbutton_TDPresetClust_Callback(h.pushbutton_TDPresetClust, [], h);
    h = guidata(h_fig);
    
     % set x-axis lower limit
    set(h.edit_TDPxLow,'String',num2str(x_axis(1)));
    edit_TDPxLow_Callback(h.edit_TDPxLow, [], h);
    h = guidata(h_fig);
    
    % set x-axis upper limit
    set(h.edit_TDPxUp,'String',num2str(x_axis(3)));
    edit_TDPxUp_Callback(h.edit_TDPxUp, [], h);
    h = guidata(h_fig);
    
    % set x-axis binning
    set(h.edit_TDPxBin,'String',num2str(x_axis(2)));
    edit_TDPxBin_Callback(h.edit_TDPxBin, [], h);
    h = guidata(h_fig);
    
    % set y-axis lower limit
    set(h.edit_TDPyLow,'String',num2str(y_axis(1)));
    edit_TDPyLow_Callback(h.edit_TDPyLow, [], h);
    h = guidata(h_fig);
    
    % set y-axis upper limit
    set(h.edit_TDPyUp,'String',num2str(y_axis(3)));
    edit_TDPyUp_Callback(h.edit_TDPyUp, [], h);
    h = guidata(h_fig);
        
    % set y-axis binning
    set(h.edit_TDPyBin,'String',num2str(y_axis(2)));
    edit_TDPyBin_Callback(h.edit_TDPyBin, [], h);
    h = guidata(h_fig);
    
    % set one count per transition
    set(h.checkbox_TDP_onecount,'Value',sgleCnt);
    checkbox_TDP_onecount_Callback(h.checkbox_TDP_onecount, [], h);
    h = guidata(h_fig);
    
    % convolute TDP with Gaussian filter
    set(h.checkbox_TDPgconv,'Value',gconv);
    checkbox_TDPgconv_Callback(h.checkbox_TDPgconv, [], h);
    h = guidata(h_fig);
    
    % set TDP units to normalized
    set(h.checkbox_TDPnorm,'Value',norm);
    checkbox_TDPnorm_Callback(h.checkbox_TDPnorm, [], h);
    h = guidata(h_fig);
    
    % update TDP
    pushbutton_TDPupdatePlot_Callback(h.pushbutton_TDPupdatePlot, [], h);
    h = guidata(h_fig);
    
    % select method
    if method==2
        togglebutton_TDPgauss_Callback(h.togglebutton_TDPgauss, [], h);
    else
        togglebutton_TDPkmean_Callback(h.togglebutton_TDPkmean, [], h);
    end
    h = guidata(h_fig);

    % set the max. number of states
    set(h.edit_TDPnStates,'String',num2str(Jmax));
    edit_TDPnStates_Callback(h.edit_TDPnStates, [], h);
    h = guidata(h_fig);
    
    % set the max. number of iterations
    set(h.edit_TDPmaxiter,'String',num2str(T));
    edit_TDPmaxiter_Callback(h.edit_TDPmaxiter, [], h);

    % apply BOBA clustering
    set(h.checkbox_TDPboba,'Value',boba);
    checkbox_TDPboba_Callback(h.checkbox_TDPboba, [], h);
    h = guidata(h_fig);
    
%     % set number of replicates
%     N = ;
%     set(h.edit_TDPnRepl,'String',num2str(N));
%     edit_TDPnRepl_Callback(obj, [], h);
%     h = guidata(h_fig);
    
    % set the numebr fo samples
    set(h.edit_TDPnSpl,'String',num2str(S));
    edit_TDPnSpl_Callback(h.edit_TDPnSpl, [], h);
    h = guidata(h_fig);
    
    for sh = 1:size(shapes,2)
        % select cluster shape
        if method==2
            set(h.popupmenu_TDPstate,'Value',shapes(sh));
            popupmenu_TDPstate_Callback(h.popupmenu_TDPstate, [], h);
            h = guidata(h_fig);
        end

        % start clustering procedure
        pushbutton_TDPupdateClust_Callback(h.pushbutton_TDPupdateClust, [], h);
        h = guidata(h_fig);
    end
end
