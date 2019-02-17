function [head,fmt,dat] = formatHa2File(times_fret,int_fret)

head = '';
dat = cat(2,times_fret,int_fret);
fmt = cat(2,repmat('%d\t',[1,size(cat(2,times_fret,int_fret),2)]));