function Display(Struct,startIndex,count,varargin)
% 该函数用于显示结构体数组的域值，支持多域输入

% struct 要显示的结构体数组
% startindex 开始的下标值
% count 显示的总个数

if ~isstruct(Struct)
    error('Display_Struct error :The first value must be struct! please check again!');
end
if nargin == 1
    count = length(Struct);
    startIndex = 1;
    numberVar = length(fieldnames(Struct));
elseif nargin == 2
    count = length(Struct);
    numberVar = length(fieldnames(Struct));
elseif nargin == 3
    numberVar = length(fieldnames(Struct));
elseif nargin >= 4
    numberVar = nargin - 3;
    for i=1:numberVar
        if ~isfield(Struct,varargin{i})
            error('Display_Struct error : input data is not a field of this Struct!');
        end
    end
end
fields = char(fieldnames(Struct));
if numberVar == length(fieldnames(Struct))
    for i=startIndex:(startIndex+count - 1)
        for j=1:numberVar
            disp(fields(j,:));
            disp(getfield(Struct,{1,i},fields(j,:)));
        end
    end
else
    for i=startIndex:(startIndex+count - 1)
        for j=1:numberVar
            disp(varargin{j});
            disp(getfield(Struct,{1,i},varargin{j}));
        end
    end    
end