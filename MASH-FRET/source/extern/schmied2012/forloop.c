#include "mex.h"

void calcmatrix(double y[], double x[], mwSize m, mwSize n, mwSize i, mwSize lim, mwSize a, mwSize b, double is, double os, double thr[])
{
    
    for(a=lim;a<n-lim;a=a+1)
    {
        for(b=lim;b<m-lim;b=b+1)
        {
            is = 0;
            os = 0;
            i = a*m+b;

            is = is + *(y+i);
            is = is + *(y+i-1);
            is = is + *(y+i+1);
            is = is + *(y+i-m);
            is = is + *(y+i+m);
            is = is + *(y+i+m-1);
            is = is + *(y+i+m+1);
            is = is + *(y+i-m-1);
            is = is + *(y+i-m+1);

            is = is/9.0;

            os = os + *(y+i-3);
            os = os + *(y+i-3+m);
            os = os + *(y+i-3+2*m);
            os = os + *(y+i-3+3*m);
            os = os + *(y+i-3-m);
            os = os + *(y+i-3-2*m);
            os = os + *(y+i-3-3*m);

            os = os + *(y+i+3);
            os = os + *(y+i+3+m);
            os = os + *(y+i+3+2*m);
            os = os + *(y+i+3+3*m);
            os = os + *(y+i+3-m);
            os = os + *(y+i+3-2*m);
            os = os + *(y+i+3-3*m);

            os = os + *(y+i+3*m);
            os = os + *(y+i+3*m+1);
            os = os + *(y+i+3*m+2);
            os = os + *(y+i+3*m-1);
            os = os + *(y+i+3*m-2);

            os = os + *(y+i-3*m);
            os = os + *(y+i-3*m+1);
            os = os + *(y+i-3*m+2);
            os = os + *(y+i-3*m-1);
            os = os + *(y+i-3*m-2);

            os = os/24.0;

            if(is/os >= thr[0])
            {
                *(x+i) = 1;
            }
            else
            {
                *(x+i) = 0;
            }

            if(a<=lim || a>=(n-lim) || b<=lim || b>=(m-lim))
                *(x+i) = 0;

    
        }
    }
    
}

void mexFunction(int nlhs, mxArray *plhs[ ],int nrhs, const mxArray *prhs[])
{
    
    
    double *y, *x, *thr, is, os;
    mwSize i, lim, a, b, m, n;
    lim = 3;
    
    
    
    m = mxGetM(prhs[0]);
    n = mxGetN(prhs[0]);
    
    
    
    /* Create matrix for the return argument. */
    plhs[0] = mxCreateDoubleMatrix(m,n, mxREAL);
    
    /* Assign pointers to each input and output. */
    x = mxGetPr(plhs[0]);
    y = mxGetPr(prhs[0]);
    thr = mxGetPr(prhs[1]); 
    /* lim = mxGetPr(?);*/
    
    calcmatrix(y,x,m,n,i,lim,a,b,is,os,thr);
}
