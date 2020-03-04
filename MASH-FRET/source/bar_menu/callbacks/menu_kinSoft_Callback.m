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

t = tic;

try
    % Find optimum number of states
    if sum(step==[0,1])
        [pname,fname,res,Js] = routine_findJ(h_fig);
        if isempty(res)
            return
        end

        h.kinsoft_res{1} = {pname,fname,res,Js};
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
        
        pname = h.kinsoft_res{1}{1};
        fname = h.kinsoft_res{1}{2};
        Js = h.kinsoft_res{1}{4}(:,1)';
        states = routine_getFRETstates(pname,fname,Js,h_fig);

        h.kinsoft_res{2} = states;
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
        
        pname = h.kinsoft_res{1}{1};
        fname = h.kinsoft_res{1}{2};
        Js = h.kinsoft_res{1}{4}(:,1)';
        ks = routine_getRates(pname,fname,Js,h_fig);

        h.kinsoft_res{3} = ks;
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

        res = routine_backSim(h_fig);

        h.kinsoft_res{4} = res;
    end
    
    % export results
    if ~strcmp(pname(end),filesep)
        pname = [pname,filesep];
    end
    [~,fname,~] = fileparts(pname(1:end-1));
    if ~isempty(h.kinsoft_res{1})
        Js = h.kinsoft_res{1}{4}(:,1);
        for J = Js
            f = fopen([pname,fname,'_results_',num2str(J),'states.txt'],'Wt');
            if ~isempty(h.kinsoft_res{2}{J})
                fprintf(f,'State configuration\n:');
                fprintf(f,'FRET\tsigma_FRET\n');
                fprintf(f,'%d\t%d\n',states');
            end
            if ~isempty(h.kinsoft_res{3})
                ks = h.kinsoft_res{3}{J};
                nExp = 3;
                fprintf(f,'Rate coefficients (second-1)\n:');
                fprintf(f,['state1\tstate2',repmat(...
                    '\tamp%i\tsig_amp%i\ttau%i\tsig_tau%i',[1,nExp]),'\n'],...
                    reshape(repmat(1:nExp,[4,1]),[1,4*nExp]));
                fprintf(f,[repmat('%d\t',[1,size(ks,2)]),'\n'],ks');
            end
            fclose(f);
        end
    end

    disp(' ')
    fprintf('process completed in %0.2f seconds\n',toc(t));
    
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
guidata(h_fig,h);

