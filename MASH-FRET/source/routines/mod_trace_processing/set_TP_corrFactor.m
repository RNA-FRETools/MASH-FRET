function set_TP_corrFactor(meth,fact,prm,h_fig)
% set_TP_corrFactor(meth,fact,prm,h_fig)
%
% Set correction factor calculations to proper settings
%
% meth: index of calculation method in list
% fact: [nFRET-by-2] gamma and beta correction factors for each FRET pair
% prm: {1-by-2} method settings as set in getDefault_TP for:
%  prm{1}: acceptor photobleaching-based calculation
%  prm{2}: calculations based on linear regression of ES histogram
% h_fig: handle to main figure

% collect interface parameters
h = guidata(h_fig);

set(h.popupmenu_TP_factors_method,'value',meth);
popupmenu_TP_factors_method_Callback(h.popupmenu_TP_factors_method,[],...
    h_fig);
    
if meth==1
    set(h.edit_gammaCorr,'string',num2str(fact(1)));
    edit_gammaCorr_Callback(h.edit_gammaCorr,[],h_fig);
    
    if size(fact,2)>=2
        set(h.edit_betaCorr,'string',num2str(fact(2)));
        edit_betaCorr_Callback(h.edit_betaCorr,[],h_fig);
    end

elseif sum(meth==[2,3])
    pushbutton_optGamma_Callback(h.pushbutton_optGamma,[],h_fig);

    % set calculation options

    %%%%%%%%%%%%%%%%%%%%%%%%%%%
end

