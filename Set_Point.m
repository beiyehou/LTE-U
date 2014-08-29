function [Struct] = Set_Point(Struct, centerPoint ,area,start_id )
% 该函数处理输入结构体数组的 Point 属性值

if (~isstruct(Struct) || ~isstruct(area))
    error('The input data is not a struct,please check it !');
end
if ~isfield(Struct, 'point')
    fieldnames(Struct);
    error('There is not filed named point in this struct. ');
end
length_struct = length(Struct);
axis_x = unifrnd(centerPoint.x - area.width, centerPoint.x + area.width ,1,length_struct);
axis_y = unifrnd(centerPoint.y - area.length, centerPoint.y + area.length,1,length_struct);
for i=1:length_struct
    Struct(i).id = start_id + i;
    Struct(i).point(1) = axis_x(i);
    Struct(i).point(2) = axis_y(i);
end

