function str_pop = getStrPop(menu, param)

% Last update: 29.5.2019 by MH
% --> reove colors in 'chan' and 'bt_chan' menus
%
% update: 29.3.2019 by MH
% --> Change 'dir_exc' string: remove colors (menu lists laser wavelength 
%     and colors are for channels) and list all lasers but emitter-specific
%     illumination (for which DE=1 and no correction is expected). For this
%     the number of input argument "param" was modified from 4 to 2.

str_pop = {};

switch menu
    
    case 'bg_corr'
        labels = param{1}; exc = param{2}; clr = param{3};
        nChan = size(labels,2);
        for l = 1:numel(exc)
            for c = 1:nChan
                clr_bg_c = sprintf('rgb(%i,%i,%i)', ...
                    round(clr{1}{l,c}(1:3)*255));
                clr_fbt_c = sprintf('rgb(%i,%i,%i)', ...
                    [255 255 255]*(sum(clr{1}{l,c}(1:3)) <= 1.5));
                str_pop = [str_pop ...
                    ['<html><span style= "background-color: ' ...
                    clr_bg_c ';color: ' clr_fbt_c ';">' labels{c} ...
                    ' at ' num2str(exc(l)) 'nm</span></html>']];
            end
        end
        
    case 'chan'
        labels = param{1};
        if ~isempty(param{2})
            curr_exc = param{2};
            clr = param{3};
            for c = 1:size(labels,2)
                str_pop = [str_pop labels{c}];
            end
        else
            str_pop = labels;
        end
        
    case 'bt_chan'
        labels = param{1}; chan = param{2};
        nChan = size(labels,2);
        if nChan > 1
            for i = 1:nChan
                if i ~= chan
                    str_pop = [str_pop labels{i}];
                end
            end
        else
            str_pop = {'none'};
        end
        
    case 'DTA_chan'
        labels = param{1}; FRET = param{2}; S = param{3}; exc = param{4};
        clr = param{5};
        for i = 1:size(FRET,1)
            clr_bg_f = sprintf('rgb(%i,%i,%i)', ...
                round(clr{2}(i,1:3)*255));
            clr_fbt_f = sprintf('rgb(%i,%i,%i)', ...
                [255 255 255]*(sum(clr{2}(i,1:3)) <= 1.5));
            str_pop = [str_pop ['<html><span style= "background-color: '...
                clr_bg_f ';color: ' clr_fbt_f ';">FRET ' labels{FRET(i,1)} ...
                '>' labels{FRET(i,2)} '</span></html>']];
        end
        for i = 1:size(S,1)
            clr_bg_s = sprintf('rgb(%i,%i,%i)', ...
                round(clr{3}(i,1:3)*255));
            clr_fbt_s = sprintf('rgb(%i,%i,%i)', ...
                [255 255 255]*(sum(clr{3}(i,1:3)) <= 1.5));
            str_pop = [str_pop ['<html><span style= "background-color: '...
                clr_bg_s ';color: ' clr_fbt_s ';">S ' labels{S(i,1)} '>' ...
                labels{S(i,2)} '</span></html>']];
        end
        for i = 1:numel(exc)
            for j = 1:size(labels,2)
                clr_bg_c = sprintf('rgb(%i,%i,%i)', ...
                    round(clr{1}{i,j}(1:3)*255));
                clr_fbt_c = sprintf('rgb(%i,%i,%i)', ...
                    [255 255 255]*(sum(clr{1}{i,j}(1:3)) <= 1.5));
                str_pop = [str_pop ...
                    ['<html><span style= "background-color: ' ...
                    clr_bg_c ';color: ' clr_fbt_c ';">' labels{j} ...
                    ' at ' num2str(exc(i)) 'nm</span></html>']];
            end
        end
        
    case 'plot_botChan'
        str_pop = {'none'};
        FRET = param{1}; S = param{2}; exc = param{3}; clr = param{4};
        labels = param{5};
        for i = 1:size(FRET,1)
            clr_bg_f = sprintf('rgb(%i,%i,%i)', ...
                round(clr{2}(i,1:3)*255));
            clr_fbt_f = sprintf('rgb(%i,%i,%i)', ...
                [255 255 255]*(sum(clr{2}(i,1:3)) <= 1.5));
            str_pop = [str_pop ['<html><span style= "background-color: '...
                clr_bg_f ';color: ' clr_fbt_f ';">FRET ' ...
                labels{FRET(i,1)} '>' labels{FRET(i,2)} '</span></html>']];
        end
        for i = 1:size(S,1)
            clr_bg_s = sprintf('rgb(%i,%i,%i)', ...
                round(clr{3}(i,1:3)*255));
            clr_fbt_s = sprintf('rgb(%i,%i,%i)', ...
                [255 255 255]*(sum(clr{3}(i,1:3)) <= 1.5));
            str_pop = [str_pop ['<html><span style= "background-color: '...
                clr_bg_s ';color: ' clr_fbt_s ';">S ' labels{S(i,1)} '>' ...
                labels{S(i,2)} '</span></html>']];
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
        str_pop = {'none'};
        labels = param{1}; curr_exc = param{2}; clr = param{3};
        nChan = size(labels,2);
        if curr_exc > size(clr,1)
            curr_exc = 1;
        end
        for c = 1:nChan
            clr_bg_c = sprintf('rgb(%i,%i,%i)', ...
                round(clr{curr_exc,c}(1:3)*255));
            clr_fbt_c = sprintf('rgb(%i,%i,%i)', ...
                [255 255 255]*(sum(clr{curr_exc,c}(1:3)) <= 1.5));
            str_pop = [str_pop ...
                ['<html><span style= "background-color: ' clr_bg_c ...
                ';color: ' clr_fbt_c ';">' labels{c} ...
                '</span></html>']];
        end
        if nChan > 1
            str_pop = [str_pop 'all'];
        end
        
    case 'bleach_chan'
        labels = param{1}; exc = param{2}; chanExc = param{3}; clr = param{4};
        nChan = numel(chanExc);
        for j = 1:nChan
            if chanExc(j)<=0
                continue
            end
            l0 = find(exc==chanExc(j));
            clr_bg_c = sprintf('rgb(%i,%i,%i)', ...
                round(clr{1}{l0,j}(1:3)*255));
            clr_fbt_c = sprintf('rgb(%i,%i,%i)', ...
                [255 255 255]*(sum(clr{1}{l0,j}(1:3)) <= 1.5));
            str_pop = [str_pop ...
                ['<html><span style= "background-color: ' ...
                clr_bg_c ';color: ' clr_fbt_c ';">' labels{j} ...
                '</span></html>']];
        end
        
    case 'exc'
        exc = param;
        for l = 1:numel(exc)
            str_pop = [str_pop [num2str(exc(l)) 'nm']];
        end
        
    case 'dir_exc'
        
        % modified by MH, 29.3.2019
