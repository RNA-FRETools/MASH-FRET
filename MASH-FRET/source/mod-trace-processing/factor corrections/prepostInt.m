% get intensity before and after photobleaching of the acceptor fluorophore
% FS, last updated on 12.1.18
% MH, last update on 27.3.2019 >> i've updated the function to be usable in
% "gammaOpt.m" without messing up with molecule processing parameters 
% p.proj{proj}.prm{mol}. Processing parameters are now set only in the 
% combined function "gammaCorr.m" which is called by "updateTraces.m" (and
% thus "updateFields.m").

function [gamma,ok] = prepostInt(stop, I_D, I_A)

ok = 0;
gamma = 1;

L = size(I_A,1);
tol = 3; % tolerance around cutoff

% determine DTA intensities prior to and after the calculated cutoff
if (stop+tol)<L && (stop-tol)>1

    I_pre = [I_D(stop-tol,1) I_A(stop-tol,1)];
    I_post = [I_D(stop+tol,1) I_A(stop+tol,1)];

    if (I_pre(1)~=I_post(1)) && (I_pre(2)~=I_post(2)) % is donor or acceptor intensity equal before and after the cutoff, (acceptor condition added by FS, 5.6.2018)
        gamma = (I_pre(2)-I_post(2))/(I_post(1)-I_pre(1));
        ok = 1;
    else
        if I_pre(1)==I_post(1)
            disp(cat(2,'donor intensities before and after photobleaching',...
                ' cutoff are identical'));
        else
            disp(cat(2,'acceptor intensities before and after ',...
                'photobleaching cutoff are identical'));
        end
    end

else
    disp(cat(2,'no photobleaching detected in acceptor intensity-time',...
        'trace'));
end
end
