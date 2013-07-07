cd ..;
[a,b]=wrapper('amazonData\\sparseMatrix.csv', 'amazonData\\wordlist.csv', 'a');
Util.conveniencePrintCSV('output\\amazonOutput_a_150_dt.txt', a, b);
[a,b]=wrapper('amazonData\\sparseMatrix.csv', 'amazonData\\wordlist.csv', 'b');
Util.conveniencePrintCSV('output\\amazonOutput_b_150_dt.txt', a, b);

[a,b]=wrapper('reutersData\\sparseMatrix.csv', 'reutersData\\wordlist.csv', 'a');
Util.conveniencePrintCSV('output\\reutersOutput_a_150_dt.txt', a, b);
[a,b]=wrapper('reutersData\\sparseMatrix.csv', 'reutersData\\wordlist.csv', 'b');
Util.conveniencePrintCSV('output\\reutersOutput_b_150_dt.txt', a, b);

[a,b]=wrapper('nsfData\\nsfnew\\sparseMatrix.csv', 'nsfData\\nsfnew\\wordlist.csv', 'a');
Util.conveniencePrintCSV('output\\nsfOutput_a_150_dt.txt', a, b);
[a,b]=wrapper('nsfData\\nsfnew\\sparseMatrix.csv', 'nsfData\\nsfnew\\wordlist.csv', 'b');
Util.conveniencePrintCSV('output\\nsfOutput_b_150_dt.txt', a, b);