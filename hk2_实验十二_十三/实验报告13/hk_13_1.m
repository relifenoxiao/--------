% 绘制RC暂态电路中电容的电压的充放电曲线
% 电压单位：V，时间单位：s
t = [0:5:50 60:10:100 120:20:180];

%% 电容电压的充电过程
Uc1 = [0.000 1.087 2.208 3.196 3.989 4.692 5.188 5.645 6.008 6.53 6.83 7.36];
Uc2 = [7.78 8.07 8.29 8.47 8.72 8.86 9.02 9.12];
Uc = [Uc1 Uc2];
US1 = 10;
% disp((length(Uc1) - 1) * 5);
% 充电过程电压可表示为Uc = Us * (1 - exp(-t / τ))
% 此处<大学物理实验 第二版>书上给出的公式有误，正确的公式为Uc = Us * (1 - exp(-t / τ))
xdata = t(1:length(Uc));
ydata = Uc;
fun = @(tau, t) US1 * (1 - exp(-t ./ tau));
x0 = 47;
x = lsqcurvefit(fun, x0, xdata, ydata);
disp('拟合结果:tau');
disp(x);
% debug
% 显示拟合结果和调试信息
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
f.Position = [100 0 800 1000];

% 创建子图
subplot(2, 1, 1);
hold on;
% 绘制拟合结果
t_fit = linspace(min(xdata), max(xdata), 100);
% todo
Uc_fit = fun(x, t_fit);

plot(t_fit, Uc_fit, ' - ', xdata, ydata, 'o');
xlabel('时间 (s)');
ylabel('电压 (V)');
title('电容电压的充电过程');
legend('实验数据', '拟合曲线');
hold off;
%% 电容电压的放电过程
Ub1 = [9.12 8.08 7.02 6.09 5.26 4.55 3.96 3.42 2.98 2.58 2.29 1.89];
Ub2 = [1.28 0.98 0.74 0.56 0.34];
Ub = [Ub1 Ub2];
US2 = 9.12;
% disp((length(Ub1) - 1) * 5);
subplot(2, 1, 2);
hold on;
xdata = t(1:length(Ub));
ydata = Ub;
fun = @(tau, t) US2 * exp(-t ./ tau);
x0 = 47;
x = lsqcurvefit(fun, x0, xdata, ydata);

disp('拟合结果:tau');
disp(x);

% 绘制拟合结果
t_fit = linspace(min(xdata), max(xdata), 100);
Ub_fit = fun(x, t_fit);

plot(t_fit, Ub_fit, ' - ', xdata, ydata, 'o');
xlabel('时间 (s)');
ylabel('电压 (V)');
title('电容电压的放电过程');
legend('实验数据', '拟合曲线');

saveas(gcf, 'RC电路电容充放电曲线.png');
hold off;
