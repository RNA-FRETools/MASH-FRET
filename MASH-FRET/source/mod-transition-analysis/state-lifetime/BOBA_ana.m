function res = BOBA_ana(hist_dt, p, strch, nExp, rspl, n_rep, n_spl, w, ...
    h_fig, lb)
% Adapted from "bobafret.m", function "pushbutton_resfit_Callback"

h = guidata(h_fig);

% randomly select histograms, exponential/Gaussian fitting
% adjust number of replicates for bootstrapping y/n
n_hist = size(hist_dt,2);
if n_rep>0 && n_hist~=n_rep
    if h.mute_actions
        choice = 'Yes';
    else
        question = ['Number of molecules with relevant dwell times: ' ...
            num2str(n_hist) '. Should the number of replicates be ' ...
            'adjusted in the resampling process (suggested)?'];
        choice = questdlg(question, 'Adjust number of replicates', ...
            'Yes', 'No', 'Yes');
    end

    if strcmp(choice, 'Yes')
        n_rep = n_hist;

    elseif ~strcmp(choice, 'No')
        res = [];
        setContPan('Fitting process aborted.','warning',h_fig);
        return;
    end
elseif n_rep==0
    n_rep = n_hist;
end

% initialise loading bar
if lb==2
    err = loading_bar('init', h_fig, n_spl, ['Performing randomisation ' ...
        'and exponential fitting...']);
    if err
        res = [];
        return;
    end
    h = guidata(h_fig);
    h.barData.prev_var = h.barData.curr_var;
    guidata(h_fig, h);
end

res.histall = cell(1,n_spl);
for k = 1:n_spl

    x = randsample(n_hist, n_rep, rspl, w);
    res.histall{k} = [];
    for i = 1:size(x,1)
        res.histall{k} = cat(1,res.histall{k},hist_dt{x(i,1)});
    end
    res.histall{k} = res.histall{k}(:,1);
    
    % sort dwell times
    res.histall{k} = sortrows(res.histall{k},1);

    [o,ia,ja] = unique(res.histall{k}(:,1));
    res.histall{k} = res.histall{k}(ia,:);
    occ = zeros(max(ja),1);
    for j = ja'
        occ(j,1) = numel(find(ja==j));
    end
    res.histall{k} = [0;res.histall{k}];
    occ = cat(1,0,occ);
    occ = occ/sum(occ);
    res.histall{k}(:,2) = 1-cumsum(occ);
    res.histall{k}(end,2) = 0;
    
    % lauch exponential fitting
    x_data = res.histall{k}(:,1);
    y_data = res.histall{k}(:,2);
    fitres = mmexpfit_mod(x_data, y_data, p, nExp, strch, h.mute_actions);
    if isempty(fitres)
        disp(cat(2,'sample ',num2str(k),': insufficient number of data ',...
            'points to fit.'));
        res.adj_s(k,1) = NaN;

        res.cf(k,:) = NaN(1,2*nExp*double(~strch)+3*strch);  % amplitude, decay constant, beta
    else
        % get fitting results
        res.adj_s(k,1) = fitres.gof;
        res.cf(k,:) = fitres.cf;  % amplitude, decay constant, beta
    end

    % update loading bar
    if lb>0 && loading_bar('update', h_fig)
        res = [];
        return
    end
end

% remove failures because of an insufficient number of data points
excl = ~~sum(isnan(res.cf),2);
res.adj_s(excl,:) = [];
res.cf(excl,:) = [];
res.histall(excl) = [];

if size(res.cf,1)<n_spl
    setContPan(cat(2,'The number of samples that resulted in a successful',...
        ' fit is of :',num2str(size(res.cf,1)),'/',num2str(n_spl)),...
        'process',h_fig);
end

% close loading bar
if lb==2
    loading_bar('close', h_fig);
end

% all fits failed because of an insufficient number of data points
if isempty(res.cf)
    res = [];
    return;
end

res.n_rep = n_rep;



