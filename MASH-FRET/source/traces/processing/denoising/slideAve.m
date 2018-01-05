function I_den = slideAve(I_raw, n)

if n<2
    I_den = I_raw;
    return;
end

I_den = [];

% make the data circular
for i_n = 1:n
    I_den = [I_den [I_raw((end-i_n+1):end,:);I_raw;I_raw(1:(n-i_n),:)]];
end

% average
I_den = mean(I_den,2);

% restore the linear data
I_den = I_den(ceil(n/2)+1:end-ceil((n-1)/2),:);


