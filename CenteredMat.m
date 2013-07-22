classdef CenteredMat <handle
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
            disp(max(cm.colAvg));
            disp(max(max(M)));
        end
        
        function recenter(obj)
            for i = 1:length(obj.colAvg)
                obj.colAvg(i) = sum(obj.ucM(:,i))/size(obj.ucM, 1);
            end
        end
        
        % matrix * verticalVec
        function v = mvMul(obj, p)
            v = obj.ucM*p-obj.colAvg*p;
            %for rowInd = 1 : length(v)
            %    nonzeroInd = find(p);
            %    v(rowInd) = (obj.ucM(rowInd, nonzeroInd)- obj.colAvg(nonzeroInd))* p(nonzeroInd);
            %end
        end
        
        % horizVec * matrix
        function v = vmMul(obj, p)
            v = obj.ucM'* p-obj.colAvg'*sum(p);
            %for colInd = 1 : length(v)
            %    nonzeroInd = find(p);
            %    v(colInd) = (obj.ucM(nonzeroInd, colInd)- obj.colAvg(colInd))'* p(nonzeroInd);
            %end
        end
        
        % get the sub matrix of a certain size
        function m = getMat(obj, rowInd, colInd)
            m = full(obj.ucM(rowInd, colInd));
            for i = 1:length(colInd)
                m(:, i) = m(:, i) - obj.colAvg(colInd(i));
            end
        end
        
        % subtract a matrix from the matrix
        function subMat(obj, rowInd, colInd, subCol, subRow)
            %subMat = subCol* subRow';
            
            obj.ucM = UpdateSparse(obj.ucM, rowInd, colInd, subCol, subRow);
            % efficiency issues
            % no re-normalization
        end
        
        % remove columns
        function removeCol(obj, colInd)
            obj.ucM(:, colInd) = [];
            obj.colAvg(:, colInd) =[];
        end
        
        
        
    end
    
    methods (Access = private)
    end
    
end

