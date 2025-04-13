function I0 = calccorrtotalint(c,chanExc,exc,I,gamma)

nChan = size(I,2);

I0_expr = buildItotExpr(c,nChan);
I0_expr = replaceByArrays(I0_expr,nChan,chanExc,exc);
I0 = eval(I0_expr);