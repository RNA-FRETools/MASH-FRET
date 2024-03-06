function [stpx,stpy] = calcmaptoolsldstep(wrect,hrect,resx,resy)

stpx = [wrect/(4*resx),wrect/resx];
stpx(isnan(stpx) | isinf(stpx)) = 0;
stpy = [hrect/(4*resy),hrect/resy];
stpy(isnan(stpy) | isinf(stpy)) = 0;