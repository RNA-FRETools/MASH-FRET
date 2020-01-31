function str_br = wrapHtmlTooltipString(str,varargin)

% defaults
nmax = 45;

if ~isempty(varargin)
    nmax = varargin{1};
end

c_op = strfind(str,'<');
c_cl = strfind(str,'>');

incl = true(1,length(str));

for c1 = c_op
    c2 = find(c_cl>c1);
    if ~isempty(c2)
        incl(c1:c_cl(c2)) = false;
    end
end

poschar = find(incl);
N = length(str);
Nchar = length(str(incl));

char_prev = 0;
pos_prev = 1;
str_br = '';

while char_prev<N
    % look for previous space
    if (pos_prev+nmax)>Nchar
        str_br = cat(2,str_br,str((char_prev+1):end));
        break
    else
        char_next = poschar(pos_prev+nmax)+1;
        while ~strcmp(str(char_next),' ') && char_next>0
            char_next = char_next-1;
        end
        if char_next==0
            char_next = poschar(pos_prev+nmax);
            str_br = cat(2,str_br,str((char_prev+1):char_next),'<br>');
            char_prev = char_next;
            pos_prev = pos_prev+nmax;
        else
            str_br = cat(2,str_br,str((char_prev+1):char_next-1),'<br>');
            pos_prev = find(poschar==(char_next-1));
            char_prev = char_next;
        end
    end
end

if ~strcmp(str_br(1:length('<html>')),'<html>')
    str_br = cat(2,'<html>',str_br);
end
if ~strcmp(str_br((end-length('</html>')+1):end),'</html>')
    str_br = cat(2,str_br,'</html>');
end

