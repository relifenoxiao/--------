%% 绘制音叉共振曲线
% rely on cacu.m, draw.m
% 2024-09-19 11:21:01
% 输入数据
fr1 = [250 251 252 253 254 255 256 257 258];
fr2 = [259 260 256.1 256.05 256.08 255.5 255.3 255.4 255.45];
fr3 = [255.48 255.49 255.55 255.52 255.510 255.505 255.6 255.7 255.8];
fr4 = [255.9 255.2 255.1 255.508];

V1 = [0.02 0.02 0.03 0.05 0.08 0.25 0.36 0.1 0.06];
V2 = [0.04 0.03 0.29 0.32 0.31 3.31 0.55 0.92 1.48];
V3 = [2.91 3.19 2.90 3.25 3.30 3.30 2.26 1.17 0.68];
V4 = [0.49 0.39 0.30 3.30];
% 拼接数据
frequencies = [fr1, fr2, fr3, fr4];
amplitudes = [V1, V2, V3, V4];

% 创建矩阵
data = [frequencies', amplitudes'];

% 按频率排序
data = sortrows(data, 1);

% 提取排序后的频率和振幅
sorted_frequencies = data(:, 1);
sorted_amplitudes = data(:, 2);

createFit(sorted_frequencies, sorted_amplitudes);

function [fitresult, gof] = createFit(sorted_frequencies, sorted_amplitudes)
    %CREATEFIT(SORTED_FREQUENCIES,SORTED_AMPLITUDES)
    %  创建一个拟合。
    %
    %  要进行 '音叉共振曲线' 拟合的数据:
    %      X 输入: sorted_frequencies
    %      Y 输出: sorted_amplitudes
    %  输出:
    %      fitresult: 表示拟合的拟合对象。
    %      gof: 带有拟合优度信息的结构体。
    %
    %  另请参阅 FIT, CFIT, SFIT.

    %  由 MATLAB 于 19-Sep-2024 11:21:01 自动生成

    %% 拟合: '音叉共振曲线'。
    [xData, yData] = prepareCurveData(sorted_frequencies, sorted_amplitudes);

    % 设置 fittype 和选项。
    ft = fittype('gauss4');
    opts = fitoptions('Method', 'NonlinearLeastSquares');
    opts.Display = 'Off';
    opts.Lower = [-Inf -Inf 0 -Inf -Inf 0 -Inf -Inf 0 -Inf -Inf 0];
    opts.StartPoint = [3.31 255.5 0.0752039815318558 1.6951520286024 255.6 0.103898198133823 0.638318314390913 255.8 0.194724458558991 0.545912922847802 255.3 0.243766427854901];

    % 对数据进行模型拟合。
    [fitresult, gof] = fit(xData, yData, ft, opts);
    % 计算半功率点和锐度
    half_max = (max(sorted_amplitudes) / sqrt(2));

    % y_fit(x) = feval(fitresult, x);
    %% wrong way to find half_max

    % 使用数值方法找到半功率点对应的两个 x 值
    % x = linspace(min(sorted_frequencies), max(sorted_frequencies), 1000);
    % y_fit = @(x) feval(fitresult, x);
    % % half_max_left = fzero(@(x) y_fit(x) - half_max, sorted_amplitudes(1));
    % % half_max_right = fzero(@(x) y_fit(x) - half_max, sorted_amplitudes(end));
    % y_fit(mean(sorted_frequencies))
    % fitresult(mean(sorted_frequencies))

    %% 尝试使用 fzero
    % half_max_left = fzero(@(x) y_fit(x) - half_max, mean(sorted_frequencies));
    % half_max_right = fzero(@(x) y_fit(x) - half_max, mean(sorted_frequencies));

    %% 尝试使用 fslove
    % options = optimoptions('fsolve', 'Display', 'off');
    % half_max_left = fsolve(@(x) y_fit(x) - half_max, initial_guess_left, options);
    % half_max_right = fsolve(@(x) y_fit(x) - half_max, initial_guess_right, options);

    % 使用数值方法找到半功率点对应的两个 频率 值
    % 定义函数ck求解半功率点,当abs(ck(x) = 0) <= 0.1时,为半功率点
    ck = @(x) fitresult(x) - half_max;
    %% 手动求出大致范围,再使用fsolve求解
    get_List = cacu(sorted_frequencies, ck);
    % 得到粗略范围
    half_max_left = get_List(1);
    half_max_right = get_List(end);

    % 计算精确范围
    get_List = fsolve(ck, [half_max_left half_max_right]);
    half_max_left = get_List(1);
    half_max_right = get_List(end);
    fwhm = half_max_right - half_max_left; % 全宽半高
    sharpness = max(sorted_amplitudes) / fwhm; % 锐度

    %debug
    % disp(sharpness);
    draw(fitresult, xData, yData, half_max_left, half_max, half_max_right, sharpness);
end
