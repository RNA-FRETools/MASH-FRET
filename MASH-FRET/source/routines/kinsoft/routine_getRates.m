function rates = routine_getRates(pname,fname,Js,h_fig)
% rates = routine_getRates(pname,fname,Js,h_fig)
%
% Analyze dwell time histograms to determine state transition rates and associated deviations
%
% pname: source directory
% fname: .mash source file name
% Js: [1-by-nJ] optimum number of states
% h_fig: handle to main figure
% rates: {1-by-nJ} [J^2-by-2] transition rates and associated deviations

% initialize output
rates = cell(1,numel(Js));

% defauts
tdp_dat = 3; % data to plot in TDP (FRET data)
tdp_tag = 1; % molecule tag to plot in TDP (all molecules)
n_max = 3; % maximum number of exponential decays
excl = true; % exclude first and last dwell times in sequences
rearr = true; % re-arrange state sequences

if ~strcmp(pname(end),filesep)
    pname = [pname,filesep];
end
fname_mashIn = cat(2,fname,'_vbFRET_%sstates.mash');
fname_kin = cat(2,fname,'_vbFRET_%sstates_%sexp.kin');
fname_histImg = cat(2,fname,'_%sstates_%s_%sexp.png');
fname_mashOut = cat(2,fname,'_vbFRET_%sstates_%sexp.mash');

% get interface parameters
h = guidata(h_fig);

disp('>> start determination of rates and associated deviations...');

% get default interface settings
p = getDef_kinsoft(pname,[]);

