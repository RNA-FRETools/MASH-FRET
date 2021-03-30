function s_fact = getSecondsFromString(unstr)

res = extract(unstr,'10^' + optionalPattern('-') + digitsPattern);
s_fact = eval(res{1});