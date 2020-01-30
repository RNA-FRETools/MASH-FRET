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
str_tag = get(h.popupmenu_TDPtag, 'String');
tpe = p.curr_type(proj);
tag = p.curr_tag(proj);
prm = p.proj{proj}.prm{tag,tpe};

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
    return
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

    if numel(prm.plot{2})==1 && isnan(prm.plot{2})
        disp(['no TDP built for data ' str_tpe{tpe}]);
    elseif isempty(prm.plot{2})
        if tag==1
            disp(['no TDP built for data ' str_tpe{tpe}]);
        else
            disp(['no TDP built for data ' str_tpe{tpe} ...
                ' and molecule subgroup ' ...
                removeHtml(str_tag{tag})]);
        end
    else
        if tag==1
            name_tdp = cat(2,name,'_',str_tpe{tpe});
        else
            name_tdp = cat(2,name,'_',str_tpe{tpe},'_',...
                removeHtml(str_tag{tag}));
        end
        [ok,str_tdp] = save_tdpDat(prm,pname_tdp,name_tdp,bol_tdp,...
            h_fig);
        if ~ok
            return;
        end
        str_act = cat(2,str_act,str_tdp);
    end
end


%% Export kinetic files

bol_kin = [kinDtHist kinFit kinBoba];

if sum(bol_kin)
    setContPan('Export kinetic results ...', 'process', h_fig);
    
    pname_kin = setCorrectPath([pname 'kinetics'], h_fig);
    
    % export dwell-time histogram files & fitting results (if)
    J = prm.kin_start{2}(1);
    mat = prm.clst_start{1}(4);
    clstDiag = prm.clst_start{1}(9);
    if ~isempty(prm.clst_res{4}) && J>0

        if tag==1
            name_kin0 = cat(2,name,'_',str_tpe{tpe});
        else
            name_kin0 = cat(2,name,'_',str_tpe{tpe},'_',...
                removeHtml(str_tag{tag}));
        end
        
        nTrs = getClusterNb(J,mat,clstDiag);
        for k = 1:nTrs
            if ~(size(prm.clst_res{4},2)>=k && ...
                    ~isempty(prm.clst_res{4}{k}))
                continue
            end
            val = round(100*prm.clst_res{1}.mu{J}(k,:))/100;

            name_kin = cat(2,name_kin0,'_',num2str(val(1)),'to',...
                num2str(val(2)));

            [ok,str_kin] = save_kinDat(bol_kin, prm,k, pname_kin, name_kin, ...
                h_fig);
            if ~ok
                return
            end
            str_act = cat(2,str_act,str_kin);
        end
    end
end

str_act = str_act(1:end-2); % remove last '\n'
setContPan(cat(2,'Export completed\n',str_act),'success',h_fig);


function [ok,str_act] = save_tdpDat(prm, pname, name, bol, h_fig)
% Save transition density plot to ASCII files and image files.
% Save transition clustering results to ASCII files
% Return actions to display

% Last update: the 25th of February 2019 by Mélodie Hadzic
% --> adapt to the new clustering result structure
% update: the 23rd of February 2019 by Mélodie Hadzic
% --> control file names with function /divers/overwriteIt
% --> return action string

str_act = '';
ok = 1;

tdp_mat = bol(1);
tdp_conv = bol(2);
tdp_coord = bol(3);
tdp_png = bol(4);
tdp_png_conv = bol(5);
tdp_clust = bol(6);

TDP = prm.plot{2};

