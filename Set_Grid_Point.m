function [Struct] = Set_Grid_Point(Struct, area,leftupPoint,start_id,LBT_type)
% 该函数处理输入结构体数组的 Point 属性值
% 同时对节点 id 号赋值

% leftupPoint 左上角的坐标
% start_id 开始的 id 号
% LBT_type LBT 标志位
if (~isstruct(Struct) || ~isstruct(area))
    error('The input data is not a struct,please check it !');
end
if ~isfield(Struct, 'point')
    fieldnames(Struct);
    error('There is not filed named point in this struct. ');
end

grid_num = search_square(length(Struct));
Point(1,grid_num) = struct('x',[],'y',[]);
% 向右为 x 轴正轴。向上为 y 轴正轴\
% 先列后行
for i=1:sqrt(grid_num)
    for j=1:sqrt(grid_num)
        Point(1,(i-1)*sqrt(grid_num)+j).x = leftupPoint.x + (i-1)*area.divx;
        Point(1,(i-1)*sqrt(grid_num)+j).y = leftupPoint.y + (j-1)*area.divy;
    end
end

Point_index = randperm(grid_num,length(Struct));
for i=1:length(Point_index)
    Struct(1,i).id = start_id + i;
    Struct(1,i).point(1) = Point(1,Point_index(i)).x;
    Struct(1,i).point(2) = Point(1,Point_index(i)).y;
    if (strcmp(LBT_type(end-4:end) , 'NOLBT'))
        Struct(1,i).LBT_enable = false;
    elseif (strcmp(LBT_type(end-2:end) , 'LBT'))
        Struct(1,i).LBT_enable = true;
    end
    if (strcmp(LBT_type(1:4),'WiFi'))
        Struct(1,i).WiFi_LTE = true;
    elseif (strcmp(LBT_type(1:3),'LTE'))
        Struct(1,i).WiFi_LTE = false;
    end
end

%%%%%%%%%%%%%%%%%%%%%%%
function [num] = search_square(num)
% 该子函数用于寻找最接近给定值的平方根

while 1
    if (num == ceil(sqrt(num))*ceil(sqrt(num)))
        break;
    else
        num = num + 1;
    end
end
