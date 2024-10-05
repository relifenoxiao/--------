% 绘制RC暂态电路中电容的电压的充放电曲线
% 电压单位：V，时间单位：s
t = [0:5:50 60:10:100 120:20:180];

%% 充电过程RC电路的电流
IC1 = [0.0 89.7 80.8 71.1 62.1 55.1 47.6 39.0 36.0];
IC2 = [33.0 27.3 23.9 20.5 17.1 15.1 14.7];
IC = [IC1 IC2]; % 微安
US = 10; % V
R = 100e3; % 欧姆
% 封装数据
xdata = t(2:length(IC));
ydata = IC(2:end);
% 创建拟合函数

fun = @(tau, t) US / R * exp(-t / tau) * 1e6; % 缩放函数
x0 = 35;
x = lsqcurvefit(fun, x0, xdata, ydata);
disp('tau:');
disp(x);

% % debug
% % 显示拟合结果和调试信息
% disp('拟合结果:');
% disp(x);
% disp('残差平方和:');
% disp(resnorm);
% disp('残差:');
% disp(residual);
% disp('退出标志:');
% disp(exitflag);
% disp('输出信息:');
% disp(output);

% 创建新的图形窗口并设置大小
f = figure;
f.Position = [100 0 1400 1000];

hold on;
% 绘制拟合结果
t_fit = linspace(min(xdata), max(xdata), 100);
% todo
Ic_fit = fun(x, t_fit);

plot(t_fit, Ic_fit, ' - ', xdata, ydata, 'o');
xlabel('时间 (s)');
ylabel('电流 (微安)');
title('充电过程RC电路的电流');
legend('实验数据', '拟合曲线');
hold off;

saveas(gcf, '充电过程RC电路的电流.png');
hold off;
