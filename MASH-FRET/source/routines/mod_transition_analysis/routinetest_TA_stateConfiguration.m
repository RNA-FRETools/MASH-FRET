function routinetest_TA_stateConfiguration(h_fig,p,prefix)
% routinetest_TA_stateConfiguration(h_fig,p,prefix)
%
% Tests different clustering methods, cluster configurations, axes export and zoom reset
%
% h_fig: handle to main figure
% p: structure containing default as set by getDefault_TA
% prefix: string to add at the beginning of each action string (usually a apecific indent)

% defaults
lklhd = [1,2];
nShapes = [3,4,3];

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
mouseTested = false(nCnfg,nShapes(1));
defTested = false(nCnfg,nShapes(1));
loglTested = false;
for meth = 1:nMeth
    for cnfg = 1:nCnfg
        clstConfig = p.clstConfig;
        clstConfig(1) = cnfg;
        
        % test different likelihood for first clustering test
        if meth==2 && ~loglTested
            clstConfig(3) = lklhd(lklhd~=p.clstConfig(3));
            loglTested = true;
        end
        
        % test different shapes
        for shape = 1:nShapes(meth)
            disp(cat(2,prefix,'>> test method "',str_meth{meth},'" with ',...
                'cluster constraint "',str_cnfg{cnfg},'" and cluster ',...
                'shape ',num2str(shape),'...'));
            clstConfig(4) = shape;
            
            % test with and without diagonal clusters
            if cnfg==1 % matrix
                disp(cat(2,prefix,'>> >> without diagonal clusters...'));
                clstConfig(2) = 0;
                set_TA_stateConfig(meth,clstPrm,clstConfig,p.clstStart,...
                    h_fig)

                % test cluster definition with mouse default once per config
                if sum(meth==[1,3]) && ~mouseTested(cnfg,shape)
                    pushbutton_TDPresetClust_Callback(...
                    h.pushbutton_TDPresetClust,[],h_fig); % reset clustering
                
                    set(h.tooglebutton_TDPmanStart,'value',1); % open tool panel
                    tooglebutton_TDPmanStart_Callback(...
                        h.tooglebutton_TDPmanStart,[],h_fig,'open');

                    set(h.tooglebutton_TDPselectZoom,'value',1); % zoom tool
                    tooglebutton_TDPselect_Callback(...
                        h.tooglebutton_TDPselectZoom,[],h_fig,1);
                    
                    set(h.tooglebutton_TDPmanStart,'value',1); % open tool panel
                    tooglebutton_TDPmanStart_Callback(...
                        h.tooglebutton_TDPmanStart,[],h_fig,'open');

                    tooglebutton_TDPselect_Callback(...
                        h.pushbutton_TDPselectClear,[],h_fig,3); % clear starting guess
                    
                    set(h.tooglebutton_TDPmanStart,'value',1); % open tool panel
                    tooglebutton_TDPmanStart_Callback(...
                        h.tooglebutton_TDPmanStart,[],h_fig,'open');
                    
                    set(h.tooglebutton_TDPselectCross,'value',1); % selection tool
                    tooglebutton_TDPselect_Callback(...
                        h.tooglebutton_TDPselectCross,[],h_fig,2);

                    for j = 1:p.clstMethPrm(1)
                        set(h.popupmenu_TDPstate,'value',j);
                        popupmenu_TDPstate_Callback(h.popupmenu_TDPstate,...
                            [],h_fig);

                        axes_TDPplot1_ButtonDownFcn(h.axes_TDPplot1,[],...
                            h_fig); % press

                        pos1 = p.clstStart(j,[1,3])-p.clstStart(j,[2,4]);
                        pos2 = p.clstStart(j,[1,3])+p.clstStart(j,[2,4]);
                        pos1 = posAxesToFig(pos1,h_fig,h.axes_TDPplot1,...
                            'normalized');
                        pos2 = posAxesToFig(pos2,h_fig,h.axes_TDPplot1,...
                            'normalized');
                        
                        axes_TDPplot1_traverseFcn(h_fig,pos1); % set first point
                        axes_TDPplot1_traverseFcn(h_fig,pos2); % set second point

                        figure_MASH_WindowButtonUpFcn(h_fig,[]); % release
                    end

                    % export image of strating guess
                    set(h_fig,'currentaxes',h.axes_TDPplot1);
                    exportAxes({[p.dumpdir,filesep,...
                        sprintf(p.exp_mouseSlct,cnfg,shape),'_nodiag.png']},...
                        [],h_fig);
                end

                % test cluster definition with default once per config
                if sum(meth==[1,3]) && ~defTested(cnfg,shape)
                    pushbutton_TDPresetClust_Callback(...
                        h.pushbutton_TDPresetClust,[],h_fig);
                    pushbutton_TDPautoStart_Callback(...
                        h.pushbutton_TDPautoStart,[],h_fig);
                    set(h_fig,'currentaxes',h.axes_TDPplot1);
                    exportAxes({[p.dumpdir,filesep,...
                        sprintf(p.exp_defSlct,cnfg,shape),'_nodiag.png']},...
                        [],h_fig);
                end

                % start clustering
                pushbutton_TDPupdateClust_Callback(...
                    h.pushbutton_TDPupdateClust,[],h_fig);

                % save project
                pushbutton_TDPsaveProj_Callback({p.dumpdir,...
                    [sprintf(p.exp_clst,meth,cnfg),'_nodiag.mash']},[],...
                    h_fig);
                
                % save default project
                if meth==p.clstMeth && isequal(clstConfig,p.clstConfig)
                    pushbutton_TDPsaveProj_Callback(...
                        {p.annexpth,p.mash_file},[],h_fig);
                end

                disp(cat(2,prefix,'>> >> with diagonal clusters...'));
                clstConfig(2) = 1;
            end
            
            set_TA_stateConfig(meth,clstPrm,clstConfig,p.clstStart,h_fig)

            % test cluster definition with mouse default once per config
            if sum(meth==[1,3]) && ~mouseTested(cnfg,shape)
                pushbutton_TDPresetClust_Callback(...
                    h.pushbutton_TDPresetClust,[],h_fig); % reset clustering
                
                set(h.tooglebutton_TDPmanStart,'value',1); % open tool panel
                tooglebutton_TDPmanStart_Callback(...
                    h.tooglebutton_TDPmanStart,[],h_fig,'open');
                
                set(h.tooglebutton_TDPselectZoom,'value',1); % zoom tool
                tooglebutton_TDPselect_Callback(...
                    h.tooglebutton_TDPselectZoom,[],h_fig,1);
                
                tooglebutton_TDPselect_Callback(...
                    h.pushbutton_TDPselectClear,[],h_fig,3); % clear starting guess
                
                set(h.tooglebutton_TDPselectCross,'value',1); % selection tool
                tooglebutton_TDPselect_Callback(...
                    h.tooglebutton_TDPselectCross,[],h_fig,2);
                
                for j = 1:p.clstMethPrm(1)
                    set(h.popupmenu_TDPstate,'value',j);
                    popupmenu_TDPstate_Callback(h.popupmenu_TDPstate,[],...
                        h_fig);
                    
                    axes_TDPplot1_ButtonDownFcn(h.axes_TDPplot1,[],h_fig); % press
                    
                    pos1 = p.clstStart(j,[1,3])-p.clstStart(j,[2,4]);
                    pos2 = p.clstStart(j,[1,3])+p.clstStart(j,[2,4]);
                    pos1 = posAxesToFig(pos1,h_fig,h.axes_TDPplot1,...
                        'normalized');
                    pos2 = posAxesToFig(pos2,h_fig,h.axes_TDPplot1,...
                        'normalized');
                    
                    axes_TDPplot1_traverseFcn(h_fig,pos1); % set first point
                    axes_TDPplot1_traverseFcn(h_fig,pos2); % set second point
                    
                    figure_MASH_WindowButtonUpFcn(h_fig,[]); % release
                end

                % export image of strating guess
                set(h_fig,'currentaxes',h.axes_TDPplot1);
                exportAxes({[p.dumpdir,filesep,...
                    sprintf(p.exp_mouseSlct,cnfg,shape),'.png']},[],...
                    h_fig);
                mouseTested(cnfg,shape) = true;
            end

            % test cluster definition with default once per config
            if sum(meth==[1,3]) && ~defTested(cnfg,shape)
                pushbutton_TDPresetClust_Callback(...
                    h.pushbutton_TDPresetClust,[],h_fig);
                pushbutton_TDPautoStart_Callback(...
                    h.pushbutton_TDPautoStart,[],h_fig);
                set(h_fig,'currentaxes',h.axes_TDPplot1);
                exportAxes({[p.dumpdir,filesep,...
                    sprintf(p.exp_defSlct,cnfg,shape),'.png']},[],...
                    h_fig);
                defTested(cnfg,shape) = true;
            end

            pushbutton_TDPupdateClust_Callback(h.pushbutton_TDPupdateClust,...
                [],h_fig);

            % save project
            pushbutton_TDPsaveProj_Callback(...
                {p.dumpdir,[sprintf(p.exp_clst,meth,cnfg),'.mash']},[],...
                h_fig);

            % save default project
            if meth==p.clstMeth && isequal(clstConfig,p.clstConfig)
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