str_tdp = cat(2,'parameters:\n', ...
    '\tone transition count per molecule: %s\n', ...
    '\tstate sequences re-arranged: %s\n', ...
    '\tinclude static state sequences: %s\n', ...
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
if prm.plot{1}(4,2)
    rearrng = 'yes';
else
    rearrng = 'no';
end
if prm.plot{1}(4,3)
    incldiag = 'yes';
else
    incldiag = 'no';
end
        
str_tdp = sprintf(str_tdp,onecount,rearrng,incldiag,prm.plot{1}(1,2:3)', ...
    prm.plot{1}(1,1),prm.plot{1}(1,2:3)',prm.plot{1}(1,1));

if tdp_mat% save TDP matrix
    
    % build file name
    fname_mat = strcat(name, '.tdp');
    fname_mat = getCorrName(fname_mat, [], h_fig);
    if sum(fname_mat)
        fname_mat = overwriteIt(fname_mat,pname,h_fig);
        if isempty(fname_mat)
            ok = 0;
            return;
        end
        
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
    fname_mat_conv = strcat(name,'_gconv.tdp');
    fname_mat_conv = getCorrName(fname_mat_conv, [], h_fig);
    if sum(fname_mat_conv)
        fname_mat_conv = overwriteIt(fname_mat_conv,pname,h_fig);
        if isempty(fname_mat_conv)
            ok = 0;
            return;
        end
        
        % calculate data
        lim = prm.plot{1}(1,[2 3]);
        bin = (lim(2)-lim(1))/size(TDP,2);
        TDP_conv = gconvTDP(TDP,lim,bin);
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
    fname_coord = strcat(name, '_coord.txt');
    fname_coord = getCorrName(fname_coord, [], h_fig);
    if sum(fname_coord)
        fname_coord = overwriteIt(fname_coord,pname,h_fig);
        if isempty(fname_coord)
            ok = 0;
            return;
        end
        
        % format data
        bin = prm.plot{1}(1,1);
        lim = prm.plot{1}(1,[2 3]);
        iv = lim(1):bin:lim(2);
        iv = mean([iv(1:end-1);iv(2:end)],1);
        [x,y] = meshgrid(iv,iv);
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
    fname_png = strcat(name, '.png');
    fname_png = getCorrName(fname_png, [], h_fig);
    if sum(fname_png)
        fname_png = overwriteIt(fname_png,pname,h_fig);
        if isempty(fname_png)
            ok = 0;
            return;
        end
        
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
    fname_png_cv = strcat(name, '_gconv.png');
    fname_png_cv = getCorrName(fname_png_cv, [], h_fig);
    if sum(fname_png_cv)
        fname_png_cv = overwriteIt(fname_png_cv,pname,h_fig);
        if isempty(fname_png_cv)
            ok = 0;
            return;
        end
        
        % format data
        lim = prm.plot{1}(1,[2 3]);
        bin = (lim(1,2)-lim(1,1))/size(TDP,2);
        TDP_conv = gconvTDP(TDP,lim,bin);
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

isRes = ~isempty(prm.clst_res{1});
if isRes && tdp_clust
    
    % build file name
    fname_clust = strcat(name, '.clst');
    fname_clust = getCorrName(fname_clust, [], h_fig);
    if sum(fname_clust)
        fname_clust = overwriteIt(fname_clust,pname,h_fig);
        if isempty(fname_clust)
            ok = 0;
            return;
        end
        
        % format data
        meth = prm.clst_start{1}(1);
        shape = prm.clst_start{1}(2);
        Jmax = prm.clst_start{1}(3);
        mat = prm.clst_start{1}(4);
        T = prm.clst_start{1}(5);
        boba = prm.clst_start{1}(6);
        nspl = prm.clst_start{1}(7);
        nrpl = prm.clst_start{1}(8);
        clstDiag = prm.clst_start{1}(9);
        logl = prm.clst_start{1}(10);
        guess = prm.clst_start{2};
        J = prm.kin_start{2}(1);
        res = prm.clst_res;
        Kmax = getClusterNb(Jmax,mat,clstDiag);
        [j1_start,j2_start] = getStatesFromTransIndexes(1:Kmax,Jmax,mat,...
            clstDiag);
        K = getClusterNb(J,mat,clstDiag);
        [j1,j2] = getStatesFromTransIndexes(1:K,J,mat,clstDiag);
        if mat
            clstmat = 'yes';
        else
            clstmat = 'no';
        end
        if clstDiag
            diagclst = 'yes';
        else
            diagclst = 'no';
        end
        switch meth
            case 1 % kmean
                switch shape
                    case 1
                        clstshape = 'square';
                    case 2
                        clstshape = 'straight ellipsis';
                    case 3
                        clstshape = 'diagonal ellipsis';
                end
                
                str_prm = cat(2,'starting parameters:\n', ...
                    '\tmethod: k-mean clustering\n', ...
                    '\tcluster matrix: ',clstmat,'\n',...
                    '\tdiagonal clusters: ',diagclst,'\n',...
                    '\tcluster shape: ',clstshape,'\n',...
                    '\tmax. number of iterations: ',num2str(T),'\n');
                
                if mat
                    str_prm = cat(2,str_prm,...
                        '\tmax. number of states: ',num2str(Jmax),'\n');
                else
                    str_prm = cat(2,str_prm,...
                        '\tmax. number of clusters: ',num2str(Jmax),'\n');
                end

                if mat
                    [states,id] = unique(guess(:,1),'stable');
                    tol = guess(id,3);
                    for j = 1:Jmax
                        str_prm = cat(2,str_prm,'\tstate ',num2str(j),': ', ...
                            num2str(states(j)),', tolerance radius: ',...
                            num2str(tol(j)),'\n');
                    end
                else
                    for k = 1:Kmax
                        str_prm = cat(2,str_prm,'\tcluster ',num2str(k),': ', ...
                            'state ',num2str(j1_start(k)),' (',...
                            num2str(guess(k,1)),', radius=',...
                            num2str(guess(k,3)),') to ',...
                            num2str(j2_start(k)),' (',...
                            num2str(guess(k,2)),', radius=',...
                            num2str(guess(k,4)),')\n');
                    end
                end
                
                if boba
                    str_prm = cat(2,str_prm,'\tbootstrapping: yes\n', ...
                        '\t\tnumber of samples: ',num2str(nspl), ...
                        '\n\t\tnumber of replicates: ',num2str(nrpl));
                else
                    str_prm = cat(2,str_prm,'\tbootstrapping: no\n');
                end
                
                str_prm = cat(2,str_prm,'\nclustering results:\n');
                if mat
                    str_prm = cat(2,str_prm,...
                        '\tnumber of states in model: ',num2str(J),'\n');
                else
                    str_prm = cat(2,str_prm,...
                        '\tnumber of clusters in model: ',num2str(K),'\n');
                end
                
                if boba
                    if mat
                        str_prm = cat(2,str_prm,...
                            '\tbootstrapped number of states: ');
                    else
                        str_prm = cat(2,str_prm,...
                            '\tbootstrapped number of clusters: ');
                    end
                    str_prm = cat(2,str_prm,...
                        sprintf('%2.2f',res{2}(1)),' +/- ',...
                        sprintf('%2.2f',res{2}(2)),'\n');
                end
                
                if mat
                    states = unique(res{1}.mu{J}(:,1),'stable')';
                else
                    states = res{1}.mu{J}(:,[1,2])';
                    states = states(:)';
                end
                fract = res{1}.fract{J};
                for j = 1:size(states,2)
                    str_prm = cat(2,str_prm,'\tstate ',num2str(j),': ', ...
                        num2str(states(j)),', time fraction: ',...
                        num2str(fract(j)),'\n');
                end
                for k = 1:K
                    str_prm = cat(2,str_prm,'\tcluster ',num2str(k),' (', ...
                        'state ',num2str(j1(k)),' to ',...
                        num2str(j2(k)),'), relative population: ',...
                        num2str(res{1}.pop{J}(k)),'\n');
                end

            case 2 % GM
                
                h = guidata(h_fig);
                str_shape = get(h.popupmenu_TDPshape,'String');
                str_like = get(h.popupmenu_TDPlike,'String');
                clstshape = str_shape{shape};
                clstlike = str_like{logl};
                
                str_prm = cat(2,'starting parameters:\n', ...
                    '\tmethod: Gaussian mixture clustering\n', ...
                    '\tcluster matrix: ',clstmat,'\n',...
                    '\tdiagonal clusters: ',diagclst,'\n',...
                    '\tcluster shape: ',clstshape,'\n',...
                    '\tmax. number of initializations: ',num2str(T),'\n',...
                    '\tlikelihood: ',clstlike,'\n');
                
                if mat
                    str_prm = cat(2,str_prm,...
                        '\tmax. number of states: ',num2str(Jmax),'\n');
                else
                    str_prm = cat(2,str_prm,...
                        '\tmax. number of clusters: ',num2str(Jmax),'\n');
                end

                str_prm = cat(2,str_prm,'\nclustering results:\n');
                if mat
                    str_prm = cat(2,str_prm,...
                        '\tnumber of states in model: ',num2str(J),' ');
                else
                    str_prm = cat(2,str_prm,...
                        '\tnumber of clusters in model: ',num2str(K),' ');
                end
                str_prm = cat(2,str_prm,' (BIC=',num2str(res{1}.BIC(J)),...
                    ')\n');
                
                if boba
                    if mat
                        str_prm = cat(2,str_prm,...
                            '\tbootstrapped number of states: ');
                    else
                        str_prm = cat(2,str_prm,...
                            '\tbootstrapped number of clusters: ');
                    end
                    str_prm = cat(2,str_prm,...
                        sprintf('%2.2f',res{2}(1)),' +/- ',...
                        sprintf('%2.2f',res{2}(2)),'\n');
                end
                
                if mat
                    states = unique(res{1}.mu{J}(:,1),'stable')';
                else
                    states = res{1}.mu{J}(:,[1,2])';
                    states = states(:)';
                end
                fract = res{1}.fract{J};
                for j = 1:size(states,2)
                    str_prm = cat(2,str_prm,'\tstate ',num2str(j),': ', ...
                        num2str(states(j)),', time fraction: ',...
                        num2str(fract(j)),'\n');
                end
                for k = 1:K
                    str_prm = cat(2,str_prm,'\tcluster ',num2str(k),' (', ...
                        'state ',num2str(j1(k)),' to ',...
                        num2str(j2(k)),'), relative population: ',...
                        num2str(res{1}.pop{J}(k)),'\n');
                end
                
                str_prm = strcat(str_prm, '\toptimum model parameters:\n');
                
                for k = 1:K
                    str_prm = cat(2,str_prm,'\t\t',...
                        sprintf('alpha_%i%i',j1(k),j2(k)),'\t',...
                        num2str(res{1}.a{J}(k)),'\n');
                end

                for k = 1:K
                    sig = res{1}.o{J}(:,:,k);
                    str_prm = strcat(str_prm,'\t\t',...
                        sprintf('sigma_%i%i',j1(k),j2(k)),...
                        '\t',num2str(sig(1,1)),'\t',num2str(sig(1,2)),...
                        '\n\t\t',...
                        '\t',num2str(sig(2,1)),'\t',num2str(sig(2,2)),'\n');
                end
                
            case 3 % manual
                switch shape
                    case 1
                        clstshape = 'square';
                    case 2
                        clstshape = 'straight ellipsis';
                    case 3
                        clstshape = 'diagonal ellipsis';
                end
                
                str_prm = cat(2,'starting parameters:\n', ...
                    '\tmethod: manual clustering\n',...
                    '\tcluster shape: ',clstshape,'\n');
                
                str_prm = cat(2,str_prm,'\tmax. number of clusters: ',...
                    num2str(Jmax),'\n');

                for k = 1:Kmax
                    str_prm = cat(2,str_prm,'\tcluster ',num2str(k),': ', ...
                        'state ',num2str(j1_start(k)),' (',...
                        num2str(guess(k,1)),', radius=',...
                        num2str(guess(k,3)),') to ',...
                        num2str(j2_start(k)),' (',...
                        num2str(guess(k,2)),', radius=',...
                        num2str(guess(k,4)),')\n');
                end
                
                str_prm = cat(2,str_prm,'\nclustering results:\n');

                states = res{1}.mu{J}(:,[1,2])';
                states = states(:)';
                fract = res{1}.fract{J};
                for j = 1:size(states,2)
                    str_prm = cat(2,str_prm,'\tstate ',num2str(j),': ', ...
                        num2str(states(j)),', time fraction: ',...
                        num2str(fract(j)),'\n');
                end
                for k = 1:K
                    str_prm = cat(2,str_prm,'\tcluster ',num2str(k),' (', ...
                        'state ',num2str(j1(k)),' to ',...
                        num2str(j2(k)),'), relative population: ',...
                        num2str(res{1}.pop{J}(k)),'\n');
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
end


function [ok,str_act] = save_kinDat(bol,prm,j,pname,name,h_fig)
% Save dwell time histograms and fitting results to ASCII files.
% Return actions to display

% Last update: the 23rd of February 2019 by Mélodie Hadzic
% --> control file names with function /divers/overwriteIt
% --> return action string

str_act = '';
ok = 1;

kinDtHist = bol(1);
kinFit = bol(2);
kinBoba = bol(3);

% dwell-time histograms
if kinDtHist
    
    % build file name
    fname_hdt = strcat(name,'.hdt');
    fname_hdt = getCorrName(fname_hdt, [], h_fig);
    if sum(fname_hdt)
        fname_hdt = overwriteIt(fname_hdt,pname,h_fig);
        if isempty(fname_hdt)
            ok = 0;
            return
        end
        
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
    fname_fit = strcat(name,'.fit');
    fname_fit = getCorrName(fname_fit, [], h_fig);
    if sum(fname_fit)
        fname_fit = overwriteIt(fname_fit,pname,h_fig);
        if isempty(fname_fit)
            ok = 0;
            return;
        end
        
        % format data
        isFit = size(prm.kin_res,1)>=j & ~isempty(prm.kin_res{j,2});
        if isFit
            kin_start = prm.kin_start{1}(j,:);
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
        end
        
    else
        % update action
        str_act = cat(2,str_act,'ERROR: Fitting results not saved ',...
            'to ASCII file because of invalid file name ',fname_fit,'\n');
        disp(cat(2,'Invalid file name: ',fname_fit));
    end
end





