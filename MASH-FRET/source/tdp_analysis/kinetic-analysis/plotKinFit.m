function plotKinFit(h_axes, hist_ref, kin_res, boba, scl, strch)

% plot raw data
if isempty(hist_ref)
    cla(h_axes);
    return;
end
set(h_axes, 'NextPlot', 'replace');
x_data = hist_ref(:,1);
y_data = hist_ref(:,end);
plot(h_axes, x_data, y_data, '+', 'linewidth', 5);
grid(h_axes, 'on');
set(h_axes, 'NextPlot', 'add');

if isempty(kin_res)
    lim = get(h_axes, 'YLim');
    set(h_axes, 'NextPlot', 'replacechildren', 'YLim', [min(y_data) ...
        lim(2)], 'Visible', 'on', 'YScale', scl);
    return;
end

% plot fits for reference and bootstrapped data
nExp = size(kin_res{2},1);

if strch % stretched exponential fit
    if boba
        A = kin_res{1}(1);
        tau = kin_res{1}(3);
        beta = kin_res{1}(5);
    else
        A = kin_res{2}(1);
        tau = kin_res{2}(2);
        beta = kin_res{2}(3);
    end

    plot_ref = A*exp(-(x_data/tau).^beta);
    
    plot(h_axes, x_data, plot_ref, 'r', 'linewidth', 2);
    
    if boba
        A_inf = kin_res{3}(1);
        tau_inf = kin_res{3}(2);
        beta_inf = kin_res{3}(3);

        A_sup = kin_res{4}(1);
        tau_sup = kin_res{4}(2);
        beta_sup = kin_res{4}(3);

        plot_inf = A_inf*exp(-(x_data/tau_inf).^beta_inf);
        plot_sup = A_sup*exp(-(x_data/tau_sup).^beta_sup);
        
        plot(h_axes, x_data, plot_inf, '--', 'Color', [1 0 0], ...
            'Linewidth', 1.5);
        plot(h_axes, x_data, plot_sup, '--', 'Color', [1 0 0], ...
            'Linewidth', 1.5);
        
    end
    
else % single-/multiexponential fit
    plot_ref = zeros(size(x_data));
    if boba
        plot_inf = zeros(size(x_data));
        plot_sup = zeros(size(x_data));
    end

    for i = 1:nExp
        if boba && size(kin_res{1},2)>=4
            A = kin_res{1}(i,1);
            tau = kin_res{1}(i,3);
        else
            A = kin_res{2}(i,1);
            tau = kin_res{2}(i,2);
        end
        
        plot_ref = plot_ref + A*exp(-x_data/tau);
        
        if boba && size(kin_res{1},2)>=4
            A_inf = kin_res{3}(i,1);
            tau_inf = kin_res{3}(i,2);

            A_sup = kin_res{4}(i,1);
            tau_sup = kin_res{4}(i,2);
            
            plot_inf = plot_inf + A_inf*exp(-x_data/tau_inf);
            plot_sup = plot_sup + A_sup*exp(-x_data/tau_sup);
        end        
    end
    
    plot(h_axes, x_data,plot_ref, 'r', 'linewidth', 2);
    if boba && size(kin_res{1},2)>=4
        plot(h_axes, x_data,plot_inf, '--', 'Color', [1 0 0], ...
            'Linewidth', 1.5);
        plot(h_axes, x_data,plot_sup, '--', 'Color', [1 0 0], ...
            'Linewidth', 1.5);
    end
    
end

title(h_axes, 'Kinetic analysis from dwell-times');
xlabel(h_axes, 'dwell-times (s)');
ylabel(h_axes, 'normalised (1 - cum(P))');
lim = get(h_axes, 'YLim');

set(h_axes, 'NextPlot', 'replacechildren', 'YLim', [min(y_data) ...
    lim(2)], 'Visible', 'on', 'YScale', scl);





