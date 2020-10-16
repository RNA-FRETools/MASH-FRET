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

isRes = false;
if isfield(prm,'clst_res')
    isRes = ~isempty(prm.clst_res{1});
end
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
        J = prm.lft_start{2}(1);
        res = prm.clst_res;
        Kmax = getClusterNb(Jmax,mat,clstDiag);
        [j1_start,j2_start] = getStatesFromTransIndexes(1:Kmax,Jmax,mat,...
            clstDiag);
        K = getClusterNb(J,mat,clstDiag);
        [j1,j2] = getStatesFromTransIndexes(1:K,J,mat,clstDiag);
        
        h = guidata(h_fig);
        str_like = get(h.popupmenu_TDPlike,'String');
        str_mat = get(h.popupmenu_TA_clstMat,'string');
        str_meth = get(h.popupmenu_TA_clstMeth,'string');
        clstlike = str_like{logl};
        clstmat = str_mat{mat};
        clstmeth = str_meth{meth};
        
        switch shape
            case 1
                if meth==2
                    clstshape = 'isotropic Gaussian';
                else
                    clstshape = 'square';
                end
            case 2
                 if meth==2
                    clstshape = 'straight multivariate Gaussian';
                 else
                    clstshape = 'straight ellipsis';
                 end
            case 3
                if meth==2
                    clstshape = 'diagonal multivariate Gaussian';
                else
                    clstshape = 'diagonal ellipsis';
                end
                 
            case 4
                if meth==2
                    clstshape = 'free-rotating multivariate Gaussian';
                end
        end
        if clstDiag
            diagclst = 'yes';
        else
            diagclst = 'no';
        end
        
        % method parameters
        str_prm = cat(2,'starting parameters:\n', ...
            '\tmethod: ',clstmeth,' clustering\n', ...
            '\tconstraint on clusters: ',clstmat,'\n',...
            '\tdiagonal clusters: ',diagclst,'\n',...
            '\tcluster shape: ',clstshape,'\n');
        if meth==1
            str_prm = cat(2,str_prm,...
                '\tmax. number of iterations: ',num2str(T),'\n');
        elseif meth==2
            str_prm = cat(2,str_prm,...
                '\tmax. number of initializations: ',num2str(T),'\n',...
                '\tlikelihood: ',clstlike,'\n');
        end
        
        % BOBA FRET parameters
        if boba
            str_prm = cat(2,str_prm,'\tbootstrapping: yes\n', ...
                '\t\tnumber of samples: ',num2str(nspl), ...
                '\n\t\tnumber of replicates: ',num2str(nrpl),'\n');
        else
            str_prm = cat(2,str_prm,'\tbootstrapping: no\n');
        end
        
        % initial conditions
        if mat==1
            str_prm = cat(2,str_prm,...
                '\tmax. number of states: ',num2str(Jmax),'\n');
        elseif mat==2
            str_prm = cat(2,str_prm,...
                '\tmax. number of clusters in a half-TDP: ',...
                num2str(Jmax),'\n');
        else
            str_prm = cat(2,str_prm,...
                '\tmax. number of clusters: ',num2str(Jmax),'\n');
        end
        if meth~=2
            if mat==1
                [val,id] = unique(guess(:,1),'stable');
                tol = guess(id,3);
                for j = 1:Jmax
                    str_prm = cat(2,str_prm,'\tstate ',num2str(j),': ', ...
                        num2str(val(j)),', tolerance radius: ',...
                        num2str(tol(j)),'\n');
                end
            else
                for j = 1:Jmax
                    str_prm = cat(2,str_prm,'\tstate ',num2str(2*j-1),': ', ...
                        num2str(guess(j,1)),', tolerance radius: ',...
                        num2str(guess(j,3)),'\n',...
                        '\tstate ',num2str(2*j),': ', ...
                        num2str(guess(j,2)),', tolerance radius: ',...
                        num2str(guess(j,4)),'\n');
                end
                for k = 1:Kmax
                    str_prm = cat(2,str_prm,'\tcluster ',num2str(k),': ', ...
                        'state ',num2str(j1_start(k)),' to ',...
                        num2str(j2_start(k)),'\n');
                end
            end
        end
        
        % clustering results
        str_prm = cat(2,str_prm,'\nclustering results:\n');
        if mat==1
            str_prm = cat(2,str_prm,...
                '\tnumber of states in model: ',num2str(J),'\n');
        elseif mat==2
            str_prm = cat(2,str_prm,...
                '\tnumber of clusters in model for half-TDP: ',...
                num2str(J),'\n');
        else
            str_prm = cat(2,str_prm,...
                '\tnumber of clusters in model: ',num2str(K),'\n');
        end
        if meth==2
            str_prm = cat(2,str_prm,' (BIC=',num2str(res{1}.BIC(J)),')\n');
        end
        
        % BOBA FRET results
        if boba
            if mat==1
                str_prm = cat(2,str_prm,...
                    '\tbootstrapped number of states: ');
            elseif mat==2
                str_prm = cat(2,str_prm,'\tbootstrapped number of',...
                    ' states for half-TDP: ');
            else
                str_prm = cat(2,str_prm,...
                    '\tbootstrapped number of clusters: ');
            end
            str_prm = cat(2,str_prm,...
                sprintf('%2.2f',res{2}(1)),' +/- ',...
                sprintf('%2.2f',res{2}(2)),'\n');
        end
        
        % cluster parameters
        if mat==1
            val = unique(res{1}.mu{J}(:,1),'stable')';
        elseif mat==2
            val = res{1}.mu{J}(1:J,[1,2])';
            val = val(:)';
        else
            val = res{1}.mu{J}(:,[1,2])';
            val = val(:)';
        end
        tj = res{1}.fract{J};
        for j = 1:size(val,2)
            str_prm = cat(2,str_prm,'\tstate ',num2str(j),': ',...
                num2str(val(j)),', time fraction: ',num2str(tj(j)),'\n');
        end
        for k = 1:K
            str_prm = cat(2,str_prm,'\tcluster ',num2str(k),' (state ',...
                num2str(j1(k)),' to ',num2str(j2(k)),'), ',...
                'relative population: ',num2str(res{1}.pop{J}(k)),'\n');
        end
        
        % optimum model
        if meth==2
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

