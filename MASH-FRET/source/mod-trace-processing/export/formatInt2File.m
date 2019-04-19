function [head,fmt,dat] = formatInt2File(exc,xdat,int_m,iunits,discr)

nExc = numel(exc);
nChan = size(int_m,2)/2;
times = xdat(:,1);
frames = xdat(:,2);
I = int_m(:,1:nChan,:);
I_DTA = int_m(:,nChan+1:end,:);

head = '';
fmt = repmat('%d\t',[1,((discr+1)*nExc*nChan+2*nExc)]);
dat = [];

for l = 1:nExc
    strl = cat(2,' at ',num2str(exc(l)),'nm');
    if l > 1
        head = cat(2,head,'\t');
    end
    dat = [dat,times(l:nExc:end,:),frames(l:nExc:end,:)];
    head = cat(2,head,'time',strl,'\tframe',strl);

    for c = 1:nChan
        dat = [dat,I(:,c,l)];
        head = cat(2,head,'\tI_',num2str(c),strl,'(',iunits,')');
        if discr
            dat = [dat,I_DTA(:,c,l)];
            head = cat(2,head,'\tdiscr.I_',num2str(c),strl,'(',iunits,')');
        end
    end
end