switchPan(h.togglebutton_TA,[],h_fig);
p.tdp_expOpt([7,8]) = true;
for Jmax = Js
    fprintf(cat(2,'>>>> import file ',fname_mashIn,...
    ' in Transition analysis...\n'),num2str(Jmax));

    % import project in TA
    pushbutton_TDPaddProj_Callback(...
        {p.dumpdir,sprintf(fname_mashIn,num2str(Jmax))},[],h_fig);
    
    % set TDP settings and update plot
    set_TA_TDP(tdp_dat,tdp_tag,p.tdpPrm,h_fig);
    pushbutton_TDPupdatePlot_Callback(h.pushbutton_TDPupdatePlot,[],h_fig);
    
    if ~strcmp(get(h.pushbutton_TDPfit_log,'string'),'y-linear scale')
        pushbutton_TDPfit_log_Callback(h.pushbutton_TDPfit_log,[],h_fig);
    end

    % process each dwell time histogram
    str_trans = get(h.listbox_TDPtrans,'string');
    K = numel(str_trans);
    [j1,j2] = getStatesFromTransIndexes(1:K,Jmax,p.clstConfig(1),...
        p.clstConfig(2));
    rates{Jmax} = [repmat([j1',j2'],n_max,1),zeros(n_max*K,2*n_max)];
    
    % collect cluster's relative populations
    h = guidata(h_fig);
    q = h.param.TDP;
    proj = q.curr_proj;
    tpe = q.curr_type(proj);
    tag = q.curr_tag(proj);
    prm = q.proj{proj}.prm{tag,tpe};
    res = prm.clst_res{1};
    w = zeros(Jmax,Jmax);
    for k = 1:K
        w(j1(k),j2(k)) = res.pop{Jmax}(k);
    end
    
    for n = n_max:-1:1
        fprintf(cat(2,'>>>> fit cumulated dwell time histograms with %i',...
            ' decays\n'),n);
        
        row0 = (n-1)*K + 1;
        
        for k = 1:K
            if j1(k)==j2(k)
                continue
            end

            fprintf('>>>>>> process transition %s\n',str_trans{k});

            set(h.listbox_TDPtrans,'value',k)
            listbox_TDPtrans_Callback(h.listbox_TDPtrans,[],h_fig);
            
            set(h.checkbox_tdp_rearrSeq,'value',rearr);
            checkbox_tdp_rearrSeq_Callback(h.checkbox_tdp_rearrSeq,[],...
                h_fig);
            
            disp('>>>>>>>> perform preliminary fit');

            % perform preliminary fit
            expPrm = p.expPrm;
            fitPrm = p.fitPrm(:,:,1:n);
            if ~expPrm(1)
                fitPrm = fitPrm(1:(end-1),:,:);
            end
            if n>1
                fitPrm(1,3,:) = 1;
            end
            expPrm(2) = n;
            expPrm(3) = false;
            set_TA_expFit(expPrm,fitPrm,h_fig);
            pushbutton_TDPfit_fit_Callback({excl},[],h_fig);
            
            % update starting guess
            h = guidata(h_fig);
            q = h.param.TDP;
            proj = q.curr_proj;
            tpe = q.curr_type(proj);
            tag = q.curr_tag(proj);
            prm = q.proj{proj}.prm{tag,tpe};
            res = prm.kin_res{k,2}; % [nExp-by-2]
            
            disp('>>>>>>>> perform bootstrap fit');
            
            % perform bootstrap fit
            expPrm(3) = true;
            fitPrm(:,2,:) = permute(res(:,[1,2],:),[2,3,1]);
            set_TA_expFit(expPrm,fitPrm,h_fig);
            pushbutton_TDPfit_fit_Callback({excl},[],h_fig);
            
            % recover results
            h = guidata(h_fig);
            q = h.param.TDP;
            proj = q.curr_proj;
            tpe = q.curr_type(proj);
            tag = q.curr_tag(proj);
            prm = q.proj{proj}.prm{tag,tpe};
            res = prm.kin_res{k,1}; % [nExp-by-4]
            amp = res(:,1)';
            o_amp = res(:,2)';
            tau = res(:,3)';
            o_tau = res(:,4)';
            a = (amp.*tau)./sum(amp.*tau);
            rates_k = 1./tau; % restricted rate coefficients
            w_k = w(j1(k),j2(k))/sum(w(j1(k),(1:Jmax)~=j1(k)));% weighing factor
            rates_k = w_k*a.*rates_k; % unrestricted rate coefficients
            d_rate = 2*(o_amp./amp + o_tau./tau) + flip(o_amp./amp,2) + ...
                flip(o_tau./tau,2);
            rates{Jmax}(row0+k-1,3:2:(2+n*2-1)) = rates_k; % unrestricted rate coefficient
            rates{Jmax}(row0+k-1,4:2:(2+n*2)) = rates_k.*d_rate; % deviation
            
            str_k = str_trans{k}(str_trans{k}~=' ' & str_trans{k}~='.');
            fprintf(cat(2,'>>>>>>>> export screenshot of histogram fit to',...
                ' file ',fname_histImg,'\n'),num2str(Jmax),num2str(str_k),...
                num2str(n));
            
            % export a screenshot of histogram fit
            set(h_fig, 'CurrentAxes',h.axes_TDPplot2);
            exportAxes({...
                [p.dumpdir,filesep,sprintf(fname_histImg,num2str(Jmax),...
                num2str(str_k),num2str(n))]},[],h_fig);
        end
        
        fprintf(...
            cat(2,'>>>> export fitting results to file ',fname_kin,'\n'),...
            num2str(Jmax),num2str(n));
        
        % export .fit files
        pushbutton_TDPexport_Callback(h.pushbutton_TDPexport,[],h_fig);
        set_TA_expOpt(p.tdp_expOpt,h_fig);
        pushbutton_expTDPopt_next_Callback(...
            {p.dumpdir,sprintf(fname_kin,num2str(Jmax),num2str(n))},[],...
            h_fig);
        
        fprintf(...
            cat(2,'>>>> save modificiations to file ',fname_mashOut,'...\n'),...
            num2str(Jmax),num2str(n));
        
        % save project
        pushbutton_TDPsaveProj_Callback(...
            {p.dumpdir,sprintf(fname_mashOut,num2str(Jmax),num2str(n))},[],...
            h_fig);
    end
    
    set(h.listbox_TDPprojList,'value',1);
    listbox_TDPprojList_Callback(h.listbox_TDPprojList,[],h_fig);
    pushbutton_TDPremProj_Callback(h.pushbutton_TDPremProj,[],h_fig);
end


