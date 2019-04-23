function export_thm(h_fig)

% Last update: 23.4.2019 by MH
% >> correct export for Gaussian fit without BOBA-FRET

h = guidata(h_fig);
p = h.param.thm;
proj = p.curr_proj;
tpe = p.curr_tpe(proj);
str_tpe = get(h.popupmenu_thm_tpe, 'String');
str_tpe = strrep(strrep(strrep(str_tpe{tpe}, ' ', ''),'>',''),'.','');
prm = p.proj{proj}.prm{tpe};
pplot = prm.plot;
pstart = prm.thm_start;
pres = prm.thm_res;

nChan = p.proj{proj}.nb_channel;
nExc = p.proj{proj}.nb_excitations;
isInt = tpe <= 2*nChan*nExc;
perSec = p.proj{proj}.cnt_p_sec;
perPix = p.proj{proj}.cnt_p_pix;
expT = p.proj{proj}.frame_rate;
nPix = p.proj{proj}.pix_intgr(2);

if isInt
    str_units = 'a.u.';
    if perSec
        str_units = cat(2,str_units,' s-1');
        pstart{2} = pstart{2}/expT; % thresholds
        pstart{3}(:,4:9) = pstart{3}(:,4:9)/expT; % Gaussian param.
    end
    if perPix
        str_units = cat(2,str_units,' pix-1');
        pstart{3}(:,4:9) = pstart{3}(:,4:9)/nPix;
    end
else
    str_units = '';
end

meth = pstart{1}(1);
boba = pstart{1}(2);
if boba
    nRpl = pstart{1}(3);
    nSpl = pstart{1}(4);
end
w = pstart{1}(5);
if w
    str_w = 'yes';
else
    str_w = 'no';
end

defname = p.proj{proj}.exp_parameters{1,2};
if isempty(defname)
    [o,defname,o] = fileparts(p.proj{proj}.proj_file);
end
defname = cat(2,setCorrectPath('histogram_analysis',h_fig),defname,'_',...
    str_tpe);
[fname,pname,o] = uiputfile({'*.txt', 'Text files(*.txt)'; '*.*', ...
    'All files(*.*)'},'Export analysis',defname);

if ~sum(fname)
    return;
end

% display action
setContPan('Exporting results from histogram analysis...','process',h_fig);

expfig = 0;

[o,name,o] = fileparts(fname);

P = pplot{2};

str_action = '';

