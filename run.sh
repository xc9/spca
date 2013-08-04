matlab -nodisplay -nodesktop -r "addpath(genpath(fullfile(pwd,'code'))); addpath(genpath(fullfile(pwd,'code'))); addpath(genpath(fullfile(pwd,'code')));M=Util.load_matrix('${1}',1);options = Util.make_option(150, 15, 0.001, 1000, 10, '${3}', 0);[ps, qs] = repeated_power_iteration(M, options); words=Util.load_dict('${2}');[indices, weights] = Util.get_indices_and_weights(qs, length(words), options); word_pc_list = words(indices); Util.conveniencePrintCSV('output\\${4}', word_pc_list, weights);" 
    
    
    