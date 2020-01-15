function [head,fmt,dat] = formatS2File(exc,chanExc,xdat,s_m,S)

nChan = size(chanExc,2);
nExc = numel(exc);
times = xdat(:,1);
frames = xdat(:,2);
nS = size(s_m,2)/2;
s_traj = s_m(:,1:nS,:);
s_DTA_traj = s_m(:,nS+1:end,:);

head = [];
fmt = repmat('%d\t',[1,(2*nS+2*numel(unique(S(:,1))))]);
dat = [];

for c = 1:nChan
    [i,o,o] = find(S(:,1)== c);
    if isempty(i)
        continue
    end
    str_l = cat(2,' at ',num2str(chanExc(c)),'nm');
    if ~isempty(head)
        head = cat(2,head,'\t');
    end
    [o,l,o] = find(exc==chanExc(c));
    dat = cat(2,dat,times(l:nExc:end,:),frames(l:nExc:end,:));
    head = cat(2,head,'time',str_l,'\tframe',str_l);

    for j = i'
        dat = cat(2,dat,s_traj(:,j),s_DTA_traj(:,j));
        head = cat(2,head,'\tS_',num2str(S(j,1)),'>',num2str(S(j,2)),...
            '\tdiscr.S_',num2str(S(j,1)),'>',num2str(S(j,2)));
    end
end

