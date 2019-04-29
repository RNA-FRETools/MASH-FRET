function ok = memAlloc(arr_size)
ok = 1;
mem = memory;
if arr_size>mem.MaxPossibleArrayBytes
    ok = 0;
    return;
end
