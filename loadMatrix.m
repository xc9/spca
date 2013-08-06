function [ M ] = load_matrix( matrix_file, offset )
    fid=fopen(matrix_file,'r');
    ijv=textscan(fid,'%f %f %f','delimiter',' ');
    fclose(fid);
    M=sparse(ijv{1}+offset,ijv{2}+offset,ijv{3});
end

