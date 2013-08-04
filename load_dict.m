function [ words ] = load_dict( dict_file )
    fid=fopen(dict_file,'r');
    words=textscan(fid,'%s %*d','delimiter',',');
    fclose(fid);
    words=words{1};
end

