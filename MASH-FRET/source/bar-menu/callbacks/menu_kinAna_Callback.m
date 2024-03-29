function menu_kinAna_Callback(obj,evd,step,h_fig)

% update, 16.3.2021 by MH: rename all "kinsoft" field into "kinana"
% update, 29.12.2020 by MH: remove useless step 4 (back-simulation)

% save current interface
h = guidata(h_fig);
h_prev = h;
curr_dir = pwd;

% get current module
chld = h_fig.Children;
for c = 1:numel(chld)
    if strcmp(chld(c).Type,'uicontrol') && ...
            strcmp(chld(c).Style,'togglebutton') && chld(c).Value==1
        break
    end
end
h_tb = chld(c);

% set overwirting file option to "always overwrite"
h.param.OpFiles.overwrite_ask = false;
h.param.OpFiles.overwrite = true;

% set action display on mute
h.mute_actions = true;

% if ~isfield(h,'kinsoft_res')
%     h.kinsoft_res = cell(1,3);
% end
if ~isfield(h,'kinana_res')
    h.kinana_res = cell(1,3);
end

guidata(h_fig,h);

disp(' ')
disp('start standard kinetic analysis...');

try
    % Find optimum number of states
    if sum(step==[0,1])
        
        % ask for the number of states
        V = NaN;
        choice = questdlg('Is the number of FRET states known?',...
            'Number of FRET states','Yes','No','No');
        if strcmp(choice,'Yes')
            ip = inputdlg('number of FRET states = ','Number of FRET states');
            V = str2num(ip{1});
        elseif ~strcmp(choice,'No')
            return
        end
        
        % ask for noise ditribution
        if step==0
            gaussNoise = false;
            choice = questdlg(['What is the noise distribution in the ',...
                'FRET trajectories?'],'Noise distribution',...
                'Gaussian noise','other','other');
            if strcmp(choice,'Gaussian noise')
                gaussNoise = true;
            elseif ~strcmp(choice,'other')
                return
            end
        end
        
        t1 = tic;
        
        [pname,fname,res,Js] = routine_findJ(h_fig,V);
        if isnan(V) && isempty(res)
            return
        end

        t_1 = toc(t1);
        
%         h.kinsoft_res{1} = {t_1,pname,fname,res,Js};
%         h.kinsoft_res(2:end) = cell(1,2);
        h.kinana_res{1} = {t_1,pname,fname,res,Js};
        h.kinana_res(2:end) = cell(1,2);
        
        guidata(h_fig,h);
    end

    % determine FRET states and associated deviations
    if sum(step==[0,2])
%         if isempty(h.kinsoft_res{1})
        if isempty(h.kinana_res{1})
            disp(' ')
            disp('step 1 must first be performed.')
            return
        end
        
        % ask for noise ditribution
        if step==2
            gaussNoise = false;
            choice = questdlg(['How is the noise distribution in the ',...
                'FRET trajectories?'],'Noise distribution',...
                'Gaussian noise','other','other');
            if strcmp(choice,'Gaussian noise')
                gaussNoise = true;
            elseif ~strcmp(choice,'other')
                return
            end
        end
        
%         pname = h.kinsoft_res{1}{2};
%         fname = h.kinsoft_res{1}{3};
%         Js = h.kinsoft_res{1}{5}(:,1)';
        pname = h.kinana_res{1}{2};
        fname = h.kinana_res{1}{3};
        Js = h.kinana_res{1}{5}(:,1)';
        
        t2 = tic;
        
        states = routine_getFRETstates(pname,fname,Js,gaussNoise,h_fig);
        
        t_2 = toc(t2);

%         h.kinsoft_res{2} = {t_2,states};
%         h.kinsoft_res(3:end) = cell(1,1);
        h.kinana_res{2} = {t_2,states};
        h.kinana_res(3:end) = cell(1,1);
        guidata(h_fig,h);
    end

    % calculate transition rates and associated deviations
    if sum(step==[0,3])
%         if isempty(h.kinsoft_res{2})
        if isempty(h.kinana_res{2})
            disp(' ')
            disp('step 2 must first be performed.')
            return
        end
        
%         pname = h.kinsoft_res{1}{2};
%         fname = h.kinsoft_res{1}{3};
%         Js = h.kinsoft_res{1}{5}(:,1)';
        pname = h.kinana_res{1}{2};
        fname = h.kinana_res{1}{3};
        Js = h.kinana_res{1}{5}(:,1)';
        
        t3 = tic;
        
        [mat,tau,ip] = routine_getRates(pname,fname,Js,h_fig);
        
        t_3 = toc(t3);

%         h.kinsoft_res{3} = {t_3,mat,tau,ip};
        h.kinana_res{3} = {t_3,mat,tau,ip};
        guidata(h_fig,h);
    end
    
    t_ana = 0;
%     for s = 1:size(h.kinsoft_res,2)
%         if ~isempty(h.kinsoft_res{s})
%             t_ana = t_ana + h.kinsoft_res{s}{1};
    for s = 1:size(h.kinana_res,2)
        if ~isempty(h.kinana_res{s})
            t_ana = t_ana + h.kinana_res{s}{1};
        end
    end
    
%     if ~isempty(h.kinsoft_res{1})
    if ~isempty(h.kinana_res{1})
        
%         knowStateNb = isempty(h.kinsoft_res{1}{4});
        knowStateNb = isempty(h.kinana_res{1}{4});
        
%         pname = h.kinsoft_res{1}{2};
        pname = h.kinana_res{1}{2};
        if ~strcmp(pname(end),filesep)
            pname = [pname,filesep];
        end
        [~,fname,~] = fileparts(pname(1:end-1));
