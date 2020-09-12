% 从最大速度开始筛选
result = table;
for vv = 75.5:-0.001:75.4
    out = vv
    % 指定拟合的模型参数
    lambda = 99.7964;
    h = 1813.6;
    theta = 21.2916;
    sol = TPDESolve(lambda, h, theta, vv);
    sol = sol(:,15);
    restrains = {@RestrainDiff @RestrainRising @RestrainPeakTime @RestrainPeakTemp};
    flag = 0;

    if ~RestrainDiff(sol)
        flag = 1;
    end
    
    if ~RestrainRising(sol) 
        flag = 2;
    end
    
    if ~RestrainPeakTime(sol)
        flag = 3;
    end
    
    if ~RestrainPeakTemp(sol)
        flag = 4;
    end
    
    result = [result; {vv, flag}];
end

function res = RestrainDiff(sol)
%% 斜率是否超过 3？
    tdiff = 2 * diff(sol);
    rising = tdiff(tdiff > 0);
    descending = tdiff(tdiff < 0);
    [rc,~] = size(rising(rising > 3));
    [dc,~] = size(descending(descending < -3));
    if rc ~= 0
        sprintf("升温速度过大。")
        res = false;
        return;
    end
    if dc ~= 0
        sprintf("降温速度过大。")
        res = false;
        return;
    end
    res = true;
end

function res = RestrainRising(sol)
%% 升温时间是否符合要求？
    % 只考虑升温过程
    sol = sol(1:600);
    count = sol(sol > 150 & sol < 190);
    [t, ~] = size(count);
    if t / 2 > 60 && t / 2 < 120
        res = true;
    else
        res = false;
        sprintf("升温时间不合要求。")

    end
end


function res = RestrainPeakTime(sol)
%% 高温时间是否符合要求？

    count = sol(sol > 217);
    [t, ~] = size(count);
    if t / 2 > 40 && t / 2 < 90
        res = true;
    else
        res = false;
        sprintf("高温时间不合要求。")

    end
end


function res = RestrainPeakTemp(sol)
%% 峰值温度是否符合要求？
    mt = max(sol);
    if max(sol) > 240 && max(sol) < 250
        res = true;
    else
        res = false;
        sprintf("峰值温度不合要求。")
    end
end