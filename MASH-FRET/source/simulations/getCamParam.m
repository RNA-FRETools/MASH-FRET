function [offset,K,eta] = getCamParam(noiseType,noisePrm)

switch noiseType
    case 'poiss'
        offset = noisePrm(1,1);
        eta = noisePrm(1,2); 
        K = 1;
    case 'norm'
        K = noisePrm(21);
        offset = noisePrm(23);
        eta = noisePrm(26);
    case 'user'
        offset = noisePrm(3,1);
        K = noisePrm(3,5);
        eta = noisePrm(3,6);
    case 'none'
        offset = noisePrm(4,1);
        K = 1;
        eta = 1;
    case 'hirsch'
        g = noisePrm(5,1);
        offset = noisePrm(5,3);
        s = noisePrm(5,5);
        eta = noisePrm(5,6);
        K = g/s;
end