function draw(fitresult, xData, yData, half_max_left, half_max, half_max_right, sharpness)
    % 绘制数据拟合图。
    figure('Name', '音叉共振曲线');
    h = plot(fitresult, xData, yData);

    legend(h, '实验数据', '音叉共振曲线', 'Location', 'NorthEast', 'Interpreter', 'none');

    % 为坐标区加标签
    xlabel('frequencies', 'Interpreter', 'none');
    ylabel('voltage', 'Interpreter', 'none');
    grid on

    % 标注半功率点和锐度
    hold on;
    plot([half_max_left, half_max_left], [0, half_max], 'r--', 'HandleVisibility', 'off'); % 左侧垂线
    plot([half_max_right, half_max_right], [0, half_max], 'r--', 'HandleVisibility', 'off'); % 右侧垂线
    plot([half_max_left, half_max_right], [half_max, half_max], 'r--', 'HandleVisibility', 'off'); % 水平线
    text(half_max_left, half_max, sprintf('f1 (%.2f, %.2f)', half_max_left, half_max), 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'right');
    text(half_max_right, half_max, sprintf('f2(%.2f, %.2f)', half_max_right, half_max), 'VerticalAlignment', 'bottom', 'HorizontalAlignment', 'left');
    text(mean(xData), max(yData) .* 1.1, sprintf('锐度Q: %.2f', sharpness), 'HorizontalAlignment', 'center');
    hold off;
end