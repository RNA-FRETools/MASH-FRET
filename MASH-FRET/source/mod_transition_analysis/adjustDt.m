function dat = adjustDt(dat0)
% dat = adjustDt_mod(dat0)
%
% Remove exlcuded states and link neighbouring states together by prolongating the duration of the previous state in the sequence. If there is no previous state, the duration of th enext state is prolongated.
%
% dat0: [N-by-6] dwell time table (duration,value before transition,value after transition,molecule index,state index before transition, state index after transition) with state index=0 if state is out-of-TDP range
% dat: [N-by-6] re-arranged dwell time table 

dat = [];

% identify states in TDP's range
id = find(dat0(:,5)>0);
I = numel(id);

% all states are out-of-TDP-range
if I==0
    dat = [sum(dat0(:,1)),NaN,NaN,dat0(1,4),0,0];
    
else
    i = 1;
    while i<=I
        
        % first state is out-of-range
        if i==1 && id(i)>1
            dt = sum(dat0(1:id(i),1));
            dat0(id(i),1) = dt;
        end
        
        if i<I
            j = i+1;
            match = false;
            while j<=I
                if dat0(id(j),5)~=dat0(id(i),5)
                    match = true;
                    break
                end
                j = j+1;
            end
            
            if match
                dt = sum(dat0(id(i):id(j)-1,1));
                val2 = dat0(id(j),2);
                j2 = dat0(id(j),5);
            else
                dt = sum(dat0(id(i):end,1));
                val2 = dat0(id(i),2);
                j2 = dat0(id(i),5);
            end
            
            dat = cat(1,dat,[dt,dat0(id(i),2),val2,dat0(id(i),4:5),j2]);
            
            i = j-1;
            
        else
            dt = sum(dat0(id(i):end,1));
            val2 = dat0(id(i),2);
            j2 = dat0(id(i),5);
            
            dat = cat(1,dat,[dt,dat0(id(i),2),val2,dat0(id(i),4:5),j2]);
            
            i = I;
        end
        
        i = i+1;
    end
end
