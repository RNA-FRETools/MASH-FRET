function plotHist(h_axes, P, lim, start, res, clr, boba, intUnits, h_fig)

if isempty(P)
    return
end

% collect interface parameters
h = guidata(h_fig);
p = h.param;
proj = p.curr_proj;
tpe = p.thm.curr_tpe(proj);

isInt = ~isempty(intUnits);
if isInt
    perSec = intUnits{1,1};
    expT = intUnits{1,2};
    perPix = intUnits{2,1};
    nPix = intUnits{2,2};
    if perSec
        P(:,1) = P(:,1)/expT;
        lim(1,:) = lim(1,:)/expT;
    end
    if perPix
        P(:,1) = P(:,1)/nPix;
        lim(1,:) = lim(1,:)/nPix;
    end
end

P(:,2) = P(:,2)/sum(P(:,2));
if numel(h_axes)>1
    P(:,3) = P(:,3)/max(P(:,3));
end

meth = start{1}(1);

% plot state configuration
if numel(h_axes)>2
    if ~isempty(res{3,1})
        L = res{3,1}(:,1);
        Jmax = size(L,1);
        isBIC = ~start{4}(1);
        
        set(h_axes(3),'visible','on');
        
        if isBIC
            BIC = res{3,1}(:,2);
            barh(h_axes(3), 1:Jmax, BIC');
            BIC_min = min(BIC(~isinf(BIC)));
            BIC_mean = mean(BIC(~isinf(BIC)));
            if BIC_min==BIC_mean
                BIC_min = BIC_mean-1;
            end
            xlim(h_axes(3),[BIC_min BIC_mean]);
            ylim(h_axes(3),[0 Jmax+1]);
            title(h_axes(3),'BIC');
            
        else
            penalty = start{4}(2);
            dL = zeros(1,Jmax-1);
            for k = 2:Jmax
                dL(k-1) = 1 + ((L(k)-L(k-1))/abs(L(k-1)));
            end
            barh(h_axes(3), 2:Jmax, dL);
            set(h_axes(3),'nextplot','add');
            plot(h_axes(3),penalty*ones(1,Jmax+2), 0:Jmax+1, '-r');
            xlim(h_axes(3),[1,2*(penalty-1)+1]);
            ylim(h_axes(3),[0,Jmax+1]);
            title(h_axes(3),'penalty');
            set(h_axes(3),'nextplot','replacechildren');
        end
    else
        cla(h_axes(3));
        set(h_axes(3),'visible','off');
    end
end

% plot state population
switch meth
    case 1 % Gaussfit
        % plot experimental data
        bar(h_axes(1), P(:,1), P(:,2), 'FaceColor', 'k', 'EdgeColor', 'k');
        
        if numel(h_axes)>1
            if size(res,1)>=2 && size(res,2)>=2 && ~isempty(res{2,2})
                mus = res{2,2}(:,2:4:end);
                pops = res{2,2}(:,4:4:end);
                K = size(mus,2);
                if isInt
                    if perSec
                        mus = mus/expT;
                    end
                    if perPix
                        mus = mus/nPix;
                    end
                end
                for k = 1:K
                    scatter(h_axes(2), mus(:,k), pops(:,k), 'Marker', ...
                        '+', 'MarkerEdgeColor', clr(k,:), ...
                        'MarkerFaceColor', clr(k,:));
                    if k == 1
                        set(h_axes(2), 'NextPlot', 'add');
                    end
                end
                set(h_axes(2), 'NextPlot', 'replacechildren');
            else
                plot(h_axes(2), P(:,1), P(:,3), '+k');
            end
        end
        
        % plot fitting results
        if ~isempty(res{2,1})
            fitprm = res{2,1};
            K = size(fitprm,1);
            set(h_axes(1), 'NextPlot', 'add');
            
            % convert intensity units for center and FWHM
            if isInt
                if perSec
                    fitprm(:,3:6) = fitprm(:,3:6)/expT;
                end
                if perPix
                    fitprm(:,3:6) = fitprm(:,3:6)/nPix;
                end
            end
            
            % convert FWHM to sigma
            fitprm(:,5) = fitprm(:,5)/(2*sqrt(2*log(2)));
            
            y_all = zeros(size(P(:,1)));
            
            for k = 1:K
                y = fitprm(k,1)*exp(-((P(:,1)-fitprm(k,3)).^2)/ ...
                    (2*(fitprm(k,5)^2)));
                plot(h_axes(1), P(:,1), y, 'Color', clr(k,:), ...
                    'LineWidth', 2);
                y_all = y_all+y;
                
                if boba && numel(h_axes)>1
                    smpl = res{2,2};
                    A_min = min(smpl(:,k*4-3));
                    o_min = min(smpl(:,k*4-1))/(2*sqrt(2*log(2)));
                    A_max = max(smpl(:,k*4-3));
                    o_max = max(smpl(:,k*4-1))/(2*sqrt(2*log(2)));
                    if isInt
                        if perSec
                            o_min = o_min/expT;
                            o_max = o_max/expT;
                        end
                        if perPix
                            o_min = o_min/nPix;
                            o_max = o_max/nPix;
                        end
                    end
                    y_min = A_min*exp(-((P(:,1)-fitprm(k,3)).^2)/ ...
                        (2*(o_min^2)));                    
                    y_max = A_max*exp(-((P(:,1)-fitprm(k,3)).^2)/ ...
                        (2*(o_max^2)));
                    plot(h_axes(1), P(:,1), y_min, 'LineStyle', '--', ...
                        'Color', clr(k,:), 'LineWidth', 1);
                    plot(h_axes(1), P(:,1), y_max, 'LineStyle', '--', ...
                        'Color', clr(k,:), 'LineWidth', 1);
                end
            end
            plot(h_axes(1), P(:,1), y_all, 'Color', [0.5 0.5 0.5], ...
                'LineWidth', 2);
            set(h_axes, 'NextPlot', 'replacechildren');
        
        % plot most probable configuration
        elseif ~isempty(res{3,1})
            h = guidata(h_fig);
            K = get(h.popupmenu_thm_nTotGauss, 'Value');
            fitprm = res{3,2}{K};
            
            if ~isempty(fitprm)
                set(h_axes(1), 'NextPlot', 'add');
                
                if isInt
                    if perSec
                        fitprm(:,[2 3]) = fitprm(:,[2 3])/expT;
                    end
                    if perPix
                        fitprm(:,[2 3]) = fitprm(:,[2 3])/nPix;
                    end
                end
                
                % convert FWHM to sigma
                fitprm(:,3) = fitprm(:,3)/(2*sqrt(2*log(2)));
                
                y_all = zeros(size(P(:,1)));
                for k = 1:K
                    y = fitprm(k,1)*exp(-((P(:,1)-fitprm(k,2)).^2)/ ...
                        (2*(fitprm(k,3)^2)));
                    y_all = y_all+y;
                    plot(h_axes(1), P(:,1), y, 'Color', clr(k,:), ...
                        'LineWidth', 2);
                end
                plot(h_axes(1), P(:,1), y_all, 'Color', [0.5 0.5 0.5], ...
                    'LineWidth', 2);
                set(h_axes(1),'NextPlot','replacechildren');
            end
        end

    case 2 % Thresholding
        
        % plot thresholds
        K = size(start{2},1)+1;
        thresh = [-Inf start{2}' Inf];
        if isInt
            if perSec
                thresh = thresh/expT;
            end
            if perPix
                thresh = thresh/nPix;
            end
        end
        
        for k = 1:K
            if k>1
                set(h_axes(1),'NextPlot','add');
            end
            id = P(:,1)>thresh(k) & P(:,1)<=thresh(k+1);
            bar(h_axes(1), P(id,1), P(id,2), 'FaceColor', ...
                clr(k,:), 'EdgeColor', clr(k,:));
        end
        y_lim = get(h_axes(1), 'YLim');
        
        for k = 2:K
            plot(h_axes(1), [thresh(k) thresh(k)], y_lim, '-k', ...
                'LineWidth', 2);
        end
        set(h_axes(1),'NextPlot','replace');
        
        if numel(h_axes)>1
            plot(h_axes(2), P(:,1), P(:,3), '+k');
            y_cumlim = get(h_axes(2), 'YLim');
            set(h_axes(2),'NextPlot','add');
            for k = 2:K
                plot(h_axes(2), [thresh(k) thresh(k)], y_cumlim, '-k', ...
                    'LineWidth', 2);
            end
            set(h_axes(2),'NextPlot','replace');
        end
end

str_tpe = get(h.popupmenu_thm_tpe, 'String');

if lim(1,2)>lim(1,1)
    set(h_axes(1), 'XLim', lim(1,:));
    if numel(h_axes)>1
        set(h_axes(2), 'XLim', lim(1,:));
    end
else
    xlim(h_axes(1), 'auto'); 
    if numel(h_axes)>1
        xlim(h_axes(2), 'auto'); 
    end
end


ylim(h_axes(1), 'auto'); 
ylabel(h_axes(1), 'normalized occurence');
if numel(h_axes)>1
    xlabel(h_axes(2), str_tpe{tpe});
    ylim(h_axes(2), [0 1]); 
    if meth==1 && size(res,1)>=2 && size(res,2)>=2 && ~isempty(res{2,2})
        ylabel(h_axes(2), 'relative population');
    else
        ylabel(h_axes(2), 'normalized cumulative occurence');
    end
end

