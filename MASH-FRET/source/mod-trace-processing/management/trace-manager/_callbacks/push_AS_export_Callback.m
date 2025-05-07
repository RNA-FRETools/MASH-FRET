function push_AS_export_Callback(obj,evd,h_fig)

h = guidata(h_fig);
p = h.param;
proj = p.curr_proj;
projnm = p.proj{proj}.exp_parameters{1,2};
[fle,loc] = uiputfile('.txt','Enter file name',[projnm,'.txt']);
[~,flenm,~] = fileparts(fle);
fle = [loc,flenm,'.txt'];

for chld = h.tm.axes_histSort.Children
    for c = 1:numel(chld)
        if ~isprop(chld(c),'Type')
            continue
        end
        switch chld(c).Type
            case 'histogram'
                edg = chld(c).BinEdges;
                x = mean([edg(1:end-1);edg(2:end)],1);
                cnt = chld(c).BinCounts;

                fhead = 'bin edges\tbin center\tcount\n';
                fdat = [edg',[x,NaN]',[cnt,NaN]'];

                f = fopen(fle,'Wt');
                fprintf(f,fhead);
                fprintf(f,'%d\t%d\t%d\n',fdat');
                fclose(f);
        
                break
    
            case 'histogram2'
                xedg = chld(c).XBinEdges;
                yedg = chld(c).YBinEdges;
                x = mean([xedg(1:end-1);xedg(2:end)],1);
                y = mean([yedg(1:end-1);yedg(2:end)],1);
                cnt = chld(c).BinCounts; % [nbinx-by-nbiny]
                fdat = [[NaN;y'],[x;cnt']];
                save(fle,'fdat','-ascii');
    
                break
    
            otherwise
                continue
        end
    end
end
