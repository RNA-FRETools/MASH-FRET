function res = BOBA_ana(hist_dt, p, strch, nExp, rspl, n_rep, n_spl, w, ...
    h_fig)
% Adapted from "bobafret.m", function "pushbutton_resfit_Callback"

h = guidata(h_fig);

% randomly select histograms, exponential/Gaussian fitting
% adjust number of replicates for bootstrapping y/n
n_hist = size(hist_dt,2);
if n_hist ~= n_rep
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
end

% initialise loading bar
err = loading_bar('init', h_fig, n_spl, ['Performing randomisation ' ...
    'and exponential fitting...']);
if err
    res = [];
    return;
end
h = guidata(h_fig);
h.barData.prev_var = h.barData.curr_var;
guidata(h_fig, h);

for k = 1:n_spl

    x = randsample(n_hist, n_rep, rspl, w);
    histall = []; occ = [];
    for i = 1:size(x,1)
        histall = [histall; hist_dt{x(i,1)}];
    end
    histall = histall(:,1);
    
    % sort dwell times
    histall = sortrows(histall,1);

    [o,ia,ja] = unique(histall(:,1));
    histall = histall(ia,:);
    for j = ja'
        occ(j,1) = numel(find(ja==j));
    end
    histall = [0;histall];
    occ = [0;occ];
    occ = occ/sum(occ);
    histall(:,2) = 1-cumsum(occ);
    histall(end,2) = 0;
    
    % lauch exponential fitting
    x_data = histall(:,1);
    y_data = histall(:,2);
    fitres = mmexpfit_mod(x_data, y_data, p, nExp, strch, h.mute_actions);
    if isempty(fitres)
%         res = [];
%         % close loading bar
%         loading_bar('close', h_fig);
%         return;
        disp(cat(2,'sample ',num2str(k),': insufficient number of data ',...
            'points to fit.'));
        res.adj_s(k,1).sse = NaN;
        res.adj_s(k,1).rsquare = NaN;
        res.adj_s(k,1).dfe = NaN;
        res.adj_s(k,1).adjrsquare = NaN;
        res.adj_s(k,1).rmse = NaN;

        res.cf(k,:) = NaN(1,2*nExp*double(~strch)+3*strch);  % amplitude, decay constant, beta
    else
        % get fitting results
        res.adj_s(k,1) = fitres.gof;
        res.cf(k,:) = fitres.cf;  % amplitude, decay constant, beta
    end

    % update loading bar
    err = loading_bar('update', h_fig); 
    if err
        res = [];
        return;
    end
end

% remove failures because of an insufficient number of data points
res.adj_s(~~sum(isnan(res.cf),2),:) = [];
res.cf(~~sum(isnan(res.cf),2),:) = [];

if size(res.cf,1)<n_spl
    setContPan(cat(2,'The number of samples that resulted in a successful',...
        ' fit is of :',num2str(size(res.cf,1)),'/',num2str(n_spl)),...
        'process',h_fig);
end

% close loading bar
loading_bar('close', h_fig);

% all fits failed because of an insufficient number of data points
if isempty(res.cf)
    res = [];
    return;
end

res.n_rep = n_rep;



