%% 特定条件下的预测

% 预测得到的参数
lambda = 99.7964;
h = 1813.6;
theta = 21.2916;
V = 78;
sol = TPDESolve(lambda, h, theta, V);
res = sol(:,15);
lines = [25 / (V / 60)];

furnaceLength = 30.5; % 熔炉长度
furnaceGap = 5;  % 熔炉间隙
edgeGap = 25; % 炉前与炉后

% 绘制炉
% figure;
width = 900; height = 350;
set(gcf,'position',[0,0,width,height])
red = '#EB4537';
green = '#55AF7B';
blue = '#4286F3';
plot(0.5:0.5:400, res, 'LineWidth', 2, 'Color', blue);
grid on;
hold on;

% 温度曲线
x = 0.5:0.5:400;
y = 1:800;
for i = 1:800
    y(i) = Tfur(x(i));
end
plot(x, y, 'Color', red, 'LineWidth', 1)

for i=1:11
    lines = [lines, (25 + i * (furnaceLength + furnaceGap)) / (V / 60)];
end

for i=1:12
    line([lines(i) lines(i)], [0 300], 'linewidth', 0.7, 'color', green);
    if i ~= 1
        text(lines(i) - 18, 290,['#', num2str(i - 1)]);
    else
        text(lines(i) - 18, 290,['炉前']);

    end
end
title('问题一预测结果')
xlabel('t (s)');
ylabel('T (^{\circ}C)');

% Mark maximum.
amax = max(res);
tmax = find(res==amax) / 2;
plot(tmax,amax,'Color',red,'Marker','v','LineStyle','none','LineWidth',1);
text(tmax-2,amax*0.9,['最大值: ', num2str(amax), '^{\circ}C']);

lgd = {'预测结果', '炉内理想温度曲线'};

legend(lgd,'location','southoutside','NumColumns',2,'FontSize',10);
axis tight;
xlim([0, 350]);

