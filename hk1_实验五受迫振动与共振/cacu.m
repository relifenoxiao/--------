function get_List = cacu(sorted_frequencies, ck)
    % 减少计算量,定义本地文件名
    filename = 'get_list_data.mat';

    % 检查本地文件是否存在
    if isfile(filename)
        % 加载本地数据
        load(filename, 'get_List');
        disp('从本地文件加载数据:');
    else
        % 计算 get_List
        % 预分配空间
        get_List = zeros(10000, 1);
        index = 1;

        for i = linspace(sorted_frequencies(1), sorted_frequencies(end), 100000)

            if ck(i) < 1e-1 && ck(i) > -1e-1
                get_List(index) = i;
                index = index + 1;
            end

        end

        % 去除冗余数据
        get_List = get_List(get_List ~= 0);
        % 保存数据到本地文件
        save(filename, 'get_List');
        disp('计算并保存数据到本地文件:');
    end

end
