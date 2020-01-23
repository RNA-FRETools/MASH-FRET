function pairs = getFRETfromFactorFiles(head)

pairs = [];
for i = 1:size(head,2)
    pos = strfind(head{i},'-');
    don = str2double(head{i}((length('FRET')+1):(pos-1)));
    acc = str2double(head{i}((pos+1):end));
    pairs = cat(1,pairs,[don,acc]);
end