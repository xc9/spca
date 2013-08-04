function [ word_pc_list, weights, indices] = wrapper( matrix_file, dict_file, mode )
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
% weights                   a x-by-y matrix, where x = threshold and y =
%                           num_pc. In other words, each column is a vector
%                           of weights, corresponding to the weight of
%                           words in word_pc_list (weights are the 
%                           magnitudes of entries inprincipal components)
% indices                   the indices of the words in word_pc_list
    
    %Read in the matrix and dictionary files
    M=Util.load_matrix(matrix_file,1);
    %Set the options
    options = Util.make_option(150, 15, 0.001, 1000, 10, mode, 0);
    % columns in qs are the principal components
    [ps, qs] = repeated_power_iteration(M, options);     
    
    words=Util.load_dict(dict_file);
    
    [indices, weights] = Util.get_indices_and_weights(qs, length(words), options);
    word_pc_list = words(indices);
end

