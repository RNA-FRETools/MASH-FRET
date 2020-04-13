function createSimPrm(varargin)
% | Create a structure of pre-set parameters and export it to a Matlab 
% | binary file. The created file can be directly imported in MASH-FRET's
% | Simulation module.
% |
% | Edit the source code of this function to set your own parameters.
% |
% | command: createSimPrm
% | argument1 (optional) >> destination file including directory path
% |
% | example: createSimPrm('C:\MyDataFolder\experiment_01\model_01.mat');

% Last update: 19.4.2019 by MH
% >> allow script execution without input argument (ask for destination
%    file with uiputfile)
% >> manage communication with disp


%% %% STATE CONFIGURATION %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% FRET = [J-by-2-by-N] matrix containing FRET values column 1 and FRET 
% deviations in column 2

% example: 9-state model with:
% - 2 degenerated states at FRETj=0.08 and no heterogemeity
% - 6 degenerated states at FRETj=0.24 and no heterogeneity
% - 3 degenerated states at FRETj=0.38 and no heterogeneity
% - 1 state at FRETj=0.6 with deviation wFRETj=0.02
% 
% FRET = cat(1, ...
%     repmat([0.08 0],[2 1]), ...
%     repmat([0.24 0],[6 1]), ...
%     repmat([0.38 0],[3 1]), ...
%     [0.60 0.02]);
%
% N = 56; % number of molecules to simulate 
%
% FRET = repmat(FRET,[1,1,N]);

%%%%% EDIT HERE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

FRET = [];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%% %% RESTRICTED STATE TRANSITION RATES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% trans_rates = [J-by-J-by-N] matrix containing transition rates from state
% j to j' in trans_rates(j,j')
% A rate of 0 means a forbidden transition.

% example: very complicated 19-states transition matrix with many 
% degenrated states (rates were taken from multi exponential fits on 
% experimental dwell time histograms in Transition analysis)
%
% k1a2 = 19.02692; % FRET1 to FRET2, 1st rate
% k1b2 = 17.10321; % FRET1 to FRET2, 2nd rate
% k1c2 = 10.33113; % FRET1 to FRET2, 3rd rate
% k2a1 = 72.35241; % FRET2 to FRET1, 1st rate
% k2b1 = 7.36367; %  FRET2 to FRET1, 2nd rate
% k2c1 = 7.36366; %  FRET2 to FRET1, 3rd rate
% k2af = 5.99528; %  FRET2 to FRET3, 1st rate
% k2bf = 13.28571; % FRET2 to FRET3, 2nd rate
% k2cf = 1.58003; %  FRET2 to FRET3, 3rd rate
% kfa2 = 1.54325; %  FRET3 to FRET2, 1st rate
% kfb2 = 4.03368; %  FRET3 to FRET2, 2nd rate
% kfc2 = 2.14883; %  FRET3 to FRET2, 3rd rate
% kfan = 15.25118; % FRET3 to FRET4, 1st rate
% kfbn = 1.6639; %   FRET3 to FRET4, 2nd rate
% knf = 9.89685; %   FRET4 to FRET3, 1st rate
% 
% trans_rates = [
%     0    0    0    k1a2 k1a2 k1a2 k1a2 k1a2 k1a2 k1a2 k1a2 k1a2 0    0    0    0    0    0    0
%     0    0    0    k1b2 k1b2 k1b2 k1b2 k1b2 k1b2 k1b2 k1b2 k1b2 0    0    0    0    0    0    0
%     0    0    0    k1c2 k1c2 k1c2 k1c2 k1c2 k1c2 k1c2 k1c2 k1c2 0    0    0    0    0    0    0
%     k2a1 k2a1 k2a1 0    0    0    0    0    0    0    0    0    k2af k2af k2af k2af k2af k2af 0
%     k2b1 k2b1 k2b1 0    0    0    0    0    0    0    0    0    k2af k2af k2af k2af k2af k2af 0
%     k2c1 k2c1 k2c1 0    0    0    0    0    0    0    0    0    k2af k2af k2af k2af k2af k2af 0
%     k2a1 k2a1 k2a1 0    0    0    0    0    0    0    0    0    k2bf k2bf k2bf k2af k2af k2af 0
%     k2b1 k2b1 k2b1 0    0    0    0    0    0    0    0    0    k2bf k2bf k2bf k2af k2af k2af 0
%     k2c1 k2c1 k2c1 0    0    0    0    0    0    0    0    0    k2bf k2bf k2bf k2af k2af k2af 0
%     k2a1 k2a1 k2a1 0    0    0    0    0    0    0    0    0    k2cf k2cf k2cf k2af k2af k2af 0
%     k2b1 k2b1 k2b1 0    0    0    0    0    0    0    0    0    k2cf k2cf k2cf k2af k2af k2af 0
%     k2c1 k2c1 k2c1 0    0    0    0    0    0    0    0    0    k2cf k2cf k2cf k2af k2af k2af 0
%     0    0    0    kfa2 kfa2 kfa2 kfa2 kfa2 kfa2 kfa2 kfa2 kfa2 0    0    0    0    0    0    kfan
%     0    0    0    kfb2 kfb2 kfb2 kfb2 kfb2 kfb2 kfb2 kfb2 kfb2 0    0    0    0    0    0    kfan
%     0    0    0    kfc2 kfc2 kfc2 kfc2 kfc2 kfc2 kfc2 kfc2 kfc2 0    0    0    0    0    0    kfan
%     0    0    0    kfa2 kfa2 kfa2 kfa2 kfa2 kfa2 kfa2 kfa2 kfa2 0    0    0    0    0    0    kfbn
%     0    0    0    kfb2 kfb2 kfb2 kfb2 kfb2 kfb2 kfb2 kfb2 kfb2 0    0    0    0    0    0    kfbn
%     0    0    0    kfc2 kfc2 kfc2 kfc2 kfc2 kfc2 kfc2 kfc2 kfc2 0    0    0    0    0    0    kfbn
%     0    0    0    0    0    0    0    0    0    0    0    0    knf  knf  knf  knf  knf  knf  0   ];
%
%
% trans_rates = repmat(trans_rates,[1,1,N]);

