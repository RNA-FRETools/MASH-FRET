function stop_flag = incomplete_data_check(plot_blur_rm,analysis_remove_blur,dat)
% last edited fall 2009 by Jonathan E Bronson (jeb2126@columbia.edu) for 
% http://vbfret.sourceforge.net


stop_flag = 0;

% error if tyring to analyze blur data before any is fit
if plot_blur_rm*analysis_remove_blur*isempty(dat.z_hat_db)
        flag.type = 'incomplete data';
        flag.problem = 'no cleaned traces';
        vbFRETerrors(flag);
        stop_flag = 1;
        
% warn if analyzing blur data and not all data is fit yet
elseif plot_blur_rm*analysis_remove_blur
    for n = 1:length(dat.z_hat_db)
        if isempty(dat.z_hat_db{n})
            flag.type = 'incomplete data';
            flag.problem = 'incomplete analysis';
            vbFRETerrors(flag);
            return
        end
    end
% warn if analyzing non-blur data and not all data is fit yet
else
    for n = 1:length(dat.z_hat)
        if isempty(dat.z_hat{n})
            flag.type = 'incomplete data';
            flag.problem = 'incomplete analysis';
            vbFRETerrors(flag);
            return
        end
    end
end    