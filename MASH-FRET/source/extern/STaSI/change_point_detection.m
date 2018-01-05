function points = change_point_detection(eff)
    %% The main function to detect all the change points in a trace
    sd = w1_noise(diff(eff))/1.4;% estimate the noise level
    points = recursion1(eff,sd,[], 0);% recursively detect all the change
                                      % points
    points = sort(points);
end

%% 
function points = recursion1(eff, sd, points, counter)
%{
tau998_table = [1:30, 40, 50, 60, 80, 100, 1000;...
    318.31, 22.327, 10.215, 7.173, 5.893, 5.208, 4.785, 4.501, 4.297, 4.144,...
    4.025, 3.93, 3.852, 3.787, 3.733, 3.686, 3.646, 3.61, 3.579, 3.552,...
    3.527, 3.505, 3.485, 3.467, 3.45, 3.435, 3.421, 3.408, 3.396, 3.385,...
    3.307, 3.261, 3.232, 3.195, 3.174, 3.098];% the t-distribution
%}
    N = numel(eff);
    tau998 = 3.174;
    if N < 2% only one point left in the segment, stop searching for the
            % change point
        return
    else
        llr = change_point_wavelet(eff,sd);
        [Z, k] = max(abs(llr));
        if Z > tau998
            counter = 0;
            points(end+1) = k;
            points1 = recursion1(eff(1:k), sd, [], counter);
            points2 = recursion1(eff(k+1:end), sd, [], counter);
            points = [points, points1, points2+k];
        elseif counter < 3% the parameter to dig in and find more
                          % short-lived transitions
            counter = counter +1;
            k = floor(numel(eff)/2);
            points1 = recursion1(eff(1:k), sd, [], counter);
            points2 = recursion1(eff(k+1:end), sd, [], counter);
            points = [points, points1, points2+k];
        else
            counter = 0;
            return
        end
    end
end

%% combine the idea of Haar wavelet and change point method
function llr = change_point_wavelet(eff, sd)
    N = numel(eff);
    llr = zeros(size(eff));
    for i = 1 : N-1
        I1 = mean(eff(1:i));
        I2 = mean(eff(i+1:end));
        llr(i) = (I2 - I1)/sd/sqrt(1/i+1/(N-i));
    end
end