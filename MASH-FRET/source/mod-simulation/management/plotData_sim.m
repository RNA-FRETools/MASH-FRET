function plotData_sim(h_fig)
% plotData_sim(h_fig)
%
% Plot first video frame, intensity traces of first molecule and intensity
% histograms
%
% h_fig: handle to main figure

% defaults
nbins = 50; % number of histogram bins

% retrieve project content
h = guidata(h_fig);
p = h.param;
if ~isModuleOn(p,'sim')
    set([h.axes_example,h.axes_example_hist,h.axes_example_mov,...
        h.cb_example_mov],'visible','off');
    return
end

prm = p.proj{p.curr_proj}.sim.prm;

% check for existing data
if ~(isfield(prm,'res_plot') && ~isempty(prm.res_plot{1}))
    set([h.axes_example,h.axes_example_hist,h.axes_example_mov,...
        h.cb_example_mov],'visible','off');
    return
end
set([h.axes_example,h.axes_example_hist,h.axes_example_mov,...
    h.cb_example_mov],'visible','on');

% collect simulation parameters
curr = p.proj{p.curr_proj}.sim.curr;
L = prm.gen_dt{1}(2);
rate = prm.gen_dt{1}(4);
viddim = prm.gen_dat{1}{2}{1};
outun = curr.exp{2};

% collect data
img = prm.res_plot{1};
I_don_ic = prm.res_plot{2}(:,1);
I_acc_ic = prm.res_plot{2}(:,2);

% get plot units
units = outun;
if ~strcmp(units, 'photon')
    units = 'image';
end

% plot first traces
timeaxis = (1:L)'/rate;
plot(h.axes_example, timeaxis,I_don_ic,'-b',timeaxis,I_acc_ic,'-r');
ylim(h.axes_example,'auto');
xlim(h.axes_example,[0 size(I_don_ic,1)/rate]);
xlabel(h.axes_example,'time (sec)');
ylabel(h.axes_example,[units,' counts']);
grid(h.axes_example,'on');
legend(h.axes_example,'donor','acceptor');

% histogram first traces
[~,edges] = histcounts([I_don_ic, I_acc_ic],nbins);
[I_don_ic_hist,don_edges] = histcounts(I_don_ic,edges);
[I_acc_ic_hist] = histcounts(I_acc_ic,edges);

% check MATLAB version for bar transparency
mtlbDat = ver;
for i = 1:size(mtlbDat,2)
    if strcmp(mtlbDat(1,i).Name,'MATLAB')
        break
    end
end
newvers = str2num(mtlbDat(1,i).Version) >= 9;

% plot histogram of first traces
if newvers
    bar(h.axes_example_hist,don_edges(1:size(don_edges,2)-1),I_don_ic_hist,...
        'EdgeColor','none','FaceColor','blue','Barwidth',1,'Facealpha',...
        0.5);
    set(h.axes_example_hist,'nextplot','add');
    bar(h.axes_example_hist,don_edges(1:size(don_edges,2)-1),I_acc_ic_hist,...
        'EdgeColor','none','FaceColor','red','Barwidth',1,'Facealpha',0.5);
else
    bar(h.axes_example_hist,don_edges(1:size(don_edges,2)-1),I_don_ic_hist,...
        'EdgeColor','none','FaceColor','blue','Barwidth',1);
    set(h.axes_example_hist,'nextplot','add');
    bar(h.axes_example_hist,don_edges(1:size(don_edges,2)-1),I_acc_ic_hist,...
        'EdgeColor','none','FaceColor','red','Barwidth',1);
end
set(h.axes_example_hist,'yscale','log','nextplot','replacechildren',...
    'xtickmode','auto');
xlim(h.axes_example_hist, 'auto');
ylim(h.axes_example_hist, 'auto');
xlabel(h.axes_example_hist, [units ' counts']);
ylabel(h.axes_example_hist, 'frequency');
grid(h.axes_example_hist, 'on');
legend(h.axes_example_hist, 'donor', 'acceptor');

% plot video frame
imagesc(h.axes_example_mov,'xdata',[0.5,viddim(1)-0.5],'ydata',...
    [0.5,viddim(2)-0.5],'cdata',img);
xlim(h.axes_example_mov,[0,viddim(1)]);
ylim(h.axes_example_mov,[0,viddim(2)]);
caxis(h.axes_example_mov,[min(min(img)),max(max(img))]);
ylabel(h.cb_example_mov, [units,' counts/time bin']);
