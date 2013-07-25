
fid = fopen('stopwords.txt','r');
sws = textscan(fid, '%[^,],');
sws=sws{1};
stopwords = containers.Map('KeyType','char','ValueType','double');
for i = 1 : size(sws, 1)
    stopwords(sws{i}) = 1;
end
stopwords('') = 1;
fclose(fid);
mat = load('bigData.mat');
col = zeros( 166912*100, 1);
row = zeros( 166912*100, 1);
val = zeros( 166912*100, 1);

actualDocumentID = zeros(size(mat.articleIDs));
word2ID = containers.Map('KeyType','char','ValueType','double');
ID2word = containers.Map('KeyType','double','ValueType','char');
wordID = 1;

numrow=0;
entry = 1;
%disp('start');
for i = 1 : size(mat.articleIDs, 1)
    currentArticleID = i;
    actualDocumentID(currentArticleID) = mat.articleIDs(i);
    text = mat.articleText{i};
    textwords = regexp(text, '[ .,"()]', 'split');
    word2count = containers.Map('KeyType','double','ValueType','double');
    for j = 1:size(textwords, 2)
        currword = textwords{j};
        if stopwords.isKey(lower(currword))
            continue
        end
        if ~ word2ID.isKey(currword)
            word2ID(currword) = wordID;
            ID2word(wordID) = currword;
            wordID = wordID + 1;
        end
        currwordID = word2ID(currword);
        if word2count.isKey(currwordID)
            word2count(currwordID) = word2count(currwordID) +1;
        else
            word2count(currwordID) = 1;
        end
    end
    words = keys(word2count);
    counts = values(word2count);
    for k = 1:length(words)
        row(entry) = currentArticleID;
        col(entry) = words{k};
        val(entry) = counts{k};
        entry = entry + 1;
    end
    disp(i/size(mat.articleIDs, 1));
end
fid = fopen('wordlist.csv','wt');
for i=1:wordID-1
    fprintf(fid, '%s,1\n', ID2word(i));
end
fclose(fid);

fid = fopen('sparseMatrix.csv','wt');
for i=1:size(row,1)
    fprintf(fid, '%d,%d,%d\n', row(i), col(i), val(i));
end
fclose(fid);