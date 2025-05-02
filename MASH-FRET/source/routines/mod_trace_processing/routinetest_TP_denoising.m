function routinetest_TP_denoising(h_fig,p,prefix)
% routinetest_TP_denoising(h_fig,p,prefix)
%
% Tests different denoising methods
%
% h_fig: handle to main figure
% p: structure containing default as set by getDefault_TP
% prefix: string to add at the beginning of each action string (usually a specific indent)

h = guidata(h_fig);

% open default project
disp(cat(2,prefix,'import file ',p.mash_files{p.nL,p.nChan}));
[~,name,~] = fileparts(p.mash_files{p.nL,p.nChan});
pushbutton_openProj_Callback({[p.annexpth,name],p.mash_files{p.nL,p.nChan}},...
    [],h_fig);

% set default parameters
setDefault_TP(h_fig,p);

% expand panel
h_but = getHandlePanelExpandButton(h.uipanel_TP_denoising,h_fig);
if strcmp(h_but.String,char(9660))
    pushbutton_panelCollapse_Callback(h_but,[],h_fig);
end

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

pushbutton_closeProj_Callback(h.pushbutton_closeProj,[],h_fig);
