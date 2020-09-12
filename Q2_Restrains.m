% 从最大速度开始筛选
result = [];
for vv = 100:-1:65
    out = vv
    % 指定拟合的模型参数
    lambda = 71.6;
    h = 1130.5;
    sol = TPDESolve(lambda, h, vv);
    sol = sol(:,15);
    restrains = {@RestrainDiff @RestrainRising @RestrainPeakTime @RestrainPeakTemp};
    flag = 1;

    if ~RestrainDiff(sol) || ~RestrainRising(sol) || ~RestrainPeakTime(sol) || ~RestrainPeakTemp(sol)
        flag = 0;
    end
%     for i=1:4
%         if restrains{i}(sol) 
%             flag = 0;
%             break;
%         end
%     end
    if flag
        result(vv) = 1;
    end
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