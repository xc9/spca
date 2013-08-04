function [ options ] = make_option( doc_thresh, term_thresh, tolerance, max_iter, num_pc, mode, center_option )
    options.threshold_m = doc_thresh; % 150 documents
    options.threshold_n = term_thresh;  % 15 terms
    options.tolerance = tolerance;
    options.max_iteration = max_iter;
    options.num_pc = num_pc;
    options.mode = mode;
    options.centerOption = center_option;
end

