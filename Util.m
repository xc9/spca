classdef Util
    %Collection of various utility functions
    
    properties
    end
    
    methods (Static = true)
        % Inputs
        %   v: the vector to be thresholded
        %   n: number of entries to keep
        % Outputs
        %   x: the thresholded sparse vector
        %   ind_v: indices of the n non-zero entries in x
        function [x, ind_v] = thresh (v, n)
            [~,ind_v]=sort(full(abs(v)),'descend');
            ind_v = ind_v (1:n);
            x=sparse(size(v,1),size(v,2));
            x(ind_v) = v(ind_v);
        end
        
        function conveniencePrintCSV ( outputfile, cellofstrings, arrayofweights)
            fid=fopen(outputfile,'wt');
            [rows, cols] = size(cellofstrings);

            for i=1:rows
                baseStr = '';
                for j = 1:cols
                    baseStr = [baseStr, cellofstrings{i,j}, char(9), num2str(arrayofweights(i,j)), char(9)];
                end
                baseStr = [baseStr, char(10)];
                fprintf(fid,baseStr);
            end

            fclose(fid);
        end
        
        function printTitles ( outputfile, cellofstrings, arrayofweights)
            fid=fopen(outputfile,'wt');
            [rows, cols] = size(cellofstrings);
            for j = 1:cols
                for i=1:rows
                    baseStr = [num2str(arrayofweights(i,j)), char(9), cellofstrings{i,j}];
                    baseStr = [baseStr, char(10)];
                    fprintf(fid,baseStr);
                end
                separator = ['-------------------',char(10)];
                fprintf(fid,separator);
            end
            fclose(fid);
        end
        
        % Inputs:
        %   qs: each column is a principal component
        %   num_original_entries: the numer of columns in the matrix M,
        %       needed for option b
        %   options: options used to run repeated_power_iteration
        % Outputs:
        %   indices: The indices of top k entries in the principal
        %       component
        %   weights: the abs value of the entries given by indices
        function [indices, weights] = get_indices_and_weights (qs, varargin) 
            weights=[];
            indices = [];
            if (~isempty(varargin))
                numtothresh=varargin{1};
            else
                numtothresh=length(find(qs(:, 1)));
            end
            for i = 1 : size(qs, 2)
                pc_q = abs(qs(:, i));
                [~, index] = Util.thresh(pc_q, numtothresh);
                actualIndices = index;
                indices = [indices, actualIndices];
                weights = [weights, pc_q(index)];
            end
        end

        function [nqs, indices] = remap (qs) 
            nqs = sparse(size(qs, 1), size(qs,2));
            indices = [];
            indexMap = (1:size(qs,1))';
            
            for i = 1 : size(qs, 2)
                pc_q = qs(:, i);
                index = find(pc_q);
                actualIndices = indexMap(index);
                indices = [indices, actualIndices];
                nqs(actualIndices, i) = pc_q(index);
                indexMap(index) = [];
            end
        end
        
        function [ M ] = load_matrix( matrix_file, offset)
            fid=fopen(matrix_file,'r');
            ijv=textscan(fid,'%f %f %f','delimiter',' ');
            fclose(fid);
            M=sparse(ijv{1}+offset,ijv{2}+offset,ijv{3});
        end
        function [ words ] = load_dict( dict_file )
            fid=fopen(dict_file,'r');
            words=textscan(fid,'%f %s','delimiter',' ');
            fclose(fid);
            words=words{2};
        end
        function [ words ] = load_fnames( dict_file )
            fid=fopen(dict_file,'r');
            words=textscan(fid,'%d %s','Delimiter','\n');
            fclose(fid);
            words=words{2};
        end
        function [ options ] = make_option( doc_thresh, term_thresh, tolerance, max_iter, num_pc, mode, center_option )
            options.threshold_m = doc_thresh; % 150 documents
            options.threshold_n = term_thresh;  % 15 terms
            options.tolerance = tolerance;
            options.max_iteration = max_iter;
            options.num_pc = num_pc;
            options.mode = mode;
            options.centerOption = center_option;
        end
        
    end   
end

