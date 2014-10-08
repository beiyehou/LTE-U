function [Channel,Node1,Node2] = Set_Packet(Channel,detaTime, dateRate,deta, max_packet_length,varargin)
% 该函数用于设置某一时刻的包长

% Struct 节点结构体数组  WiFi / LTE
% Channel 信道
% detaTime 指数分布参数 均值 180s
% deta 每次主循环的时间间隔，单位为 s
% dateRate 节点的数据传输速率 如： 54Mbit/s
% max_packet_length WiFi 节点一帧的最大应用层数据长度，无量纲时间块的个数
% 节点的 LBT 类型，WiFi_LBT / WiFi_NOLBT / LTE_LBT / LTE_NOLBT

% 将最大时间片长装换为对应的bit
% max_packet_length = max_packet_length*(deta*dateRate);
% 定义两个局部变量数据到达的正态分布的均值和方差
% mean 2Mbytes  sigma 0.722 Mbytes  max_value 5Mbytes
% LTE_Frame LTE 一帧 为 2ms
mean_value = 2*10^6*8;
sigma_value = 0.722*10^6*8;
max_value = 5*10^6*8;
LTE_Frame = 2*10^(-3);
Node1 = [];
Node2 = [];
Struct = [];

if nargin < 6
    error('Input less than six ,please check the input');
elseif nargin == 6
    Node1 = varargin{1};
    Struct = Node1;
elseif nargin == 7
    Node1 = varargin{1};
    Node2 = varargin{2};
    Struct = [Node1 Node2];
end

if ~isstruct(Struct) 
    error('Input data is not a sturct,please check again!');
end
if (~isfield(Struct,'packet_length') || ~isfield(Struct,'listen_enable'))
    error('There is no filed length or listen_enble in this Struct ,please check your input!');
