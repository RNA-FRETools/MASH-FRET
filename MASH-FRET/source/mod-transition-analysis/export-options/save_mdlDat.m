function [ok,str_act] = save_mdlDat(prm,pname,rname,opt,h_fig)

ok = 0;
str_act = '';

if opt(1) % model selection results
    fname_bic = [rname,'_BIC.txt'];
    fname_bic = getCorrName(fname_bic, [], h_fig);
    if sum(fname_bic)
        fname_bic = overwriteIt(fname_bic,pname,h_fig);
        if isempty(fname_bic)
            return
        end
        
        % collect data
        BIC = prm.mdl_res{6}{2};
        J = prm.lft_start{2}(1);
        mat = prm.clst_start{1}(4);
        clstDiag = prm.clst_start{1}(9);
        mu = prm.clst_res{1}.mu{J};
        bin = prm.lft_start{2}(3);
        
        % bin state values
        nTrs = getClusterNb(J,mat,clstDiag);
        [j1,j2] = getStatesFromTransIndexes(1:nTrs,J,mat,clstDiag);
        [stateVals,~] = binStateValues(mu,bin,[j1,j2]);
        V = numel(stateVals);
        
        % write data to file
        f = fopen([pname fname_bic], 'Wt');
        fprintf(f,['D\t',repmat('BIC(state %0.2f)\t',[1,V]),'\n'],...
            stateVals);
        fprintf(f,['%i\t',repmat('%d\t',[1,V]),'\n'],BIC');
        fclose(f);
        
        % update action
        str_act = cat(2,str_act,'DPH-based model selection saved to ASCII',...
            ' file: ',fname_bic,' in folder: ',pname,'\n');
        
    else
        % update action
        str_act = cat(2,str_act,'ERROR: DPH-based model selection were ',...
            'not saved to ASCII file because of invalid file name ',...
            fname_bic,'\n');
        disp(cat(2,'Invalid file name: ',fname_bic));
    end
end

if opt(2) % optimized kinetic model parameters
    fname_mdl = [pname,rname,'_mdl.txt'];
    fname_mdl = getCorrName(fname_mdl, [], h_fig);
    if sum(fname_mdl)
        fname_mdl = overwriteIt(fname_mdl,pname,h_fig);
        if isempty(fname_mdl)
            return
        end
        
        % collect data
        tp = prm.mdl_res{1};
        tp_err = prm.mdl_res{2};
        ip = prm.mdl_res{3};
        states = prm.mdl_res{5};
        J = numel(states);
        h = guidata(h_fig);
        p = h.param;
        proj = p.curr_proj;
        expT = p.proj{proj}.resampling_time;
        k = tp/expT;
        k(~~eye(J)) = 0;
        k_err = tp_err/expT;
        for d = 1:size(k_err,3)
            k_err_d = k_err(:,:,d);
            k_err_d(~~eye(J)) = 0;
            k_err(:,:,d) = k_err_d;
        end
        k_err_up = k_err(:,:,1);
        k_err_down = k_err(:,:,2);
        tau = 1./sum(k,2);
        
        % write data to file
        f = fopen([pname fname_mdl], 'Wt');
        fprintf(f,['states\tvalues\tlifetimes(s)\tinitial prob.',...
            repmat('\tk(s-1)',[1,J]),repmat('\t+dk(s-1)',[1,J]),...
            repmat('\t-dk(s-1)',[1,J]),'\n']);
        fprintf(f,['%i\t%d\t%d\t%d',repmat('\t%d',[1,J]),...
            repmat('\t%d',[1,J]),repmat('\t%d',[1,J]),'\n'],...
            [(1:J)',states,tau,ip',k,k_err_up,k_err_down]');
        fclose(f);
        
        % update action
        str_act = cat(2,str_act,'Kinetic model parameters saved to ASCII',...
            ' file: ',fname_mdl,' in folder: ',pname,'\n');
        
    else
        % update action
        str_act = cat(2,str_act,'ERROR: Kinetic model parameters were ',...
            'not saved to ASCII file because of invalid file name ',...
            fname_mdl,'\n');
        disp(cat(2,'Invalid file name: ',fname_mdl));
    end
end

if opt(3) % experimental vs simulated data
    fname_sim = [pname,rname,'.dt'];
    fname_sim = getCorrName(fname_sim, [], h_fig);
    if sum(fname_sim)
        fname_sim = overwriteIt(fname_sim,pname,h_fig);
        if isempty(fname_sim)
            return
        end
        
        % collect data
        h = guidata(h_fig);
        p = h.param;
        proj = p.curr_proj;
        expT = p.proj{proj}.resampling_time;
        simdat = prm.mdl_res{4};
        dt = simdat.dt;
        dt(:,1) = dt(:,1)*expT;
        
        % write data to file
        f = fopen([pname fname_sim], 'Wt');
        fprintf(f,['dwell time (seconds)\tmolecule\tstate\tstate after ',...
            'transition\n']);
        fprintf(f,'%d\t%i\t%i\t%i\t\n',dt');
        fclose(f);
        
        % update action
        str_act = cat(2,str_act,'Simulated dwell times saved to ASCII',...
            ' file: ',fname_sim,' in folder: ',pname,'\n');
        
    else
        % update action
        str_act = cat(2,str_act,'ERROR: Simulated dwell times were not ',...
            'saved to ASCII file because of invalid file name ',fname_sim,...
            '\n');
        disp(cat(2,'Invalid file name: ',fname_sim));
    end
end

ok = 1;
