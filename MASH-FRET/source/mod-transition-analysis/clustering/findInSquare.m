function id = findInSquare(x,y,x0,y0,w0,h0)

xmin = x0-w0/2;
xmax = x0+w0/2;
ymin = y0-h0/2;
ymax = y0+h0/2;

[o,id,o] = find(y>=ymin & y<=ymax & x>=xmin & x<=xmax);


