% Haran nonlinear Filter: 
% Performs the nonlinear filtering procedure of chung and Kennedy on two
% vectors of et. Weights are combinations of the two separate weights 
% literature: [1] G. Haran, „Noise reduction in single-molecule 
% fluorescence trajectories of folding proteins“, Chemical Physics, 307, 
% 2-3, 137-145, 2004.

function d = nlfilteret(r, f1, f2, length)
    g = size(length,2); % 4
    n = size(r.a,1); % number of frames
    d.a = zeros(n,1);
    d.b = zeros(n,1);
    sum = zeros(n,1);

    
% calculate the predictors and weights; Each predictor has a different 
% running-average length.
for i = 1:g % 1:4
    
    % create arrays filled with zeros that will be filled later in order
    % to increase computation speed.
    ra.b{i} = zeros(n,1);
    ra.f{i} = zeros(n,1);
    rb.b{i} = zeros(n,1);
    rb.f{i} = zeros(n,1);
    w.b{i} = zeros(n,1);
    w.f{i} = zeros(n,1);
    double(w.b{i});
    double(w.f{i});
    
    % calculate averaged trajectories (equations on page 73 of Chung and 
    % Kennedy)
    le = length(i); % window size
    averagea = zeros(n-le,1);
    averageb = zeros(n-le,1);
    
    % Copy values into a new array, divide by window size
    for j = 2:(le+1)
        a = r.a(j:(n-le+j-1));
        b = r.b(j:(n-le+j-1));
        averagea = averagea + a/le;
        averageb = averageb + b/le;
    end
    %SK: Time trace a, backward values
    ra.b{i}(1:(n-le-1)) = averagea(1:(n-le-1));
    %SK: Time trace a, forward values
    ra.f{i}((1+le+1):n) = averagea(1:(n-le-1));
    %SK: Time trace b, backward values
    rb.b{i}(1:(n-le-1)) = averageb(1:(n-le-1));
    %SK: Time trace b, forward values
    rb.f{i}((1+le+1):n) = averageb(1:(n-le-1));
    
   % calculate the weights for each predictor (equations 4,5 in Chung and 
   % Kennedy)
    average.b = zeros((n-f2+1),1);
    average.f = zeros((n-f2+1),1);
    
    for j = 1:f2
        
        % equation 5
        b = (r.a(j:(n-f2+j)) - ra.b{i}(j:(n-f2+j))).^2 + ...
            (r.b(j:(n-f2+j)) - rb.b{i}(j:(n-f2+j))).^2;
        average.b = average.b + b;
        
        % equation 4
        f = (r.a(j:(n-f2+j)) - ra.f{i}(j:(n-f2+j))).^2 + ...
            (r.b(j:(n-f2+j)) - rb.f{i}(j:(n-f2+j))).^2;
        average.f = average.f + f;
    end

    for k = 1:(n-f2+1)
        if average.b(k) == 0
            average.b(k) = 1;
        end
        if average.f(k) == 0
            average.f(k) = 1;
        end
    end
    w.b{i}(1:(n-f2)) = 1./((average.b(1:(n-f2))).^f1);

    w.f{i}((f2+1):n) = 1./((average.f(1:(n-f2))).^f1);


    % calculate normalization constant for weights
    sum = sum + w.b{i} + w.f{i};
    
    % need to make sure no division by zero! need to introduce pi weights!
end

% normalize all weights and generate new data sets
for i = 1:g % 1:4
    w.b{i} = w.b{i}./sum;
    w.f{i} = w.f{i}./sum;
    d.a = d.a + w.f{i}.*ra.f{i} + w.b{i}.*ra.b{i};
    d.b = d.b + w.f{i}.*rb.f{i} + w.b{i}.*rb.b{i};
end

% remove infinities
d.a(find(isnan(d.a))) = mean(d.a);    
d.b(find(isnan(d.b))) = mean(d.b);    

   