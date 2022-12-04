function gauss_ana(h_fig)

% update 23.4.2019 by MH: use loading bar only for BOBA-FRET

% recover parameters from MASH interface
h = guidata(h_fig);
p = h.param;
proj = p.curr_proj;
tpe = p.thm.curr_tpe(proj);
tag = p.thm.curr_tag(proj);

molTag = p.proj{proj}.molTag;
m_incl = p.proj{proj}.coord_incl;
def = p.proj{proj}.HA.def{tag,tpe};
prm = p.proj{proj}.HA.prm{tag,tpe};
curr = p.proj{proj}.HA.curr{tag,tpe};

prm_plot = prm.plot;
ovrfl = prm_plot{1}(1,4); % remove (or not) first and last bin

prm.thm_start([1,3]) = curr.thm_start([1,3]);
prm.thm_res(2,:) = def.thm_res(2,:);

prm_start = prm.thm_start;
boba = prm_start{1}(2); % apply (or not) bootstraping
nRpl = prm_start{1}(3); % number of replicates (usually the number of SM)
w = prm_start{1}(5); % weight (or not) the SM contribution to the histogram 
                     % according to the trajectory length L
if ~boba
    nSpl = 1;
else
    nSpl = prm_start{1}(4); % number of samples (usually 100)
end

param = prm_start{3};

J = size(param,1); % number of gaussian functions to fit

nMol = size(m_incl,2); % inital number of molecules
if boba
    mols = 1:nMol;
    if tag==1
        mols = mols(m_incl);
    else
        mols = mols(m_incl & molTag(:,tag-1)');
    end
    N = size(mols,2); % number of user-selected molecules
end

% Gaussian function coefficients
lower = reshape(prm_start{3}(:,1:3:end-3), [1,3*J]); % lower bound
start = reshape(prm_start{3}(:,2:3:end-3), [1,3*J]); % initial guess
upper = reshape(prm_start{3}(:,3:3:end-3), [1,3*J]); % upper bound

% convert FWHM to sigma
lower(2*J+1:end) = lower(2*J+1:end)/(2*sqrt(2*log(2)));
start(2*J+1:end) = start(2*J+1:end)/(2*sqrt(2*log(2)));
upper(2*J+1:end) = upper(2*J+1:end)/(2*sqrt(2*log(2)));

% get coeficient indexes
ids = 1:4*J; id_pop = ids(4:4:end);
id_amuo = [];
for i = 1:3
    id_amuo = [id_amuo i:4:J*4];
end

% initializes output
cf = zeros(nSpl,J*4); % fitting coefficients A, mu, o and calculated
                      % relative occurence for each Gaussian function
P_bs = []; % histograms of each sample


% get Gaussian mixture equation
str_fit = getEqGauss(J);

if boba
    setContPan(cat(2,'Bootstrap (',num2str(nRpl),' replicates, ',...
        num2str(nSpl),' samples) and fit histograms with ',num2str(J),...
        ' Gaussians ...'),'process',h_fig);
    if loading_bar('init', h_fig, nSpl, ['Performing randomisation and ' ...
            'Gaussian fitting ...'])
        return
    end
    h = guidata(h_fig);
    h.barData.prev_var = h.barData.curr_var;
    guidata(h_fig, h);
else
    setContPan(cat(2,'Fit histogram with ',num2str(J),'Gaussians ...'),...
        'process',h_fig);
end

for s = 1:nSpl

    if boba
        % select randomly nSpl single molecule (with replacement)
        m = randsample(mols, nRpl, true, ones(N,1))';
    else
        m = 'all';
    end
    
    % build normalized histogram
    P_s = getHist(m, w, ovrfl, h_fig); 
    P_s(:,2) = P_s(:,2)/sum(P_s(:,2));
    
    % remove NaN values if any
    [r,o,o] = find(isnan(P_s(:,2)));
    R = 1:size(P_s,1);
    R(r') = [];

    % define fit options
    fo_ = fitoptions('method', 'NonlinearLeastSquares', 'Lower', ...
        lower, 'Upper', upper, 'Startpoint', start);
    
    try % fit
    	[cf_, o, o] = fit(P_s(R,1), P_s(R,2), str_fit, fo_);
    catch err
        if strcmp(err.identifier,'curvefit:fit:notEnoughDataPoints')
            loading_bar('close', h_fig);
            setContPan(err.message, 'error', h_fig);
            return
        else
            throw(err)
        end
    end
    
    % recover fitting coefficients
    cf(s,id_amuo) = coeffvalues(cf_);
    
    % calculate relative populations
    P_p = zeros(size(P_s,1),J);
    for k = 1:J
        P_p(:,k) = normpdf(P_s(:,1), cf(s,4*k-2), cf(s,4*k-1));
        P_p(:,k) = repmat(cf(s,4*k-3),[size(P_p(:,k),1) 1]).*P_p(:,k)./ ...
            repmat(max(P_p(:,k),[],1),[size(P_p(:,k),1) 1]);
    end
    pop = sum(P_p,1)/sum(sum(P_p,1),2);
    cf(s,id_pop) = pop;
    
    % complete fitting coefficients
    cf_srt = reshape(cf(s,:),[4,J])';
    cf(s,:) = reshape(sortrows(cf_srt,2)',[1 4*J]);
    
    % recover bootstrap sample (histogram)
    P_bs(:,s) = P_s(:,2);
    
    % update loading bar
    if boba && loading_bar('update', h_fig)
        return
    end
end

% convert sigma to FWHM
cf(:,3:4:end) = cf(:,3:4:end)*(2*sqrt(2*log(2)));

% A, A sig, mu, mu sig, o, o sig, pop, pop sig
[r,o,o] = find(isnan(cf));
R = 1:nSpl;
R(r') = [];
res(1,:) = mean(cf(R,:),1)';
res(2,:) = std(cf(R,:),0,1)';
res = reshape(reshape(res,[1,numel(res)])',[8 J])';

prm.thm_res(2,:) = {res, cf, cat(2,P_s(:,1),P_bs)};
curr.thm_res(2,:) = prm.thm_res(2,:);

p.proj{proj}.HA.prm{tag,tpe} = prm;
p.proj{proj}.HA.curr{tag,tpe} = curr;
h.param = p;
guidata(h_fig,h);

if boba
    loading_bar('close', h_fig); % close loading bar
end

setContPan(cat(2,'Gaussian fit successfully completed and state relative ',...
    'population calculated.'),'success',h_fig);


