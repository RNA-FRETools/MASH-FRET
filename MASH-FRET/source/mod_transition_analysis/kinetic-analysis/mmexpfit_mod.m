function res = mmexpfit_mod(x_dat, y_dat, p, nExp, strch)

%% Define fit type
res = [];

[str_fit,cell_cf] = getEqExp(strch, nExp);

ft_ = fittype(str_fit,'dependent',{'y'},'independent',{'x'},'problem', ...
    {'P0','x0'},'coefficients',cell_cf);


%% Set fit options
excl_x = [x_dat(1) x_dat(end)];
ex_ = false(size(x_dat));
ex_([[]]) = 1;
ex_ = ex_ | ~(excl_x(1)<x_dat & x_dat<excl_x(2));
ok_ = ~(isnan(x_dat) | isnan(y_dat));

fo_ = fitoptions('method','nonlinearleastsquares','lower',p.lower,...
    'upper',p.upper,'startpoint',p.start,'robust','on');


%% Fit model to data
if sum(~ex_(ok_))<2  % too many points excluded
    return;

else
    [cf, gof, output] = fit(x_dat(ok_),y_dat(ok_),ft_, fo_,'problem', ...
        {0,0});
    % get fitting results, reformat
    res.cf = coeffvalues(cf);
    res.gof = gof;
    
    % re-establish order of decays in starting guess
    if ~strch
        pos_dec = 2:2:size(res.cf,2);
        pos_amp = 1:2:(size(res.cf,2)-1);
        [res.cf(pos_dec),id] = sort(res.cf(pos_dec),'ascend');
        res.cf(pos_amp) = res.cf(2*id-1);
        
        [~,order] = sort(p.start(pos_dec),'ascend');
        res.cf(2*order) = res.cf(pos_dec);
        res.cf(2*order-1) = res.cf(pos_amp);
    end
end

