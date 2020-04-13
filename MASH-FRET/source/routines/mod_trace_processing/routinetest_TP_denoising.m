function routinetest_TP_denoising(h_fig,p,prefix)
% routinetest_TP_denoising(h_fig,p,prefix)
%
% Tests different denoising methods
%
% h_fig: handle to main figure
% p: structure containing default as set by getDefault_TP
% prefix: string to add at the beginning of each action string (usually a specific indent)

h = guidata(h_fig);

setDefault_TP(h_fig,p);

str_meth = get(h.popupmenu_denoising,'string');
nMeth = numel(str_meth);
defPrm = p.denPrm;
for meth = 1:nMeth
    disp(cat(2,prefix,'test ',str_meth{meth},'...'));
    if meth==3
        for prm1 = 1:3
            for prm2 = 1:2
                for prm3 = 1:2
                    if ~isequal([prm1,prm2,prm3],p.denPrm(meth,:))
                        defPrm(meth,:) = [prm1,prm2,prm3];
                        set_TP_denoising(meth,defPrm,true,h_fig);
                        pushbutton_ttGo_Callback(h.pushbutton_ttGo,[],...
                            h_fig);
                    end
                end
            end
        end
    else
        set_TP_denoising(meth,p.denPrm,true,h_fig);
        pushbutton_ttGo_Callback(h.pushbutton_ttGo,[],h_fig);
    end
end

pushbutton_applyAll_den_Callback(h.pushbutton_applyAll_den,[],h_fig);
pushbutton_TP_updateAll_Callback(h.pushbutton_TP_updateAll,[],h_fig);

pushbutton_remTraces_Callback(h.pushbutton_remTraces,[],h_fig);
