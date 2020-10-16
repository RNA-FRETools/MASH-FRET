function [rates,mat,prob0] = routine_getRates(pname,fname,Js,h_fig)
% rates = routine_getRates(pname,fname,Js,h_fig)
%
% Analyze dwell time histograms to determine state transition rates and associated deviations
%
% pname: source directory
% fname: .mash source file name
% Js: [1-by-nJ] optimum number of states
% h_fig: handle to main figure
% rates: {1-by-nJ} [J^2-by-(4+8*n_max)] bootstrap fitting results, restricted rates and associated deviations, weighing factors, degenerated state relative populations, associated deviations and model validity
% mat: {1-by-nJ} final rate, transition probabilitiy, and deviations matrices with:
%  mat{j}(:,:,1): restricted rates (from dwell times)
%  mat{j}(:,:,2): restricted rate deviations
%  mat{j}(:,:,3): unrestricted rates (weighed by transition prob.)
%  mat{j}(:,:,4): unrestricted rate deviations
%  mat{j}(:,:,5): transition porbabilities (weighing factors * exponential contribution)
%  mat{j}(:,:,6): transition porbability deviaitions
% prob0: {1-by-nJ} [2-by-J] initial state probabilities

% initialize output
nJ = numel(Js);
rates = cell(1,nJ);
mat = cell(1,nJ);
prob0 = cell(1,nJ);

% defauts
modelSlct = 'mean'; % method to select the most sufficient number of exponential functions ('conf' or 'mean')
tdp_dat = 3; % data to plot in TDP (FRET data)
tdp_tag = 1; % molecule tag to plot in TDP (all molecules)
n_spl = 100; % number of bootstrap samples
excl = true; % exclude first and last dwell times in sequences
rearr = true; % re-arrange state sequences
tol = 3; % deviation multiplication factor used to dertermine the number of decays (ex:3 for 3*sigma)
conf = 0; % confidence (maximum overlap percentage of decay error ranges)

if ~strcmp(pname(end),filesep)
    pname = [pname,filesep];
end
fname_mashIn = getCorrName([fname,'_vbFRET_%sstates.mash'],pname,h_fig);
fname_kin = getCorrName([fname,'_vbFRET_%sstates_%sexp.fit'],pname,h_fig);
fname_histImg = getCorrName([fname,'_%sstates_%s_%sexp.png'],pname,h_fig);
fname_mashOut = getCorrName([fname,'_vbFRET_%sstates_%sexp.mash'],pname,...
    h_fig);

% get interface parameters
h = guidata(h_fig);

disp('>> start determination of rates and associated deviations...');

% get default interface settings
p = getDef_kinsoft(pname,[]);

n_max = p.nMax; % maximum number of exponential functiosn to fit

