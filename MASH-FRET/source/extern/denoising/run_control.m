function [traj_den] = run_control(fret_shrink, data)
%-------------------------------------------------------------------------%
% run_control.m
% 
% this file gets input from the GUI window and calls the necessary
% scripts.  Little computation is done here. 
%
% modified for SIRA 
%-------------------------------------------------------------------------%

cspin      = fret_shrink.cspin_on;
time_local = fret_shrink.adaptive;
firm       = fret_shrink.firm;
soft       = fret_shrink.soft;
hard       = fret_shrink.hard;

numfiles = 1;

traj = data;
cols = size(traj,2);
traj_den = zeros(size(traj));
for k = 1:cols
    S = traj(:,k);
    S = S';
    % Number of samples in signal
    N = numel(S);
    % Mean of signal
    uS = mean(S);
    Ns = 2^nextpow2(N);
    % Pad signal with mean to next power of 2
    pad = uS*ones(1,(Ns-N));
    S_pad = [S pad];
    % determine highest level of decomposition
    level = nextpow2(N) - 2;
    if cspin
        R = zeros(2^level,Ns);
        for s = 1:2^level
            S_c = circshift(S_pad,[0 s-1]);
            % call denoise.m for each time shift 
            R_c = denoise(S_c,level,time_local,soft,firm);
            % remove the time shift
            R(s,:) = circshift(R_c,[0 1-s]);
        end
        % average the cycle-spun results and remove the pad
        R = mean(R(:,1:N));
    else
        % call denoise.m without cycle-spinning
        R = denoise(S_pad,level,time_local,soft,firm);
        % remove pad
        R = R(1:N);
    end
    % store denoised result in output array
    traj_den(:,k) = R';
end