end
 % 检查业务是否有数据到达，到达了存入 total_date 中
 detaT = [Struct.detaT]; 
 Less_than_zero = find(detaT<=0.0);
 if ~isempty(Less_than_zero)
     for i=1:length(Less_than_zero)
         Struct(1,Less_than_zero(i)).detaT = exprnd(detaTime);
         packet = ceil(normrnd(mean_value,sigma_value));
         packet = min(abs(packet),max_value);
         % 存到达业务量总数
         Struct(1,Less_than_zero(i)).total_input(3) = Struct(1,Less_than_zero(i)).total_input(3) + packet;
         Struct(1,Less_than_zero(i)).total_input(2) = Struct(1,Less_than_zero(i)).total_input(2) + floor(Struct(1,Less_than_zero(i)).total_input(3)/10^6);
         Struct(1,Less_than_zero(i)).total_input(3) = mod(Struct(1,Less_than_zero(i)).total_input(3),10^6);
         Struct(1,Less_than_zero(i)).total_input(1) = Struct(1,Less_than_zero(i)).total_input(1) + floor(Struct(1,Less_than_zero(i)).total_input(2)/10^3);
         Struct(1,Less_than_zero(i)).total_input(2) = mod(Struct(1,Less_than_zero(i)).total_input(2),10^3);
         % 按 G  10M  bit  进制
         Struct(1,Less_than_zero(i)).total_date(3) = Struct(1,Less_than_zero(i)).total_date(3) + packet;
         Struct(1,Less_than_zero(i)).total_date(2) = Struct(1,Less_than_zero(i)).total_date(2) + floor(Struct(1,Less_than_zero(i)).total_date(3)/(10*10^6));
         Struct(1,Less_than_zero(i)).total_date(3) = mod(Struct(1,Less_than_zero(i)).total_date(3),10*10^6);
         Struct(1,Less_than_zero(i)).total_date(1) = Struct(1,Less_than_zero(i)).total_date(1) + floor(Struct(1,Less_than_zero(i)).total_date(2)/10^2);
         Struct(1,Less_than_zero(i)).total_date(2) = mod(Struct(1,Less_than_zero(i)).total_date(2),10^2);         
     end
 end
 
 Great_than_zero = find(detaT>0.0);
 if ~isempty(Great_than_zero)
     for i=1:length(Great_than_zero)
         Struct(1,Great_than_zero(i)).detaT = Struct(1,Great_than_zero(i)).detaT - deta;
     end
 end
 % 检查节点的 packet_length 信号量，如果不为 0 说明该节点有包在发送
 % 如果为 packet_length 0 说明无包发送 &&  waitQueue 为空 && total_date ! =0 此时生成一个数据包放在 waitQueue 中
 Packet_length = [Struct.packet_length];
 Packet_index = find(Packet_length <= 0);
 
 Wait_index = [];
 Total_index = [];
 for i=1:length(Struct)
     if isempty(Struct(1,i).waitQueue)
         Wait_index = [Wait_index i];
     end
     if Struct(1,i).total_date(3) >0
         Total_index = [Total_index i];
     end
 end

 
 
 index = intersect(Packet_index,Wait_index );
 index = intersect(Total_index, index);
 % 生成数据包
 if ~isempty(index)
     for i=1:length(index)
         if Struct(1,index(i)).WiFi_LTE == true
            % 按 G 10M bit 的进制计算
             if Struct(1,index(i)).total_date(3) >= ceil(max_packet_length*(deta*dateRate))
                Struct(1,index(i)).waitQueue = [Struct(1,index(i)).waitQueue max_packet_length];
                
                Struct(1,index(i)).packet_bit = ceil(max_packet_length*(deta*dateRate));
                Struct(1,index(i)).total_date(3) = Struct(1,index(i)).total_date(3) - Struct(1,index(i)).packet_bit;
             else
                 if Struct(1,index(i)).total_date(2) >= 1
                    Struct(1,index(i)).total_date(2) = Struct(1,index(i)).total_date(2) - 1;
                    Struct(1,index(i)).total_date(3) = Struct(1,index(i)).total_date(3) + 10*10^6;
                    
                    Struct(1,index(i)).packet_bit = ceil(max_packet_length*(deta*dateRate));
                    Struct(1,index(i)).total_date(3) = Struct(1,index(i)).total_date(3) - Struct(1,index(i)).packet_bit;  
                    Struct(1,index(i)).waitQueue = [Struct(1,index(i)).waitQueue max_packet_length];
                 else
                     if Struct(1,index(i)).total_date(1) >= 1
                         Struct(1,index(i)).total_date(1) = Struct(1,index(i)).total_date(1) - 1;
                         Struct(1,index(i)).total_date(2) = Struct(1,index(i)).total_date(2) + 10^2;  
                         Struct(1,index(i)).total_date(2) = Struct(1,index(i)).total_date(2) - 1;
                         Struct(1,index(i)).total_date(3) = Struct(1,index(i)).total_date(3) + 10*10^6;
                         
                         Struct(1,index(i)).packet_bit = ceil(max_packet_length*(deta*dateRate));
                        Struct(1,index(i)).total_date(3) = Struct(1,index(i)).total_date(3) - Struct(1,index(i)).packet_bit; 
                        Struct(1,index(i)).waitQueue = [Struct(1,index(i)).waitQueue max_packet_length];
                     else
                         Struct(1,index(i)).packet_bit = Struct(1,index(i)).total_date(3);
                         Struct(1,index(i)).waitQueue = [Struct(1,index(i)).waitQueue ceil(Struct(1,index(i)).total_date(3)/(deta*dateRate))];
                         Struct(1,index(i)).total_date(3) = 0;
                     end
                 end
             end

         elseif Struct(1,index(i)).WiFi_LTE == false
             SNR = 10*log10(sum(Struct(1,index(i)).energy)/sum(Struct(1,index(i)).noise));
             TBS = Select_TBS(SNR);
             Struct(1,index(i)).waitQueue = [Struct(1,index(i)).waitQueue ceil(LTE_Frame/deta)];
            % 按 G 10M bit 的进制计算
             if Struct(1,index(i)).total_date(3) >= TBS

                Struct(1,index(i)).packet_bit = TBS;
                Struct(1,index(i)).total_date(3) = Struct(1,index(i)).total_date(3) - Struct(1,index(i)).packet_bit;
             else
                 if Struct(1,index(i)).total_date(2) >= 1
                    Struct(1,index(i)).total_date(2) = Struct(1,index(i)).total_date(2) - 1;
                    Struct(1,index(i)).total_date(3) = Struct(1,index(i)).total_date(3) + 10*10^6;
                    
                    Struct(1,index(i)).packet_bit = TBS;
                    Struct(1,index(i)).total_date(3) = Struct(1,index(i)).total_date(3) - Struct(1,index(i)).packet_bit;  

                 else
                     if Struct(1,index(i)).total_date(1) >= 1
                         Struct(1,index(i)).total_date(1) = Struct(1,index(i)).total_date(1) - 1;
                         Struct(1,index(i)).total_date(2) = Struct(1,index(i)).total_date(2) + 10^2;  
                         Struct(1,index(i)).total_date(2) = Struct(1,index(i)).total_date(2) - 1;
                         Struct(1,index(i)).total_date(3) = Struct(1,index(i)).total_date(3) + 10*10^6;
                         
                        Struct(1,index(i)).packet_bit = TBS;
                        Struct(1,index(i)).total_date(3) = Struct(1,index(i)).total_date(3) - Struct(1,index(i)).packet_bit;   

                     else
                         Struct(1,index(i)).packet_bit = Struct(1,index(i)).total_date(3);
                         Struct(1,index(i)).total_date(3) = 0;
                     end
                 end
             end

         end
     end
 end
 
 if ~isempty(Packet_index)
     for i=1:length(Packet_index)
         if Struct(1,Packet_index(i)).WiFi_LTE == true
             Struct(1,Packet_index(i)).noise = [0 0 0 0];
             Struct(1,Packet_index(i)).energy = [0 0 0 0];    
         elseif Struct(1,Packet_index(i)).WiFi_LTE == false
             Struct(1,Packet_index(i)).noise = [0];
             Struct(1,Packet_index(i)).energy =[0];             
         end
     end
 end
 %%%%%%%%%% 备注 此处还需考虑 LTE 节点查SNR 计算 TBS 数据块大小的选取%%%%%%%%%%%
 %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
