function saveTDP(h_fig)

%% collect parameters

setContPan('Collecting parameters ...', 'process', h_fig);

% general parameters
h = guidata(h_fig);
p = h.param.TDP;
proj = p.curr_proj;
isMov = p.proj{proj}.is_movie;
isCoord = p.proj{proj}.is_coord;
nChan = p.proj{proj}.nb_channel;
nExc = p.proj{proj}.nb_excitations;
FRET = p.proj{proj}.FRET;
S = p.proj{proj}.S;
nFRET = size(FRET,1);
nS = size(S,1);

q = p.proj{proj}.exp;
str_tpe = get(h.popupmenu_TDPdataType, 'String');
nTpe = size(str_tpe,1);
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

%% Export adjusted data

q{1}{1}(1) = 0; % remove function(bugged)
q{1}{1}(2) = 0; % remove function(bugged)
q{1}{1}(4) = 0; % remove function(bugged)

if q{1}{1}(1) || q{1}{1}(2) || q{1}{1}(4)
    p.proj{proj}.adj = get_adjDiscr(p.proj{proj}, str_tpe);
    h.param.TDP = p;
    guidata(h_fig, h);

    % export param. for trace files
    xp.traces{1}(1) = q{1}{1}(1); % export traces file
    xp.traces{1}(2) = q{1}{1}(1); % export format (ASCII)
    xp.traces{2}(1) = q{1}{1}(1); % export intensities
    xp.traces{2}(2) = double(nFRET>0); % export FRET
    xp.traces{2}(3) = double(nS>0); % export S
    xp.traces{2}(4) = double(nChan>1 | nS>0 | nFRET>0); % all in one file
    xp.traces{2}(5) = 0; % parameters (in external file)

    % histogram files
    xp.hist{1}(1) = q{1}{1}(3); % export histogram files
    xp.hist{1}(2) = q{1}{1}(3); % include discretised
     % export intensities & min& binning & max 
    xp.hist{2}(1,1:4) = [q{1}{1}(3) q{1}{2}(1,:)];
    % export FRET & min & binning & max
    xp.hist{2}(2,1:4) = [double(q{1}{1}(3)&nFRET>0) q{1}{2}(2,:)]; 
    % export S & min & binning & max
    xp.hist{2}(3,1:4) = [double(q{1}{1}(3)&nS>0) q{1}{2}(3,:)];

    % dwell-time files
    isdtI = 0; isdtFRET = 0; isdtS = 0;
    tpe = 0;
    for i_l = 1:nExc
        for i_c = 1:nChan
            tpe = tpe + 1;
            if ~isempty(p.proj{proj}.prm{tpe}.plot{3})
                isdtI = 1;
                break;
            end
        end
    end
    for i_fret = 1:nFRET
        tpe = tpe + 1;
        if ~isempty(p.proj{proj}.prm{tpe}.plot{3})
            isdtFRET = 1;
            break;
        end
    end
    for i_s = 1:nS
        tpe = tpe + 1;
        if ~isempty(p.proj{proj}.prm{tpe}.plot{3})
            isdtS = 1;
            break;
        end
    end

    xp.dt{1} = q{1}{1}(2); % export dwell-time files
    xp.dt{2}(1) = double(q{1}{1}(2)&isdtI); % export intensities
    xp.dt{2}(2) = double(q{1}{1}(2)&isdtFRET); % export FRET
    xp.dt{2}(3) = double(q{1}{1}(2)&isdtS); % export S
    xp.dt{2}(4) = 0; % export kinetic file

    % figures
    % export figures
    xp.fig{1}(1) = double(q{1}{1}(4));
    xp.fig{1}(2) = q{1}{3}(1); % format (*.pdf)
    xp.fig{1}(3) = q{1}{3}(2); % number of molecule per figure
    xp.fig{1}(4) = double(q{1}{3}(3)&isMov&isCoord); % include subimages
    xp.fig{1}(5) = q{1}{4}(6); % include histograms
    xp.fig{1}(6) = q{1}{4}(7); % include discretised traces
    % include top axes & exc & channel (current plot)
    xp.fig{2}{1} = q{1}{4}([1 3 4]); 
    % include bottom axes & channel (current plot)
    xp.fig{2}{2} = [double(q{1}{4}(2)&(nFRET+nS)>0) q{1}{4}(5)];

    pname_adj = setCorrectPath([pname 'adjusted_data'], h_fig);

    setContPan('Export adjusted data ...', 'process', h_fig);

    saveProcAscii(h_fig, p, xp, [pname_adj filesep], name);