switchPan(h.togglebutton_TA,[],h_fig);
p.tdp_expOpt([7,8]) = true;
for j = 1:nJ
    fprintf(cat(2,'>>>> import file ',fname_mashIn,...
    ' in Transition analysis...\n'),num2str(Js(j)));

    % import project in TA
    pushbutton_TDPaddProj_Callback(...
        {p.dumpdir,sprintf(fname_mashIn,num2str(Js(j)))},[],h_fig);
    
    % set TDP settings and update plot
    set_TA_TDP(tdp_dat,tdp_tag,p.tdpPrm,h_fig);
    pushbutton_TDPupdatePlot_Callback(h.pushbutton_TDPupdatePlot,[],h_fig);
    
    if ~strcmp(get(h.pushbutton_TDPfit_log,'string'),'y-linear scale')
        pushbutton_TDPfit_log_Callback(h.pushbutton_TDPfit_log,[],h_fig);
    end

    % process each dwell time histogram
    str_trans = get(h.listbox_TDPtrans,'string');
    K = getClusterNb(Js(j),p.clstConfig(1),p.clstConfig(2));
    [j1,j2] = getStatesFromTransIndexes(1:K,Js(j),p.clstConfig(1),...
        p.clstConfig(2));
    rates{j} = [repmat([j1',j2'],n_max,1),zeros(n_max*K,8*n_max+2)];
    prob0{j} = zeros(1,Js(j));
    
    % collect cluster's relative populations
    h = guidata(h_fig);
    q = h.param.TDP;
    proj = q.curr_proj;
    tpe = q.curr_type(proj);
    tag = q.curr_tag(proj);
    prm = q.proj{proj}.prm{tag,tpe};
    res = prm.clst_res{1};
    w = zeros(Js(j),Js(j));
    for k = 1:K
        w(j1(k),j2(k)) = res.pop{Js(j)}(k);
    end
    w(~~eye(Js(j))) = 0;
    w = w/sum(sum(w));
    
    % collect initial state populations (non-degenerated states)
    mols = unique(res.clusters{Js(j)}(res.clusters{Js(j)}(:,end-1)>0,4));
    for m = mols'
        states1 = res.clusters{Js(j)}(res.clusters{Js(j)}(:,4)==m,end-1);
        prob0{j}(states1(1)) = prob0{j}(states1(1))+1;
    end
    prob0{j} = prob0{j}/sum(prob0{j});
    
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
            if n==2
                fitPrm(1,1,1) = 0.5;
                fitPrm(1,3,2) = 0.5;
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
            
            if isempty(res)
                continue
            end
            
            disp('>>>>>>>> perform bootstrap fit');
            
            % perform bootstrap fit
            expPrm(3) = true;
            expPrm(5) = n_spl;
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
            
            w_k = w(j1(k),j2(k))/sum(w(j1(k),(1:Js(j))~=j1(k))); % weighing factor
            amp = res(:,1)';
            o_amp = res(:,2)';
            tau = res(:,3)';
            o_tau = res(:,4)';
            a = (amp.*tau)./sum(amp.*tau); % degenrated state population
            da = a.*(o_amp./amp + o_tau./tau + flip(o_amp./amp,2) + ...
                flip(o_tau./tau,2));

            isValid = isExpFitValid(n,tau,o_tau,tol,conf,modelSlct);
            
            rates0_k = 1./tau; % restricted rate coefficients
            d_rate0 = rates0_k.*o_tau./tau;
            
            rates{j}(row0+k-1,3:4:(2+4*n)) = amp;
            rates{j}(row0+k-1,4:4:(2+4*n)) = o_amp;
            rates{j}(row0+k-1,5:4:(2+4*n)) = tau;
            rates{j}(row0+k-1,6:4:(2+4*n)) = o_tau;
            rates{j}(row0+k-1,(3+4*n_max):2:(2+4*n_max+2*n)) = rates0_k; % restricted rate coefficient
            rates{j}(row0+k-1,(4+4*n_max):2:(2+4*n_max+2*n)) = d_rate0; % deviation
            rates{j}(row0+k-1,3+6*n_max) = w_k; % weighing factors
            rates{j}(row0+k-1,(4+6*n_max):2:(3+6*n_max+2*n)) = a; % degenrated state pop
            rates{j}(row0+k-1,(5+6*n_max):2:(3+6*n_max+2*n)) = da; % deviation
            rates{j}(row0+k-1,end) = isValid;
            
            str_k = str_trans{k}(str_trans{k}~=' ' & str_trans{k}~='.');
            fprintf(cat(2,'>>>>>>>> export screenshot of histogram fit to',...
                ' file ',fname_histImg,'\n'),num2str(Js(j)),num2str(str_k),...
                num2str(n));
            
            % export a screenshot of histogram fit
            set(h_fig, 'CurrentAxes',h.axes_TDPplot2);
            exportAxes({...
                [p.dumpdir,filesep,sprintf(fname_histImg,num2str(Js(j)),...
                num2str(str_k),num2str(n))]},[],h_fig);
        end

        fprintf(...
            cat(2,'>>>> export fitting results to file ',fname_kin,'\n'),...
            num2str(Js(j)),num2str(n));
        
        % export .fit files
        pushbutton_TDPexport_Callback(h.pushbutton_TDPexport,[],h_fig);
        set_TA_expOpt(p.tdp_expOpt,h_fig);
        pushbutton_expTDPopt_next_Callback(...
            {p.dumpdir,sprintf(fname_kin,num2str(Js(j)),num2str(n))},[],...
            h_fig);
        
        fprintf(...
            cat(2,'>>>> save modificiations to file ',fname_mashOut,...
            '...\n'),num2str(Js(j)),num2str(n));
        
        % save project
        pushbutton_TDPsaveProj_Callback(...
            {p.dumpdir,sprintf(fname_mashOut,num2str(Js(j)),num2str(n))},...
            [],h_fig);
    end
    
    % determine optimum number of decays and calculate associated
    % probabilties
    n_dec = zeros(Js(j),Js(j));
    k_rstr_opt = cell(1,K);
    dk_rstr_opt = cell(1,K);
    w_k = zeros(1,K);
    A_opt = cell(1,K);
    dA_opt = cell(1,K);
    for k = 1:K
        if j1(k)==j2(k)
            continue
        end
        for n_exp = n_max:-1:1
            isValid = rates{j}((n_exp-1)*K+k,end);
            if isValid
                break
            end
        end

        n_dec(j1(k),j2(k)) = n_exp;
        
        k_rstr_opt{k} = rates{j}(...
            (n_exp-1)*K+k,(3+4*n_max):2:(2+4*n_max+2*n_exp));
        dk_rstr_opt{k} = rates{j}(...
            (n_exp-1)*K+k,(4+4*n_max):2:(2+4*n_max+2*n_exp));
        
        w_k(k) = rates{j}((n_exp-1)*K+k,3+6*n_max);
        if n_exp==1
            A_opt{k} = 1;
            dA_opt{k} = 0;
        else
            A_opt{k} = ...
                rates{j}((n_exp-1)*K+k,(4+6*n_max):2:(3+6*n_max+2*n_exp));
            dA_opt{k} = rates{j}(...
                (n_exp-1)*K+k,(5+6*n_max):2:(3+6*n_max+2*n_exp));
        end
    end
    
    % determine transition index corresponding to each cell
    states_id = [];
    n_opt = ones(1,Js(j));
    for state = 1:Js(j)
        n_opt(state) = prod(n_dec(state,(1:Js(j))~=state));
        states_id = cat(2,states_id,repmat(state,[1,n_opt(state)]));
    end
    prob0{j} = prob0{j}(states_id);
    
    [degen2,state1] = meshgrid(states_id);
    trans = zeros(size(state1));
    w_opt = zeros(size(state1));
    for k = 1:K
        w_opt(state1==j1(k) & degen2==j2(k)) = w_k(k);
        trans(state1==j1(k) & degen2==j2(k)) = k;
    end
    
    % determine decay index corresponding to each cell
    exp_id = zeros(size(trans));
    pop_n = ones(1,size(trans,1));
    d_pop_n = zeros(1,size(trans,1));
    for state1 = 1:Js(j)
        vect = cell(1,Js(j));
        for state2 = 1:Js(j)
            if state1==state2 % transitions to same state value are forbidden
                vect{state2} = 0;
            else
                % vector containing sub-indexes of states degenerated with state2
                vect{state2} = 1:n_dec(state1,state2);
            end
        end
        
        % get all possible state transitions between degenerated states
        id_12 = meshcoord(vect);
        id_12extend = [];
        for state2 = 1:Js(j)
            id_12extend = cat(2,id_12extend,...
                repmat(id_12(:,state2),[1,n_opt(state2)]));
        end
        
        id_1 = sum(n_opt(1:(state1-1)))+(1:n_opt(state1));
        exp_id(id_1,:) = id_12extend;
        for s1 = 1:size(id_12,1)
            for degen2 = 1:size(id_12,2)
                if id_12(s1,degen2)==0
                    continue
                end
                k = find(j1==state1 & j2==degen2,1);
                pop_n(id_1(s1)) = pop_n(id_1(s1))*A_opt{k}(id_12(s1,degen2));
                d_pop_n(id_1(s1)) = d_pop_n(id_1(s1))+...
                    dA_opt{k}(id_12(s1,degen2))/A_opt{k}(id_12(s1,degen2));
            end
        end
    end
    
    % calculate transition probabilities
    prob0{j} = prob0{j}.*pop_n;
    p0 = w_opt.*repmat(pop_n,[numel(pop_n),1]);
    dp0 = p0.*repmat(d_pop_n',[1,numel(d_pop_n)]);
    
    % fill transition matrix with proper restricted rates
    k_rstr = zeros(sum(n_opt));
    dk_rstr = k_rstr;
    for a1 = 1:sum(n_opt)
        for a2 = 1:sum(n_opt)
            if exp_id(a1,a2)==0
                continue
            end
            k_rstr(a1,a2) = k_rstr_opt{trans(a1,a2)}(exp_id(a1,a2));
            dk_rstr(a1,a2) = dk_rstr_opt{trans(a1,a2)}(exp_id(a1,a2));
        end
    end
    
    % calculate unrestrcited rates
    k_unrstr = k_rstr.*p0;
    dk_unrstr = k_unrstr.*(dp0./p0 + dk_rstr./k_rstr);
    
    % concatenate results
    mat{j} = zeros(sum(n_opt),sum(n_opt),6);
    mat{j}(:,:,1) = k_rstr;
    mat{j}(:,:,2) = dk_rstr;
    mat{j}(:,:,3) = p0;
    mat{j}(:,:,4) = dp0;
    mat{j}(:,:,5) = k_unrstr;
    mat{j}(:,:,6) = dk_unrstr;
    mat{j}(isnan(mat{j})) = 0;
    
    % add state indexes in first row & column
    mat{j} = cat(1,repmat(states_id,[1,1,size(mat{j},3)]),mat{j});
    mat{j} = cat(2,repmat([0,states_id]',[1,1,size(mat{j},3)]),mat{j});
    
    % add state indexes in first row
    prob0{j} = cat(1,states_id,prob0{j});
    
    set(h.listbox_TDPprojList,'value',1);
    listbox_TDPprojList_Callback(h.listbox_TDPprojList,[],h_fig);
    pushbutton_TDPremProj_Callback(h.pushbutton_TDPremProj,[],h_fig);
end


