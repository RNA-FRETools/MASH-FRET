function res = mmexpfit_mod(x_dat, y_dat, p, nExp, strch)

%% Define fit type
res = [];

[str_fit cell_cf] = getEqExp(strch, nExp);

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
    warndlg(sprintf(['Not enough data left to fit equation:\n' str_fit ...
        '\nafter applying exclusion rules.']));

else
    [cf, gof, output] = fit(x_dat(ok_),y_dat(ok_),ft_, fo_,'problem', ...
        {0,0});
    % get fitting results, reformat
    res.cf = coeffvalues(cf);
    res.gof = gof;
end

