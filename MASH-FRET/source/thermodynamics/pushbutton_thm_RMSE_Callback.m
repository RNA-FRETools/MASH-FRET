function pushbutton_thm_RMSE_Callback(obj, evd, h)
p = h.param.thm;
if ~isempty(p.proj)
    proj = p.curr_proj;
    tpe = p.curr_tpe(proj);
    prm = p.proj{proj}.prm{tpe};
    prm.thm_res(2,1:3) = {[] [] []};
    prm.thm_res(3,1:3) = {[] [] []};
    prev_res = prm.thm_res;
    
    isBIC = ~prm.thm_start{4}(1); % apply BIC (or rmse) selection
    penalty = prm.thm_start{4}(2); % penalty factor for rmse selection
    Kmax = prm.thm_start{4}(3); % maximum number of Gaussian functions to fit
    val = prm.plot{2}(:,[1 2 3])'; % histogram: data, count, cumulative count
%     N = size(val,2); % number of molecules

    res = rmse_ana(h.figure_MASH, isBIC, penalty, Kmax, val);
    prm.thm_res(3,1:2) = res;
    
    if isequal(prm.thm_res,prev_res)
        setContPan('Not enought data for RMSE analysis.', 'error' , ...
            h.figure_MASH);
        return;
    end
    
    L = prm.thm_res{3,1}(:,1);
    BIC = prm.thm_res{3,1}(:,2);
    
    if isBIC
        [o,Kopt] = min(BIC);
        
    else
        Kopt = 1;
        for k = 2:Kmax
            if ((L(k)-L(k-1))/abs(L(k-1)))>(penalty-1)
                Kopt = k;
            else
                break;
            end
        end
    end
    
    set(h.popupmenu_thm_nTotGauss, 'Value', Kopt);
    
    meth = prm.thm_start{1}(1);
        
    % Selected configuration
    fitprm = prm.thm_res{3,2}{Kopt};

    switch meth

        case 1 % Modify Gaussian fitting parameters
            x_lim = prm.plot{1}(2:3);
            prm.thm_start{3} = [zeros(Kopt,1) fitprm(:,1) ones(Kopt,1) ...
                repmat(x_lim(1),[Kopt,1]) fitprm(:,2) repmat(x_lim(2),[Kopt,1]) ...
                zeros(Kopt,1) fitprm(:,3) Inf(Kopt,1) p.colList(1:Kopt,:)];

        case 2 % Modify Thersholding parameters
            A = fitprm(:,1);
            mu = fitprm(:,2);
            sig = fitprm(:,3);
            prm.thm_start{2} = [];
            for k = 1:Kopt-1
                x1 = mu(k);   o1 = sig(k);   A1 = A(k);
                x2 = mu(k+1); o2 = sig(k+1); A2 = A(k+1);
                vA = 1/(o2^2)-1/(o1^2);
                vB = 2*x1/(o1^2)-2*x2/(o2^2);
                vC = ((x2/o2)^2)-((x1/o1)^2)-2*log(A2/A1);
                delta = (vB^2)-4*vA*vC;

                prm.thm_start{2}(k,1) = (-vB-sqrt(delta))/(2*vA);
            end
    end

    % Save modifications
    p.proj{proj}.prm{tpe} = prm;
    h.param.thm = p;
    guidata(h.figure_MASH, h);

    % Update interface
    updateFields(h.figure_MASH, 'thm');
end