%%%%% EDIT HERE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

trans_rates = [];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% %% TRANSITION REPARTITION PROBABILITY %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% trans_prob = [J-by-J-by-N] matrix containing transition repartition 
% probbailities  from state j to j' in trans_rates(j,j')
% Diagonal terms must be null.

% example: 4-state matrix
%
% trans_prob = [0 1 0
%     0.1 0 0.9
%     0.5 0.5 0];
%
% trans_prob = repmat(trans_prob,[1,1,N]);

%%%%% EDIT HERE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

trans_prob = [];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% %% INITIAL STATE PROBABILITY %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% ini_prob = [N-by-J] matrix containing initial state probbailities for the
% J states.

% example: 4 states
%
% ini_prob = [0.1 0.5 0.3 0.1];
%
% ini_prob = repmat(ini_prob,[N,1]);

%%%%% EDIT HERE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

ini_prob = [];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%% %%% GAMMA FACTORS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% gamma = [N-by-2] array containting gamma factors in column 1 and gamma
% factor heterogeneous broadening widths in column 2
%
% example: no fluorescence anisotropy (gamma=1) for half the sample and 
% gamma=0.8 for the other half with no deviation.
%
% gamma = [ones(N,1) zeros(N,1)];
% gamma(round(N/2):N,1) = 0.8;

%%%%% EDIT HERE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

gamma = [];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%% %% DONOR EMISSION INTENSITY IN ABSENCE OF ACCEPTOR %%%%%%%%%%%%%%%%%%%%%
% tot_intensity = [N-by-2] array containting donor emission intensity 
% Itot,em in absence of acceptor in column 1 and deviations in column 2
%
% example: fluorescence intensity of 56 pc and a deviation of 6 pc.
%
% tot_intensity = repmat([56,6],N,1);

%%%%% EDIT HERE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

tot_intensity = [];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%% %%% COORDINATES %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% coordinates = [N-by-2] or [N-by-4] array containing molecule coordinates
% in donor and/or acceptor channel with the x-positions in odd columns and
% y-positions in even columns
%
% example: N molecules evenly spread on a 512x512 frame
%
% x =linspace(1,255,32);
% y =linspace(1,511,32);
% [X,Y] = meshgrid(x,y);
% X = reshape(X,[numel(X),1]);
% Y = reshape(Y,[numel(Y),1]);
% coordinates = [X Y];
% coordinates = coordinates(1:N,:);

%%%%% EDIT HERE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

coordinates = [];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%% %%% PSF STANDARD DEVIATIONS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% psf_width = [N-by-1] or [N-by-2] array containing PSF standard deviations 
% in donor and/or acceptor channel
%
% example: N molecules with increasing with regular interval from 0.1 to 2
%
% psf_width = linspace(0.1,2,N)';

%%%%% EDIT HERE %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

psf_width = [];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



%% %%% SAVE CREATED FIELDS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if ~isempty(varargin)
    file = varargin{1};
else
    [fname,pname,o] = uiputfile('*.mat','Export presets to file');
    if ~(~isempty(pname) && ~isempty(fname) && sum(fname) && sum(pname))
        return;
    end
    cd(pname);
    file = cat(2,pname,fname);
end

save(file,'FRET','trans_rates','trans_prob','gamma','tot_intensity',...
    'coordinates','psf_width','-mat');

disp(cat(2,'Preset parameters were successfully written in file: ',file));


