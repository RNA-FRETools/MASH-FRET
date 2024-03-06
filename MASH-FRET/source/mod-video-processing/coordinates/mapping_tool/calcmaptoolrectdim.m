function [wrect,hrect] = calcmaptoolrectdim(z,resx,wax,hax)

wrect = resx/z;
hrect = wrect*hax/wax;