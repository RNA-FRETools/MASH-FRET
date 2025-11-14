function area_slct = plot_pbGamma(h_axes, x_axis, I_a, traj, clr, cutOff, ...
    tol, area_slct)

% default
decr = 0.1;
clr_cut = [0,0,1];
alpha_tol = 0.2;

if isequal(clr{3},clr{1})
    clr{3} = clr{3}-decr;
    clr{3}(clr{3}<0) = 0;
end

plot(h_axes, x_axis(1,:), I_a, 'Color', clr{1});

set(h_axes, 'NextPlot', 'add');

I_dta = traj{1};
I_DA = traj{2};
plot(h_axes, x_axis(2,:), I_DA(1,:), 'Color', clr{2});
plot(h_axes, x_axis(2,:), I_DA(2,:), 'Color', clr{3});
plot(h_axes, x_axis(2,:), I_dta(:,1), 'Color', shiftbright(clr{2},-0.2),...
    'LineWidth', 2);
plot(h_axes, x_axis(2,:), I_dta(:,2), 'Color', shiftbright(clr{3},-0.2),...
    'LineWidth', 2);

xlim(h_axes,[min(x_axis(:,1)),max(x_axis(:,end))]);
ylim(h_axes,'auto');

lim_y = get(h_axes,'ylim');

plot(h_axes, [cutOff,cutOff], lim_y, 'Color', clr_cut);

xdata = [x_axis(1)-1 cutOff-tol cutOff-tol cutOff+tol cutOff+tol x_axis(end)+1];
ydata = [lim_y(1)-1 lim_y(1)-1 lim_y(2)+1 lim_y(2)+1 lim_y(1)-1 lim_y(1)-1];

if ~isempty(area_slct) && ishandle(area_slct)
    set(area_slct,'xdata',xdata,'ydata',ydata,'basevalue',lim_y(1)-1);
else
    area_slct = area(h_axes,xdata,ydata,'linestyle','none','facecolor',...
        clr_cut,'facealpha',alpha_tol,'basevalue',lim_y(1)-1);
end

ylim(h_axes,lim_y);

set(h_axes, 'NextPlot', 'replacechildren');



