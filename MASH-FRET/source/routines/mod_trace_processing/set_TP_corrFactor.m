function set_TP_corrFactor(meth,fact,prm,h_fig)
% set_TP_corrFactor(meth,fact,prm,h_fig)
%
% Set correction factor calculations to proper settings
%
% meth: index of calculation method in list
% fact: [nFRET-by-1 or -2] gamma and beta correction factors for each FRET pair
% prm: {1-by-2} method settings as set in getDefault_TP for:
%  prm{1}: {1-by-2} source directory and {1-by-nFiles} factor files
%  prm{2}: acceptor photobleaching-based calculation
%  prm{3}: calculations based on linear regression of ES histogram
% h_fig: handle to main figure

% collect interface parameters
h = guidata(h_fig);

impFile = false;
if meth==0
    impFile = true;
    meth = 1;
end
set(h.popupmenu_TP_factors_method,'value',meth);
popupmenu_TP_factors_method_Callback(h.popupmenu_TP_factors_method,[],...
    h_fig);

if impFile % import factors from file
    pushbutton_optGamma_Callback({prm{1}{1},prm{1}{2}},[],h_fig);
    
else
    switch meth
        case 1
            set(h.edit_gammaCorr,'string',num2str(fact(1)));
            edit_gammaCorr_Callback(h.edit_gammaCorr,[],h_fig);

            if size(fact,2)>=2
                set(h.edit_betaCorr,'string',num2str(fact(2)));
                edit_betaCorr_Callback(h.edit_betaCorr,[],h_fig);
            end

        case 2
            pushbutton_optGamma_Callback(h.pushbutton_optGamma,[],h_fig);
            h = guidata(h_fig);
            h_fig2 = h.figure_gammaOpt;
            q = guidata(h_fig2);
            
            set(q.popupmenu_data,'value',prm{2}(1));
            popupmenu_data_pbGamma_Callback(q.popupmenu_data,[],h_fig,...
                h_fig2);
            
            set(q.edit_threshold,'string',num2str(prm{2}(2)));
            edit_pbGamma_threshold_Callback(q.edit_threshold,[],h_fig,...
                h_fig2);
            
            set(q.edit_extraSubstract,'string',num2str(prm{2}(3)));
            edit_pbGamma_extraSubstract_Callback(q.edit_extraSubstract,[],...
                h_fig,h_fig2);
            
            set(q.edit_minCutoff,'string',num2str(prm{2}(4)));
            edit_pbGamma_minCutoff_Callback(q.edit_minCutoff,[],h_fig,...
                h_fig2);
            
            set(q.edit_tol,'string',num2str(prm{2}(5)));
            edit_pbGamma_tol_Callback(q.edit_tol,[],h_fig,h_fig2);
            
            pushbutton_computeGamma_Callback(q.pushbutton_save,[],h_fig,h_fig2);

        case 3
            pushbutton_optGamma_Callback(h.pushbutton_optGamma,[],h_fig);
            h = guidata(h_fig);
            h_fig2 = h.figure_ESlinRegOpt;
            q = guidata(h_fig2);
            
            set(q.popupmenu_tag,'value',prm{3}(1));
            popupmenu_tag_ESopt_Callback(q.popupmenu_tag,[],h_fig,h_fig2);
            
            set(q.edit_Emin,'string',num2str(prm{3}(2)));
            edit_Emin_ESopt_Callback(q.edit_Emin,[],h_fig,h_fig2);
            
            set(q.edit_Ebin,'string',num2str(prm{3}(3)));
            edit_Ebin_ESopt_Callback(q.edit_Ebin,[],h_fig,h_fig2);
            
            set(q.edit_Emax,'string',num2str(prm{3}(4)));
            edit_Emax_ESopt_Callback(q.edit_Emax,[],h_fig,h_fig2);
            
            set(q.edit_Smin,'string',num2str(prm{3}(5)));
            edit_Smin_ESopt_Callback(q.edit_Smin,[],h_fig,h_fig2);
            
            set(q.edit_Sbin,'string',num2str(prm{3}(6)));
            edit_Sbin_ESopt_Callback(q.edit_Sbin,[],h_fig,h_fig2);
            
            set(q.edit_Smax,'string',num2str(prm{3}(7)));
            edit_Smax_ESopt_Callback(q.edit_Smax,[],h_fig,h_fig2);
            
            pushbutton_linreg_ESopt_Callback(q.pushbutton_linreg,[],h_fig,...
                h_fig2);
            
            set(q.checkbox_show,'value',prm{3}(8));
            checkbox_show_ESopt_Callback(q.checkbox_show,[],h_fig,h_fig2);

            pushbutton_save_ESopt_Callback(q.pushbutton_save,[],h_fig,...
                h_fig2);
    end
end

