function d_traces = getDiscr(method, traces, incl, prm, thresh, calc, ...
    str_discr, h_fig)

if isempty(incl)
    incl = true(size(traces));
end

d_traces = nan(size(traces));
N = size(d_traces,1);

if method == 2 % VbFRET
    nSlopes = 0;
    for n = 1:N
        minN = prm(n,1);
        maxN = prm(n,2);
        n_iter = prm(n,3);
        nSlopes = nSlopes + (maxN-minN+1)*n_iter;
    end
else
    nSlopes = N;
end

h = guidata(h_fig);
lb = 0;
if ~isfield(h, 'barData') && sum(method == [2 4])
    % loading bar parameters-----------------------------------------------
    intrupt = loading_bar('init', h_fig, nSlopes, str_discr);
    if intrupt
        return;
    end
    h = guidata(h_fig);
    h.barData.prev_var = h.barData.curr_var;
    guidata(h_fig, h);
    lb = 1;
    % ---------------------------------------------------------------------
end

warning('verbose', 'on');
warning('off', 'stats:kmeans:EmptyCluster');

for n = 1:N
    switch method
        case 1 % Threshold
            discrVal = thresh(1,:,n);
            low = thresh(2,:,n);
            up = thresh(3,:,n);
            nbStates = prm(n,1);
            
            d_traces(n,incl(n,:)) = discr_thresh(traces(n,incl(n,:)), ...
                discrVal, low, up, nbStates);

        case 2 % VbFRET
%             t = tic;
            minN = prm(n,1);
            maxN = prm(n,2);
            n_iter = prm(n,3);
            data = cell(1,1);
            data{1} = traces(n,incl(n,:));
            [d_traces(n,incl(n,:)),o] = discr_vbFRET(minN, maxN, n_iter, data, ...
                h_fig, lb);
%             ct = toc(t);
%             if exist('C:\Users\SigelPC18\Desktop', 'dir')
%                 f = fopen(['C:\Users\SigelPC18\Desktop\' ...
%                     'calculation_times_VbFRET.txt'], 'At');
%                 fprintf(f, '%i\t1\t%d\n', maxN, ct);
%                 fclose(f);
%             end

        case 3 % One state
            d_traces(n,incl(n,:)) = ones(size(traces(n,incl(n,:))))* ...
                mean(traces(n,incl(n,:)));

        case 4 % CPA
%             t = tic;
            maxN = 0; % not used
            n_bss = prm(n,1);
            lvl = prm(n,2);
            ana_type = prm(n,3);
            d_traces(n,incl(n,:)) = discr_cpa(traces(n,incl(n,:)), n_bss, lvl, ...
                ana_type, maxN);
%             ct = toc(t);
%             if exist('C:\Users\SigelPC18\Desktop', 'dir')
%                 f = fopen(['C:\Users\SigelPC18\Desktop\' ...
%                     'calculation_times_CPA.txt'], 'At');
%                 fprintf(f, 'Inf\t%d\n', ct);
%                 fclose(f);
%             end
            
        case 5 % STaSI
%             t = tic;
            maxN = prm(n,1);
            [MDL dat] = discr_stasi(traces(n,incl(n,:)), maxN);
            [o,idx] = min(MDL);
            d_traces(n,incl(n,:)) = dat(idx,:)';
%             ct = toc(t);
%             if exist('C:\Users\SigelPC18\Desktop', 'dir')
%                 f = fopen(['C:\Users\SigelPC18\Desktop\' ...
%                     'calculation_times_STaSI.txt'], 'At');
%                 fprintf(f, '%d\t%d\n', maxN, ct);
%                 fclose(f);
%             end
    end
    
    for l = 1:size(d_traces,2)
        if l>1 && isnan(d_traces(n,l)) && ~isnan(d_traces(n,l-1))
            d_traces(n,l) = d_traces(n,l-1);
        elseif l>1 && ~isnan(d_traces(n,l)) && isnan(d_traces(n,l-1))
            d_traces(n,isnan(d_traces(n,1:l))) = d_traces(n,l);
        end
    end
    d_traces(n,isnan(d_traces(n,:))) = 0;

    d_traces(n,:) = binDiscrVal(prm(n,6), d_traces(n,:));
    d_traces(n,:) = refineDiscr(prm(n,5), d_traces(n,:), traces(n,:));
    if calc
        d_traces(n,:) = aveStates(traces(n,:), d_traces(n,:));
    end

    if lb && method == 4
        intrpt = loading_bar('update', h_fig);
        if intrpt
            return;
        end
    end
end

warning('on', 'stats:kmeans:EmptyCluster');

if lb && sum(method == [2 4])
    loading_bar('close', h_fig);
end

function discr_ave = aveStates(tr, discr)
val = unique(discr);
discr_ave = nan(size(discr));
for i = 1:size(val,2)
    discr_ave(1,(discr(1,:) == val(i))) = ...
        mean(tr(1,(discr(1,:) == val(i))));
end


