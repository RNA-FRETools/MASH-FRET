function dat = adjustDt(dat)

% first transition excluded
if isequal(dat(1,(end-1):end),[0 0])
    for i = 2:size(dat,1)
        if ~isequal(dat(i,(end-1):end),[0 0])
            dat(1,[2 3 end-1 end]) = ...
                dat(i,[2 2 (end-1) (end-1)]);
            break;
        end
    end
end
if ~isequal(dat(1,(end-1):end),[0 0])
    for i = 2:size(dat,1)

        % transition excluded = constant state
        if isequal(dat(i,(end-1):end),[0 0])
            dat(i,[2 end-1 ]) = dat(i-1,[3 end]);
            if i<size(dat,1) && ...
                    isequal(dat(i+1,(end-1):end),[0 0])
                incl = [];
                for j = i+1:size(dat,1)
                    if ~isequal(dat(j,(end-1):end),[0 0])
                        if abs(dat(i,3)-dat(j,2)) < ...
                                abs(dat(i,3)-dat(i-1,3))
                            dat(i,[3 end]) = ...
                                dat(j,[2 (end-1)]);
                        else
                            dat(i,[3 end]) = dat(i-1,[3 end]);
                        end
                        break;
                    else
                        incl = [incl j];
                    end
                    % excluded transitions until the last
                    if j == size(dat,1)
                        dat(i:end,[2 3 end-1 end]) = repmat( ...
                            dat(i-1,[3 3 end end]), ...
                            [numel(i:size(dat,1)) 1]);
                    else
                        dat(incl,[2 3 (end-1) end]) = ...
                            repmat(dat(i,[3 3 end end]), ...
                            [numel(incl) 1]);
                    end
                end
            else
                dat(i,[3 end]) = dat(i-1,[3 end]);
            end
        end
        if dat(i,(end-1)) ~= dat(i-1,end)
            dat(i,[2 (end-1)]) = dat(i-1,[3 end]);
        end
    end
    dat = delFalseTrs(dat(:,[1 (end-1):end 2:(end-2)]));
    dat = dat(:,[1 4:end 2:3]);
end

