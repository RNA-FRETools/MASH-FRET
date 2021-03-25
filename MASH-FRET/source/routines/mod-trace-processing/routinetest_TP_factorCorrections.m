function routinetest_TP_factorCorrections(h_fig,p,prefix)
% routinetest_TP_factorCorrections(h_fig,p,prefix)
%
% Tests different methods for calculations of correction factors
%
% h_fig: handle to main figure
% p: structure containing default as set by getDefault_TP
% prefix: string to add at the beginning of each action string (usually a specific indent)

h = guidata(h_fig);

setDefault_TP(h_fig,p);

str_meth = get(h.popupmenu_TP_factors_method,'string');
nMeth = numel(str_meth);
nPair = numel(get(h.popupmenu_gammaFRET,'string'))-1;
factPrm = p.factPrm;
factPrm{1} = {p.dumpdir,p.factFiles};
for meth = 1:nMeth
    disp(cat(2,prefix,'test ',str_meth{meth},'...'));
    for pair = 1:nPair
        set(h.popupmenu_gammaFRET,'value',pair+1);
        popupmenu_gammaFRET_Callback(h.popupmenu_gammaFRET,[],h_fig);
        if p.factMeth==0
            % import factors from file
            set_TP_corrFactor(0,p.fact,factPrm,h_fig);
            pushbutton_ttGo_Callback(h.pushbutton_ttGo,[],h_fig);
        end
        
        set_TP_corrFactor(meth,p.fact,factPrm,h_fig);
        pushbutton_ttGo_Callback(h.pushbutton_ttGo,[],h_fig);
    end
end

pushbutton_applyAll_corr_Callback(h.pushbutton_applyAll_corr,[],h_fig);
pushbutton_TP_updateAll_Callback(h.pushbutton_TP_updateAll,[],h_fig);

pushbutton_remTraces_Callback(h.pushbutton_remTraces,[],h_fig);
