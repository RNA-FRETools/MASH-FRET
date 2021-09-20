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
bobaFig = bol(4);

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
        bin = prm.lft_start{2}(3);
        excl = prm.lft_start{2}(4);
        rearr = prm.lft_start{2}(5);
        str_excl = 'no';
        str_rearr = 'no';
        if excl
            str_excl = 'yes';
        end
        if rearr
            str_rearr = 'yes';
        end
        
        % write data to file
        f = fopen([pname fname_hdt], 'Wt');
        fprintf(f, ['state binning: %d\n',...
            'excluded first and last dwell times: ',str_excl,'\n',...
            're-calculate dwell times: ',str_rearr,'\n\n'],bin);
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
        isFit = size(prm.lft_res,1)>=j & ~isempty(prm.lft_res{j,2});
        if isFit
            lft_start = prm.lft_start{1}(j,:);
            lft_res = prm.lft_res(j,:);
            
            nExp = lft_start{1}(3);
            strch = lft_start{1}(2);
            boba = lft_start{1}(5) & kinBoba;
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
                fit_prm = lft_start{2}(1,:);
                fit_res_ref = lft_res{2}(1,:);
                if boba
                    fit_res_boba = lft_res{1}(1,:);
                end

            elseif ~strch
                fit_prm = reshape(lft_start{2}(1:nExp,1:6)', [1 nExp*2*3]);
                fit_res_ref = reshape(lft_res{2}(1:nExp,1:2)', [1 nExp*2]);
                if boba
                    fit_res_boba = reshape(lft_res{1}(1:nExp,1:4)', ...
                        [1 nExp*4]);
                end
            end

            if boba
                rpl = lft_start{1}(6);
                spl = lft_start{1}(7);
                wght = lft_start{1}(8);
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

if bobaFig && ~isempty(prm.lft_res{j,5})
    fname_pdf = strcat(name,'.pdf');
    fname_pdf = getCorrName(fname_pdf, [], h_fig);
    if ~sum(fname_pdf)
        return
    end
    fname_pdf = overwriteIt(fname_pdf,pname,h_fig);
    if isempty(fname_pdf)
        ok = 0;
        return
    end
    [~,name,~] = fileparts(fname_pdf);
    exportBOBAfit_exp(j,pname,name,h_fig);
end
