function R = denoise(S,level,time_local,soft,firm)
%-------------------------------------------------------------------------%
% denoise.m
%
% this script does the heavy lifting.  It is called for each input
% trajectory by run_control.m. The script takes the signal trajectory and
% first runs wavelet decompositon with the Haar wavelet.  Thresholding is
% then performed with user-input specs.  The denoised estimate is then
% obtained by inversion of the wavelet transformation.
%
%-------------------------------------------------------------------------%

N = numel(S);

%% Decompose
% Haar low-pass and
phi = [1/sqrt(2) 1/sqrt(2)];
% High-pass filters
psi = [-1/sqrt(2) 1/sqrt(2)];

X = S;
A = cell(1,level);
D = cell(1,level);
for J = 1:level
    n = N/(2^(J-1));
    % convolve signal, then successive approximations
    a = real(ifft(fft(X,n).*fft(phi,n),n));
    % with each filter 
    d = real(ifft(fft(X,n).*fft(psi,n),n));   
    % dyadically downsample and store in cell array
    A{J} = a(2:2:n);
    D{J} = d(2:2:n);
    % set next level's signal to this level's approximation
    X = A{J};
end

%% Threshold
D_t = cell(size(D));
% time local
if time_local
    % firm + time local
    if firm
        for J = 1:level
            sigma = sqrt(mean(reshape(S, 2^J, N/2^J)));
            T1 = 3*sigma;
            T2 = 3.561*sigma;
            d = D{J};
            absd = abs(d);
            sgnd = sign(d);
            d(absd <= T1) = 0;
            sh = find(absd > T1 & absd < T2);
            d(sh) = ...
                T2(sh).*sgnd(sh).*(absd(sh) - T1(sh))./(T2(sh) - T1(sh));
            D_t{J} = d;
        end
    else
        % hard + time local
        for J = 1:level
            T = 3*sqrt(mean(reshape(S,2^J,N/2^J)));
            d = D{J};
            absd = abs(d);
            d(abs(d) <= T) = 0;
            % soft + time local
            if soft
                sgnd = sign(d);
                sh = find(absd > T);
                d(sh) = sgnd(sh).*(absd(sh) - T(sh));
            end
            D_t{J} = d;
        end
    end
    
% universal
else
    % firm + uni
    if firm
        T1 = sqrt(2*log(N)*mean(S));
        load 'upper_th.dat';
        T2 = upper_th(N,2)*sqrt(mean(S));
        for J = 1:level
            d = D{J};
            absd = abs(d);
            sgnd = sign(d);
            d(absd <= T1) = 0;
            sh = find(absd > T1 & absd < T2);
            d(sh) = T2.*sgnd(sh).*(absd(sh) - T1)./(T2 - T1);
            D_t{J} = d;
        end
        
    % hard + uni
    else
        T = sqrt(2*log(N)*mean(S));
        for J = 1:level
            d = D{J};
            d(abs(d) <= T) = 0;
            
            % soft + uni
            if soft
                sh = find(d > T);
                d(sh) = sign(d(sh)).*(abs(d(sh)) - T);
            end
            D_t{J} = d;
        end
    end
end


%% Reconstruct
% the low-pass filter remains the same
psi = [1/sqrt(2) -1/sqrt(2)];

a = A{level};
R = cell(1,level);
A_up = cell(1,level);
D_up = cell(1,level);
for J = level:-1:1
    n = 2*numel(a);
    d = D_t{J};
    % dyadically upsample
    a = reshape([a; zeros(size(a))],1,n);
    d = reshape([d; zeros(size(d))],1,n);
    % convolve with appropriate filter
    A_up{J} = real(ifft(fft(a,n).*fft(phi,n),n));
    D_up{J} = real(ifft(fft(d,n).*fft(psi,n),n));
    % obtain denoised estimate 
    R{J} = A_up{J} + D_up{J};
    % set next level's approximation to this level's estimate
    a = R{J};
end

% denoised estimate
R = R{1};