end


%% Export TDP
setContPan('Export TDP and clustering results ...', 'process', h_fig);

tdp_mat = TDPascii & (TDPascii_fmt==1 | TDPascii_fmt==4);
tdp_conv = TDPascii & (TDPascii_fmt==2 | TDPascii_fmt==4);
tdp_coord = TDPascii & (TDPascii_fmt==3 | TDPascii_fmt==4);
tdp_png = TDPimg & (TDPimg_fmt==1 | TDPimg_fmt==3);
tdp_png_conv = TDPimg & (TDPimg_fmt==2 | TDPimg_fmt==3);
bol = [tdp_mat tdp_conv tdp_coord tdp_png tdp_png_conv TDPclust];

pname_tdp = setCorrectPath([pname 'clustering'], h_fig);

for t = 1:nTpe
    prm = p.proj{proj}.prm{t};
    if isempty(prm.plot{2})
        disp(['no TDP built for data: ' str_tpe{t}]);
    else
        save_tdpDat(str_tpe{t}, prm, pname_tdp, name, bol, h_fig);
    end
end


%% Export kinetic files
setContPan('Export kinetic results ...', 'process', h_fig);

pname_kin = setCorrectPath([pname 'kinetics'], h_fig);
bol = [kinDtHist kinFit kinBoba];

% export dwell-time histogram files & fitting results (if)
for t = 1:nTpe
    prm = p.proj{proj}.prm{t};
    K = size(prm.clst_res{1},1);
    if K == 0
        disp(['no clustering for data:' str_tpe{t}]);
    end
    k = 0;
    for k1 = 1:K
        for k2 = 1:K
            if k1 ~= k2
                k = k+1;
                if isempty(prm.clst_res{4})
                    disp(['no dwell-time histogram for data:' str_tpe{t}]);
                    break;

                elseif ~(size(prm.clst_res{4},2)>=k && ...
                        ~isempty(prm.clst_res{4}{k}))
                    states = ...
                        round(100*prm.clst_res{1}([k1 k2],1))/100;
                    str = strcat(num2str(states(1)), ' to ', ...
                        num2str(states(2)));
                    disp(['no dwell-time histogram for data:' ...
                        str_tpe{t} ', transition: ' str]);

                else
                    states = round(100*prm.clst_res{1}([k1 k2],1))/100;
                    str = strcat(num2str(states(1)), ' to ', ...
                        num2str(states(2)));
                    save_kinDat(bol, prm, k, str_tpe{t}, str, ...
                        pname_kin, [name '_' str_tpe{t}], h_fig);
                end
            end
        end
    end
end

setContPan(['Data "' name '" have been successfully created in the ' ...
    'folder: ' pname], 'success', h_fig);


function save_tdpDat(str, prm, pname, name, bol, h_fig)
tdp_mat = bol(1);
tdp_conv = bol(2);
tdp_coord = bol(3);
tdp_png = bol(4);
tdp_png_conv = bol(5);
tdp_clust = bol(6);

TDP = prm.plot{2};

