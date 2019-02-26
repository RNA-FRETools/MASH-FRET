function saveTDP(h_fig)
% Export files from Transition analysis

% Last update: the 25th of February 2019 by Mélodie Hadzic
% --> adapt to the new clustering result structure
% update: The 23rd of February 2019 by Mélodie Hadzic
% --> remove option to export readjusted data (no use)
% --> update action display

setContPan('Export transition analysis data ...', 'process', h_fig);

%% collect parameters

% general parameters
h = guidata(h_fig);
p = h.param.TDP;
proj = p.curr_proj;
q = p.proj{proj}.exp;
str_tpe = get(h.popupmenu_TDPdataType, 'String');
nTpe = size(str_tpe,1);

% export parameters for TDP
TDPascii = q{2}(1);
TDPimg = q{2}(2);
TDPascii_fmt = q{2}(3);
TDPimg_fmt = q{2}(4);
TDPclust = q{2}(5);

% export parameters for kinetic analysis
kinDtHist = q{3}(1);
kinFit = q{3}(2);
kinBoba = q{3}(3);

if ~(TDPascii || TDPimg || TDPclust || kinDtHist || kinFit || kinBoba)
    setContPan('There is no data to export.', 'warning', h_fig);
    return;
end

% build file name
[o,fname_proj,o] = fileparts(p.proj{proj}.proj_file);

defName = [setCorrectPath('tdp_analysis', h_fig) fname_proj];
[fname, pname] = uiputfile({ ...
    '*.tdp;*.txt;*.hdt;*.fit','TDP analysis files'; ...
    '*.txt;*.dt;*.hd','Trace processing files'; ...
    '*.pdf;*.png;*.jpeg','Figure files'; ...
    '*.*','All Files (*.*)'}, 'Export data', defName);

if ~sum(fname)
    return;
end

fname = getCorrName(fname, [], h_fig);
[o,name,o] = fileparts(fname);

str_act = '';

%% Export TDP

tdp_mat = TDPascii & (TDPascii_fmt==1 | TDPascii_fmt==4);
tdp_conv = TDPascii & (TDPascii_fmt==2 | TDPascii_fmt==4);
tdp_coord = TDPascii & (TDPascii_fmt==3 | TDPascii_fmt==4);
tdp_png = TDPimg & (TDPimg_fmt==1 | TDPimg_fmt==3);
tdp_png_conv = TDPimg & (TDPimg_fmt==2 | TDPimg_fmt==3);
bol_tdp = [tdp_mat tdp_conv tdp_coord tdp_png tdp_png_conv TDPclust];

if sum(bol_tdp)
    
    setContPan('Export TDP and clustering results ...', 'process', h_fig);

    pname_tdp = setCorrectPath([pname 'clustering'], h_fig);

    for t = 1:nTpe
        prm = p.proj{proj}.prm{t};
        if isempty(prm.plot{2})
            disp(['no TDP built for data: ' str_tpe{t}]);
        else
            str_act = cat(2,str_act,...
                save_tdpDat(str_tpe{t},prm,pname_tdp,name,bol_tdp,h_fig));
        end
    end
end


%% Export kinetic files

bol_kin = [kinDtHist kinFit kinBoba];

if sum(bol_kin)
    setContPan('Export kinetic results ...', 'process', h_fig);
    
    pname_kin = setCorrectPath([pname 'kinetics'], h_fig);
    
    % export dwell-time histogram files & fitting results (if)
    for t = 1:nTpe
        prm = p.proj{proj}.prm{t};
        J = prm.clst_res{3};
        if J == 0
            disp(['no clustering for data:' str_tpe{t}]);
        end
        j = 0;
        for j1 = 1:J
            for j2 = 1:J
                if j1 ~= j2
                    j = j+1;
                    if isempty(prm.clst_res{4})
                        str_act = cat(2,str_act,'No dwell-time histogram',...
                            'for data:',str_tpe{t},'\n');
                        disp(cat(2,'No dwell-time histogram for data:',...
                            str_tpe{t}));
                        break;

                    elseif ~(size(prm.clst_res{4},2)>=j && ...
                            ~isempty(prm.clst_res{4}{j}))
                        
                        % update action
                        states = round(100*prm.clst_res{1}.mu{J}([j1,j2],...
                            1))/100;
                        str = strcat(num2str(states(1)),' to '...
                            ,num2str(states(2)));
                        str_act = cat(2,str_act,'No dwell-time histogram',...
                            'for data:',str_tpe{t},', transition: ',str,...
                            '\n');
                        disp(cat(2,'No dwell-time histogram for data:',...
                            str_tpe{t},', transition: ',str));

                    else
                        states = round(100*prm.clst_res{1}.mu{J}([j1,j2],...
                            1))/100;
                        str = strcat(num2str(states(1)), ' to ', ...
                            num2str(states(2)));
                        str_act = cat(2,str_act,...
                            save_kinDat(bol_kin,prm,j,str_tpe{t},str, ...
                            pname_kin,[name '_' str_tpe{t}],h_fig));
                    end
                end
            end
        end
    end

