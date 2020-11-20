function nbytes = dispProgress(str,nbytes)

% erase previous message
if nbytes>0
    fprintf(repmat('\b',[1,nbytes]));
end

% print new message
nbytes = fprintf([str,'\n']);