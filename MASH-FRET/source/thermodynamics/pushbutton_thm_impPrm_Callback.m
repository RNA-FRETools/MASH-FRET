function pushbutton_thm_impPrm_Callback(obj, evd, h)
% Import selected state configuration from panel "state configuration" to
% panel "state population" (Gaussian fitting or Thresholding method)

p = h.param.thm;
if ~isempty(p.proj)
    proj = p.curr_proj;
    tpe = p.curr_tpe(proj);
    prm = p.proj{proj}.prm{tpe};
    meth = prm.thm_start{1}(1);

    if ~isempty(prm.thm_res{3,2})
        
        % Selected configuration
        K = get(h.popupmenu_thm_nTotGauss, 'Value');
        fitprm = prm.thm_res{3,2}{K};
        
        switch meth
            
            case 1 % Modify Gaussian fitting parameters
                x_lim = prm.plot{1}(2:3);
                prm.thm_start{3} = [zeros(K,1) fitprm(:,1) ones(K,1) ...
                    repmat(x_lim(1),[K,1]) fitprm(:,2) repmat(x_lim(2),[K,1]) ...
                    zeros(K,1) fitprm(:,3) Inf(K,1) p.colList(1:K,:)];
                
                % Reinitialize results
                prm.thm_res{2,1} = [];
                prm.thm_res{2,2} = [];
                prm.thm_res{2,3} = [];
                
            case 2 % Modify Thersholding parameters
                A = fitprm(:,1);
                mu = fitprm(:,2);
                sig = fitprm(:,3)/(2*sqrt(2*log(2)));
                prm.thm_start{2} = threshFromGauss(A, mu, sig);
                
                % Reinitialize results
                prm.thm_res{1,1} = [];
                prm.thm_res{1,2} = [];
                prm.thm_res{1,3} = [];
        end
        
        % Save modifications
        p.proj{proj}.prm{tpe} = prm;
        h.param.thm = p;
        guidata(h.figure_MASH, h);
        
        % Update interface
        updateFields(h.figure_MASH, 'thm');
    end
end

