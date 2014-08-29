function [Struct,index] = Set_Packet(Struct,dataRate, deta)
% 该函数用于设置某一时刻的包长

% Struct 节点结构体数组  WiFi / LTE
% Channel 信道
% dataRate 泊松分布参数
%deta 每次主循环的时间间隔

if ~isstruct(Struct) 
    error('Input data is not a sturct,please check again!');
end
if (~isfield(Struct,'packet_length') || ~isfield(Struct,'listen_enable'))
    error('There is no filed length or listen_enble in this Struct ,please check your input!');
end
 % 检查业务是否有数据包到达
 detaT = [Struct.detaT];
 Great_than_zero = find(detaT>0.0);
 if ~isempty(Great_than_zero)
     for i=1:length(Great_than_zero)
         Struct(1,Great_than_zero(i)).detaT = Struct(1,Great_than_zero(i)).detaT - deta;
     end
 end
 
 Less_than_zero = find(detaT<=0.0);
 if ~isempty(Less_than_zero)
     for i=1:length(Less_than_zero)
         Struct(1,Less_than_zero(i)).detaT = exprnd(1/dataRate);
         packet = randi([100,2000]);
         Struct(1,Less_than_zero(i)).waitQuene = [Struct(1,Less_than_zero(i)).waitQuene packet];
     end
 end
 % 检查 Wait 队列 和 CCA 的值决定可监听的节点
 % 置标志位 listen_enable 为 1
 CCA_nozero = [Struct.CCA];
 Wait_quene = [Struct.waitQuene];
 CCA_index = find(CCA_nozero ~= 0);
 Wait_index = find(~isempty(Wait_quene));
 index = intersect(CCA_index, Wait_index);
 if (~isempty(CCA_index) && ~isempty(Wait_index))  
    index = intersect(CCA_index,Wait_index);
 end
 if ~isempty(index)
     for i=1:length(index)
         Struct(1,index(i)).listen_enable = true;
     end
 end
 % CCA 的值对非零值进行递减操作
if ~isempty(CCA_index)
    for i=1:length(CCA_index)
        Struct(1,CCA_index(i)).CCA = Struct(1,CCA_index(i)).CCA - 1;
    end
end
