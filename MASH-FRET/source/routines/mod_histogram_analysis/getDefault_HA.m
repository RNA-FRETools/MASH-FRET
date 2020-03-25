function p = getDefault_HA
% p = getDefault_HA
%
% Generates default values for Histogram analysis testing
%
% p: structure that contain default parameters

% defaults
nChan_min = 2;
nChan_max = 3;
nL_max = 3;
nChan_def = 2;
nL_def = 2;
nPop = 4;

% general parameters
[pname,o,o] = fileparts(mfilename('fullpath'));
p.annexpth = cat(2,pname,filesep,'assets'); % path to annexed files
p.dumpdir = cat(2,pname,filesep,'dump'); % path to exported data
if exist(p.dumpdir,'dir')
    cd(p.annexpth); % change directory
    try
        rmdir(p.dumpdir); % delete dump directory
    catch err
        disp(cat(2,'WARNING: the previous dump directory could not be ',...
            'deleted (needs administrator privileges).'));
        disp(' ');
    end
end
if ~exist(p.dumpdir,'dir')
    mkdir(p.dumpdir); % create new dump directory
end
p.nChan_min = nChan_min;
p.nChan_max = nChan_max;
p.nL_max = nL_max;

% parameters for project management area
p.nChan = nChan_def;
p.nL = nL_def;
p.wl = [];
while isempty(p.wl) || numel(unique(p.wl))~=nL_max
    p.wl = round(1000*sort(rand(1,nL_max))); % laser wavelengths
end
p.mash_file = sprintf('%ichan%iexc.mash',nChan_def,nL_def);
for nL = 1:nL_max
    for nChan = nChan_min:nChan_max 
        chanExc = zeros(1,nChan);
        FRET = [];
        chanExc(1:min([nChan,nL])) = p.wl(1:min([nChan,nL]));
        for don = 1:(nChan-1)
            if chanExc(don)>0
                for acc = (don+1):nChan
                    FRET = cat(1,FRET,[don,acc]);
                end
            end
        end
        nFRET = size(FRET,1);
    end
end


% parameters for panel Histogram and plot
p.histDat = 2*p.nChan*p.nL+1;
p.histTag = 1;
p.histPrm = [0,0.01,1,0]; % low, bin, up, overflow
p.exp_overflow = 'histOverflow';

% parameters for panel State configuration
p.cnfgPrm = [5,2,1.2]; % Jmax, (1 or 2) penalty or BIC, penalty
p.exp_BICplot = 'GOFplot';
p.exp_BIC = 'config_BIC.txt';
p.exp_penalty = 'config_penalty.txt';
p.exp_config = 'config.mash';

% parameters for panel State populations
p.popMeth = [1,0,5,1]; % (1 or 2) gaussian fit or threshold, boba, samples, weighing
thresh = linspace(p.histPrm(1),p.histPrm(3),nPop+1);
p.threshPrm = {nPop-1,thresh(2:end-1)};
amps = repmat(1/nPop,[nPop,1]);
means = linspace(p.histPrm(1),p.histPrm(3),nPop+2)';
fwhms = repmat((p.histPrm(3)-p.histPrm(1))/(4*nPop),[nPop,1]);
p.gaussPrm = {nPop, [permute([zeros(nPop,1) amps Inf(nPop,1)],[3,2,1]);...
    permute([-Inf(nPop,1) means(2:end-1,1) Inf(nPop,1)],[3,2,1]);...
    permute([zeros(nPop,1) fwhms Inf(nPop,1)],[3,2,1])]};

% parameters for Visualization area