%         Js = h.kinsoft_res{1}{5}(:,1);
        Js = h.kinana_res{1}{5}(:,1);
        if ~knowStateNb
%             BICs = h.kinsoft_res{1}{4}.BIC;
            BICs = h.kinana_res{1}{4}.BIC;
            BICs = [(1:numel(BICs))',BICs',zeros(numel(BICs),1)];
            BICs(isinf(BICs(:,2)),:) = [];
            for j = 1:numel(Js)
                BICs(BICs(:,1)==Js(j),3) = 1;
            end
        end
        for j = 1:numel(Js)
            f = fopen(...
                [pname,fname,'_results_',num2str(Js(j)),'states.txt'],...
                'Wt');

            fprintf(f,'Total processing time (in seconds):%d\n',t_ana);
            
            if ~knowStateNb
                fprintf(f,'\nNumber of states:\n');
                fprintf(f,'J\tBIC\tselected\n');
                fprintf(f,'%i\t%d\t%i\n',BICs');
            else
                fprintf(f,'\nNumber of states:%i\n',Js(j));
            end
            
%             if ~isempty(h.kinsoft_res{2})
%                 states = h.kinsoft_res{2}{2}{j};
            if ~isempty(h.kinana_res{2})
                states = h.kinana_res{2}{2}{j};
                
                fprintf(f,'\nState configuration:\n');
                fprintf(f,'state\tFRET\tsigma_FRET\n');
                fprintf(f,'%i\t%d\t%d\n',[(1:Js(j))',states]');
                
%                 if ~isempty(h.kinsoft_res{3})
%                     mat = h.kinsoft_res{3}{2}{j};
%                     tau = h.kinsoft_res{3}{3}{j};
%                     ip = h.kinsoft_res{3}{4}{j};
                if ~isempty(h.kinana_res{3})
                    mat = h.kinana_res{3}{2}{j};
                    tau = h.kinana_res{3}{3}{j};
                    ip = h.kinana_res{3}{4}{j};

                    fprintf(f,...
                        '\nInitial state probabilties:\n');
                    fprintf(f,'%i\t%d\n',ip);
                    
                    fprintf(f,...
                        '\nState lifetimes (second):\n');
                    fprintf(f,'%i\t%d\n',tau);
                    
                    fprintf(f,...
                        '\nTransition probabilities:\n');
                    fprintf(f,[repmat('%i\t',[1,size(mat,2)]),'\n'],...
                        mat(1,:,1));
                    fprintf(f,['%i\t',repmat('%d\t',[1,size(mat,2)-1]),'\n'],...
                        mat(2:end,:,1)');
                    
                    fprintf(f,...
                        '\nTransition probability positive deviation:\n');
                    fprintf(f,[repmat('%i\t',[1,size(mat,2)]),'\n'],...
                        mat(1,:,2));
                    fprintf(f,['%i\t',repmat('%d\t',[1,size(mat,2)-1]),'\n'],...
                        mat(2:end,:,2)');

                    fprintf(f,...
                        '\nTransition probability negative deviation:\n');
                    fprintf(f,[repmat('%i\t',[1,size(mat,2)]),'\n'],...
                        mat(1,:,3));
                    fprintf(f,['%i\t',repmat('%d\t',[1,size(mat,2)-1]),'\n'],...
                        mat(2:end,:,3)');
                    
                    fprintf(f,...
                        '\nTransition rate coefficients:\n');
                    fprintf(f,[repmat('%i\t',[1,size(mat,2)]),'\n'],...
                        mat(1,:,4));
                    fprintf(f,['%i\t',repmat('%d\t',[1,size(mat,2)-1]),'\n'],...
                        mat(2:end,:,4)');
                    
                    fprintf(f,...
                        '\nTransition rate coefficient positive deviation:\n');
                    fprintf(f,[repmat('%i\t',[1,size(mat,2)]),'\n'],...
                        mat(1,:,5));
                    fprintf(f,['%i\t',repmat('%d\t',[1,size(mat,2)-1]),'\n'],...
                        mat(2:end,:,5)');

                    fprintf(f,...
                        '\nTransition rate coefficient negative deviation:\n');
                    fprintf(f,[repmat('%i\t',[1,size(mat,2)]),'\n'],...
                        mat(1,:,6));
                    fprintf(f,['%i\t',repmat('%d\t',[1,size(mat,2)-1]),'\n'],...
                        mat(2:end,:,6)');
                end
            end
            fclose(f);
        end
    end
    
%     h_kinsoft_res = h.kinsoft_res;
    h_kinana_res = h.kinana_res;
    
%     save([pname,'MASH_analysis_results.mat'],'h_kinsoft_res','-mat');
    save([pname,'_results.mat'],'h_kinana_res','-mat');

    disp(' ')
    fprintf('Process completed in %0.2f seconds (total processing time)\n',...
        t_ana);
    
catch err
    % display error and stop logs
    disp(' ');
    dispMatlabErr(err)
    
    % close figures
    h = guidata(h_fig);
    if isfield(h,'figure_setExpSet') && ishandle(h.figure_setExpSet)
        close(h.figure_setExpSet);
    end
    if isfield(h,'expTDPopt') && isfield(h.expTDPopt,'figure_expTDPopt') && ...
            ishandle(h.expTDPopt.figure_expTDPopt)
        close(h.expTDPopt.figure_expTDPopt);
    end
end

% restore interface as before executing routine
h_prev.kinana_res = h.kinana_res;

h_prev.mute_actions = false;
guidata(h_fig,h_prev);
cd(curr_dir);

h = guidata(h_fig);
h.param = ud_projLst(h.param, h.listbox_proj);
guidata(h_fig,h);

switchPan(h_tb,[],h_fig);

updateFields(h_fig,'all');



