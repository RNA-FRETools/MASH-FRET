function push_AS_export_Callback(obj,evd,h_fig)

h = guidata(h_fig);
p = h.param;
proj = p.curr_proj;
projnm = p.proj{proj}.exp_parameters{1,2};
[fle,loc] = uiputfile('.txt','Enter file name',projnm);
if isempty(fle) || (isscalar(fle) && fle==0)
    return
end
[~,flenm,~] = fileparts(fle);
if strcmp(flenm(end-length('_autosort')+1:end),'_autosort')
    flenm = flenm(1:end-length('_autosort'));
end
fle = [loc,flenm,'_autosort.txt'];
               
% collect data names
xdat = removeHtml(...
    h.tm.popupmenu_selectXdata.String{h.tm.popupmenu_selectXdata.Value});
xval = removeHtml(...
    h.tm.popupmenu_selectXval.String{h.tm.popupmenu_selectXval.Value});
ydat = removeHtml(...
    h.tm.popupmenu_selectYdata.String{h.tm.popupmenu_selectYdata.Value});
yval = removeHtml(...
    h.tm.popupmenu_selectYval.String{h.tm.popupmenu_selectYval.Value});

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
                fprintf(f,'data: %s, %s\n',xdat,xval);
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
                fmt = repmat('%d\t',1,size(fdat,2));
                fmt(end) = 'n';

                f = fopen(fle,'Wt');
                fprintf(f,'x-data: %s, %s\n',xdat,xval);
                fprintf(f,'y-data: %s, %s\n',ydat,yval);
                fprintf(f,fmt,fdat');
                fclose(f);
    
                break
    
            otherwise
                continue
        end
    end
end
