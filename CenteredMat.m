classdef CenteredMat
    %Class for representing implicitly centered sparse matrices
    
    properties
        %uncentered matrix
        ucM;
        %averages for each column
        colAvg;
    end
    
    methods
        % Constructor, M is the sparse, uncentered matrix
        function cm = CenteredMat(M)
            cm.ucM = M;
            cm.colAvg = zeros(1, size(cm.ucM, 2));
            for i = 1:length(cm.colAvg)
                cm.colAvg(i) = sum(M(:,i))/size(cm.ucM, 1);
            end
        end
        
        % matrix * verticalVec
        function v = mvMul(obj, p)
            v = zeros (size(obj.ucM, 1),1);
            for rowInd = 1 : length(v)
                nonzeroInd = find(p);
                v(rowInd) = (obj.ucM(rowInd, nonzeroInd)- obj.colAvg(nonzeroInd))* p(nonzeroInd);
            end
        end
        
        % horizVec * matrix
        function v = vmMul(obj, p)
            v = zeros (size(obj.ucM, 2),1);
            for colInd = 1 : length(v)
                nonzeroInd = find(p);
                v(colInd) = (obj.ucM(nonzeroInd, colInd)- obj.colAvg(colInd))'* p(nonzeroInd);
            end
        end
        
        % get the sub matrix of a certain size
        function m = getMat(obj, rowInd, colInd)
            m = full(centeredMat(rowInd, colInd));
            for i = 1:length(colInd)
                m(:, i) = m(:, i) - obj.colAvg(colInd(i));
            end
        end
        
        % subtract a matrix from the matrix
        function m = subMat(obj, rowInd, colInd, subMat)
            obj.ucM(rowInd, colInd) = obj.ucM(rowInd, colInd) - subMat;
            % efficiency issues
            % no re-normalization
        end
        
    end
    
    methods (Access = private)
    end
    
end

