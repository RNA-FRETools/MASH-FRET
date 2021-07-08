function exportBOBAfit_exp(j,pname,name,h_fig)

% defaults
fntSize = 10.66666;
mg = 10;
isdriver = true;
wA4 = 21;
hA4 = 29.7;
markhist = '+';
lwhist = 5;
clrfit = 'r';
lwfit = 2;
scl = 'log';
nCol = 3;
nRow = 4;

h = guidata(h_fig);
p = h.param.TDP;
proj = p.curr_proj;
tag = p.curr_tag(proj);
tpe = p.curr_type(proj);
prm = p.proj{proj}.prm{tag,tpe};
lft_res = prm.lft_res(j,:);
lft_start = prm.lft_start{1}(j,:);
strch = lft_start{1}(2);
nExp = lft_start{1}(3);
histspl =  lft_res{5}{1};
fitres = lft_res{5}{2}; 
nSpl = size(lft_res{5}{1},2);

if loading_bar('init', h_fig, ceil(nSpl/3), ['Build *.pdf figures of ' ...
        'bootstrapped histograms ...'])
    return
end
h = guidata(h_fig);
h.barData.prev_var = h.barData.curr_var;
guidata(h_fig, h);

units_0 = get(0, 'Units');
set(0, 'Units', 'pixels');
pos_0 = get(0, 'ScreenSize');
set(0, 'Units', units_0);
hFig = pos_0(4); % A4 format
wFig = hFig*wA4/hA4;
xFig = (pos_0(3) - wFig)/2;
yFig = (pos_0(4) - hFig)/2;
h_fig_mol = figure('Visible','off','Units','pixels','Position',...
    [xFig yFig wFig hFig],'Color',[1 1 1],'Name','Preview','NumberTitle',...
    'off','MenuBar','none','PaperOrientation','portrait','PaperType','A4',...
    'PaperPositionMode','auto');
posFig = get(h_fig_mol, 'Position');
wFig = posFig(3);
hFig = posFig(4);
hMol = hFig/4;
h_axes = hMol-3*mg;
w_full = wFig/3;
w_axes = w_full-mg;

fname_fig = {};
pname_fig_temp = cat(2,pname,'temp');
if ~exist(pname_fig_temp,'dir')
    mkdir(pname_fig_temp);
end

yNext = hFig - hMol - mg;
nfig = 1;
s_prev = 1;
s_end = nCol*nRow;
for curr_s = 1:nCol:nSpl
    xNext = mg;
    for s = curr_s:(curr_s+nCol-1)
        if s>nSpl
            break
        end
        xNext = xNext + double(curr_s~=s)*w_full;
        
        excl = histspl{s}(:,2)==0;
        histspl{s}(excl,:) = [];
        
        a = axes('Parent',h_fig_mol,'Units','pixels','FontUnits',...
            'pixels','FontSize',fntSize,'ActivePositionProperty', ...
            'OuterPosition');
        
        plot(a,histspl{s}(:,1),histspl{s}(:,2),markhist,'linewidth',...
            lwhist);
        set(a, 'NextPlot', 'add');
        
        if strch
            A = fitres(s,1);
            tau = fitres(s,2);
            beta = fitres(s,3);
            plot_fit = A*exp(-(histspl{s}(:,1)/tau).^beta);
        else
            plot_fit = zeros(size(histspl{s}(:,1)));
            for i = 1:nExp
                A = fitres(s,(i-1)*2+1);
                tau = fitres(s,i*2);
                plot_fit = plot_fit + A*exp(-histspl{s}(:,1)/tau);
            end
        end
        plot(a, histspl{s}(:,1), plot_fit, clrfit, 'linewidth', lwfit);
        
        if histspl{s}(1,1)==histspl{s}(end,1)
            x_lim = histspl{s}(1,1)+[-1,1];
        else
            x_lim = histspl{s}([1,end],1)';
        end
        y_min = min(histspl{s}(:,2));
        y_max = max(histspl{s}(:,2));
        if y_min==y_max
            y_lim = y_min+[-1,1];
        else
            y_lim = [y_min,y_max];
        end

        set(a,'NextPlot','replacechildren','YScale',scl);
        set([get(a,'XLabel') get(a,'YLabel')],'String',[]);
        grid(a, 'on');
        xlim(a,x_lim);
        ylim(a,y_lim);
        title(a, ['sample n:°' num2str(s)]);

        pos = getRealPosAxes([xNext yNext w_axes h_axes], ...
            get(a,'TightInset'),'traces');
        set(a, 'Position', pos);
    end

    yNext = yNext - hMol;

    if s==s_end || s==nSpl
        if isdriver
            try
                fname_fig = cat(2,fname_fig,cat(2,pname_fig_temp,filesep,...
                    name,'_sample',num2str(s_prev),'-',num2str(s),'of',...
                    num2str(nSpl),'.pdf'));

                print(h_fig_mol,fname_fig{nfig},'-dpdf');
                nfig = nfig + 1;
                s_prev = s + 1;

            catch err
                if strcmp(err.identifier,'ps2pdf:ghostscriptCommand')
                    isdriver = true;
                    setContPan(['Can not find Ghostscript installed ' ...
                        'with MATLAB: Figure were exported to *.png ' ...
                        'files.'],'process',h.figure_MASH);
                    print(h_fig_mol, [pname,name,'samples_', ...
                        num2str(s_end-nCol*nRow+1),'_to_',num2str(s_end), ...
                        '.png'],'-dpng');
                else
                    throw(err);
                end
            end

        else
            print(h_fig_mol, [pname,name,'samples_', ...
                num2str(s_end-nCol*nRow+1),'_to_',num2str(s_end),'.png'], ...
                '-dpng');
        end

        close(h_fig_mol);
        s_end = s_end + nCol*nRow;
        if s<nSpl
            h_fig_mol = figure('Visible', 'off', 'Units', 'pixels', ...
                'Position',[xFig yFig wFig hFig], 'Color', [1 1 1], ...
                'Name','Preview','NumberTitle', 'off', 'MenuBar', ...
                'none','PaperOrientation','portrait', 'PaperType', ...
                'A4','PaperPositionMode','auto');
            yNext = hFig - hMol - mg;
        end
    end
    err = loading_bar('update', h_fig);
    if err
        return;
    end
end

if ishandle(h_fig_mol)
    close(h_fig_mol);
end

if isdriver
    fname_pdf = cat(2,name,'.pdf');
    if exist([pname,fname_pdf],'file')
        delete([pname,fname_pdf]);
    end
    append_pdfs(cat(2,pname,fname_pdf),fname_fig{:});
    flist = dir(pname_fig_temp);
    for i = 1:size(flist,1)
        if ~(strcmp(flist(i).name,'.') || strcmp(flist(i).name,'..')) 
            delete(cat(2,pname_fig_temp,filesep,flist(i).name));
        end
    end
    rmdir(pname_fig_temp);
end

loading_bar('close', h_fig);
