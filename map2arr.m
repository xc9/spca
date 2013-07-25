function [ key, val ] = map2arr( map )
    key = map.keySet.toArray.cell;
    val={};
    for i = 1 : size(key, 1)
        val{i, 1} = map.get(key{i});
    end
end

