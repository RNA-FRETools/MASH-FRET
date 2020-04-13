function str = repSpecialChar(str)
% replace special charracters in a string by escaped characters

str = strrep(str,'\','\\');
str = strrep(str,'%','%%');
% str = strrep(str,'''',cat(2,'''',''''));