%         exc = param{1}; curr_exc = param{2}; chanExc = param{3};
%         clr = param{4};
        exc = param{1}; curr_exc = param{2};
        
        if numel(exc) > 1
            for l = 1:numel(exc)
                if l ~= curr_exc
                    
                    % modified by MH, 29.3.2019
%                     clr_bg_c = sprintf('rgb(%i,%i,%i)', ...
%                         round(clr{l,spec_chan}(1:3)*255));
%                     clr_fbt_c = sprintf('rgb(%i,%i,%i)', ...
%                         [255 255 255]*(sum(clr{l,spec_chan}(1:3)) <= 1.5));
%                     str_pop = [str_pop ...
%                         ['<html><span style= "background-color: ' ...
%                         clr_bg_c ';color: ' clr_fbt_c ';">' ...
%                         num2str(exc(l)) 'nm</span></html>']];
                    str_pop = [str_pop [num2str(exc(l)) 'nm']];

                end
            end
        else
            str_pop = {'none'};
        end
        
    case 'plot_exc'
        exc = param;
        for l = 1:numel(exc)
            str_pop = [str_pop [num2str(exc(l)) 'nm']];
        end
        if numel(exc) > 1
            str_pop = [str_pop 'all'];
        end
        
     case 'corr_gamma'
        str_pop = {'none'};
        FRET = param{1}; labels = param{2}; clr = param{3}; 
        for i = 1:size(FRET,1)
            clr_bg_f = sprintf('rgb(%i,%i,%i)', ...
                round(clr{2}(i,1:3)*255));
            clr_fbt_f = sprintf('rgb(%i,%i,%i)', ...
                [255 255 255]*(sum(clr{2}(i,1:3)) <= 1.5));
            str_pop = [str_pop ['<html><span style= "background-color: '...
                clr_bg_f ';color: ' clr_fbt_f ';">FRET ' ...
                labels{FRET(i,1)} '>' labels{FRET(i,2)}]];
        end
end

