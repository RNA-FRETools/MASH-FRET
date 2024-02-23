function p = getDefault_HA
% p = getDefault_HA
%
% Generates default values for Histogram analysis testing
%
% p: structure that contain default parameters

% defaults
nChan_def = 2;
nL_def = 2;
nPop = 4;
defprm = {'Movie name','','';
       'Molecule name','','';
       '[Mg2+]',[],'mM';
       '[K+]',[],'mM'};

% general parameters
[pname,o,o] = fileparts(mfilename('fullpath'));
p.annexpth = cat(2,pname,filesep,'assets'); % path to annexed files
p.dumpdir = cat(2,pname,filesep,'dump'); % path to exported data
if exist(p.dumpdir,'dir')
    cd(p.annexpth); % change directory
    try
        warning off MATLAB:RMDIR:RemovedFromPath
        rmdir(p.dumpdir,'s'); % delete dump directory
    catch err
        disp(cat(2,'WARNING: the previous dump directory could not be ',...
            'deleted (needs administrator privileges).'));
        disp(' ');
    end
end
if ~exist(p.dumpdir,'dir')
    mkdir(p.dumpdir); % create new dump directory
end

% parameters for project management area
p.nChan = nChan_def;
p.nL = nL_def;
p.wl = [];
while isempty(p.wl) || numel(unique(p.wl))~=nL_def
    p.wl = round(1000*sort(rand(1,nL_def))); % laser wavelengths
end
p.mash_file = sprintf('%ichan%iexc.mash',nChan_def,nL_def);
chanExc = zeros(1,nChan_def);
chanExc(1:min([nChan_def,nL_def])) = p.wl(1:min([nChan_def,nL_def]));
nDE = sum(chanExc~=0);
p.es{p.nChan,p.nL}.imp.histfile = 'histfile.hist';
p.es{p.nChan,p.nL}.fstrct = [1,2,1,2];
p.es{p.nChan,p.nL}.div.projttl = sprintf('test_histimport');
p.es{p.nChan,p.nL}.div.molname = 'none';
for l = 1:p.nL
    defprm = cat(1,defprm,{['Power(',num2str(p.wl(l)),'nm)'],'','mW'});
end
p.es{p.nChan,p.nL}.div.expcond = defprm;
p.es{p.nChan,p.nL}.div.splt = 0.2;
p.es{p.nChan,p.nL}.div.plotclr = [1,repmat(rand(1),1,2)];
p.exp_ascii2mash = 'mashfromascii.mash';

% parameters for panel Histogram and plot
p.histDat = 2*p.nChan*p.nL+2*nDE+1;
p.histTag = 1;
p.histPrm = [0,0.01,1,0]; % low, bin, up, overflow
p.exp_overflow = 'histOverflow';

% parameters for panel State configuration
p.cnfgPrm = [5,2,1.2,1]; % Jmax, (1 or 2) penalty or BIC, penalty, (1 or 2) likelihood calculations
p.exp_BICplot = 'GOFplot';
p.exp_BIC = 'config_BIC.txt';
p.exp_penalty = 'config_penalty.txt';
p.exp_config = 'config.mash';

% parameters for panel State populations
p.popMethPrm = [1,0,5,1]; % (1 or 2) gaussian fit or threshold, boba, samples, weighing
thresh = linspace(p.histPrm(1),p.histPrm(3),nPop+1);
p.threshPrm = {nPop-1,thresh(2:end-1)};
amps = repmat(1/nPop,[nPop,1]);
means = linspace(p.histPrm(1),p.histPrm(3),nPop+2)';
fwhms = repmat((p.histPrm(3)-p.histPrm(1))/(4*nPop),[nPop,1]);
p.gaussPrm = {nPop, [permute([zeros(nPop,1) amps Inf(nPop,1)],[3,2,1]);...
    permute([-Inf(nPop,1) means(2:end-1,1) Inf(nPop,1)],[3,2,1]);...
    permute([zeros(nPop,1) fwhms Inf(nPop,1)],[3,2,1])]};
p.exp_pop = 'pop';

% parameters for Visualization area
p.exp_axes = 'axes';

