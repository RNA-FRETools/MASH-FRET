function radiobutton_thm_BIC_Callback(obj, evd, h_fig)

% control HA
h = guidata(h_fig);
p = h.param;
if ~isModuleOn(p,'HA')
    return
end

% save modifications
proj = p.curr_proj;
tpe = p.thm.curr_tpe(proj);
tag = p.thm.curr_tag(proj);
curr = p.proj{proj}.HA.curr{tag,tpe};
prm = p.proj{proj}.HA.prm{tag,tpe};

curr.thm_start{4}(1,1) = ~get(obj,'Value');
prm.thm_start{4}(1,1) = ~get(obj,'Value');

p.proj{proj}.HA.curr{tag,tpe} = curr;
p.proj{proj}.HA.prm{tag,tpe} = prm;
h.param = p;
guidata(h_fig, h);

% control results
if ~(isfield(prm,'thm_res') && size(prm.thm_res,1)>=3 && ...
        ~isempty(prm.thm_res{3,1}))
    
    % refresh panel and plot
    updateFields(h_fig, 'thm');
    
    return
end

% determine optimum config
isBIC = ~prm.thm_start{4}(1); % apply BIC (or rmse) selection
penalty = prm.thm_start{4}(2); % penalty factor for rmse selection
Kmax = prm.thm_start{4}(3); % maximum number of Gaussian functions to fit
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
            break
        end
    end
end

% set selected config to optimum
set(h.popupmenu_thm_nTotGauss, 'Value', Kopt);

% refresh panel and plot
updateFields(h_fig, 'thm');
