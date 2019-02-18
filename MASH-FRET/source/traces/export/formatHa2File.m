function [head,fmt,dat] = formatHa2File(times_fret,int_fret)
% Format intensity data to write in HaMMy-compatible files.
%
% [head,fmt,dat] = formatHa2File(times_fret,int_fret)
% times_fret >> [L-by-1] time data
% int_fret >> [L-by-2] donor and acceptor intensities
% head >> file header (empty)
% fmt >> data structure in file
% dat >> formatted data

head = '';
dat = cat(2,times_fret,int_fret);
fmt = cat(2,repmat('%d\t',[1,size(cat(2,times_fret,int_fret),2)]));