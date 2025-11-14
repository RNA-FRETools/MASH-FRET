function dat = adjustDt(dat0)
% dat = adjustDt_mod(dat0)
%
% Remove exlcuded states and link neighbouring states together by 
% prolongating the duration of the previous state in the sequence. If there 
% is no previous state, the duration of th enext state is prolongated.
%
% dat0: [N-by-6 or 8] dwell time table (duration,value before transition,
%       value after transition,molecule index,state index before 
%       transition, state index after transition) with state index=0 if 
%       state is out-of-TDP range
% dat: [N-by-6 or 8] re-arranged dwell time table 

dat = [];

if size(dat0,2)==8
      cols = [7,8];
elseif size(dat0,2)==4
    cols = [3,4];
else
    cols = [5,6];
end

% identify clustered transitions
id = find(dat0(:,cols(1))>0);
I = numel(id);

% all transitions left out of clusters
if I==0
    if size(dat0,2)==8
        dat = [sum(dat0(:,1)),NaN,NaN,dat0(1,4),0,0,0,0];
    elseif size(dat0,2)==4
        dat = [sum(dat0(:,1)),dat0(:,2),0,0];
    else
        dat = [sum(dat0(:,1)),NaN,NaN,dat0(1,4),0,0];
    end
    
else
    i = 1;
    while i<=I
        
        % sum up time before first clustered transition
        if i==1 && id(i)>1
            dt = sum(dat0(1:id(i),1));
            dat0(id(i),1) = dt;
        end
        
        % sum up time between two successive clustered transitions
        if i<I
            j = i+1;
            match = false;
            while j<=I
                if dat0(id(j),cols(1))~=dat0(id(i),cols(1))
                    match = true;
                    break
                end
                j = j+1;
            end
            
            % determine state after transition
            if match
                dt = sum(dat0(id(i):id(j)-1,1));
                val2 = dat0(id(j),2);
                if size(dat0,2)>=5
                    y = dat0(id(j),5);
                end
                if size(dat0,2)==8
                    j2 = dat0(id(j),7);
                end
                if size(dat0,2)==4
                    j2 = dat0(id(j),3);
                end
            else
                dt = sum(dat0(id(i):end,1));
                val2 = dat0(id(i),2);
                if size(dat0,2)>=5
                    y = dat0(id(i),5);
                end
                if size(dat0,2)==8
                    j2 = dat0(id(i),7);
                end
                if size(dat0,2)==4
                    j2 = dat0(id(i),3);
                end
            end
            
            % update dwell time table
            if size(dat0,2)==8
                dat = cat(1,dat,[dt,dat0(id(i),2),val2,dat0(id(i),4:5),y,...
                    dat0(id(i),7),j2]);
            elseif size(dat0,2)==4
                dat = cat(1,dat,[dt,dat0(id(i),2:3),j2]);
            else
                dat = cat(1,dat,[dt,dat0(id(i),2),val2,dat0(id(i),4:5),y]);
            end
           
            i = j-1;
        
        % sum up time after last clustered transition
        else
            dt = sum(dat0(id(i):end,1));
            val2 = dat0(id(i),2);
            if size(dat0,2)>=5
                y = dat0(id(i),5);
            end
            if size(dat0,2)==8
                j2 = dat0(id(i),7);
            end
            if size(dat0,2)==4
                j2 = dat0(id(i),3);
            end
            
            if size(dat0,2)==8
                dat = cat(1,dat,[dt,dat0(id(i),2),val2,dat0(id(i),4:5),y,...
                    dat0(id(i),7),j2]);
            elseif size(dat0,2)==4
                dat = cat(1,dat,[dt,dat0(id(i),2:3),j2]);
            else
                dat = cat(1,dat,[dt,dat0(id(i),2),val2,dat0(id(i),4:5),y]);
            end
            
            i = I;
        end
        i = i+1;
    end
end
