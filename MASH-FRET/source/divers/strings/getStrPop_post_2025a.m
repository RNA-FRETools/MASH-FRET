function str_pop = getStrPop_post_2025a(menu, param)

str_pop = {};

switch menu
    
    case 'bg_corr'
        labels = param{1}; exc = param{2}; 
        nChan = size(labels,2);
        for l = 1:numel(exc)
            for c = 1:nChan
                str_pop = cat(2, str_pop, ...
                    [labels{c}, ' at ' num2str(exc(l)) 'nm']);
            end
        end
        
    case 'chan'
        labels = param{1};
        str_pop = labels;
        
    case 'bt_chan'
        labels = param{1}; chan = param{2};
        nChan = size(labels,2);
        if nChan>1
            str_pop = labels;
            str_pop(chan)= [];
        else
            str_pop = {'none'};
        end
        
    case 'DTA_chan'
        labels = param{1}; FRET = param{2}; S = param{3}; exc = param{4};
        for i = 1:size(FRET,1)
            str_pop = cat(2, str_pop, ...
                ['FRET ', labels{FRET(i,1)}, '>' labels{FRET(i,2)}]);
        end
        for i = 1:size(S,1)
            str_pop = cat(2, str_pop, ...
                ['S ' labels{S(i,1)} '>' labels{S(i,2)}]);
        end
        for i = 1:numel(exc)
            for j = 1:size(labels,2)
                str_pop = cat(2, str_pop, ...
                [labels{j}, ' at ', num2str(exc(i)), 'nm']);
            end
        end
        
    case 'plot_botChan'
        str_pop = {'none'};
        FRET = param{1}; S = param{2}; labels = param{5};
        for i = 1:size(FRET,1)
            str_pop = cat(2, str_pop, ...
                ['FRET ', labels{FRET(i,1)},'>',labels{FRET(i,2)}]);
        end
        for i = 1:size(S,1)
            str_pop = cat(2, str_pop, ...
                ['S ', labels{S(i,1)}, '>', labels{S(i,2)}]);
        end
        if size(FRET,1) > 1
            str_pop = [str_pop 'all FRET'];
        end
        if size(S,1) > 1
            str_pop = [str_pop 'all S'];
        end
        if size(FRET,1) > 0 && numel(S) > 0
            str_pop = [str_pop 'all'];
        end
    
    case 'plot_topChan'
        labels = param{1};
        nChan = size(labels,2);
        str_pop = {'none'};
        if nChan>0
            str_pop = [str_pop, labels];
            if nChan > 1
                str_pop = [str_pop 'all'];
            end
        end
        
    case 'bleach_chan'
        labels = param{1}; chanExc = param{3};
        str_pop = labels;
        str_pop(chanExc<=0) = [];
        
    case 'exc'
        exc = param;
        for l = 1:numel(exc)
            str_pop = cat(2, str_pop, [num2str(exc(l)) 'nm']);
        end
        
    case 'dir_exc'
        exc = param{1}; curr_exc = param{2};
        if numel(exc)>1
            for l = 1:numel(exc)
                if l ~= curr_exc
                    str_pop = cat(2, str_pop, [num2str(exc(l)) 'nm']);
                end
            end
        else
            str_pop = {'none'};
        end
        
    case 'plot_exc'
        exc = param;
        for l = 1:numel(exc)
            str_pop = cat(2, str_pop, [num2str(exc(l)) 'nm']);
        end
        if numel(exc) > 1
            str_pop = [str_pop 'all'];
        end
        
     case 'corr_gamma'
        str_pop = {'none'};
        FRET = param{1}; labels = param{2};
        for i = 1:size(FRET,1)
            str_pop = cat(2, str_pop, ...
                ['FRET ' labels{FRET(i,1)} '>' labels{FRET(i,2)}]);
        end
end

