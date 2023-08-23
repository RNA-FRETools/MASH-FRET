function ok = memAlloc(arr_size)
ok = 1;
if ~contains(computer,'PCWIN') % not Windows platfroms
    if ismac % MACOS
        [~, w] = system('sysctl hw.memsize | awk ''{print $2}''');
        maxsz = str2double(w);
    else % LINUX
        % from angainor (https://stackoverflow.com/questions/12350598/how-to-access-memory-information-in-matlab-on-unix-equivalent-of-user-view-max)
        [~,w] = unix('free -b | grep Mem');
        stats = str2double(regexp(w, '[0-9]*', 'match'));
        maxsz = stats(end);
    end
else
    mem = memory;
    maxsz = mem.MaxPossibleArrayBytes;
end

if arr_size>=maxsz
    ok = 0;
    return
end
