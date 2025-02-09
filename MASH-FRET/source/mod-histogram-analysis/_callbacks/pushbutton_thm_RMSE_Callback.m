function pushbutton_thm_RMSE_Callback(obj, evd, h_fig)

% defaults
likl_str = {'complete','incomplete'};

% retrieve interface parameters
h = guidata(h_fig);
p = h.param;
if ~isModuleOn(p,'HA')
    return
end

% collect project parameters
proj = p.curr_proj;
tpe = p.thm.curr_tpe(proj);
tag = p.thm.curr_tag(proj);
colList = p.thm.colList;
prm = p.proj{proj}.HA.prm{tag,tpe};
def = p.proj{proj}.HA.def{tag,tpe};
curr = p.proj{proj}.HA.curr{tag,tpe};

% collect RMSE analysis parameters
likl = curr.thm_start{4}(4);
isBIC = ~curr.thm_start{4}(1); % apply BIC (or rmse) selection
penalty = curr.thm_start{4}(2); % penalty factor for rmse selection
Kmax = curr.thm_start{4}(3); % maximum number of Gaussian functions to fit
val = curr.plot{2}(:,[1 2 3])'; % histogram: data, count, cumulative count

% reset previous results
prm.thm_res = def.thm_res; % reset analysis results

% start RMSE analysis
res = rmse_ana(h_fig, isBIC, penalty, Kmax, val, likl_str{likl});
if isequal(res,def.thm_res)
    setContPan('Not enought data for RMSE analysis.', 'error' , h_fig);
    return
end

% store new results
prm.thm_res(3,1:2) = res;
prm.thm_start = curr.thm_start;
curr.thm_res = prm.thm_res;

% determine optimum config
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

% export optimum config to population analysis
fitprm = prm.thm_res{3,2}{Kopt};
meth = curr.thm_start{1}(1);
switch meth
    case 1 % Modify Gaussian fitting parameters
        x_lim = prm.plot{1}(2:3);
        curr.thm_start{3} = [zeros(Kopt,1) fitprm(:,1) ones(Kopt,1) ...
            repmat(x_lim(1),[Kopt,1]) fitprm(:,2) repmat(x_lim(2),[Kopt,1]) ...
            zeros(Kopt,1) fitprm(:,3) Inf(Kopt,1) colList(1:Kopt,:)];

    case 2 % Modify Thersholding parameters
        A = fitprm(:,1);
        mu = fitprm(:,2);
        sig = fitprm(:,3)/(2*sqrt(2*log(2)));
        curr.thm_start{2} = threshFromGauss(A, mu, sig);
end

% Save modifications
p.proj{proj}.HA.prm{tag,tpe} = prm;
p.proj{proj}.HA.curr{tag,tpe} = curr;
h.param = p;
guidata(h_fig, h);

% bring histogram plot tab front
bringPlotTabFront('HAhist',h_fig);

% Update interface
updateFields(h_fig, 'thm');


