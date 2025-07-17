function d_traces = getDiscr(method, traces, incl, prm, thresh, calc, ...
    str_discr, h_fig)

% Last update by MH, 27.12.2020: add 2D-vbFRET
% update by MH, 29.5.2019: handle error better for ratio data: if less than 2 data points remains because of out-of-range [-0.2;1.2] data, include all data point back and discretize out-of-range data.
% update by MH, 30.3.2019: fix error for ratio data: if all data points were excluded because out-of-range [-0.2;1.2], include all data point back and discretize out-of-range data.

mute = false;
if isscalar(str_discr) && str_discr==0
    mute = true;
end

is2D = false;
if iscell(traces)
    is2D = true;
    N = numel(traces);
    incl = cell(1,N);
    d_traces = cell(1,N);
    for n = 1:N
        if sum(incl{n})<2
            incl{n} = true(1,size(traces{n},2));
        end
        d_traces{n} = nan(size(traces{n}));
    end
else
    if sum(incl)<2
        incl = true(size(traces,1),size(traces,2));
    end
    d_traces = nan(size(traces,1),size(traces,2));
    N = size(d_traces,1);
end

if any(method==[2,3,6]) % VbFRET
    nSlopes = 0;
    for n = 1:N
        minK = prm(n,1);
        maxK = prm(n,2);
        n_iter = prm(n,3);
        nSlopes = nSlopes + (maxK-minK+1)*n_iter + 1;
    end
else
    nSlopes = N;
end

lb = 0;
if ~isempty(h_fig)
    h = guidata(h_fig);
    if ~isfield(h, 'barData') && sum(method == [2,3,5,6])
        if loading_bar('init', h_fig, nSlopes, str_discr)
            return
        end
        h = guidata(h_fig);
        h.barData.prev_var = h.barData.curr_var;
        guidata(h_fig, h);
        lb = 1;
    end
end

warning('verbose', 'on');
warning('off', 'stats:kmeans:EmptyCluster');