end

str_act = str_act(1:end-2); % remove last '\n'
setContPan(cat(2,'Data successfully exported:\n',str_act),'success',h_fig);


function str_act = save_tdpDat(str, prm, pname, name, bol, h_fig)
% Save transition density plot to ASCII files and image files.
% Save transition clustering results to ASCII files
% Return actions to display

% Last update: the 25th of February 2019 by Mélodie Hadzic
% --> adapt to the new clustering result structure
% update: the 23rd of February 2019 by Mélodie Hadzic
% --> control file names with function /divers/overwriteIt
% --> return action string

str_act = '';

tdp_mat = bol(1);
tdp_conv = bol(2);
tdp_coord = bol(3);
tdp_png = bol(4);
tdp_png_conv = bol(5);
tdp_clust = bol(6);

TDP = prm.plot{2};

str_tdp = cat(2,'parameters:\n', ...
    '\tone transition count per molecule: %s\n', ...
    '\tx-axis: value before transition (m)\n', ...
    '\ty-axis: value after transition (m*)\n', ...
    '\tz-axis: occurence of transition amp(m,m*)\n', ...
    '\tx-lim: [%d,%d], x bin: %d\n', ...
    '\ty-lim: [%d,%d], y bin: %d');

if prm.plot{1}(4,1)
    onecount = 'yes';
else
    onecount = 'no';
end
        
