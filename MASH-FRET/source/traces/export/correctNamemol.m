function [name_mol,name] = correctNamemol(fname,pname,mol,h_fig)

new_fname = overwriteIt(fname,pname,h_fig);
if isempty(new_fname)
    name_mol = [];
    name = [];
    return;
end

[o,name_int,o] = fileparts(new_fname);

curs = strfind(name_int, '_mol');
if ~isempty(curs)
    name = name_int(1:(curs-1));

else
   curs = strfind(name_int, 'mol'); 
   if ~isempty(curs)
       name = name_int(1:(curs-1));

   else
       name = name_int;
   end
end

n = mol(1);
N = mol(2);

name_mol = strcat(name,'_mol',num2str(n),'of',num2str(N));
