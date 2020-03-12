function routinetest_TA_stateConfiguration(h_fig,p,prefix)
% routinetest_TA_stateConfiguration(h_fig,p,prefix)
%
% Tests different clustering methods, cluster configurations, axes export and zoom reset
%
% h_fig: handle to main figure
% p: structure containing default as set by getDefault_TA
% prefix: string to add at the beginning of each action string (usually a apecific indent)

setDefault_TA(h_fig,p);

h = guidata(h_fig);

% test regular clustering
disp(cat(2,prefix,'test regular clustering...'));
clstPrm = p.clstMethPrm;
clstPrm(4) = false;
str_meth = get(h.popupmenu_TA_clstMeth,'string');
str_cnfg = get(h.popupmenu_TA_clstMat,'string');
nMeth = numel(str_meth);
nCnfg = numel(str_cnfg);
mouseTested = false(1,nCnfg);
loglTested = false;
for meth = 1:nMeth
    for cnfg = 1:nCnfg
        disp(cat(2,prefix,'>> test method "',str_meth{meth},'" with ',...
            'cluster constraint "',str_cnfg{cnfg},'"...'));
        
        clstConfig = p.clstConfig;
        clstConfig(1) = cnfg;

        % test with and without diagonal clusters
        if cnfg==1 % matrix
            
            % test different likelihood
            if meth==1 && ~loglTested
                clstConfig(3) = 1;
                loglTested = true;
                set_TA_stateConfig(meth,clstPrm,clstConfig,p.clstStart,h_fig)
                pushbutton_TDPupdateClust_Callback(h.pushbutton_TDPupdateClust,...
                    [],h_fig);
            end
            clstConfig(3) = 2;
            
            disp(cat(2,prefix,'>> >> without diagonal clusters...'));
            clstConfig(2) = 0;
            set_TA_stateConfig(meth,clstPrm,clstConfig,p.clstStart,h_fig)
            pushbutton_TDPupdateClust_Callback(h.pushbutton_TDPupdateClust,...
                [],h_fig);
            
            % test cluster definition with mouse and with default
            if sum(meth==[1,3]) && ~mouseTested(cnfg)
                pushbutton_TDPresetClust_Callback(...
                    h.pushbutton_TDPresetClust,[],h_fig);
                axes_TDPplot1_ButtonDownFcn(obj,evd,h_fig);
                pushbutton_TDPupdateClust_Callback(...
                    h.pushbutton_TDPupdateClust,[],h_fig);
            end
            
            % save project
            pushbutton_TDPsaveProj_Callback(...
                {p.dumdir,[sprintf(p.exp_clst,meth,cnfg),'.mash']},[],...
                h_fig);
            
            disp(cat(2,prefix,'>> >> with diagonal clusters...'));
            clstConfig(2) = 1;
            set_TA_stateConfig(meth,clstPrm,clstConfig,p.clstStart,h_fig)
            pushbutton_TDPupdateClust_Callback(h.pushbutton_TDPupdateClust,...
                [],h_fig);
            
            % test cluster definition with mouse and using default
            if sum(meth==[1,3]) && ~mouseTested(cnfg)
                pushbutton_TDPupdateClust_Callback(...
                    h.pushbutton_TDPupdateClust,[],h_fig);
                mouseTested(cnfg) = true;
            end
            
            % save project
            pushbutton_TDPsaveProj_Callback(...
                {p.dumdir,[sprintf(p.exp_clst,meth,cnfg),'_diag.mash']},[],...
                h_fig);
            
            % save default project
            if meth==p.clstMeth && cnfg==p.clstConfig
                pushbutton_TDPsaveProj_Callback({p.annexpth,p.mash_file},...
                    [],h_fig);
            end
        end
    end
end

% test bootstrap clustering
disp(cat(2,prefix,'test bootstrap clustering...'));
str_meth = get(h.popupmenu_TA_clstMeth,'string');
nMeth = numel(str_meth);
for meth = 1:nMeth
    disp(cat(2,prefix,'>> test method ',str_meth{meth},'...'));
end

pushbutton_TDPremProj_Callback(h.pushbutton_TDPremProj,[],h_fig);
