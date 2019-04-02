function [mu_ic_d,o_ic,A_cic,tau_cic] = ...
    fit_NExpN(mu_ic_0,P,mu_ic_d,o_ic,A_cic,tau_cic,logFit)
% [mu_ic_d,o_ic,A_cic,tau_cic] = ...
%    fit_NExpN(mu_ic_0,P,mu_ic_d,o_ic,A_cic,tau_cic,logFit);
%
% Description:
%    Fit a mixture of one Gaussian with one exponential decay function to
%    P(mu_ic_0) or log[P(mu_ic_0)] data. Logarithm of P data is necessary 
%    to fit small exponential contributions.
%
% Input arguments:
%    mu_ic_0: column vector of x values (e.g. pixel intenities)
%    P:       column vector of probabilities
%    mu_ic_d: starting guess of mean value of the Gaussian in the mixture
%    o_ic:    starting guess of standard deviation of the Gaussian in the 
%             mixture
%    A_cic:   starting guess of exponential contribution to the mixture 
%             (between 0 and 1)
%    tau_cic: starting guess of decay constant of the exponential in the 
%             mixture
%    logFit:  0 or 1 to fit P or log(P)

% correct x and P data dimensions if necessary
if size(mu_ic_0,2)>size(mu_ic_0,1)
    mu_ic_0 = mu_ic_0';
end
if size(P,2)>size(P,1)
    P = P';
end

% transform P data to log(P) data if desired
if logFit
    logP = log(P);
end

% define fit parameters starting guess and boundaries
p.lower = [0 -Inf 0 0];
p.start = [A_cic mu_ic_d o_ic tau_cic];
p.upper = [1 Inf Inf Inf];

% build fit function
if logFit
    NExpN = @(A_cic,mu_ic_d,o_ic,tau_cic,x) ...
        log((1-A_cic)*(1/(sqrt(2*pi)*o_ic))*exp(-((x-mu_ic_d).^2)/...
        (2*(o_ic^2))) + 0.5*A_cic*exp((o_ic^2)/(2*(tau_cic^2))-...
        (x-mu_ic_d)./tau_cic).*(1-erf(o_ic/(sqrt(2)*tau_cic)-...
        (x-mu_ic_d)./(sqrt(2)*o_ic))));
else
    NExpN = @(A_cic,mu_ic_d,o_ic,tau_cic,x) ...
        (1-A_cic)*(1/(sqrt(2*pi)*o_ic))*exp(-((x-mu_ic_d).^2)/(2*(o_ic^2)))...
        + 0.5*A_cic*exp((o_ic^2)/(2*(tau_cic^2))-(x-mu_ic_d)./tau_cic).*...
        (1-erf(o_ic/(sqrt(2)*tau_cic)-(x-mu_ic_d)./(sqrt(2)*o_ic)));
end

% set fit object and options
ft_ = fittype(NExpN,'dependent',{'y'},'independent',{'x'});
fo_ = fitoptions('method','nonlinearleastsquares','lower',p.lower,...
    'upper',p.upper,'startpoint',p.start,'maxiter',10000,'maxfuneval', ...
    10000,'robust','lar','tolfun',1E-10,'tolx',1E-10);

% fit function to data
disp('fitting in progress ...');
try
    if logFit
        [cf,gof,op] = fit(mu_ic_0, logP, ft_, fo_);
    else
        [cf,gof,op] = fit(mu_ic_0, P, ft_, fo_);
    end
    
catch err
    if ~logFit && strcmp(err.identifier,'curvefit:fit:nanComputed')
        disp('fitting cannot continue: NaN computed by model function');
        disp(cat(2,'try using input argument logFit=1 to fit ',...
            'log-probabilities'));
        return;
    else
        throw(err);
    end
end
disp('fitting completed.');

% get best fit parameters
cf_val = coeffvalues(cf);
A_cic = cf_val(1);
mu_ic_d = cf_val(2);
o_ic = cf_val(3);
tau_cic = cf_val(4);

% calcuate best fit function
if logFit
    logP_fit = NExpN(A_cic,mu_ic_d,o_ic,tau_cic,mu_ic_0);
    P_fit = exp(logP_fit);
else
    P_fit = NExpN(A_cic,mu_ic_d,o_ic,tau_cic,mu_ic_0);
end

% plot data and best fit function
f = figure('NumberTitle','off','Name','Fitting results');
a = axes('parent',f');
plot(a,mu_ic_0,P,'+k');
set(a,'nextplot','add');
plot(a,mu_ic_0,P_fit,'-r');
set(a,'yscale','log','xlim',[mu_ic_0(1),mu_ic_0(end)],'ylim',...
    [min(P),max(P)],'nextplot','replace');
xlabel(a,'pixel intensity');
ylabel(a,'normalized probability');

% display best fit parameters
disp(sprintf(cat(2,'fitting results:\n\tA_cic = ',num2str(A_cic),'\n',...
    '\tmu_ic_d = ',num2str(mu_ic_d),'\n\to_ic = ',num2str(o_ic),'\n',...
    '\ttau_cic = ',num2str(tau_cic),'\n\tSSE=',num2str(gof.sse),', ',...
    'R^2=',num2str(gof.rsquare),', DFE=',num2str(gof.dfe),', ',...
    'R^2 adj.=',num2str(gof.adjrsquare),', RMSE=',num2str(gof.rmse),'')));