for n = 1:N
    
    % added by MH, 30.3.2019
    if ~is2D && sum(~incl(n,:))==size(traces,2)
        incl(n,:) = true;
    elseif is2D && sum(~incl{n})==size(traces{n},2)
        incl{n}(:,:) = true;
    end
    
    switch method
        case 1 % Threshold
            discrVal = thresh(1,:,n);
            low = thresh(2,:,n);
            up = thresh(3,:,n);
            nbStates = prm(n,1);
            
            d_traces(n,incl(n,:)) = discr_thresh(traces(n,incl(n,:)), ...
                discrVal, low, up, nbStates);

        case 2 % 1D-VbFRET
            minK = prm(n,1);
            maxK = prm(n,2);
            n_iter = prm(n,3);
            data = cell(1,1);
            data{1} = traces(n,incl(n,:));
            [vbres,o] = discr_vbFRET(minK,maxK,n_iter,data,h_fig,lb,...
                mute,1);
            d_traces(n,incl(n,:)) = vbres{1};

            
        case 3 % 2D-VbFRET
            minK = prm(n,1);
            maxK = prm(n,2);
            n_iter = prm(n,3);
            data = cell(1,1);
            data{1} = traces{n};
            [vbres,o] = discr_vbFRET(minK,maxK,n_iter,data,h_fig,lb,...
                mute,2);
            d_traces{n}(:,incl{n}) = vbres{1}';

        case 4 % One state
            d_traces(n,incl(n,:)) = ones(size(traces(n,incl(n,:))))* ...
                mean(traces(n,incl(n,:)));

        case 5 % CPA
            maxK = 0; % not used
            n_bss = prm(n,1);
            lvl = prm(n,2);
            ana_type = prm(n,3);
            d_traces(n,incl(n,:)) = discr_cpa(traces(n,incl(n,:)),...
                mute,n_bss,lvl,ana_type, maxK);
            
        case 6 % STaSI
            maxK = prm(n,1);
            [MDL,dat] = discr_stasi(traces(n,incl(n,:)),maxK,mute);
            if ~isempty(dat)
                [~,idx] = min(MDL);
                d_traces(n,incl(n,:)) = dat(idx,:)';
            end
            
        case 7 % STaSI+vbFRET-1D
            minK = prm(n,1);
            maxK = prm(n,2);
            n_iter = prm(n,3);
            [MDL,dat] = discr_stasi(traces(n,incl(n,:)),maxK,mute);
            if ~isempty(dat)
                maxK = numel(MDL);
                K = find(MDL==min(MDL(min([minK,maxK]):maxK)));
                
                % normalizes signal
                data = cell(1,1);
                data{1} = prepdatforvbfret(traces(n,incl(n,:)));
                
                % determine starting model parameters
                gmmprm0 = cell(1,K);
                gmmprm0{K}.states = unique(dat(K,:));
                gmmprm0{K}.pop = zeros(1,K);
                gmmprm0{K}.stdev = zeros(1,K);
                normstates = NaN(1,K);
                for k = 1:K
                    isstatek = dat(K,:)==gmmprm0{K}.states(k);
                    normstates(k) = mean(data{1}(incl(n,isstatek)));
                    gmmprm0{K}.pop(k) = sum(isstatek);
                    gmmprm0{K}.stdev(k) = std(data{1}(incl(n,isstatek)));
                end
                gmmprm0{K}.pop= gmmprm0{K}.pop/sum(gmmprm0{K}.pop); 
                gmmprm0{K}.states = normstates;
                
                % run constrained vbFRET on normalized signal values
                [vbres,~] = discr_vbFRET(K,K,n_iter,data,h_fig,lb,mute,1,...
                    gmmprm0);
                
                % restore original signal values
                d_traces(n,incl(n,:)) = trajkernel(traces(n,incl(n,:)),...
                    true(size(data{1})),vbres{1}');
            end
            
        case 8 % imported
            d_traces(n,incl(n,:)) = traces(n,incl(n,:),2);
    end
    
    if is2D
        for m = 1:size(d_traces{n},1)
            for l = 1:size(d_traces{n},2)
                if l>1 && isnan(d_traces{n}(m,l)) && ...
                        ~isnan(d_traces{n}(m,l-1))
                    d_traces{n}(m,l) = d_traces{n}(m,l-1);
                elseif l>1 && ~isnan(d_traces{n}(m,l)) && ...
                        isnan(d_traces{n}(m,l-1))
                    d_traces{n}(m,isnan(d_traces{n}(m,1:l))) = ...
                        d_traces{n}(m,l);
                end
            end
            d_traces{n}(m,isnan(d_traces{n}(m,:))) = 0;
        end
        
    else
        for l = 1:size(d_traces,2)
            if l>1 && isnan(d_traces(n,l)) && ~isnan(d_traces(n,l-1))
                d_traces(n,l) = d_traces(n,l-1);
            elseif l>1 && ~isnan(d_traces(n,l)) && isnan(d_traces(n,l-1))
                d_traces(n,isnan(d_traces(n,1:l))) = d_traces(n,l);
            end
        end
        d_traces(n,isnan(d_traces(n,:))) = 0;
        
        d_traces(n,:) = postprocessdiscrtraj(d_traces(n,:),...
            [prm(n,[7,6,5]),calc],traces(n,:,1));
    end

    if lb && any(method == [2,3,5,6])
        if loading_bar('update', h_fig)
            return
        end
    end
end

warning('on', 'stats:kmeans:EmptyCluster');

if lb && any(method == [2,3,5,6])
    loading_bar('close', h_fig);
end


function [dat,prm0] = prepdatforvbfret(dat,prm0)
L = size(dat,2);
meandat = mean(dat,2);
stddat = std(dat,0,2);
dat = (dat-repmat(meandat,1,L))./repmat(stddat,1,L);


