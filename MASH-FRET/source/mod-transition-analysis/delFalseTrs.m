function dt = delFalseTrs(dt)

% find A-->A trans.
[same_id o o] = find((dt(:,2) == dt(:,3)));
if ~isempty(same_id)
    excl = [];
    % find the index in r of rows being the first of a multiple 
    % A-->A row series
    row = 1;
    keep = true;
    if size(dt,1)>1
        while keep
            if row < size(dt,1)
                r = 0;
                while (same_id(row)+r)<size(dt,1) && ...
                        ~isempty(find(same_id==(same_id(row)+r),1))
                    excl = [excl same_id(row)+r];
                    r = r+1;
                end
                dt(same_id(row)+r,1) = sum(dt(same_id(row):same_id(row)+r,1));
                dt(same_id(row)+r,2) = dt(same_id(row),3);
                if r == 0
                    r = 1;
                end
                if row+r <= numel(same_id)
                    row = row+r;
                else
                    keep = false;
                end
            else
                keep = false;
            end
        end
        dt(excl,:) = [];
    end
end

