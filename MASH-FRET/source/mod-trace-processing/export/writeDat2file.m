function ok = writeDat2file(path_mol,ext,filedat,prm,str_xp,h_fig)

ok = 1;

head = filedat(:,1);
fmt = filedat(:,2);
dat = filedat(:,3);

fromTT = prm(1);
savePrm = prm(2);

% build file name
[pname,name_mol,o] = fileparts(path_mol);
pname = cat(2,pname,filesep);
fname = cat(2,name_mol,ext);

% [name_mol,name] = correctNamemol(fname,pname,mol,h_fig);
% if isempty(name)
%     return;
% end
% fname = cat(2,name_mol,ext);

fname = overwriteIt(fname,pname,h_fig);
if isempty(fname)
    ok = 0;
    return;
end


% write data to file
f = fopen(cat(2,pname,fname),'Wt');
if fromTT && savePrm == 2
    fprintf(f,cat(2,str_xp,'\n'));
end

head_tot = '';
for i = 1:size(head,1)
    if ~isempty(head{i,1})
        head_tot = cat(2,head_tot,head{i,1},'\t');
    end
end
if ~isempty(head_tot)
    fprintf(f,cat(2,head_tot,'\n'));
end

fmt_tot = '';
for i = 1:size(fmt,1)
    if ~isempty(fmt{i,1})
        fmt_tot = cat(2,fmt_tot,fmt{i,1});
    end
end

dat_tot = [];
for i = 1:size(fmt,1)
    if ~isempty(dat{i,1})
        dat_tot = cat(2,dat_tot,dat{i,1});
    end
end

if isempty(fmt_tot)
    fprintf(f,dat_tot');
else
    if isempty(dat_tot)
        fprintf(f,cat(2,fmt_tot,'\n'));
    else
        fprintf(f,cat(2,fmt_tot,'\n'),dat_tot');
    end
end

fclose(f);

