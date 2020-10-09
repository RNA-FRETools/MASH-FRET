function menu_kinSoft_Callback(obj,evd,step,h_fig)

% save current interface
h = guidata(h_fig);
h_prev = h;
curr_dir = pwd;

% set overwirting file option to "always overwrite"
h.param.OpFiles.overwrite_ask = false;
h.param.OpFiles.overwrite = true;

% set action display on mute
h.mute_actions = true;

if ~isfield(h,'kinsoft_res')
    h.kinsoft_res = cell(1,4);
end
guidata(h_fig,h);

disp(' ')
disp('start analysis of kinSoft challenge data...');

try
    % Find optimum number of states
    if sum(step==[0,1])
        
        t1 = tic;
        
        [pname,fname,res,Js] = routine_findJ(h_fig);
        if isempty(res)
            return
        end
        
        t_1 = toc(t1);

        h.kinsoft_res{1} = {t_1,pname,fname,res,Js};
        h.kinsoft_res(2:end) = cell(1,3);
        guidata(h_fig,h);
    end

    % determine FRET states and associated deviations
    if sum(step==[0,2])
        if isempty(h.kinsoft_res{1})
            disp(' ')
            disp('step 1 must first be performed.')
            return
        end
        
        pname = h.kinsoft_res{1}{2};
        fname = h.kinsoft_res{1}{3};
        Js = h.kinsoft_res{1}{5}(:,1)';
        
        t2 = tic;
        
        states = routine_getFRETstates(pname,fname,Js,h_fig);
        
        t_2 = toc(t2);

        h.kinsoft_res{2} = {t_2,states};
        h.kinsoft_res(3:end) = cell(1,2);
        guidata(h_fig,h);
    end

    % calculate transition rates and associated deviations
    if sum(step==[0,3])
        if isempty(h.kinsoft_res{2})
            disp(' ')
            disp('step 2 must first be performed.')
            return
        end
        
        pname = h.kinsoft_res{1}{2};
        fname = h.kinsoft_res{1}{3};
        Js = h.kinsoft_res{1}{5}(:,1)';
        
        t3 = tic;
        
        [ks,mat,prob0] = routine_getRates(pname,fname,Js,h_fig);
        
        t_3 = toc(t3);

        h.kinsoft_res{3} = {t_3,ks,mat,prob0};
        h.kinsoft_res(end) = cell(1,1);
        guidata(h_fig,h);
    end

    % select the final number of states by comparing simulations
    if sum(step==[0,4])
        if isempty(h.kinsoft_res{3})
            disp(' ')
            disp('step 3 must first be performed.')
            return
        end
        
        pname = h.kinsoft_res{1}{2};
        fname = h.kinsoft_res{1}{3};
        Js = h.kinsoft_res{1}{5}(:,1)';
        states = h.kinsoft_res{2}{2};
        mat = h.kinsoft_res{3}{3};
        prob0 = h.kinsoft_res{3}{4};
        
        t4 = tic;
        
        [TDPs,logL,useProb0] = routine_backSim(pname,fname,Js,states,mat,...
            prob0,h_fig);
        
        t_4 = toc(t4);
        
        h.kinsoft_res{4} = {t_4,TDPs,logL};
    end
    
    t_ana = 0;
    for s = 1:size(h.kinsoft_res,2)
        if ~isempty(h.kinsoft_res{s})
            t_ana = t_ana + h.kinsoft_res{s}{1};
        end
    end
    
    if ~isempty(h.kinsoft_res{1})        
        pname = h.kinsoft_res{1}{2};
        if ~strcmp(pname(end),filesep)
            pname = [pname,filesep];
        end
        [~,fname,~] = fileparts(pname(1:end-1));
        BICs = h.kinsoft_res{1}{4}.BIC;
        Js = h.kinsoft_res{1}{5}(:,1);
        BICs = [(1:numel(BICs))',BICs',zeros(numel(BICs),1)];
        BICs(isinf(BICs(:,2)),:) = [];
        for j = 1:numel(Js)
            BICs(BICs(:,1)==Js(j),3) = 1;
        end
        for j = 1:numel(Js)
            f = fopen(...
                [pname,fname,'_results_',num2str(Js(j)),'states.txt'],...
                'Wt');

            fprintf(f,'Total processing time (in seconds):%d\n',t_ana);
            
            fprintf(f,'\nNumber of states:\n');
            fprintf(f,'J\tBIC\tselected\n');
            fprintf(f,'%i\t%d\t%i\n',BICs');
            
            if ~isempty(h.kinsoft_res{2})
                states = h.kinsoft_res{2}{2}{j};
                fprintf(f,'\nState configuration:\n');
                fprintf(f,'state\tFRET\tsigma_FRET\n');
                fprintf(f,'%i\t%d\t%d\n',[(1:Js(j))',states]');
                
                if ~isempty(h.kinsoft_res{3})
                    ks = h.kinsoft_res{3}{2}{j};
                    mat = h.kinsoft_res{3}{3}{j};
                    prob0 = h.kinsoft_res{3}{4}{j};
                    nExp = (size(ks,2)-4)/8;
                    fprintf(f,...
                        '\nFitting results and rate coefficients (second-1):\n');
                    fprintf(f,['state1\tstate2',...
                        repmat('\tamp%i\td_amp%i\ttau%i\td_tau%i',[1,nExp]),...
                        repmat('\tk0%i\td_k0%i',[1,nExp]),'\tw12',...
                        repmat('\tA%i\td_A%i',[1,nExp]),'\tvalid\n'],...
                        [reshape(repmat(1:nExp,[4,1]),[1,4*nExp]),....
                        reshape(repmat(1:nExp,[2,1]),[1,2*nExp]),....
                        reshape(repmat(1:nExp,[2,1]),[1,2*nExp])]);
                    fprintf(f,[repmat('%d\t',[1,size(ks,2)]),'\n'],ks');
                    
                    if useProb0
                        fprintf(f,...
                            '\nInitial state probabilties:\n');
                        fprintf(f,'%i\t%d\n',prob0);
                    end
                    
                    fprintf(f,...
                        '\nRestricted rates (second-1):\n');
                    fprintf(f,[repmat('%i\t',[1,size(mat,2)]),'\n'],...
                        mat(1,:,1));
                    fprintf(f,['%i\t',repmat('%d\t',[1,size(mat,2)-1]),'\n'],...
                        mat(2:end,:,1)');
                    
                    fprintf(f,...
                        '\nRestricted rate deviations (second-1):\n');
                    fprintf(f,[repmat('%i\t',[1,size(mat,2)]),'\n'],...
                        mat(1,:,2));
                    fprintf(f,['%i\t',repmat('%d\t',[1,size(mat,2)-1]),'\n'],...
                        mat(2:end,:,2)');
                    
                    fprintf(f,...
                        '\nTransition probabilities:\n');
                    fprintf(f,[repmat('%i\t',[1,size(mat,2)]),'\n'],...
                        mat(1,:,3));
                    fprintf(f,['%i\t',repmat('%d\t',[1,size(mat,2)-1]),'\n'],...
                        mat(2:end,:,3)');
                    
                    fprintf(f,...
                        '\nTransition probabilities deviations:\n');
                    fprintf(f,[repmat('%i\t',[1,size(mat,2)]),'\n'],...
                        mat(1,:,4));
                    fprintf(f,['%i\t',repmat('%d\t',[1,size(mat,2)-1]),'\n'],...
                        mat(2:end,:,4)');

                    fprintf(f,...
                        '\nUnrestricted rates (second-1):\n');
                    fprintf(f,[repmat('%i\t',[1,size(mat,2)]),'\n'],...
                        mat(1,:,5));
                    fprintf(f,['%i\t',repmat('%d\t',[1,size(mat,2)-1]),'\n'],...
                        mat(2:end,:,5)');
                    
                    fprintf(f,...
                        '\nUnrestricted rate deviations (second-1):\n');
                    fprintf(f,[repmat('%i\t',[1,size(mat,2)]),'\n'],...
                        mat(1,:,6));
                    fprintf(f,['%i\t',repmat('%d\t',[1,size(mat,2)-1]),'\n'],...
                        mat(2:end,:,6)');
                    if ~isempty(h.kinsoft_res{4})
                        logL = h.kinsoft_res{4}{3};
                        
                        fprintf(f,'\nBest configuration:\n');
                        fprintf(f,'J\tlogL\n');
                        fprintf(f,'%i\t%d\n',[Js,logL']');
                    end
                end
            end
            fclose(f);
        end
    end
    
    h_kinsoft_res = h.kinsoft_res;
    
    save([pname,'MASH_analysis_results.mat'],'h_kinsoft_res','-mat');

    disp(' ')
    fprintf('Process completed in %0.2f seconds (total processing time)\n',...
        t_ana);
    
catch err
    % display error and stop logs
    disp(' ');
    dispMatlabErr(err)
    
    % close figures
    h = guidata(h_fig);
    if isfield(h,'figure_itgExpOpt') && ishandle(h.figure_itgExpOpt)
        close(h.figure_itgExpOpt);
    end
    if isfield(h,'expTDPopt') && isfield(h.expTDPopt,'figure_expTDPopt') && ...
            ishandle(h.expTDPopt.figure_expTDPopt)
        close(h.expTDPopt.figure_expTDPopt);
    end
end

% restore interface as before executing routine
h_prev.mute_actions = false;
h_prev.kinsoft_res = h.kinsoft_res;
guidata(h_fig,h_prev);

cd(curr_dir);

updateFields(h_fig,'all');