str_tdp = strcat('parameters:\n', ...
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
    fname_mat = strcat(name, '_', str, '.tdp');
    fname_mat = getCorrName(fname_mat, [], h_fig);
    if ~sum(fname_mat)
        disp(['invalid TDP file name for data: ' str]);
    else
        Nx = size(TDP,2);
        f = fopen([pname fname_mat], 'Wt');
        fprintf(f, [str_tdp '\n\n']);
        fprintf(f, [repmat('%d\t',[1,Nx]) '\n'], TDP');
        fclose(f);
        disp(['export: ' fname_mat]);
    end
end

if tdp_conv % save gaussian convolution TDP matrix
    fname_mat_conv = strcat(name, '_', str, ...
        '_gconv.tdp');
    fname_mat_conv = getCorrName(fname_mat_conv, [], h_fig);
    if ~sum(fname_mat_conv)
        disp(['invalid gconv TDP file name for data:' str]);
    else
        lim = prm.plot{1}([1 2],[2 3]);
        TDP_conv = convGauss(TDP, 0.0005, lim);
        Nx = size(TDP_conv,2);
        f = fopen([pname fname_mat_conv], 'Wt');
        fprintf(f, [str_tdp '\n\n']);
        fprintf(f, [repmat('%d\t',[1,Nx]) '\n'], TDP_conv');
        fclose(f);
        disp(['export: ' fname_mat_conv]);
    end
end

if tdp_coord % save TDP coordinates
    fname_coord = strcat(name, '_', str, '_coord.txt');
    fname_coord = getCorrName(fname_coord, [], h_fig);
    if ~sum(fname_coord)
        disp(['invalid coord TDP file name for data: ' str]);
    else
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

        f = fopen([pname fname_coord], 'Wt');
        fprintf(f, [str_tdp '\n\n']);
        fprintf(f, 'before trans.\tafter trans.\toccurence\n');
        fprintf(f, '%d\t%d\t%d\n', coord);
        fclose(f);
        disp(['export: ' fname_coord]);
    end
end

if tdp_png
    fname_png = strcat(name, '_', str, '.png');
    fname_png = getCorrName(fname_png, [], h_fig);
    if ~sum(fname_png)
        disp(['invalid TDP image file name for data: ' str]);
    else
        maxI = max(max(TDP)); minI = min(min(TDP));
        TDP_8bit = uint8(255*(TDP-minI)/(maxI-minI));
        imwrite(flipdim(TDP_8bit,1), [pname fname_png], 'png', ...
            'bitdepth', 8);
        disp(['export: ' fname_png]);
    end
end

if tdp_png_conv
    fname_png_cv = strcat(name, '_', str, '_gconv.png');
    fname_png_cv = getCorrName(fname_png_cv, [], h_fig);
    if ~sum(fname_png_cv)
        disp(['invalid conv TDP image file name for data: ' str]);
    else
        lim = prm.plot{1}([1 2],[2 3]);
        TDP_conv = convGauss(TDP, 0.0005, lim);
        maxI = max(max(TDP_conv)); minI = min(min(TDP_conv));
        TDP_8bit_conv = uint8(255*(TDP_conv-minI)/(maxI-minI));
        imwrite(flipdim(TDP_8bit_conv,1), [pname fname_png_cv], 'png', ...
            'bitdepth', 8);
        disp(['export: ' fname_png_cv]);
    end
end

isClst = ~isempty(prm.clst_res{1});
if isClst && tdp_clust
    fname_clust = strcat(name, '_', str, '.clst');
    fname_clust = getCorrName(fname_clust, [], h_fig);
    if ~sum(fname_clust)
        disp(['invalid cluster file name for data: ' str]);
    else
        meth = prm.clst_start{1}(1);
        switch meth
            case 1 % kmean
                str_prm = strcat('starting parameters:\n', ...
                    '\tmethod: k-mean clustering\n', ...
                    '\tnumber of max. states: %i\n');
                Kmax = prm.clst_start{1}(3);
                for k = 1:Kmax
                    str_prm = strcat(str_prm, sprintf('\tstate %i:', k), ...
                        '%d, tolerance radius: %d\n');
                end
                str_prm = strcat(str_prm, ...
                    '\tmax. number of k-mean iterations: %i\n');
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
                    '\toptimum number of states: %i\n');
                Kopt = size(prm.clst_res{1},1);
                for k = 1:Kopt
                    str_prm = strcat(str_prm, sprintf('\tstate %i:', k), ...
                        '%d, time fraction: %d\n');
                end
                str_prm = sprintf(str_prm, Kmax, prm.clst_start{2}', ...
                    prm.clst_start{1}(5), Kopt, prm.clst_res{1}');

            case 2 % GM
                
                h = guidata(h_fig);
                str_pop = get(h.popupmenu_TDPstate,'String');
                shape = str_pop{prm.clst_start{1}(2)};
                
                Kmax = prm.clst_start{1}(3);
                
                str_prm = strcat('starting parameters:\n', ...
                    ['\tmethod: 2D Gaussian mixture model-based ' ...
                    'clustering\n'], ...
                    ['\tcluster shape: ' shape '\n'], ...
                    ['\tmax. number of states: ' sprintf('%i',Kmax) '\n']);
                
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
                
                Kopt = size(prm.clst_res{1},1);
                str_prm = strcat(str_prm, ['\nclustering results:\n' ...
                    '\toptimum number of states: ' sprintf('%i',Kopt) ...
                    ' (BIC=' sprintf('%d',prm.clst_res{3}.BIC) ')\n']);
                
                if prm.clst_start{1}(6)
                    str_prm = strcat(str_prm, ['\tbootstrapped number ' ...
                        'of states: ' ...
                        sprintf('%2.2f',prm.clst_res{3}.boba_K(1)) ...
                        ' +/- ', ...
                        sprintf('%2.2f',prm.clst_res{3}.boba_K(2)) '\n']);
                end
                
                for k = 1:Kopt
                    str_prm = strcat(str_prm, ...
                        [sprintf('\tstate %i:\t%d',k, ...
                        prm.clst_res{1}(k,1)) '\ttime fraction:\t' ...
                        sprintf('%d',prm.clst_res{1}(k,2)) '\n']);
                end
                
                str_prm = strcat(str_prm, ...
                    '\toptimum model parameters:\n');
                
                k = 0;
                for k1 = 1:Kopt
                    for k2 = 1:Kopt
                        k = k+1;
                        str_prm = strcat(str_prm,'\t\t', ...
                           sprintf('alpha_%i%i',k1,k2),'\t',...
                            sprintf('%d',prm.clst_res{3}.a(k)),'\n');
                    end
                end
                
                k = 0;
                for k1 = 1:Kopt
                    for k2 = 1:Kopt
                        k = k+1;
                        str_prm = strcat(str_prm, ['\t\t' ...
                            sprintf('sigma_%i%i',k1,k2) '\t' ...
                            sprintf('%d\t%d', ...
                            prm.clst_res{3}.o(1,:,k)) ...
                            '\n\t\t\t' sprintf('%d\t%d', ...
                            prm.clst_res{3}.o(2,:,k)) '\n']);
                    end
                end
        end
        f = fopen([pname fname_clust], 'Wt');
        fprintf(f, strcat(str_prm,'\n\n'));
        fprintf(f, ['dwell-times(s)\tm\tm*\tmolecule\tx(m)\ty(m*)\ts_i' ...
            '\ts_j\n']);
        fprintf(f, '%d\t%d\t%d\t%i\t%i\t%i\t%i\t%i\n', prm.clst_res{2}');
        fclose(f);
        disp(['export: ' fname_clust]);
    end
else
    disp(['no clustering for data: ' str]);
end


function save_kinDat(bol, prm, k, str1, str2, pname, name, h_fig)
kinDtHist = bol(1);
kinFit = bol(2);
kinBoba = bol(3);

dt_hist = prm.clst_res{4}{k};

fname_hdt = strcat(name,'_',str2,'.hdt');
fname_hdt = getCorrName(fname_hdt, [], h_fig);
fname_fit = strcat(name,'_',str2,'.fit');
fname_fit = getCorrName(fname_fit, [], h_fig);

% dwell-time histograms
if kinDtHist
    if ~sum(fname_hdt)
        disp(['invalid dwell-time histogram file name for data:' str1 ...
            ', transition: ' str2]);
    else
        f = fopen([pname fname_hdt], 'Wt');
        fprintf(f, ['dwell-times(s)\tcount\tnorm. count\tcum. count\t' ...
            'compl. norm. count\n']);
        fprintf(f, '%d\t%d\t%d\t%d\t%d\n', dt_hist');
        fclose(f);
        disp(['export: ' fname_hdt]);
    end
end

% fitting parameters and results
if kinFit
    isFit = size(prm.kin_res,1)>=k & ~isempty(prm.kin_res{k,2});
    if isFit
        kin_start = prm.kin_start(k,:);
        kin_res = prm.kin_res(k,:);
        if ~sum(fname_fit)
            disp(['invalid fit results file name for data:' str1 ', ' ...
                'transition: ' str2]);
        else
            nExp = kin_start{1}(2);
            strch = kin_start{1}(1);
            boba = kin_start{1}(4) & kinBoba;
            [str_eq o] = getEqExp(strch, nExp);
            str_prm = strcat('equation: %s\n', ...
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

            f = fopen([pname fname_fit], 'Wt');
            fprintf(f, [str_prm '\n\n']);
            fclose(f);
            disp(['export: ' fname_fit]);
        end
    else
        disp(['no fitting results for data:' str1 ', transition: ' str2]);
    end
end





