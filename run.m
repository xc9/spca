cd amazonData;
[a,b]=wrapper('sparseMatrix.csv', 'wordlist.csv', 'a');
printCSV('amazonOutput_a_1500_wm.txt', a, b);
[a,b]=wrapper('sparseMatrix.csv', 'wordlist.csv', 'b');
printCSV('amazonOutput_b_1500_wm.txt', a, b);
cd ..;
cd reutersData;
[a,b]=wrapper('sparseMatrix.csv', 'wordlist.csv', 'a');
printCSV('reutersOutput_a_1500_wm.txt', a, b);
[a,b]=wrapper('sparseMatrix.csv', 'wordlist.csv', 'b');
printCSV('reutersOutput_b_1500_wm.txt', a, b);
cd ..;
cd nsfData\\nsfnew;
[a,b]=wrapper('sparseMatrix.csv', 'wordlist.csv', 'a');
printCSV('nsfOutput_a_1500_wm.txt', a, b);
[a,b]=wrapper('sparseMatrix.csv', 'wordlist.csv', 'b');
printCSV('nsfOutput_b_1500_wm.txt', a, b);