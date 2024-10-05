% 绘制线性电阻伏安特性曲线
% 创建新的图形窗口并设置大小
f = figure;
f.Position = [100 0 800 1000];

% 电源电压(V)
Us = 0:10;

% 电流(mA)
I = [0.00 10.2 19.7 29.7 39.3 48.7 59.0 69.6 80.2 89.9 101.4];
I = I / 1000; % mA -> A
% 电压(V)
U = [0.000 0.998 1.980 2.927 3.833 4.748 5.719 6.700 7.760 8.660 9.760];
subplot(2, 1, 1);
plot(U, I, 'o');
hold on;
fig = polyfit(U, I, 1);
disp(fig);
ux = min(U):0.1:max(U);
iy = polyval(fig, ux);
plot(ux, iy);
xlabel('电压 U(V)');
ylabel('电流 I(A)');
title('线性电阻伏安特性曲线');
str = sprintf('R = %.3f Ω', 1 / fig(1));
text(7.5, 0.1, str);
hold off;
disp('相对误差是:')
disp(100 - 1 / fig(1))

%% 非线性电阻伏安特性曲线
subplot(2, 1, 2);
I = [0.0 30.9 46.7 57.2 70.3 79.9 88.7];
U = [0.011 0.941 1.919 2.725 3.875 4.828 5.798];
I = I / 1000; % mA -> A
plot(U, I, 'o');
hold on;
% 非线性电阻伏安特性曲线为I = n * U^\alpha
ydata = I;
xdata = U;
% 设置拟合模型
fun = @(x, xdata) x(1) * xdata .^ x(2);
x0 = [1 1];
x = lsqcurvefit(fun, x0, xdata, ydata);
param = [x(1), x(2)];
fprintf('拟合参数: n = %.3f, α = %.3f\n', param(1), param(2));

% 绘制拟合曲线
U_fit = linspace(min(U), max(U), 100);
I_fit = param(1) * U_fit .^ param(2); % Evaluate the function handle
plot(U_fit, I_fit, '-r');
xlabel('电压 U(V)');
ylabel('电流 I(A)');
title('非线性电阻伏安特性曲线');
legend('数据点', '拟合曲线');
hold off;

% 定义符号变量
syms U_sym;

% 定义符号表达式 I_sym
I_sym = param(1) * U_sym ^ param(2);

% 计算 I 对 U 的导数
dI_dU = diff(I_sym, U_sym);
% 初始化 R_values 为空数组
R_values = [];

% 在多个点处计算导数值并追加到 R_values
U_values = [2, 11];

for u = U_values
    R = 1 / double(subs(dI_dU, U_sym, u));
    R_values = [R_values, R];
end

saveas(gcf, '伏安特性曲线.png');
% 显示导数值
disp('在 [2, 11] 处的导数值(欧):');
disp(R_values);
%% 拟合: '1'。
% [xData, yData] = prepareCurveData(U, I);

% % 设置 fittype 和选项。
% ft = fittype('a*x^b', 'independent', 'x', 'dependent', 'y');
% opts = fitoptions('Method', 'NonlinearLeastSquares');
% opts.Display = 'Off';
% opts.StartPoint = [0.27692298496089 0.0461713906311539];
% % 对数据进行模型拟合。
% [fitresult, gof] = fit( xData, yData, ft, opts );

% % 绘制数据拟合图。
% figure( 'Name', '1' );
% h = plot( fitresult, xData, yData );
% legend( h, 'I vs. U', '1', 'Location', 'NorthEast', 'Interpreter', 'none' );
% % 为坐标区加标签
% xlabel( 'U', 'Interpreter', 'none' );
% ylabel( 'I', 'Interpreter', 'none' );
% grid on
