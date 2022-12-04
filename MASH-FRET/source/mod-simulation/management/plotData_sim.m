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
    cla(h.axes_example);
    cla(h.axes_S_frettrace);
    cla(h.axes_example_hist);
    cla(h.axes_S_frethist);
    cla(h.axes_example_mov);
    set([h.axes_example,h.axes_S_frettrace,h.axes_example_hist,...
        h.axes_S_frethist,h.axes_example_mov,h.cb_example_mov],'visible',...
        'off');
    return
end
FRET = p.proj{p.curr_proj}.FRET;
chanExc = p.proj{p.curr_proj}.chanExc;
exc = p.proj{p.curr_proj}.excitations;
clr =  p.proj{p.curr_proj}.colours;
inSec = p.proj{p.curr_proj}.time_in_sec;
perSec = p.proj{p.curr_proj}.cnt_p_sec;
prm = p.proj{p.curr_proj}.sim.prm;

% check for existing data
if ~(isfield(prm,'res_plot') && ~isempty(prm.res_plot{1}))
    cla(h.axes_example);
    cla(h.axes_S_frettrace);
    cla(h.axes_example_hist);
    cla(h.axes_S_frethist);
    cla(h.axes_example_mov);
    set([h.axes_example,h.axes_S_frettrace,h.axes_example_hist,...
        h.axes_S_frethist,h.axes_example_mov,h.cb_example_mov],'visible',...
        'off');
    return
end
set([h.axes_example,h.axes_S_frettrace,h.axes_example_hist,...
    h.axes_S_frethist,h.axes_example_mov,h.cb_example_mov],'visible','on');

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

% calculate FRET data
frettrace = calcFRET([],[],exc,chanExc,FRET,[I_don_ic,I_acc_ic],...
    ones(size(I_don_ic)));

% get plot units
units = outun;
if ~strcmp(units, 'photon')
    units = 'image';
end
if perSec
    img = img*rate;
    I_don_ic = I_don_ic*rate;
    I_acc_ic = I_acc_ic*rate;
    str_iun = [units,' counts / seconds'];
else
    str_iun = [units,' counts'];
end

% plot first intensity traces
timeaxis = (1:L)';
if inSec
    timeaxis = timeaxis/rate;
    str_tun = 'seconds';
else
    str_tun = 'frames';
end
plot(h.axes_example,timeaxis,I_don_ic,'linestyle','-','color',clr{1}{1,1});
set(h.axes_example,'nextplot','add');
plot(h.axes_example,timeaxis,I_acc_ic,'linestyle','-','color',clr{1}{1,2});
set(h.axes_example,'nextplot','replacechildren');
ylim(h.axes_example,'auto');
xlim(h.axes_example,[timeaxis(1) timeaxis(end)]);
xlabel(h.axes_example,['time (',str_tun,')']);
ylabel(h.axes_example,['intensity (',str_iun,')']);
grid(h.axes_example,'on');
legend(h.axes_example,'donor','acceptor');

% plot first FRET trace
plot(h.axes_S_frettrace,timeaxis,frettrace,'linestyle','-','color',...
    clr{2}(1,:));
ylim(h.axes_S_frettrace,[-0.2,1.2]);
xlim(h.axes_S_frettrace,[timeaxis(1) timeaxis(end)]);
xlabel(h.axes_S_frettrace,['time (',str_tun,')']);
ylabel(h.axes_S_frettrace,'FRET');
grid(h.axes_S_frettrace,'on');

% histogram first traces
[~,edges_I] = histcounts([I_don_ic, I_acc_ic],nbins);
[I_don_ic_hist,don_edges] = histcounts(I_don_ic,edges_I);
[I_acc_ic_hist] = histcounts(I_acc_ic,edges_I);
[frethist,fret_edges] = histcounts(frettrace,-0.2:0.025:1.2);

% check MATLAB version for bar transparency
mtlbDat = ver;
for i = 1:size(mtlbDat,2)
    if strcmp(mtlbDat(1,i).Name,'MATLAB')
        break
    end
end
newvers = str2num(mtlbDat(1,i).Version) >= 9;

% plot histogram of first intensity traces
if newvers
    bar(h.axes_example_hist,don_edges(1:size(don_edges,2)-1),I_don_ic_hist,...
        'EdgeColor','none','FaceColor',clr{1}{1,1},'Barwidth',1,...
        'Facealpha',0.5);
    set(h.axes_example_hist,'nextplot','add');
    bar(h.axes_example_hist,don_edges(1:size(don_edges,2)-1),I_acc_ic_hist,...
        'EdgeColor','none','FaceColor',clr{1}{1,2},'Barwidth',1,...
        'Facealpha',0.5);
else
    bar(h.axes_example_hist,don_edges(1:size(don_edges,2)-1),I_don_ic_hist,...
        'EdgeColor','none','FaceColor',clr{1}{1,1},'Barwidth',1);
    set(h.axes_example_hist,'nextplot','add');
    bar(h.axes_example_hist,don_edges(1:size(don_edges,2)-1),I_acc_ic_hist,...
        'EdgeColor','none','FaceColor',clr{1}{1,2},'Barwidth',1);
end
set(h.axes_example_hist,'yscale','log','nextplot','replacechildren',...
    'xtickmode','auto');
xlim(h.axes_example_hist, 'auto');
ylim(h.axes_example_hist, 'auto');
xlabel(h.axes_example_hist, ['intensity (',str_iun,')']);
ylabel(h.axes_example_hist, 'frequency');
grid(h.axes_example_hist, 'on');
legend(h.axes_example_hist, 'donor', 'acceptor');

% plot histogram o ffirst FRET trace
bar(h.axes_S_frethist,fret_edges(1:size(fret_edges,2)-1),frethist,...
    'EdgeColor','none','FaceColor',clr{2}(1,:),'Barwidth',1);
set(h.axes_S_frethist,'yscale','log');
xlim(h.axes_S_frethist,[-0.2,1.2]);
ylim(h.axes_S_frethist, 'auto');
xlabel(h.axes_S_frethist, 'FRET');
ylabel(h.axes_S_frethist, 'frequency');
grid(h.axes_S_frethist, 'on');

% plot video frame
imagesc(h.axes_example_mov,'xdata',[0.5,viddim(1)-0.5],'ydata',...
    [0.5,viddim(2)-0.5],'cdata',img);
xlim(h.axes_example_mov,[0,viddim(1)]);
ylim(h.axes_example_mov,[0,viddim(2)]);
caxis(h.axes_example_mov,[min(min(img)),max(max(img))]);
ylabel(h.cb_example_mov, ['intensity (',str_iun,')']);
