function [name_all,name] = correctNameall(fname,pname,N,h_fig)

new_fname = overwriteIt(fname,pname,h_fig);
if isempty(new_fname)
    name_all = [];
    name = [];
    return;
end

[o,name_int,o] = fileparts(new_fname);

curs = strfind(name_int, '_all');
if ~isempty(curs)
    name = name_int(1:(curs-1));

else
   curs = strfind(name_int, 'all'); 
   if ~isempty(curs)
       name = name_int(1:(curs-1));

   else
       name = name_int;
   end
end

name_all = strcat(name,'_all',num2str(N));
