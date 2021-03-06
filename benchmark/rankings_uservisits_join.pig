rmf output/PIG_bench/html_join;
a = load '/data/uservisits/*' using PigStorage('|') as (sourceIP,destURL,visitDate,adRevenue,userAgent,countryCode,languageCode,searchWord,duration);
b = load '/data/rankings/*' using PigStorage('|') as (pagerank:int,pageurl,aveduration);
b1 = foreach b generate pagerank, pageurl;
c = filter a by visitDate > '1999-01-01' AND visitDate < '2000-01-01';
c1 = foreach c generate sourceIP, destURL, adRevenue;
d = JOIN c1 by destURL, b1 by pageurl parallel 60;
d1 = foreach d generate sourceIP, pagerank, adRevenue;
e = group d1 by sourceIP parallel 60;
f = FOREACH e GENERATE group, AVG(d1.pagerank), SUM(d1.adRevenue);
g = order f by $2 desc;
h = limit g 1;
store h into 'output/PIG_bench/html_join';

