function dat = remove_photobleach(dat,params)
% This function takes the raw FRET data and removes the photobleaching
% using the parameters from the structure params.

% last edited fall 2009 by Jonathan E Bronson (jeb2126@columbia.edu) for 
% http://vbfret.sourceforge.net

N = length(dat.raw_bkup);
dat.raw = cell(1,N);
dat.labels = dat.labels_bkup;

%truncation methods
%1 = 1D transformed 
%2 = Single channel 
%3 = Summed channel

warning off MATLAB:divideByZero

switch params.type
    case 1 %1D transformed
        for n=1:N
            [cy3 cy5] = get_cy3_cy5(dat.raw_bkup{n},params);
            cyRatio = cy5 ./ (cy3+cy5);
            temp = find(cyRatio < -params.cutoff_1D | cyRatio > 1+params.cutoff_1D,1) - 1;
            if isempty(temp)
                dat.raw{n} = dat.raw_bkup{n};
            else
                %make sure the the trace is truncated between the first and
                %last timestep of the trace
                endPoint = max(1,min(temp-params.xtra,size(dat.raw_bkup{n},1)));
                %save trace with photobleach removed
                dat.raw{n} = dat.raw_bkup{n}(1:endPoint,:);
            end            
        end
        
    case 2 %min channel
        for n=1:N
            [cy3 cy5] = get_cy3_cy5(dat.raw_bkup{n},params);
            %cy3
            temp1=find(cy3 < params.cutoff_either ,1) - 1;
            %cy5
            temp2=find(cy5 < params.cutoff_either ,1) - 1;
            if (isempty(temp1)&&isempty(temp2))
                endPoint = size(dat.raw_bkup{n},1);
            elseif (isempty(temp1) && ~isempty(temp2))
                endPoint = temp2;                
            elseif (isempty(temp2) && ~isempty(temp1))
                endPoint = temp1;
            else
                endPoint = min(temp1,temp2);
            end
            %make sure the the trace is truncated between the first and
            %last timestep of the trace
            endPoint = max(1,min(endPoint-params.xtra,size(dat.raw_bkup{n},1)));
            %save trace with photobleach removed
            dat.raw{n} = dat.raw_bkup{n}(1:endPoint,:);
        end
        
    case 3% min_sum
        for n=1:N
            [cy3 cy5] = get_cy3_cy5(dat.raw_bkup{n},params);
            cy35 = cy3+cy5;
            temp = find(cy35 < params.cutoff_sum ,1) - 1;
            
            if isempty(temp)
                dat.raw{n} = dat.raw_bkup{n};
            else
                %make sure the the trace is truncated between the first and
                %last timestep of the trace
                endPoint = max(1,min(temp-params.xtra,size(dat.raw_bkup{n},1)));
                %save trace with photobleach removed
                dat.raw{n} = dat.raw_bkup{n}(1:endPoint,:);
            end            
        end
end

warning on MATLAB:divideByZero

%find traces that are too short
Tmin = params.min_length;
removed_list = cell(1,N);
to_remove = zeros(1,N);
for n=1:N
    T = size(dat.raw{n},1);
    if (T < Tmin)
        removed_list{n} =  dat.labels{n};
        to_remove(n) = n;
    end
end

del = to_remove == 0;
removed_list(del) =  [];
to_remove(del) = [];


%remove traces that are too short
dat.raw(to_remove) = [];
dat.labels(to_remove) = [];  
dat.x_hat = cell(2,length(dat.raw));
dat.z_hat  = cell(1,length(dat.raw));
dat.raw_db = {};
dat.FRET_db = {};
dat.x_hat_db = {};
dat.z_hat_db ={};


% FRET = cy5 /(cy3+cy5)
N = length(dat.raw);
dat.FRET = cell(1,N);
for n=1:N
    dat.FRET{n} = dat.raw{n}(:,2)./(sum(dat.raw{n},2));
end

%notify if any traces were deleted removal 
num_rm = length(removed_list);
if num_rm > 0
    if num_rm == 1
   %     msgboxText{1} = sprintf('The following trace was shorter than %d time steps:',Tmin);
   %     msgboxText{2} = sprintf('%s',removed_list{1});
%     elseif num_rm < 30
%         msgboxText{1} = sprintf('The following %d traces were shorter than %d time steps and were removed:',num_rm,Tmin); 
%         for i = 1:num_rm
%             msgboxText{i+1} = sprintf('%s',removed_list{i});
%         end
    else
        msgboxText{1} = sprintf('The following %d traces were shorter than %d time steps and were removed:',num_rm,Tmin);
        count = 0;
        for i = 1:ceil(num_rm/10);
            msg_txt = '';
            for j = 1:10
                count = count+1;
                if count > num_rm
                    break
                end
                msg_txt = [msg_txt sprintf('   %s',removed_list{count})];
            end
            msgboxText{i+1} = msg_txt;
        end
    end
    msgbox(msgboxText,'Photobleaching Removal', 'none');
    pause(0.2)

end


%%
function [cy3 cy5] = get_cy3_cy5(raw,params)
%smooth data
if params.smooth
    I = params.smooth_steps;
    cy3 = zeros(size(raw,1)-I+1,1);
    cy5 = cy3;

    for i=1:I
        cy3 = cy3+raw(i:end-I+i,1);
        cy5 = cy5+raw(i:end-I+i,2);
    end
        
    cy3 = cy3/I;
    cy5 = cy5/I;
else
    cy3 = raw(:,1);
    cy5 = raw(:,2);
end