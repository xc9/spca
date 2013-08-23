function [ newstr ] = stemword( oldstr )
    newstr = strtrim(regexprep(['.',lower(oldstr)], '([\s|,|.|~|!|\{|\}|\(|\)|\[|\]|\"|''|?|>|<|\\|/])*', ' '));
end
%{
fid = fopen('stopwords.txt');
a=textscan(fid, '%s', 'delimiter','\n');
a=a{1};
stopmap = containers.Map('KeyType','char','ValueType','char');
for i = 1:length(a)
    stopmap(a{i})=a{i};
end
fclose(fid);
%}