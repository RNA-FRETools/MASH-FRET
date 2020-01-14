function ud_TDPplot(h_fig)

% Last update by MH, 12.12.2019:
% >> give the colorbar's handle in plotTDP's input to prevent dependency on 
%  MASH main figure's handle and allow external use.

h = guidata(h_fig);
p = h.param.TDP;
proj = p.curr_proj;
tpe = p.curr_type(proj);
tag = p.curr_tag(proj);

prm = p.proj{proj}.prm{tag,tpe};
exc = p.proj{proj}.excitations;
nExc = p.proj{proj}.nb_excitations;
nChan = p.proj{proj}.nb_channel;
labels = p.proj{proj}.labels;
FRET = p.proj{proj}.FRET;
nFRET = size(FRET,1);
S = p.proj{proj}.S;
nS = size(S,1);
tagNames = p.proj{proj}.molTagNames;
colorlist = p.proj{proj}.molTagClr;
nTag = size(tagNames,2);

bin = prm.plot{1}(1,1);
lim = prm.plot{1}(1,2:3);
gconv = prm.plot{1}(3,2);
norm = prm.plot{1}(3,3);
onecount = prm.plot{1}(4,1);
rearrng = prm.plot{1}(4,2);
TDP = prm.plot{2};
meth = prm.clst_start{1}(1);

% build data type list
str_pop = {};
for l = 1:nExc
    for c = 1:nChan
        str_pop = cat(2,str_pop,cat(2,labels{c},' at ',num2str(exc(l)),...
            'nm'));
    end
end
for n = 1:nFRET
    str_pop = cat(2,str_pop,cat(2,'FRET ',labels{FRET(n,1)},'>',...
        labels{FRET(n,2)}));
end
for n = 1:nS
    str_pop = cat(2,str_pop,cat(2,'S ',labels{S(n,1)},'>',labels{S(n,2)}));
end
set(h.popupmenu_TDPdataType,'value',tpe,'string',str_pop);

% build tag list
str_pop = getStrPopTags(tagNames,colorlist);
if nTag>1
    str_pop = cat(2,'all molecules',str_pop);
end
set(h.popupmenu_TDPtag,'string',str_pop,'value',tag);

% build TDP matrix
dt_raw = p.proj{proj}.dt(:,tpe); % {1-by-nMol} transitions
TDP_prm{1} = bin; % TDP binning
TDP_prm{2} = lim; % TDP limits
TDP_prm{3} = p.proj{proj}.frame_rate; % rate
TDP_prm{4} = [onecount,rearrng]; % transition count/rearrange sequences

% create TDP matrix and get binned transitions + TDP coord. assignment
if isempty(TDP)
    [TDP,dt_bin] = getTDPmat(dt_raw, TDP_prm, h_fig);
    prm.plot{2} = TDP;
    prm.plot{3} = dt_bin;
    p.proj{proj}.prm{tag,tpe} = prm;
end
if numel(TDP)==1 && isnan(TDP)
    setProp(h.uipanel_TA_transitionDensityPlot,'enable','off');
    set([h.text_TDPdataType,h.popupmenu_TDPdataType,h.text_TDPtag,...
        h.popupmenu_TDPtag],'enable','on');
    return
end

setProp(h.uipanel_TA_transitionDensityPlot,'enable','on');

set([h.edit_TDPbin h.edit_TDPmin h.edit_TDPmax],'BackgroundColor',[1 1 1]);

set(h.edit_TDPbin, 'String', num2str(bin));
set(h.edit_TDPmin, 'String', num2str(lim(1)));
set(h.edit_TDPmax, 'String', num2str(lim(2)));
set(h.checkbox_TDPgconv, 'Enable', 'on', 'Value', gconv);
set(h.checkbox_TDPnorm, 'Enable', 'on', 'Value', norm);
set(h.checkbox_TDP_onecount, 'Enable', 'on', 'Value', onecount);
set(h.checkbox_TDPignore, 'Enable', 'on', 'Value', rearrng);

% plot TDP matrix and clusters data
clr = prm.clst_start{3};
mu = [];
a = [];
o = [];
clust = [];

if ~isempty(prm.clst_res{1})
    if meth == 2 % GM
        % adjust index of model to display
        J = get(h.popupmenu_tdp_model,'Value')+1;
        Jmax = size(prm.clst_res{1}.mu,2);
        if J>Jmax
            J = Jmax;
        end
        set(h.popupmenu_tdp_model,'Value',J-1);
        
        % adjust model list
        str = {};
        for j = 1:Jmax
            str = cat(2,str,num2str(j));
        end
        set(h.popupmenu_tdp_model,'String',str(2:Jmax));

        mu = prm.clst_res{1}.mu{J};
        clust = prm.clst_res{1}.clusters{J};
        a = prm.clst_res{1}.a{J};
        o = prm.clst_res{1}.o{J};
        
        % plot BIC results
        Jmax = size(prm.clst_res{1}.BIC,2);
        BICs = prm.clst_res{1}.BIC;
        barh(h.axes_tdp_BIC,1:Jmax,BICs);
        xlim(h.axes_tdp_BIC,[min(BICs) mean(BICs)]);
        ylim(h.axes_tdp_BIC,[0,Jmax+1]);
        title(h.axes_tdp_BIC,'BIC');
        
    else
        J = prm.clst_res{3};
        mu = prm.clst_res{1}.mu{J};
        clust = prm.clst_res{1}.clusters{J};
    end
else
    if meth == 1 % kmean
        mu = prm.clst_start{2}(:,1);
    end
end

plot_prm{1} = lim; % TDP limits
plot_prm{2} = bin; % TDP binning
plot_prm{3} = gconv; % conv./not TDP with Gaussian, o^2=0.0005
plot_prm{4} = norm; % normalize/not TDP z-axis
plot_prm{5} = clr; % cluster colours

clust_prm{1} = mu; % converged cluster centres (states)
clust_prm{2} = clust; % cluster assigment of TDP coordinates
clust_prm{3}.a = a; % converged Gaussian weights
clust_prm{3}.o = o; % converged Gaussian deviations

plotTDP(h.axes_TDPplot1, h.colorbar_TA, TDP, plot_prm, clust_prm, h_fig);

% adjust colormap
p.cmap = colormap(h.axes_TDPplot1);
set(h.axes_TDPplot1, 'Color', p.cmap(1,:));
setCmap(h_fig, p.cmap);

% store modifications
h.param.TDP = p;
guidata(h_fig, h);

