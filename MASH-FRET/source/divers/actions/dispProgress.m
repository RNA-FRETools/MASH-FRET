function nbytes = dispProgress(str,nbytes)

% erase previous message and print new message
if nbytes>0
    fprintf(repmat('\b',[1,nbytes]));
end
nbytes = fprintf(str);