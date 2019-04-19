function [head,fmt,dat] = formatS2File(exc,chanExc,xdat,int_m,sdta_m,labels,S)

nExc = numel(exc);
times = xdat(:,1);
frames = xdat(:,2);
nS = size(sdta_m,2);

head = [];
fmt = repmat('%d\t',[1,4*nS]);
dat = [];

for s = 1:nS
    str_l = [' at ' num2str(chanExc(S(s))) 'nm'];
    [o,l,o] = find(chanExc(S(s))==exc);
    if ~isempty(head)
        head = cat(2,head,'\t');
    end
    dat = cat(2,dat,times(l:nExc:end,:),frames(l:nExc:end,:));
    head = cat(2,head,'time',str_l,'\tframe',str_l);

    Inum = sum(int_m(:,:,l),2);
    Iden = sum(sum(int_m,2),3);
    dat = cat(2,dat,Inum./Iden);
    dat = cat(2,dat,sdta_m(:,s));

    head = cat(2,head,'\tS_',labels{S(s)},'\tdiscr.S_',labels{S(s)});
end

