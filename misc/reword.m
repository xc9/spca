fid=fopen('sparseMatrix.csv','r');
ijv=textscan(fid,'%f %f %f','delimiter',',');
fclose(fid);
M=sparse(ijv{1}+1,ijv{2}+1,ijv{3});
fid=fopen('wordlist.csv','r');
words=textscan(fid,'%s %*d','delimiter',',');
fclose(fid);
words=words{1};
currnewid = 1;

map = containers.Map('KeyType','char','ValueType','double');
id2newid = containers.Map('KeyType','double','ValueType','double');
newid2actualcount = containers.Map('KeyType','double','ValueType','double');
newid2word = containers.Map('KeyType','double','ValueType','char');
for i = 1:length(words)
    word = lower(words{i});
    words{i} = word;
    if (map.isKey(word))
        newID = map(word);
    else
        newID = currnewid;
        currnewid = currnewid + 1;
        newid2word(newID) = word;
    end
    id2newid(i)=newID;    
end

for i = 1:length(ijv{3})
    ijv{2}(i) = id2newid(ijv{2}(i));
    if (newid2actualcount.isKey(ijv{2}(i)))
        newid2actualcount(ijv{2}(i)) = newid2actualcount(ijv{2}(i)) + ijv{3}(i);
    else
        newid2actualcount(ijv{2}(i)) = ijv{3}(i);
    end
end
fid = fopen('wordlist2.csv','wt');
for i=1:length(newid2word)
    fprintf(fid, '%s,%d\n', newid2word(i), newid2actualcount(i));
end
fclose(fid);

fid = fopen('sparseMatrix2.csv','wt');
for i=1:16250043
    fprintf(fid, '%d,%d,%d\n', ijv{1}(i), ijv{2}(i), ijv{3}(i));
end
fclose(fid);