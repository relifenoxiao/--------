% 创建新的图形窗口并设置大小
f = figure;
f.Position = [100 0 800 1000];

% 表头内阻测量值
Rg = 160;

% 绘制△I-Ix校准曲线
subplot(2, 1, 1);
Ix = [0.12 0.2 0.32 0.4 0.52 0.6 0.72 0.8 0.92 1.0]; % 电流（mA）
I = [-0.01 -0.025 -0.035 -0.02 -0.035 -0.015 -0.02 -0.02 -0.025 -0.02]; % 误差△I（mA）

plot(Ix, I, 'o-');
hold on;
xlabel('改装表读数 Ix(mA)');
ylabel('误差 △I(mA)');
title('△I-Ix校准曲线');
disp('精度等级是:')
disp(max(abs(I)) / 5)

%% △U-Ux
subplot(2, 1, 2);
Ux = [0.12 0.2 0.32 0.4 0.52 0.6 0.72 0.8 0.92 1.0];
U = [-0.01 -0.035 -0.01 -0.015 -0.02 -0.015 0 0 -0.05 0];

plot(Ux, U, 'o-');
xlabel('改装表读数 Ux(V)');
ylabel('误差 △U(V)');
title('△U-Ux校准曲线');
disp('精度等级是:')
disp(max(abs(U)) / 5)
