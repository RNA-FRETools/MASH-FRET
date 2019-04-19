function discr = getDiscrFromDt(dt, rate)

dt(:,1) = round(dt(:,1)/rate);
discr(1:dt(1,1),1) = dt(1,2);
for t = 2:size(dt,1)
    discr((size(discr,1)+1):(size(discr,1)+dt(t,1)),1) = dt(t,2);
end