CCA_nozero = [Struct.CCA];
 % CCA 的值对非零值进行递减操作
CCA_index = find(CCA_nozero ~= 0);
if ~isempty(CCA_index)
    for i=1:length(CCA_index)
        Struct(1,CCA_index(i)).CCA = Struct(1,CCA_index(i)).CCA - 1;
    end
end
 % 有 LBT时 检查 Wait 队列不为空 和 CCA 的值为零  packet_lenght 为零决定可监听的节点
 % 置标志位 listen_enable 为 1
 
 % 没有 LBT 时，不检查 CCA 的值，置 send_enable 标志位
 % 由于 NOLBT 不参加监听队列 ，所以 CCA 一直为零可以重用代码
 CCA_nozero = [Struct.CCA];
 CCA_index = find(CCA_nozero == 0);
 index = [];
 Wait_index = [];
 for i=1:length(Struct)
     if ~isempty(Struct(1,i).waitQueue)
         Wait_index = [Wait_index i];
         if (Struct(1,i).waitQueue(1)<=0)
             error('set packet waitQueue null');
         end
     end
 end
 Packet_index = find([Struct.packet_length] == 0);
 if (~isempty(CCA_index) && ~isempty(Wait_index) && ~isempty(Packet_index))  
    index = intersect(CCA_index,Wait_index);
    index = intersect(index,Packet_index);
 end
 if ~isempty(index)
     for i=1:length(index)
         if  Struct(1,index(i)).LBT_enable == false;
             Struct(1,index(i)).send_enable = true;
             if  Struct(1,index(i)).WiFi_LTE == true  
                 WiFi_Channel = Struct(1,index(i)).Channel_id;
                 if isempty(WiFi_Channel)
                     error('WiFi Channel is empty!');
                 end
                 for j=1:length(WiFi_Channel)
                    Channel(1,WiFi_Channel(j)).busy_check = true;
                 end
             elseif  Struct(1,index(i)).WiFi_LTE == false
                 Channel(1,Struct(1,index(i)).Channel_id).busy_check = true;
             end
             Struct(1,index(i)).packet_length =  Struct(1,index(i)).waitQueue(1);
         elseif  Struct(1,index(i)).LBT_enable == true;
            Struct(1,index(i)).listen_enable = true;
         end
     end
 end
 
 % 返回 Node1 Node2
 if nargin == 6
     Node1 = Struct;
elseif nargin == 7
    Node1 = Struct(1:length(Node1));
    Node2 = Struct(length(Node1)+1:end);
end