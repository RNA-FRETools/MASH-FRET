function plotData_videoView(h_fig)

% Last update: 24.8.2019 by MH
% >> adjust axes limits

% defaults 
mg_top = 0.4;
mksz = 10;
lineWidth = 2;

h = guidata(h_fig);
p = h.param;
proj = p.curr_proj;
nExc = p.proj{proj}.nb_excitations;
nChan = p.proj{proj}.nb_channel;
clr = h.tm.molTagClr;
coord = p.proj{proj}.coord;
molTags = h.tm.molTag;

nVid = numel(h.tm.axes_videoView);

% abort if no average image or coordinates are available in project
if ~(isfield(p.proj{proj},'aveImg') && ...
        size(p.proj{proj}.aveImg,2)==(nExc+1) && ~isempty(coord))
    if ~isfield(h.tm,'text_novid')
        
        for vid = 1:nVid
            xLim = get(h.tm.axes_videoView(vid),'xlim');
            yLim = get(h.tm.axes_videoView(vid),'ylim');

            h.tm.text_novid(2*vid-1) = text(h.tm.axes_videoView(vid),0,0,...
                'View on video is not available:');
            h.tm.text_novid(2*vid) = text(h.tm.axes_videoView(vid),0,0,...
                ['no video and/or molecule coordinates are assigned to ',...
                'the project.']);

            pos1 = get(h.tm.text_novid(2*vid-1),'extent');
            pos2 = get(h.tm.text_novid(2*vid),'extent');
            pos1(1) = xLim(1)+(abs(diff(xLim))-pos1(3))/2;
            pos1(2) = yLim(2)-mg_top*abs(diff(yLim));
            pos2(1) = xLim(1)+(abs(diff(xLim))-pos2(3))/2;
            pos2(2) = pos1(2) - 2*pos2(4);

            set(h.tm.text_novid(2*vid-1),'position',pos1([1,2]));
            set(h.tm.text_novid(2*vid),'position',pos2([1,2]));

            set(h.tm.axes_videoView(vid),'visible','off');
        end

        guidata(h_fig,h);
    end
    return
end

% get proper average image
exc = get(h.tm.popupmenu_VV_exc,'value');

% get proper coordinates selection to plot
meth = get(h.tm.popupmenu_VV_mol,'value');
switch meth
    case 1 % selected molecules
        incl = h.tm.molValid;
    case 2 % unselected molecules
        incl = ~h.tm.molValid;
    case 3 % all molecules
        incl = true(size(h.tm.molValid));
end

for vid = 1:nVid
    if exc>nExc
        img = p.proj{proj}.aveImg{vid,1};
    else
        img = p.proj{proj}.aveImg{vid,exc+1};
    end

    % get image size
    [h_vid,w_vid] = size(img);

    % get image limits in y-direction
    y_data = [0.5,h_vid-0.5];

    % plot image
    imagesc(h.tm.axes_videoView(vid),[0.5,w_vid-0.5],y_data,img);
    set(h.tm.axes_videoView(vid),'nextplot','add');

    % plot channel bounds
    if nChan>1 && nVid==1
        for c = 1:nChan-1
            x_data = repmat(c*(w_vid/nChan),1,2);
            plot(h.tm.axes_videoView(vid),x_data,y_data,'--w');
        end
    end

    % plot untagged coordinates
    if get(h.tm.checkbox_VV_tag0,'value')
        mols = ~sum(molTags,2)' & incl;
        if nVid==1
            x_coord = coord(mols,1:2:end);
            y_coord = coord(mols,2:2:end);
        else
            x_coord = coord(mols,2*vid-1);
            y_coord = coord(mols,2*vid);
        end
        plot(h.tm.axes_videoView(vid),x_coord(:),y_coord(:),'linestyle',...
            'none','marker','o','markersize',mksz,'markeredgecolor',...
            'white','linewidth',lineWidth);
    end

    % plot tagged coordinates
    if isfield(h.tm,'checkbox_VV_tag') && ishandle(h.tm.checkbox_VV_tag(1))
        nTag = numel(h.tm.checkbox_VV_tag);
        N = size(molTags,1);
        allm = 1:N;
        mkSize = repmat(mksz,1,N);
        prevt = 0;
        if nVid==1
            x_coord = coord(:,1:2:end);
            y_coord = coord(:,2:2:end);
        else
            x_coord = coord(:,2*vid-1);
            y_coord = coord(:,2*vid);
        end
        for t = 1:nTag
            if get(h.tm.checkbox_VV_tag(t),'value')
                mols = molTags(:,t)' & incl;
                if prevt>0
                    mkSize = mkSize + (lineWidth+3)*molTags(:,prevt)';
                end

                for n = allm(mols)
                    plot(h.tm.axes_videoView(vid),x_coord(n,:),...
                        y_coord(n,:),'linestyle','none','marker','o',...
                        'markersize',mkSize(n),'linewidth',lineWidth,...
                        'markeredgecolor',hex2rgb(clr{t})/255);
                end
                prevt = t;
            end
        end
    end
    
    set(h.tm.axes_videoView(vid),'nextplot','replacechildren');

    % set image limits
    % modified by MH, 24.08.2019
    xlim(h.tm.axes_videoView(vid),[0,size(img,2)]);
    ylim(h.tm.axes_videoView(vid),[0,size(img,1)]);
    % xlim(h.tm.axes_videoView,[0,size(img,2)+1]);
    % ylim(h.tm.axes_videoView,[0,size(img,1)+1]);
end

