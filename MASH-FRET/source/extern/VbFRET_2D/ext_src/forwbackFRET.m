function  [wa, wpi, xbar, S, Nk, lnZ] = forwbackFRET(A,px_z,pz,data)

% function  [wa, wpi, xbar, S, Nk, lnZ] = forwbackFRET(A,px_z,pz,data)
%          
% Performs forward-backward message passing for HMMs
% 
% Inputs:
%   A (K by K) - state transition probabilities
%   px_z (T by K) - estimated probabilities of the observed data given each
%   hidden state at each time point in the trace.
%   pz (1 by K) - initial state prior
%   data: trace of data points
%   Note these probabilities can be sub-normalised.
%
% Outputs:
%   wa (K by K) - transition matrix prior counts. Formerly called Xi in
%       Beal's code, but relabeled at the end of this function to wa to be
%       consistent with our notation.
%   wpi (1 by K) - initial state prior counts
%   xbar (D by K) - estimated mean's of gaussian clusters. xbar for state k
%       is calculated by weighting each data point by its responsiblity to
%       group k and then taking the mean of the data.
%   S (D by D by K) - estimate of hyperparameter used in Wishart prior
%   Nk (1 by K) - total number of data points in cluster k (sum of
%       responsiblities)
%   lnZ (1 by 1) - log likelihood of all data
% % %   lnZv (N by 1) - log likelihood of each data string - not calculated
%       or used anymore
%
% M J Beal 13/04/02
% last edited fall 2009 by Jonathan E Bronson (jeb2126@columbia.edu) for 
% http://vbfret.sourceforge.net

K = size(A,1);
[D T] = size(data);
Xi = zeros(K,K);
GammaInit = zeros(1,K); % for the pi
%lnZv = zeros(N,1);
Nk = zeros(K,1);
xbar = zeros(D,K);
S = zeros(D,D,K);

  %initializing this array might take a long time, 
  % maybe move it outside the fxn call?
  Gamma = zeros(T,K);
  alpha = zeros(T,K);
  beta = zeros(T,K);
  scale = zeros(1,T);
  
  % pzck out the likelihood of each symbol in the sequence
  % px_z = the transpose of a kxn matrix where 
  %px_z = pXgivenZtilde;     %B(:,data{n})';  
                           %each row is the likelihood of the data 
                           %assuming the system is in state K
                           
  % Forward pass (with scaling)
  alpha(1,:) = pz.*px_z(1,:); %1xK vector of p(z)p(x|z) for each state
  scale(1) = sum(alpha(1,:));
  alpha(1,:) = alpha(1,:)/scale(1); %work with rescaled probabilites
  for t=2:T
    alpha(t,:) = (alpha(t-1,:)*A).*px_z(t,:); 
    scale(t) = sum(alpha(t,:));
    alpha(t,:) = alpha(t,:)/scale(t); %nxk matrix
  end;
  
  % Backward pass (with scaling)
  beta(T,:) = ones(1,K)/scale(T);
  for t=T-1:-1:1
    beta(t,:) = (beta(t+1,:).*px_z(t+1,:))*A'/scale(t);  
  end;
  
  % Another pass gives us the joint probabilities
  for t=1:T-1
      Xi=Xi+A.*(alpha(t,:)'*(beta(t+1,:).*px_z(t+1,:))); 
  end;
  
  % Compute Gamma
  Gamma = alpha.*beta;
  Gamma = Gamma./repmat(sum(Gamma,2),1,K);
  
  % Compute the sums of Gamma conditioned on k
%   for t = 1:T(n)
%     Gammak(:,data{n}(t)) = Gammak(:,data{n}(t)) + Gamma(t,:)';
%   end;
   
  GammaInit = GammaInit + Gamma(1,:); 
   lnZv = sum(log(scale));

    Nk = Nk + sum(Gamma,1)';
    for k=1:K
        % NB: not actually xbar until divide by Nk after loop
        xbar(:,k) = sum(repmat(Gamma(:,k)',D,1).*data,2); 
    end

lnZ = sum(lnZv,1);
wa = Xi;
wpi = GammaInit;

% add a non-zero term for the components with zero responsibilities
Nk = Nk + 1e-10; 

% rescale xbar(k), S(k)
xbar = xbar./repmat(Nk',D,1);


for k=1:K
    diff1 = data - repmat(xbar(:,k),1,T);
    diff2 = repmat(Gamma(:,k)',D,1).*diff1;
    S(:,:,k) = S(:,:,k) + (diff2*diff1');%/Nk(k);
end

%Nk3d is just Nk tiled over a DxDxK matrix so that I can divide S by Nk
Nk3d = zeros(D,D,K);

for k=1:K
    Nk3d(:,:,k)=Nk(k);
end

S = S ./ Nk3d;