str_tdp = sprintf(str_tdp, onecount, prm.plot{1}(1,2:3)', ...
    prm.plot{1}(1,1), prm.plot{1}(2,2:3)', prm.plot{1}(2,1));

if tdp_mat% save TDP matrix
    
    % build file name
    fname_mat = strcat(name, '_', str, '.tdp');
    fname_mat = getCorrName(fname_mat, [], h_fig);
    if sum(fname_mat)
        fname_mat = overwriteIt(fname_mat,pname,h_fig);
        
        % write data to file
        Nx = size(TDP,2);
        f = fopen([pname fname_mat], 'Wt');
        fprintf(f, [str_tdp '\n\n']);
        fprintf(f, [repmat('%d\t',[1,Nx]) '\n'], TDP');
        fclose(f);
        
        % update action
        str_act = cat(2,str_act,'TDP matrix saved to ASCII file: ',...
            fname_mat,' in folder: ',pname, '\n');
        
    else
        % update action
        str_act = cat(2,str_act,'ERROR: TDP matrix not saved to ASCII ',...
            'file because of invalid file name ', fname_mat, '\n');
        disp(cat(2,'Invalid file name: ',fname_mat));
    end
end

if tdp_conv % save gaussian convolution TDP matrix
    
    % build file name
    fname_mat_conv = strcat(name, '_', str,'_gconv.tdp');
    fname_mat_conv = getCorrName(fname_mat_conv, [], h_fig);
    if sum(fname_mat_conv)
        fname_mat_conv = overwriteIt(fname_mat_conv,pname,h_fig);
        
        % calculate data
        lim = prm.plot{1}([1 2],[2 3]);
        TDP_conv = convGauss(TDP, 0.0005, lim);
        Nx = size(TDP_conv,2);
        
        % write data to file
        f = fopen([pname fname_mat_conv], 'Wt');
        fprintf(f, [str_tdp '\n\n']);
        fprintf(f, [repmat('%d\t',[1,Nx]) '\n'], TDP_conv');
        fclose(f);
        
        % update action
        str_act = cat(2,str_act,'Gaussian-convolved TDP matrix saved to ',...
            'ASCII file: ',fname_mat_conv,' in folder: ',pname, '\n');
        
    else
        % update action
        str_act = cat(2,str_act,'ERROR: Gaussian-convolved TDP matrix not',...
            ' saved to ASCII file because of invalid file name ', ...
            fname_mat_conv, '\n');
        disp(cat(2,'Invalid file name: ',fname_mat_conv));
    end
end

if tdp_coord % save TDP coordinates
    
    % build file name
    fname_coord = strcat(name, '_', str, '_coord.txt');
    fname_coord = getCorrName(fname_coord, [], h_fig);
    if sum(fname_coord)
        fname_coord = overwriteIt(fname_coord,pname,h_fig);
        
        % format data
        bins = prm.plot{1}([1 2],1);
        lim = prm.plot{1}([1 2],[2 3]);
        iv_x = (lim(1,1):bins(1):lim(1,2));
        iv_x = mean([iv_x(1:end-1);iv_x(2:end)],1);
        iv_y = (lim(2,1):bins(2):lim(2,2));
        iv_y = mean([iv_y(1:end-1);iv_y(2:end)],1);
        [x,y] = meshgrid(iv_x,iv_y);
        x = x(:); y = y(:);
        z = reshape(TDP,[numel(TDP) 1]);
        coord = [x y z]';
        
        % write data to file
        f = fopen([pname fname_coord], 'Wt');
        fprintf(f, [str_tdp '\n\n']);
        fprintf(f, 'before trans.\tafter trans.\toccurence\n');
        fprintf(f, '%d\t%d\t%d\n', coord);
        fclose(f);
        
        % update action
        str_act = cat(2,str_act,'TDP coordinates saved to ASCII file: ',...
            fname_coord,' in folder: ',pname, '\n');
        
    else
        % update action
        str_act = cat(2,str_act,'ERROR: TDP coordinates not saved to ASCII',...
            ' file because of invalid file name ', fname_coord, '\n');
        disp(cat(2,'Invalid file name: ',fname_coord));
    end
end

if tdp_png
    
    % build file name
    fname_png = strcat(name, '_', str, '.png');
    fname_png = getCorrName(fname_png, [], h_fig);
    if sum(fname_png)
        fname_png = overwriteIt(fname_png,pname,h_fig);
        
        % format data
        maxI = max(max(TDP)); minI = min(min(TDP));
        TDP_8bit = uint8(255*(TDP-minI)/(maxI-minI));
        
        % write data to file
        imwrite(flip(TDP_8bit,1), [pname fname_png], 'png', 'bitdepth', 8);

        % update action
        str_act = cat(2,str_act,'TDP saved to image file: ',...
            fname_png,' in folder: ',pname, '\n');
        
    else
        % update action
        str_act = cat(2,str_act,'ERROR: TDP not saved to image file ',...
            'because of invalid file name ', fname_png, '\n');
        disp(cat(2,'Invalid file name: ',fname_png));
    end
end

if tdp_png_conv
    
    % build file name
    fname_png_cv = strcat(name, '_', str, '_gconv.png');
    fname_png_cv = getCorrName(fname_png_cv, [], h_fig);
    if sum(fname_png_cv)
        fname_png_cv = overwriteIt(fname_png_cv,pname,h_fig);
        
        % format data
        lim = prm.plot{1}([1 2],[2 3]);
        TDP_conv = convGauss(TDP, 0.0005, lim);
        maxI = max(max(TDP_conv)); minI = min(min(TDP_conv));
        TDP_8bit_conv = uint8(255*(TDP_conv-minI)/(maxI-minI));
        
        % write data to file
        imwrite(flip(TDP_8bit_conv,1), [pname fname_png_cv], 'png', ...
            'bitdepth', 8);
        
        % update action
        str_act = cat(2,str_act,'Gaussian-convolved TDP saved to image ',...
            'file: ',fname_png_cv,' in folder: ',pname,'\n');
        
    else
        % update action
        str_act = cat(2,str_act,'ERROR: Gaussian-convlved TDP not saved ',...
            'to image file because of invalid file name ',fname_png_cv,...
            '\n');
        disp(cat(2,'Invalid file name: ',fname_png_cv));
    end
end

isClst = ~isempty(prm.clst_res{1});
if isClst && tdp_clust
    
    % build file name
    fname_clust = strcat(name, '_', str, '.clst');
    fname_clust = getCorrName(fname_clust, [], h_fig);
    if sum(fname_clust)
        fname_clust = overwriteIt(fname_clust,pname,h_fig);
        
        % format data
        meth = prm.clst_start{1}(1);
        switch meth
            case 1 % kmean
                str_prm = cat(2,'starting parameters:\n', ...
                    '\tmethod: j-mean clustering\n', ...
                    '\tnumber of max. states: %i\n');
                Jmax = prm.clst_start{1}(3);
                for j = 1:Jmax
                    str_prm = strcat(str_prm, sprintf('\tstate %i:', j), ...
                        '%d, tolerance radius: %d\n');
                end
                str_prm = strcat(str_prm, ...
                    '\tmax. number of j-mean iterations: %i\n');
                if prm.clst_start{1}(6)
                    str_prm = strcat(str_prm, '\tbootstrapping: yes\n', ...
                        '\t\tnumber of samples: ', ...
                        num2str(prm.clst_start{1}(7)), ...
                        '\t\tnumber of replicates: ', ...
                        num2str(prm.clst_start{1}(8)));
                else
                    str_prm = strcat(str_prm, '\tbootstrapping: no\n');
                end
                str_prm = strcat(str_prm, '\nclustering results:\n', ...
                    '\tnumber of states in model: %i\n');
                J = prm.clst_res{3};
                for j = 1:J
                    str_prm = strcat(str_prm, sprintf('\tstate %i:', j), ...
                        '%d, time fraction: %d\n');
                end
                str_prm = sprintf(str_prm, Jmax, prm.clst_start{2}', ...
                    prm.clst_start{1}(5), J, [prm.clst_res{1}.mu{J} ...
                    prm.clst_res{1}.fract{J}]');

            case 2 % GM
                
                h = guidata(h_fig);
                str_pop = get(h.popupmenu_TDPstate,'String');
                shape = str_pop{prm.clst_start{1}(2)};
                
                Jmax = prm.clst_start{1}(3);
                
                str_prm = cat(2,'starting parameters:\n', ...
                    ['\tmethod: 2D Gaussian mixture model-based ' ...
                    'clustering\n'], ...
                    ['\tcluster shape: ' shape '\n'], ...
                    ['\tmax. number of states: ' sprintf('%i',Jmax) '\n']);
                
                if prm.clst_start{1}(6)
                    str_prm = strcat(str_prm, '\tbootstrapping: yes\n', ...
                        ['\t\tnumber of samples: ' ...
                        sprintf('%i',prm.clst_start{1}(7)) '\n'], ...
                        ['\t\tnumber of replicates: ' ...
                        sprintf('%i',prm.clst_start{1}(8)) '\n']);
                else
                    str_prm = strcat(str_prm, '\tbootstrapping: no\n');
                end
                
                str_prm = strcat(str_prm, ...
                    ['\tnumber of model initialisations: ' ...
                    sprintf('%i',prm.clst_start{1}(5)) '\n']);
                
                J = prm.clst_res{3};
                str_prm = strcat(str_prm, ['\nclustering results:\n' ...
                    '\tnumber of states in model: ' sprintf('%i',J) ...
                    ' (BIC=' sprintf('%d',prm.clst_res{1}.BIC(J)) ')\n']);
                
                if prm.clst_start{1}(6)
                    str_prm = strcat(str_prm, ['\tbootstrapped number ' ...
                        'of states: ' ...
                        sprintf('%2.2f',prm.clst_res{2}(1)) ' +/- ', ...
                        sprintf('%2.2f',prm.clst_res{2}(2)) '\n']);
                end
                
                for j = 1:J
                    str_prm = strcat(str_prm, ...
                        [sprintf('\tstate %i:\t%d',j, ...
                        prm.clst_res{1}.mu{J}(j,1)) '\ttime fraction:\t' ...
                        sprintf('%d',prm.clst_res{1}.fract{J}(j,1)) '\n']);
                end
                
                str_prm = strcat(str_prm, ...
                    '\toptimum model parameters:\n');
                
                j = 0;
                for j1 = 1:J
                    for j2 = 1:J
                        j = j+1;
                        str_prm = strcat(str_prm,'\t\t', ...
                           sprintf('alpha_%i%i',j1,j2),'\t',...
                            sprintf('%d',prm.clst_res{1}.a{J}(j)),'\n');
                    end
                end
                
                j = 0;
                for j1 = 1:J
                    for j2 = 1:J
                        j = j+1;
                        str_prm = strcat(str_prm, ['\t\t' ...
                            sprintf('sigma_%i%i',j1,j2) '\t' ...
                            sprintf('%d\t%d', ...
                            prm.clst_res{1}.o{J}(1,:,j)) ...
                            '\n\t\t\t' sprintf('%d\t%d', ...
                            prm.clst_res{1}.o{J}(2,:,j)) '\n']);
                    end
                end
        end
        
        % write data to file
        f = fopen([pname fname_clust], 'Wt');
        fprintf(f, strcat(str_prm,'\n\n'));
        fprintf(f, ['dwell-times(s)\tm\tm*\tmolecule\tx(m)\ty(m*)\ts_i' ...
            '\ts_j\n']);
        fprintf(f, '%d\t%d\t%d\t%i\t%i\t%i\t%i\t%i\n', ...
            prm.clst_res{1}.clusters{J}');
        fclose(f);

        % update action
        str_act = cat(2,str_act,'Clustering results saved to ASCII file: ',...
            fname_clust,' in folder: ',pname,'\n');
        
    else
        % update action
        str_act = cat(2,str_act,'ERROR: Clustering results not saved to ',...
            'ASCII file because of invalid file name ',fname_clust,'\n');
        disp(cat(2,'Invalid file name: ',fname_clust));
    end
else
    disp(cat(2,'no clustering for data: ',str));
end


function str_act = save_kinDat(bol, prm, j, str1, str2, pname, name, h_fig)
% Save dwell time histograms and fitting results to ASCII files.
% Return actions to display

% Last update: the 23rd of February 2019 by Mélodie Hadzic
% --> control file names with function /divers/overwriteIt
% --> return action string

str_act = '';

kinDtHist = bol(1);
kinFit = bol(2);
kinBoba = bol(3);

% dwell-time histograms
if kinDtHist
    
    % build file name
    fname_hdt = strcat(name,'_',str2,'.hdt');
    fname_hdt = getCorrName(fname_hdt, [], h_fig);
    if sum(fname_hdt)
        fname_hdt = overwriteIt(fname_hdt,pname,h_fig);
        
        % collect data
        dt_hist = prm.clst_res{4}{j};
        
        % write data to file
        f = fopen([pname fname_hdt], 'Wt');
        fprintf(f, ['dwell-times(s)\tcount\tnorm. count\tcum. count\t' ...
            'compl. norm. count\n']);
        fprintf(f, '%d\t%d\t%d\t%d\t%d\n', dt_hist');
        fclose(f);
        
        % update action
        str_act = cat(2,str_act,'Dwell time histograms saved to ASCII ',...
            'file: ',fname_hdt,' in folder: ',pname,'\n');
        
    else
        % update action
        str_act = cat(2,str_act,'ERROR: Dwell time histograms not saved ',...
            'to ASCII file because of invalid file name ',fname_hdt,'\n');
        disp(cat(2,'Invalid file name: ',fname_hdt));
    end
end

% fitting parameters and results
if kinFit
    
    % build file name
    fname_fit = strcat(name,'_',str2,'.fit');
    fname_fit = getCorrName(fname_fit, [], h_fig);
    if sum(fname_fit)
        fname_fit = overwriteIt(fname_fit,pname,h_fig);
        
        % format data
        isFit = size(prm.kin_res,1)>=j & ~isempty(prm.kin_res{j,2});
        if isFit
            kin_start = prm.kin_start(j,:);
            kin_res = prm.kin_res(j,:);
            
            nExp = kin_start{1}(2);
            strch = kin_start{1}(1);
            boba = kin_start{1}(4) & kinBoba;
            [str_eq o] = getEqExp(strch, nExp);
            str_prm = cat(2,'equation: %s\n', ...
                'starting parameters:\n', ...
                '\tparameter\tlower\tstart\tupper\n');
            if strch
                str_prm = strcat(str_prm, ...
                    '\ta:\t%d\t%d\t%d\n', ...
                    '\tb(s):\t%d\t%d\t%d\n', ...
                    '\tc:\t%d\t%d\t%d\n');
            else
                for n = 1:nExp
                    str_prm = strcat(str_prm, ...
                        '\ta_', num2str(n),':\t%d\t%d\t%d\n', ...
                        '\tb_', num2str(n),'(s):\t%d\t%d\t%d\n');
                end
            end

            if boba
                str_prm = strcat(str_prm, 'bootstrap parameters:\n', ...
                    '\tweighting: %s\n', ...
                    '\tnumber of samples: %i\n', ...
                    '\tnumber of replicates: %i\n');
            end

            str_prm = strcat(str_prm, 'fitting results (reference):\n');
            if strch
                str_prm = strcat(str_prm, ...
                    '\ta:\t%d\n', ...
                    '\tb(s):\t%d\n', ...
                    '\tc:\t%d\n');
            else
                for n = 1:nExp
                    str_prm = strcat(str_prm, ...
                        '\ta_', num2str(n),':\t%d\n', ...
                        '\tb_', num2str(n),'(s):\t%d\n');
                end
            end

            if boba
                str_prm = strcat(str_prm, ...
                    'fitting results (bootstrap):\n', ...
                    '\tparameter\tmean\tsigma\n');

                if strch
                    str_prm = strcat(str_prm, ...
                        '\ta:\t%d\t%d\n', ...
                        '\tb(s):\t%d\t%d\n', ...
                        '\tc:\t%d\t%d\n');
                else
                    for n = 1:nExp
                        str_prm = strcat(str_prm, ...
                            '\ta_', num2str(n),':\t%d\t%d\n', ...
                            '\tb_', num2str(n),'(s):\t%d\t%d\n');
                    end
                end
            end

            if strch
                fit_prm = kin_start{2}(1,:);
                fit_res_ref = kin_res{2}(1,:);
                if boba
                    fit_res_boba = kin_res{1}(1,:);
                end

            elseif ~strch
                fit_prm = reshape(kin_start{2}(1:nExp,1:6)', [1 nExp*2*3]);
                fit_res_ref = reshape(kin_res{2}(1:nExp,1:2)', [1 nExp*2]);
                if boba
                    fit_res_boba = reshape(kin_res{1}(1:nExp,1:4)', ...
                        [1 nExp*4]);
                end
            end

            if boba
                rpl = kin_start{1}(5);
                spl = kin_start{1}(6);
                wght = kin_start{1}(7);
                if wght
                    str_w = 'yes';
                else
                    str_w = 'no';
                end
                str_prm = sprintf(str_prm, str_eq, fit_prm, str_w, spl, ...
                    rpl, fit_res_ref, fit_res_boba);
            else
                str_prm = sprintf(str_prm, str_eq, fit_prm, ...
                    fit_res_ref);
            end
            
            % write data to file
            f = fopen([pname fname_fit], 'Wt');
            fprintf(f, [str_prm '\n\n']);
            fclose(f);
            
            % update action
            str_act = cat(2,str_act,'Fitting results saved to ASCII file:',...
                ' ',fname_fit,' in folder: ',pname,'\n');
        else
            str_act = cat(2,str_act,'No fitting results for data: ',str1,...
                ', transition: ',str2,'\n');
            disp(cat(2,'No fitting results for data:',str1,...
                ', transition: ',str2));
        end
        
    else
        % update action
        str_act = cat(2,str_act,'ERROR: Fitting results not saved ',...
            'to ASCII file because of invalid file name ',fname_fit,'\n');
        disp(cat(2,'Invalid file name: ',fname_fit));
    end
end





