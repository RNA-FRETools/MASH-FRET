function [dat err] = load_path_data(filname, dat)
% last edited fall 2009 by Jonathan E Bronson (jeb2126@columbia.edu) for 
% http://vbfret.sourceforge.net

err = 0;

try
    [ignore,label_n,ext,ignore]=fileparts(filname);
    
    trace = load(filname);
    
    raw = trace(:,2:3);

    xhat = trace(:,5);
    
    % infer z_hat from x_hat
    zhat = xhat;
    xunique = unique(xhat);
    for i = 1:length(xunique)
        zhat(zhat == xunique(i)) = i;
    end
    
    % generate 2D x_hat
    xhat_2D = x_hat_2D(zhat,raw);
    
    % append trace in current file to existing traces
    q = length(dat.raw_bkup) + 1;

    % update backup traces
    dat.raw_bkup{q} = raw;
    dat.labels_bkup{q} = label_n;

    %update raw traces
    dat.raw{q} = dat.raw_bkup{q};
    dat.labels{q} = dat.labels_bkup{q};

    %update x_hat & z_hat
    dat.x_hat{1,q} = xhat;
    dat.x_hat{2,q} = xhat_2D;
    dat.z_hat{q} = zhat;
    
catch
    flag.type = 'importData';
    flag.problem = 'load data error';
    flag.filname = [label_n ext];
    err = 1;
    vbFRETerrors(flag);
    return
end