% export histogram
if ~isempty(P)
    if isInt
        if perSec
            P(:,1) = P(:,1)/expT;
        end
        if perPix
            P(:,1) = P(:,1)/nPix;
        end
    end
    
    % build file name
    fname = cat(2,name,'.hist');
    
    % write data to file
    f = fopen(cat(2,pname,fname),'Wt');
    fprintf(f,cat(2,str_tpe,'(',str_units,')\tfrequency count\t',...
        'probability\tcumulative frequency count\t',...
        'cumulative probability\n'));
    fprintf(f,'%d\t%d\t%d\t%d\t%d\n',[P(:,[1,2]),P(:,2)/sum(P(:,2)), ...
        P(:,3),P(:,3)/sum(P(:,2))]');
    fclose(f);
    
    % update action
    str_action = cat(2,str_action,'Histogram written to file: ',fname,...
        '\nin folder: ',pname,'\n');
end

% Export RMSE analysis results
if ~isempty(pres{3,1})
    
    % build file name
    fname = cat(2,name,'_config.txt');
    
    % format file header
    Kmax = pstart{4}(3);
    isBIC = ~pstart{4}(1);
    if isBIC
        [o,Kopt] = min(pres{3,1}(:,2));
        str_meth = 'BIC';
    else
        penalty = pstart{4}(2);
        Kopt = 1;
        for k = 2:Kmax
            if ((pres{3,1}(k,1)-pres{3,1}(Kopt,1))/ ...
                    pres{3,1}(Kopt,1))>(penalty-1)
                Kopt = k;
            end
        end
        str_meth = num2str(penalty);
    end

    str_head = cat(2,...
        'Max. number of Gaussians: ',sprintf('%i',Kmax),'\n',...
        'Penalty: ',str_meth,'\n',...
        'Fitting equations:\n');
    for K = 1:Kmax
        if K>2
            str_head = cat(2,str_head,'- ',sprintf('%i',K),...
                ' Gaussians:\t',getEqGauss(1),' + ... + ',...
                strrep(getEqGauss(1),'1',num2str(K)),'\n');
        else
            str_head = cat(2,str_head,'- ',sprintf('%i',K),...
                ' Gaussians:\t',getEqGauss(K),'\n');
        end
    end
    str_head = cat(2,str_head,'\nOptimum number of Gaussians: ',...
        sprintf('%i',Kopt),'\nBest parameters for all GMM with ',...
        'FWHM = o * 2*sqrt(2*ln(2)):\n',...
        'number of Gaussians\tLog Likelihood\tBIC');
    for k = 1:K
        kstr = num2str(k);
        str_head = cat(2,str_head,'\tA_',kstr,'\tmu_',kstr,'\tFWHM_',kstr,...
            '\t');
    end
    str_head = cat(2,str_head,'\n');
    
    % write data to file
    f = fopen(cat(2,pname,fname),'Wt');
    fprintf(f,str_head);
    for K = 1:Kmax
        if ~isempty(pres{3,2}{K})
            if isInt
                if perSec
                    pres{3,2}{K}(:,[2 3]) = pres{3,2}{K}(:,[2 3])/expT;
                end
                if perPix
                    pres{3,2}{K}(:,[2 3]) = pres{3,2}{K}(:,[2 3])/nPix;
                end
            end

            fprintf(f, cat(2,'%i\t%d\t%d',repmat('\t%d',[1,3*K]), ...
                '\n'),[K pres{3,1}(K,:),reshape(pres{3,2}{K}', ...
                [1,numel(pres{3,2}{K})])]);
        else
            fprintf(f,'%i\tn.a.\n',K);
        end
    end
    fclose(f);
    
    % update action
    str_action = cat(2,str_action,'State configuration written to file: ',...
        fname,'\nin folder: ',pname,'\n');
end

switch meth
            
    case 1 % Gaussian fitting
        
        % Export Gaussian fitting results
        if ~isempty(pres{2,1})
            
            if isInt
                if perSec
                    pres{2,1}(:,3:6) = pres{2,1}(:,3:6)/expT;
                end
                if perPix
                    pres{2,1}(:,3:6) = pres{2,1}(:,3:6)/nPix;
                end
            end
            
            fname = [name '_gauss.txt'];
            f = fopen([pname fname], 'Wt');
            K = size(pstart{3},1);
            str_fit = getEqGauss(K);
            fprintf(f, 'Fitting equation:\n%s\n', str_fit);
            fprintf(f, ['Starting fit parameters with FWHM = o * ' ...
                '2*sqrt(2*ln(2)):\n']);
            for k = 1:K
                fprintf(f, ['- Gaussian ' num2str(k) ':\tA_' num2str(k) ...
                    '=%d\tmu_' num2str(k) '=%d\t' 'FWHM_' num2str(k) ...
                    '=%d\n'], pstart{3}(k,2:3:end-2));
            end
            if boba
                if isInt
                    if perSec
                        pres{2,2}(:,[2 3]) = pres{2,2}(:,[2 3])/expT;
                    end
                    if perPix
                        pres{2,2}(:,[2 3]) = pres{2,2}(:,[2 3])/nPix;
                    end
                end
            
                fprintf(f, ['\nBootstraping parameters:\n' ...
                    '- %i samples\n' ...
                    '- %i replicates\n' ...
                    '- weighting: ' str_w], nSpl, nRpl);
                fprintf(f, '\n\nBootstrap mean:');
                fprintf(f, ['\nGaussian\tA\tmu\tFWHM\trelative ' ...
                    'occurence\n']);
                
                for k = 1:K
                    fprintf(f, '%i\t%d\t%d\t%d\t%d\n', k, ...
                        pres{2,1}(k,1:2:end));
                end
                fprintf(f, '\n\nBootstrap standard deviation:\n');
                fprintf(f, ['Gaussian\tA\tmu\tFWHM\trelative ' ...
                    'occurence\n']);
                for k = 1:K
                    fprintf(f, '%i\t%d\t%d\t%d\t%d\n', k, ...
                        pres{2,1}(k,2:2:end));
                end
                fprintf(f, '\n\nBootstrap samples:\n');
                fprintf(f, ['sample' repmat(['\tA_%i\tmu_%i\tFWHM_%i\t' ...
                    'relocc_%i'],[1 K]) '\n'], ...
                    reshape(repmat(1:K,[4,1]),[1,4*K]));
                fprintf(f, ['%i' repmat('\t%d', [1 K*4]) '\n'], ...
                    [(1:size(pres{2,2},1))' pres{2,2}]');
                
                expfig = 1;
                
                if isInt
                    if perSec
                        pres{2,2}(:,[2 3]) = pres{2,2}(:,[2 3])*expT;
                    end
                    if perPix
                        pres{2,2}(:,[2 3]) = pres{2,2}(:,[2 3])*expT;
                    end
                end
                
            else
                fprintf(f, '\n\nFit parameters:\n');
                fprintf(f, ['Gaussian\tA\tmu\tFWHM\trelative ' ...
                    'occurence\n']);
                for k = 1:K
                    fprintf(f, '%i\t%d\t%d\t%d\t%d\n', ...
                        k,pres{2,1}(k,1:2:end));
                end
            end
            fclose(f);
            
            if isInt
                if perSec
                    pres{2,1}(:,3:6) = pres{2,1}(:,3:6)*expT;
                end
                if perPix
                    pres{2,1}(:,3:6) = pres{2,1}(:,3:6)*nPix;
                end
            end
            
            % update action
            str_action = cat(2,str_action,'Gaussian fitting results ',...
                'written to file: ',fname,'\nin folder: ',pname,'\n');
        end

    case 2 % Thresholding
        if ~isempty(pres{1,1})
            fname = [name '_thresh.txt'];
            f = fopen([pname fname], 'Wt');
            T = numel(pstart{2});
            thresh = [-Inf pstart{2}' Inf];
            fprintf(f, ['Thresholds (' str_tpe '):' repmat('\t%d', ...
                [1 T]) ':\n'], pstart{2}');
            for k = 1:T+1
                fprintf(f, '\n- population %i: from\t%d\tto\t%d', ...
                    [k thresh(k:k+1)]);
            end
            if boba
                fprintf(f, ['\n\nBootstraping parameters:\n' ...
                    '- %i samples\n' ...
                    '- %i replicates\n' ...
                    '- weighting: ' str_w], nSpl, nRpl);
                fprintf(f, ['\n\nBootstrap mean (relative occurences):' ...
                    repmat('\t%d',[1 T+1]) '\n\n'],  pres{1,1}(:,1)');
                fprintf(f, ['Bootstrap standard deviation (relative ' ...
                    'occurences):' repmat('\t%d',[1 T+1]) '\n\n'],  ...
                    pres{1,1}(:,2)');
                fprintf(f, 'Bootstrap samples (relative occurences):\n\n');
                fprintf(f, ['sample\t' repmat('population %i\t', ...
                    [1 T+1]) '\n'], 1:T+1);
                fprintf(f, ['%i\t' repmat('%d\t', [1 T+1]) '\n'], ...
                    [(1:nSpl)' pres{1,2}]');
                
                expfig = 1;
                
            else
                fprintf(f, ['Relative occurences:' repmat('\t%d', ...
                    [1 T+1])],  pres{1,1}(:,1)');
            end
            fclose(f);
            
            % update action
            str_action = cat(2,str_action,'Thresholding results ',...
                'written to file: ',fname,'\nin folder: ',pname,'\n');
        end
end

if expfig
    
    err = loading_bar('init', h_fig, ceil(nSpl/3), ['Build *.pdf figures of ' ...
        'bootstrapped histograms ...']);
    if err
        return;
    end
    h = guidata(h_fig);
    h.barData.prev_var = h.barData.curr_var;
    guidata(h_fig, h);
    
    units_0 = get(0, 'Units');
    set(0, 'Units', 'pixels');
    pos_0 = get(0, 'ScreenSize');
    set(0, 'Units', units_0);
    hFig = pos_0(4); % A4 format
    wFig = hFig*21/29.7;
    xFig = (pos_0(3) - wFig)/2;
    yFig = (pos_0(4) - hFig)/2;
    h_fig_mol = figure('Visible', 'off', 'Units', 'pixels', ...
        'Position',[xFig yFig wFig hFig], 'Color', [1 1 1], ...
        'Name','Preview','NumberTitle', 'off', 'MenuBar', ...
        'none','PaperOrientation','portrait', 'PaperType', ...
        'A4','PaperPositionMode','auto');
    posFig = get(h_fig_mol, 'Position');
    wFig = posFig(3);
    hFig = posFig(4);
    fntSize = 10.66666;
    mg = 10;
    
    hMol = hFig/4;
    h_axes = hMol-3*mg;
    w_full = wFig/3;
    w_axes = w_full-mg;

    start{1}(1) = meth;
    start{2} = pstart{2};
    clr = p.colList;

    switch meth
        case 1 % Gaussian fit
            P = pres{2,3};
        case 2 % Thresholding
            P = pres{1,3};
    end
    
    x_axis = P(:,1);
    lim = pplot{1}(2:3);
    
    K = size(pstart{3},1);
    pres_s = pres;
    s_end = 12;
    yNext = hFig - hMol - mg;
    
    if isInt
        intUnits{1,1} = perSec;
        intUnits{1,2} = expT;
        intUnits{2,1} = perPix;
        intUnits{2,2} = nPix;
    else
        intUnits = [];
    end
    
    isdriver = true;
    
    nfig = 1;
    fname_fig = {};
    pname_fig_temp = cat(2,pname,'temp');
    if ~exist(pname_fig_temp,'dir')
        mkdir(pname_fig_temp);
    end
    s_prev = 1;

    for s = 1:3:nSpl
        xNext = mg;
        for curr_s = s:s+2
            if curr_s>nSpl
                break;
            end
            xNext = xNext + double(s~=curr_s)*w_full;

            a = axes('Parent',h_fig_mol,'Units','pixels','FontUnits',...
                'pixels','FontSize',fntSize,'ActivePositionProperty', ...
                'OuterPosition');
            P_s = [x_axis P(:,curr_s+1)];
            if meth==1
                pres_s{2,1}(:,1:2:end) = reshape(pres{2,2}(curr_s,:),4,K)';
            end
            plotHist(a, P_s, lim, start, pres_s, clr, boba, intUnits, ...
                h_fig);
            set([get(a,'XLabel') get(a,'YLabel')],'String',[]);
            title(a, ['sample n:°' num2str(curr_s)]);

            pos = getRealPosAxes([xNext yNext w_axes h_axes], ...
                get(a,'TightInset'),'traces');
            set(a, 'Position', pos);
        end
        
        yNext = yNext - hMol;
        
        if curr_s==s_end || curr_s==nSpl
            if isdriver
                try
                    if meth==1
                        fname_fig{nfig} = cat(2,pname_fig_temp,filesep, ...
                            name,'_gauss_sample',num2str(s_prev),'-', ...
                            num2str(curr_s),'of',num2str(nSpl),'.pdf');
                    else
                        fname_fig{nfig} = cat(2,pname_fig_temp,filesep, ...
                            name,'_thresh_sample',num2str(s_prev),'-', ...
                            num2str(curr_s),'of',num2str(nSpl),'.pdf');
                    end
                    
                    print(h_fig_mol,fname_fig{nfig},'-dpdf');
                    nfig = nfig + 1;
                    s_prev = curr_s + 1;
                    
                catch err
                    if strcmp(err.identifier,'ps2pdf:ghostscriptCommand')
                        isdriver = true;
                        setContPan(['Can not find Ghostscript installed ' ...
                            'with MATLAB: Figure were exported to *.png ' ...
                            'files.'],'process',h.figure_MASH);
                        print(h_fig_mol, [pname,name,'samples_', ...
                            num2str(s_end-11),'_to_',num2str(s_end), ...
                            '.png'],'-dpng');
                    else
                        throw(err);
                    end
                end
                
            else
                print(h_fig_mol, [pname,name,'samples_', ...
                    num2str(s_end-11),'_to_',num2str(s_end),'.png'], ...
                    '-dpng');
            end
            
            delete(h_fig_mol);
            s_end = s_end + 12;
            if curr_s<nSpl
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
    
    if isdriver
        if meth==1
            fname_pdf = cat(2,name,'_gauss.pdf');
        else
            fname_pdf = cat(2,name,'_thresh.pdf');
        end
        append_pdfs(cat(2,pname,fname_pdf),fname_fig{:});
        flist = dir(pname_fig_temp);
        for i = 1:size(flist,1)
            if ~(strcmp(flist(i).name,'.') || strcmp(flist(i).name,'..')) 
                delete(cat(2,pname_fig_temp,filesep,flist(i).name));
            end
        end
        rmdir(pname_fig_temp);
        
        % update action
        str_action = cat(2,str_action,'Sample figures written to file ',...
            fname_pdf,'\nin folder: ',pname,'\n');
    end
end

loading_bar('close', h_fig);

if ~isempty(str_action)
    setContPan(str_action,'success',h_fig);
end

