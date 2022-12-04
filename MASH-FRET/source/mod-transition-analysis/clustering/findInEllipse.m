function id = findInEllipse(x,y,x0,y0,w0,h0,theta)

y_elps = ellipsis(x,[],[x0,y0],[w0/2,h0/2],theta);

[o,id,o] = find(~isnan(y_elps(:,1)') & ~isnan(y_elps(:,2)') & ...
    y>=(y_elps(:,1)') & y<=(y_elps(:,2)'));