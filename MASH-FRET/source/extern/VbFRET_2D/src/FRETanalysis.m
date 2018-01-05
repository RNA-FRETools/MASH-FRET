function [dat analysis fit_par] = FRETanalysis()
% function FRETanalysis()
% This function does the actual data analysis in vbFRET
% last edited fall 2009 by Jonathan E Bronson (jeb2126@columbia.edu) for 
% http://vbfret.sourceforge.net

% get the main_gui handle (access to the gui)
vbFRET_handle = vbFRET;       
% get the data from the gui (all handles inside gui_main)
vbFRET_data = guidata(vbFRET_handle);

% set variables 
dat = vbFRET_data.dat;
analysis = vbFRET_data.analysis;
fit_par = vbFRET_data.fit_par;
% calling it plot_opts instead of plot since the word 'plot' has another
% function
plot_opts = vbFRET_data.plot;
% only needed for autosave
debleach = vbFRET_data.debleach;


% check that maxK > minK
if (analysis.maxK - analysis.minK) < 0
    flag.type = 'analysis error';
    flag.problem = 'k_range';
    vbFRETerrors(flag);
    return
end

% initialize variables that will be used later
D = analysis.dim;
N = length(dat.FRET);
I = analysis.numrestarts;

PriorPar = analysis.PriorPar;
PriorPar.mu = PriorPar.mu*ones(D,1);
PriorPar.W = PriorPar.W*eye(D);
vb_opts.maxIter = analysis.maxIter;
vb_opts.threshold = analysis.threshold;
run_time = []; run_iters = [];

% if user decided to blur-clean traces after analysis is complete
if (analysis.cur_trace == -1 && analysis.remove_blur && isempty(dat.raw_db)) && ~isempty(fit_par)
    % set counter to skip non-blur-clean analysis
    count = 0;
    for n = 1:N
        for k = analysis.minK:analysis.maxK
            for i = 1:I
                count = count + 1;
                 if k==1 && i > 1 
                    break
                 end
            end
        end
    end
    % the + 1 needed to skip repeating last restart of last non-deblured
    % trace
    analysis.cur_trace = count+1;
% initialize data structures if not continuing from previous fit
elseif analysis.cur_trace == -1
    fit_par.out = cell(1,N); % hyperparameters of best fit
    fit_par.mix = cell(1,N); % initial starting guesses of best fit
    fit_par.bestLP = -Inf*ones(1,N); % log evidence of best fit
    fit_par.settings = analysis; % analysis settings
    dat.z_hat=cell(1,N);
    dat.x_hat=cell(2,N);
    dat.raw_db = {};
    dat.FRET_db = {};
    dat.x_hat_db = {};
    dat.z_hat_db = {};
% if traces were appended while analysis was paused add cells to fit_par
elseif length(fit_par.out) < N
    n0 = length(fit_par.out);
    fit_par.out = [fit_par.out cell(1,N-n0)];
    fit_par.mix = [fit_par.mix cell(1,N-n0)];
    fit_par.bestLP = [fit_par.bestLP -Inf*ones(1,N-n0)];
end    


% ANALYZE DATA
% turn off divide by 0 warning
warning off MATLAB:divideByZero

