function [head,fmt,dat] = formatQub2File(int_fret)
% Format intensity data to write in QuB-compatible files.
%
% [head,fmt,dat] = formatQub2File(int_fret)
% int_fret >> [L-by-2] donor and acceptor intensities
% head >> file header (empty)
% fmt >> data structure in file
% dat >> formatted data

head = '';
dat = int_fret;
fmt = cat(2,repmat('%d\t',[1,size(int_fret,2)]));