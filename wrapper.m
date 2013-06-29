function [ word_pc_list, ps] = wrapper( matrix_file, dict_file, mode )
%wrapper a convenience class for loading the matrix and translating the
%principal component to a word matrix
% inputs:
% matrix_file               file name of file containing document-term
%                           matrix
% dict_file                 file name of file containing dictionary
% options.max_iteration     max iterations to run
% output:
% word_pc_list              a x-by-y matrix, where x = threshold and y =
%                           num_pc. In other words, each column is a vector
%                           of words (sorted in order of magnitude)
%                           in the principal component vector
% ps                        a x-by-y matrix, where x = threshold and y =
%                           num_pc. In other words, each column is a vector
%                           of weights, corresponding to the weight of
%                           words in word_pc_list (weights are the 
%                           magnitudes of entries inprincipal components)
    fid=fopen(matrix_file,'r');
    ijv=textscan(fid,'%f %f %f','delimiter',',');
    fclose(fid);
    M=sparse(ijv{1}+1,ijv{2}+1,ijv{3});
    %M = M' * M;
    fid=fopen(dict_file,'r');
    words=textscan(fid,'%s %*d','delimiter',',');
    fclose(fid);
    words=words{1};
    
    options.threshold_m = 1500;
    options.threshold_n = 15;
    options.tolerance = 0.001;
    options.max_iteration = 1000;
    options.num_pc = 10;
    options.mode = mode;
    
    [~, qs] = repeated_power_iteration(M, options);    
    word_pc_list = [];
    ps=[];
    for i = 1 : options.num_pc
        pc_q = abs(qs(:, i));
        [~,index]=sort(pc_q,'descend');
        index = index (1 : options.threshold_n);
        word_pc = words(index);
        word_pc_list = [word_pc_list, word_pc]; %#ok<AGROW>
        ps = [ps, pc_q(index)];
        if options.mode == 'b'
            words(index)=[];
    end
end