%%
% keep track of traces analyzed
count = 0;
for n = 1:N
    % get trace
    if D == 1;
        trace = dat.FRET{n};
    else
        trace = dat.raw{n};
    end
    
    % fit trace with minK:maxK states, numrestarts times
    for k = analysis.minK:analysis.maxK
        % this is only used if user inputs guesses
        analysis.guess_perm = [];
        for i = 1:I
            count = count + 1; 
            % when K = 1, all restarts converge to same value so don't
            % waste time with extra restarts. If analysis was paused and
            % resumed also skip over any analysis that has already been
            % done 
            if k==1 && i > 1 
                break
            elseif count < analysis.cur_trace
                continue                    
            end
             
            % if user paused analysis, make sure x_hat is up to date, store
            % current trace being worked on and exit
            if get(vbFRET_data.analyzeData_pushbutton,'UserData') == 0
                if ~analysis.plot && ~isempty(fit_par.out{n})
                    [dat.z_hat{n} dat.x_hat{1,n}] = chmmViterbi(fit_par.out{n},trace');
                end
                dat.x_hat(2,:) = pseudo_x_hat(dat.z_hat,dat.FRET,dat.raw,D);
                analysis.cur_trace = count;
                set(vbFRET_data.analyzeData_pushbutton,'String','Resume Analysis')
                % update display, if applicable
                vbFRET_data.msgBox_staticText = pauseMsgBox(n,N,...
                    dat.labels{n},vbFRET_data.msgBox_staticText);
                return
            end
            drawnow

            % update display, if applicable
            if analysis.display_progress
                vbFRET_data.msgBox_staticText = updateMsgBox(n,N,k,i,run_time,...
                    run_iters,dat.labels{n},vbFRET_data.msgBox_staticText);
            end
            
            % record run time
            tic
            
            % get initial guess for hidden state means
            [start_guess analysis] = init_guess(k,i,analysis);
            
             try
                % mix structure has initilization information
                [mix] = get_mix(trace,start_guess);
                [out] = vbFRET_VBEM(trace', mix,PriorPar,vb_opts);
                
                % Only save the iterations with the best out.F
                if out.F(end) > fit_par.bestLP(n)
                    fit_par.bestLP(n) = out.F(end);
                    fit_par.out{n} = out;
                    fit_par.mix{n} = mix;                 
                    % plot results, if user desires
                    if analysis.plot
                        set(vbFRET_data.plot1_slider,'Value',n);
                        set(vbFRET_data.plot1Slider_editText,'String',dat.labels{n});
                        set(vbFRET_data.plot1SliderFraction_editText,'String',sprintf('%d of %d',n,N));
                        % get Viterbi path
                        [dat.z_hat{n} dat.x_hat{1,n}] = chmmViterbi(out,trace');                        
                        plotFRET(vbFRET_data.axes1, dat, plot_opts, n);
                    end
                end
                

                run_iters = length(out.F);
                run_time = toc;
             catch
                 set(vbFRET_data.msgBox_staticText,'String',sprintf...
                     ('Error fitting trace %s\nwith %d states on attempt %d.\n Fitting attempt will be skipped.',...
                         dat.labels{n},k,i));
             end
        end
    end
    
    % get Viterbi path if it wasn't done before
    if ~analysis.plot
        [dat.z_hat{n} dat.x_hat{1,n}] = chmmViterbi(fit_par.out{n},trace');
    end

    % autosave, if applicable
    if ~isempty(analysis.auto_name) && analysis.auto_rate > 0 && mod(n,analysis.auto_rate) == 0
        set(vbFRET_data.msgBox_staticText,'String','Autosaving...')
        analysis.cur_trace = count;
        save_autosave(dat, fit_par, plot_opts, debleach, analysis);
    end

end

% make a second set of pseudo x_hats in the dimension not analyzed
dat.x_hat(2,:) = pseudo_x_hat(dat.z_hat,dat.FRET,dat.raw,D);

%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if analysis.remove_blur

    if isempty(dat.x_hat_db)
            fit_par.out_deblured = cell(1,N);
            fit_par.mix_deblured = cell(1,N);
            fit_par.bestLP_deblured = -Inf*ones(1,N);
            % repeat analysis in blur state removal mode if applicable.
            [dat] = deblurData(dat);   
    end
        
    
    %Rerun analysis with blur corrected traces
    for n = 1:N
        if sum(dat.mod_list == n) == 0
            continue
        elseif isempty(dat.x_hat{1,n})
            flag.type = 'analysis error';
            flag.problem = 'cannot db';
            vbFRETerrors(flag) 
            break 
        end
        
        % get trace
        if D == 1;
            trace = dat.FRET_db{n};
        else
            trace = dat.raw_db{n};
        end

        % fit trace with minK:maxK states, numrestarts times
        for k = analysis.minK:analysis.maxK
            % this is only used if user inputs guesses
            analysis.guess_perm = [];
            for i = 1:I
                count = count + 1; 
                % when K = 1, all restarts converge to same value so don't
                % waste time with extra restarts. If analysis was paused and
                % resumed also skip over any analysis that has already been
                % done 
                if k==1 && i > 1 
                    break
                elseif count < analysis.cur_trace
                    continue                    
                end

                % if user paused analysis, make sure x_hat is up to date, store
                % current trace being worked on and exit
                if get(vbFRET_data.analyzeData_pushbutton,'UserData') == 0
                    if ~analysis.plot &&~isempty(fit_par.out_deblured{n})
                        [dat.z_hat_db{n} dat.x_hat_db{1,n}] = chmmViterbi(fit_par.out_deblured{n},trace');
                    end
                    dat.x_hat_db(2,:) = pseudo_x_hat(dat.z_hat_db,dat.FRET_db,dat.raw_db,D);
                    analysis.cur_trace = count;
                    set(vbFRET_data.analyzeData_pushbutton,'String','Resume Analysis')
                    % update display
                    vbFRET_data.msgBox_staticText = pauseMsgBox_db(n,N,...
                    dat.labels{n},vbFRET_data.msgBox_staticText);

                    return
                end
                drawnow

                % update display, if applicable
                if analysis.display_progress
                    vbFRET_data.msgBox_staticText = updateMsgBox_db(n,N,k,i,run_time,...
                        run_iters,dat.labels{n},vbFRET_data.msgBox_staticText);
                end

                % record run time
                tic

                % get initial guess for hidden state means
                [start_guess analysis] = init_guess(k,i,analysis);
                
                % run the program
                 try
                    % mix structure has initilization information
                    [mix] = get_mix(trace,start_guess);
                    [out] = vbFRET_VBEM(trace', mix,PriorPar,vb_opts);

                    % Only save the iterations with the best out.F
                    if out.F(end) > fit_par.bestLP_deblured(n)
                        fit_par.bestLP_deblured(n) = out.F(end);
                        fit_par.out_deblured{n} = out;
                        fit_par.mix_deblured{n} = mix;
                        % plot results, if user desires
                        if analysis.plot
                            set(vbFRET_data.plot1_slider,'Value',n);
                            set(vbFRET_data.plot1Slider_editText,'String',dat.labels{n});
                            set(vbFRET_data.plot1SliderFraction_editText,'String',sprintf('%d of %d',n,N));
                            % get Viterbi path
                            [dat.z_hat_db{n} dat.x_hat_db{1,n}] = chmmViterbi(out,trace');
                            plotFRET(vbFRET_data.axes1, dat, plot_opts, n);
                        end
                    end


                    run_iters = length(out.F);
                    run_time = toc;
                catch
                    set(vbFRET_data.msgBox_staticText,'String',sprintf...
                        ('Error fitting trace %s\nwith %d states on attempt %d.\n Fitting attempt will be skipped.',...
                            dat.labels{n},k,i));
                end
            end
        end

        % get Viterbi path if it wasn't done before
        if ~analysis.plot
            [dat.z_hat_db{n} dat.x_hat_db{1,n}] = chmmViterbi(fit_par.out_deblured{n},trace');
        end
    end

    % autosave, if applicable
    if ~isempty(analysis.auto_name) && analysis.auto_rate > 0 && mod(n,analysis.auto_rate) == 0
        set(vbFRET_data.msgBox_staticText,'String','Autosaving...')
        analysis.cur_trace = count;
        save_autosave(dat, fit_par, plot_opts, debleach, analysis);
    end
end 

% make a second set of pseudo x_hats in the dimension not analyzed
dat.x_hat_db(2,:) = pseudo_x_hat(dat.z_hat_db,dat.FRET_db,dat.raw_db,D);


%%
    
% turn warnings back on
warning on MATLAB:divideByZero

% reset analysis status
set(vbFRET_data.analyzeData_pushbutton,'String','Analyze Data!')
set(vbFRET_data.msgBox_staticText,'String','Done with analysis')

analysis.analyze_flag = 0;
analysis.cur_trace = -1;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%
function [dat] = deblurData(dat)

% the deblured data files
dat.raw_db = dat.raw;
dat.FRET_db = dat.FRET;
dat.z_hat_db = dat.z_hat;
dat.x_hat_db = dat.x_hat;

% store list of traces deblured
mod_list = zeros(1,length(dat.raw));

for n = 1:length(dat.raw)
    T = length(dat.raw{n});
    xhat = dat.x_hat{1,n};
    for t=2:T-1
        if (xhat(t) < xhat(t-1) && xhat(t) > xhat(t+1)) || (xhat(t) > xhat(t-1) && xhat(t) < xhat(t+1))
            % mark that trace n was deblured
            mod_list(n) = 1;
            % move the blur datum to the value of the closest neighboring
            % states
            if abs(dat.FRET{n}(t) - xhat(t-1)) < abs(dat.FRET{n}(t) - xhat(t+1))
                dat.FRET_db{n}(t) = xhat(t-1);
                dat.raw_db{n}(t,:) = dat.x_hat{2,n}(t-1,:);
            else
                dat.FRET_db{n}(t) = xhat(t+1);
                dat.raw_db{n}(t,:) = dat.x_hat{2,n}(t+1,:);
            end
        end
    end
end

mod_list = find(mod_list == 1);
num_blur = length(mod_list);
% store modlist in dat
dat.mod_list = mod_list;

if num_blur
    for q = 1:length(mod_list)
        dat.z_hat_db{mod_list(q)} = [];
        dat.x_hat_db{1,mod_list(q)} = [];
        dat.x_hat_db{2,mod_list(q)} = [];        
    end    
    
    if num_blur == 1
        msgboxText{1} = sprintf('The following trace had camera blur states which were removed:');
        msgboxText{2} = sprintf('%s',dat.labels{mod_list});
    else
        msgboxText{1} = sprintf('The following %d traces had camera blur states which were removed:',num_blur);
        count = 0;
        for i = 1:ceil(num_blur/10);
            msg_txt = '';
            for j = 1:10
                count = count+1;
                if count > num_blur
                    break
                end
                msg_txt = [msg_txt sprintf('   %s',dat.labels{mod_list(count)})];
            end
            msgboxText{i+1} = msg_txt;
        end
    end
    msgbox(msgboxText,'Camera Blur Cleanup', 'none');
end

%%
function x_hat = pseudo_x_hat(z_hat,FRET,raw,D)

N = length(FRET);
x_hat = cell(1,N);
% use traces in dimension opposite the one analyzed
if D == 1
    traces = raw;
    pseudoD = 2;
else
    traces = FRET;
    pseudoD = 1;
end


for n=1:N
    if isempty(z_hat{n})
        break
    end
    
    states = unique(z_hat{n});
    T = length(FRET{n});
    x_hat{n} = zeros(T,pseudoD);
    for s=1:length(states)
        % set the mean (i.e. Viterbi path value) of each state based on the
        % mean value of the data points at that state.
        meanS = mean(traces{n}(z_hat{n} == states(s),:),1);
        x_hat{n}(z_hat{n} == states(s),:) = meanS(ones(1,sum(z_hat{n} == states(s))),:);
    end
end

%%
function [start_guess analysis] = init_guess(K,i,analysis)      
% this function generates the inital guess for the positions of the hidden
% states that will then be used in further analysis. If user does not enter
% any guesses then the first restart will have the starting states evenly
% spread between 0 and 1 (provided more than one restart is used). When
% less states are fit to the data than are guessed, subsets of gussed
% states are selected at random and used. When more states are fit to the
% data than are guessed the extra states are initialized at random.

% dimsion/number of states user guesses
[Kinput Dinput] = size(analysis.guess);

% only use guess if use guess box is checked and guesses are entered
if analysis.use_guess * analysis.exist_guess
    % if more user guessed states than states being fit
    if K < Kinput 
            perm = randperm(Kinput);
            start_guess = analysis.guess(perm(1:K),:);
            
    % if number of user guessed states = number of states being fit
    elseif K == Kinput %&& i == 1
            start_guess = analysis.guess;
            
    % if less user guessed states than states being fit
    elseif K > Kinput             
            start_guess = [analysis.guess; rand(K-Kinput,1)];
    end

% get initial guess at random
else
    % spread states evenly between 0 and 1 for the first guess
    if i == 1
        start_guess = (1:K)'/(K+1);
    else
        start_guess = rand(K,1);
    end
    
end

% start_guess
%%
function text_handle = updateMsgBox(n,N,k,i,run_time,run_iters,label,text_handle)

txt_str = sprintf('Analyzing trace %s (%d/%d)\nFitting %d states: attempt %d',label,n,N,k,i);

if run_time < 1
    txt_str = [txt_str sprintf('\nPrevious attempt converged after %.3f sec\nafter %d iterations of VBEM',run_time,run_iters)];
else
    txt_str = [txt_str sprintf('\nPrevious attempt converged after %d sec\nafter %d iterations of VBEM',round(run_time),run_iters)];
end

set(text_handle,'String',txt_str);

%%
function text_handle = updateMsgBox_db(n,N,k,i,run_time,run_iters,label,text_handle)

txt_str = sprintf('Analyzing blur cleaned trace %s (%d/%d)\nFitting %d states: attempt %d',label,n,N,k,i);

if run_time < 1
    txt_str = [txt_str sprintf('\nPrevious attempt converged after %.3f sec\nafter %d iterations of VBEM',run_time,run_iters)];
else
    txt_str = [txt_str sprintf('\nPrevious attempt converged after %d sec\nafter %d iterations of VBEM',round(run_time),run_iters)];
end

set(text_handle,'String',txt_str);

%%
function text_handle = pauseMsgBox(n,N,label,text_handle)

txt_str = sprintf('Analysis paused while analyzing trace %s (%d/%d)',label,n,N);

set(text_handle,'String',txt_str);

%%
function text_handle = pauseMsgBox_db(n,N,label,text_handle)

txt_str = sprintf('Analysis paused while analyzing blur cleaned trace %s (%d/%d)',label,n,N);

set(text_handle,'String',txt_str);
