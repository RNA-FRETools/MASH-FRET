function def = setExpOpt(opt, p_proj)
% Set default export defions regarding project parameters.
% "p_proj" >> structure containing project parameters
% "def" >> structure containing export defions for each of the n panels
%
% Last update: the 18th of March 2014 by Mélodie C.A.S. Hadzic

nChan = p_proj.nb_channel;
nFRET = size(p_proj.FRET,1);
nS = size(p_proj.S,1);

def.process = 1;
def.mol_valid = 1;
def.mol_TagVal = length(p_proj.molTagNames); % added by FS, 26.4.2018

if ~isfield(opt, 'process')
    opt.process = def.process;
end
if ~isfield(opt, 'mol_valid')
    opt.mol_valid = def.mol_valid;
end
if ~isfield(opt, 'traces')
    opt.traces = [];
end
if ~isfield(opt, 'hist')
    opt.hist = [];
end
if ~isfield(opt, 'dt')
    opt.dt = [];
end
if ~isfield(opt, 'fig')
    opt.fig= [];
end
% add field "mol_TagVal" to p.proj{proj}.exp structure; added by FS, 26.4.2018
if ~isfield(opt, 'mol_TagVal')
    opt.mol_TagVal = def.mol_TagVal;
end

%% trace files

def.traces{1}(1) = 1; % export traces file
def.traces{1}(2) = 1; % export format (ASCII)

def.traces{2}(1) = 1; % export intensities
def.traces{2}(2) = double(nFRET>0); % export FRET
def.traces{2}(3) = double(nS>0); % export S
def.traces{2}(4) = double(nChan>1 | nS>0 | nFRET>0); % all in one file
def.traces{2}(5) = 1; % parameters (in external file)
def.traces{2}(6) = 1; % gamma factors, added by FS, 4.4.2018

opt.traces = adjustVal(opt.traces, def.traces);

%% histogram files

def.hist{1}(1) = 1; % export histogram files
def.hist{1}(2) = 1; % include discretised

 % export intensities & min& binning & max 
def.hist{2}(1,1:4) = [1 -100 50 2000];
% export FRET & min & binning & max
def.hist{2}(2,1:4) = [double(nFRET>0) -0.2 0.01 1.2]; 
% export S & min & binning & max
def.hist{2}(3,1:4) = [double(nS>0) -0.2 0.01 1.2];

opt.hist = adjustVal(opt.hist, def.hist);

%% dwell-time files
def.dt{1} = 1; % export dwell-time files
def.dt{2}(1) = 1; % export intensities
def.dt{2}(2) = double(nFRET>0); % export FRET
def.dt{2}(3) = double(nS>0); % export S
def.dt{2}(4) = 0; % export kinetic file

opt.dt = adjustVal(opt.dt, def.dt);

%% figures
def.fig{1}(1) = 1; % export figures
def.fig{1}(2) = 1; % format (*.pdf)
def.fig{1}(3) = 6; % number of molecule per figure
def.fig{1}(4) = 1; % include subimages
def.fig{1}(5) = 1; % include histograms
def.fig{1}(6) = 1; % include discretised traces
% include top axes & exc & channel (current plot)
def.fig{2}{1} = [1 p_proj.fix{2}(1:2)]; 
% include bottom axes & channel (current plot)
def.fig{2}{2} = [double(nFRET>0 | nS>0) p_proj.fix{2}(3)]; 

opt.fig = adjustVal(opt.fig, def.fig);


