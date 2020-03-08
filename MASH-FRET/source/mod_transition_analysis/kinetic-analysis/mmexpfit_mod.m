function res = mmexpfit_mod(x_dat, y_dat, p, nExp, strch, varargin)
% res = mmexpfit_mod(x_dat, y_dat, p, nExp, strch)
% res = mmexpfit_mod(x_dat, y_dat, p, nExp, strch, mute)

% initialize output
res = [];

% defaults
nmin_beta = 3; % minimum number of data point to fit a stretched exponential

mute = false;
if ~isempty(varargin)
    mute = varargin{1};
end

if strch
    nmin = nmin_beta;
else
    nmin = 2*nExp;
end
excl_x = [x_dat(1) x_dat(end)];
ex_ = false(size(x_dat));
ex_([[]]) = 1;
ex_ = ex_ | ~(excl_x(1)<x_dat & x_dat<excl_x(2));
ok_ = ~(isnan(x_dat) | isnan(y_dat));
if sum(~ex_(ok_))<nmin  % too many points excluded
    return
end

% use home-written fitting algorithm
if ~strch
    [tau,amp,gof] = fitMultiExp(y_dat(ok_),x_dat(ok_),p);
    if sum(isinf(tau)) || sum(isinf(amp))
        return
    end
    res.cf = [amp;tau];
    res.cf = res.cf(:)';
    res.gof = gof;
    
    % re-establish order of decays in starting guess
    pos_dec = 2:2:size(res.cf,2);
    pos_amp = 1:2:(size(res.cf,2)-1);
    [res.cf(pos_dec),id] = sort(res.cf(pos_dec),'ascend');
    res.cf(pos_amp) = res.cf(2*id-1);

    [~,order] = sort(p.start(pos_dec),'ascend');
    res.cf(2*order) = res.cf(pos_dec);
    res.cf(2*order-1) = res.cf(pos_amp);
    
else
    % Define fit type
    res = [];

    [str_fit,cell_cf] = getEqExp(strch, nExp);

    ft_ = fittype(str_fit,'dependent',{'y'},'independent',{'x'},'problem', ...
        {'P0','x0'},'coefficients',cell_cf);

    if mute
        fo_ = fitoptions('method','nonlinearleastsquares','lower',p.lower,...
            'upper',p.upper,'startpoint',p.start,'robust','on','display','off');
    else
        fo_ = fitoptions('method','nonlinearleastsquares','lower',p.lower,...
            'upper',p.upper,'startpoint',p.start,'robust','on');
    end


    % Fit model to data
    [cf, gof, output] = fit(x_dat(ok_),y_dat(ok_),ft_, fo_,'problem', ...
        {0,0});
    % get fitting results, reformat
    res.cf = coeffvalues(cf);
    res.gof = gof;
end


