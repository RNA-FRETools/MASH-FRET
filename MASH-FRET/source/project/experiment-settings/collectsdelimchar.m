function delimchar = collectsdelimchar(delim)

switch delim
    case 1
        delimchar = {sprintf('\t'),' ',' '};
    case 2
        delimchar = sprintf('\t');
    case 3
        delimchar = ',';
    case 4
        delimchar = ';';
    case 5
        delimchar = {' ',' '};
    otherwise
        delimchar = sprintf('\t');
end