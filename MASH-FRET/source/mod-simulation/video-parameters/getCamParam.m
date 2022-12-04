function [mu_y_dark,K,eta] = getCamParam(noiseType,noisePrm)

switch noiseType
    case 'poiss'
        mu_y_dark = noisePrm(1,1);
        eta = noisePrm(1,3); 
        K = 1;
    case 'norm'
        mu_y_dark = noisePrm(2,1);
        eta = noisePrm(2,3);
        K = noisePrm(2,5);
    case 'user'
        mu_y_dark = noisePrm(3,1);
        eta = noisePrm(3,3);
        K = noisePrm(3,5);
    case 'none'
        mu_y_dark = noisePrm(4,1);
        eta = 1;
        K = 1;
    case 'hirsch'
        mu_y_dark = noisePrm(5,1);
        eta = noisePrm(5,3);
        g = noisePrm(5,5);
        s = noisePrm(5,6);
        K = g/s;
end