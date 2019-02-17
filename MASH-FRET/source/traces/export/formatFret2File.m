function [head,fmt,dat] = formatFret2File(exc,chanExc,xdat,fret_m,FRET)

nExc = numel(exc);
nChan = numel(chanExc);
times = xdat(:,1);
frames = xdat(:,2);
nFRET = size(fret_m,2)/2;
fret_traj = fret_m(:,1:nFRET,:);
fret_DTA_traj = fret_m(:,nFRET+1:end,:);

head = [];
fmt = repmat('%d\t',[1,(2*nFRET+2*numel(unique(FRET(:,1))))]);
dat = [];

for c = 1:nChan
    [i,o,o] = find(FRET(:,1)== c);
    if ~isempty(i)
        str_l = cat(2,' at ',num2str(chanExc(c)),'nm');
        if ~isempty(head)
            head = cat(2,head,'\t');
        end
        [o,l,o] = find(exc==chanExc(c));
        dat = cat(2,dat,times(l:nExc:end,:),frames(l:nExc:end,:));
        head = cat(2,head,'time',str_l,'\tframe',str_l);

        for j = i'
            dat = cat(2,dat,fret_traj(:,j),fret_DTA_traj(:,j));
            head = cat(2,head,'\tFRET_',num2str(FRET(j,1)),'>',...
                num2str(FRET(j,2)),'\tdiscr.FRET_',num2str(FRET(j,1)),...
                '>',num2str(FRET(j,2)));
        end
    end
end


