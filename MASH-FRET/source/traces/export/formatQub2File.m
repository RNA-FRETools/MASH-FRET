function [head,fmt,dat] = formatQub2File(int_fret)

head = '';
dat = int_fret;
fmt = cat(2,repmat('%d\t',[1,size(int_fret,2)]));