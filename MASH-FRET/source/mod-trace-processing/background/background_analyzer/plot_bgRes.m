function plot_bgRes(h_fig)
g = guidata(h_fig);
h = guidata(g.figure_MASH);
p = h.param.ttPr;
proj = p.curr_proj;
m = g.curr_m;
l = g.curr_l;
c = g.curr_c;
if isempty(g.res)
    return;
end
res_m = g.res{m,l,c};
if isempty(res_m)
    return;
end
perSec = p.proj{proj}.fix{2}(4);
rate = p.proj{proj}.frame_rate;
nPix = p.proj{proj}.pix_intgr(2);
str_un = '(a.u. /pix)';
if perSec
    str_un = '(a.u. /pix /s)';
    res_m(:,1) = res_m(:,1)/rate;
end
res_m(:,1) = res_m(:,1)/nPix;

if isempty(res_m)
    rotate3d(g.axes_plot_bgint, 'off');
    cla(g.axes_plot_bgint);
    return;
end

meth = g.param{1}{m}(l,c,1);

str_p1 = 'none'; isprm1 = false;
str_sbig = 'none'; issubdim = false;
if meth~=1
    str_sbig = num2str(res_m(1,3)); % method not manual
    issubdim = true;
end
if sum(meth==[3 4 5 6 7]) % method "mean value", "most frequent value" or 
                        % "histothresh50%" or "dark trace"
    str_p1 = num2str(res_m(1,2));
    isprm1 = true;
end

if g.param{3}(1) || ~isprm1
    if size(res_m,1)>=1 && (g.param{3}(2) || ~issubdim)
        % fix param 1 and sub-image dim.
        % no plot
        cla(g.axes_plot_bgint);
        xlim(g.axes_plot_bgint, [0 1]);
        ylim(g.axes_plot_bgint, [0 1]);
        text(0.05, 0.95, sprintf([...
            'BG intensity ' str_un ' = %d\n' ...
            'Parameter 1 = %s\n', ...
            'Sub-image dim. (pixel) = %s\n'], res_m(1), str_p1, ...
            str_sbig), 'Parent', g.axes_plot_bgint, ...
            'Units', 'data', 'VerticalAlignment', 'top');
        view(g.axes_plot_bgint, 2);
        rotate3d(g.axes_plot_bgint, 'off');
        title(g.axes_plot_bgint, '');
        xlabel(g.axes_plot_bgint, '');
        ylabel(g.axes_plot_bgint, '');
        zlabel(g.axes_plot_bgint, '');
        grid(g.axes_plot_bgint, 'off');

    elseif size(res_m,1)>=10 % fix param 1
                             % varies sub-image dim.
        plot(g.axes_plot_bgint, res_m(1:10,3), res_m(1:10,1), '+b');
        title(g.axes_plot_bgint, sprintf('Parameter 1 = %s', str_p1));
        view(g.axes_plot_bgint, 2);
        rotate3d(g.axes_plot_bgint, 'off');
        xlabel(g.axes_plot_bgint, 'Sub-image dim. (pixel)');
        ylabel(g.axes_plot_bgint, ['BG intensity ' str_un]);
        zlabel(g.axes_plot_bgint, '');
    end
else
    if size(res_m,1)>=10 && (g.param{3}(2) || ~issubdim) 
        % fix sub-image dim.
        % varies param 1
        plot(g.axes_plot_bgint, res_m(1:10,2), res_m(1:10,1), '+b');
        title(g.axes_plot_bgint, sprintf('Sub-image dim. = %s', str_sbig));
        view(g.axes_plot_bgint, 2);
        rotate3d(g.axes_plot_bgint, 'off');
        xlabel(g.axes_plot_bgint, 'Parameter 1');
        ylabel(g.axes_plot_bgint, ['BG intensity ' str_un]);
        zlabel(g.axes_plot_bgint, '');

    elseif size(res_m,1)>=10 % varies param 1 and sub-image dim.
        X = reshape(res_m(1:100,2), [10 10]);
        Y = reshape(res_m(1:100,3), [10 10]);
        Z = reshape(res_m(1:100,1), [10 10]);
        surf(g.axes_plot_bgint, X, Y, Z);
        title(g.axes_plot_bgint, '2D-screening');
        rotate3d(g.axes_plot_bgint, 'on');
        xlabel(g.axes_plot_bgint, 'Parameter 1');
        ylabel(g.axes_plot_bgint, 'Sub-image dim. (pixel)');
        zlabel(g.axes_plot_bgint, ['BG intensity ' str_un]);

    end
end


