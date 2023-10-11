%data为输入数据；m为模板维数，通常取2,3,4；r为模板匹配相似容忍度，通常取0.1-0.25倍的信号标准差
function output = TL3_SampEn(data,m,r)
N = length(data);
% m = 2;
% r = 0.25;
r = r*std(data);
%% 模版构成
for i = 1:N-m+1
    X(i,:) =data(i:i+m-1);%构造m维模板，模板总数为N-m+1,每个模板包含m个数
end
%% 计算距离
for i = 1:N-m+1
    data2 = X(i,:);%选择第i个模板
    data22 = X;
    data22(i,:) = [];%将m维模板中的第i个模板去掉
    d2 = [ones(N-m,1) * data2] - data22;%计算第i个模板到其他N-m个模板的对应点的距离，即消除了自身模板匹配
    num2 = 0;
    for j = 1:N-m
        if max(abs(d2(j,:))) < r%求两个模板对应点的距离的最大值
            num2 = num2 + 1;;%如果最大距离包含在相似容忍度内，表示两个模板相似
        end
    end
    c2(i) = num2/(N-m);%模板相似的个数除以模板匹配的个数即为相似模板的比例
    clear data22
end
%% 计算平均相似率
y2 = sum(c2)/(N-m+1);


%% 模版构成
m = m + 1;
for i = 1:N-m+1
    Y(i,:) = data(i:i+m-1);
end
%% 计算距离
for i = 1:N-m+1
    data3 = Y(i,:);
    data33 = Y;
    data33(i,:) = [];
    d3 = [ones(N-m,1) * data3] - data33;
    num3 = 0;
    for j = 1:N-m
        if max(abs(d3(j,:))) < r
            num3 = num3 + 1;
        end
    end
    c3(i) = num3/(N-m);
    clear data33
end
y3 = sum(c3)/(N-m+1);
%% 计算样本熵
output = -log(y3/y2);%y2为m维模板的平均相似率，y3为m+1维的平均相似率