function [pathloss] = Pathloss(UE,Channel,varargin)
% 此函数用于计算传输中的路损表，
% 按照M.2135 TABLE A1-2 计算路损 (UMi和UMa)

% Node  所有WIFI和LTE节点
% IN_OUTDOOR  1表室内  0表室外
% LOS_NLOS  1表视距  0非视距

% Node 节点结构体数组 WiFi/LTE
Node1 = [];
Node2 = [];
Node = [];
if nargin == 2
    error('Input must has one Node Struct!');
elseif nargin == 3
     Node1 = varargin{1};
     Node = Node1;
elseif nargin == 4
    Node1 = varargin{1};
    Node2 = varargin{2};
    if Node1(1,1).id > Node2(1,1).id
        Node = [Node2 Node1];
    else
        Node = [Node1 Node2];
    end
end

% 四种路损模型
SCENARIOS_INH = 1;
SCENARIOS_UMI = 2;
SCENARIOS_UMA = 3;
SCENARIOS_RMA = 4;

% 输入参数
IN_OUTDOOR = 0;
LF = 0;
LNLOS = 15;
%楼层穿透因子
Pf = 16; 

distance = zeros(length(Node),length(UE));
pathloss = zeros(length(Node),length(UE),length(Channel));

% 计算传输距离
for i = 1:length(Node)
    for j = 1:length(UE)
        distance(i,j) = sqrt((Node(1,i).point(1)-UE(1,j).point(1))^2 +(Node(1,i).point(2)-UE(1,j).point(2))^2);  
    end   
end

% 计算路损
for i = 1:length(Node)
    for j = 1:length(UE)
        for k = 1:length(Channel);
            fc = Channel(k).frequency;
            d = distance(i,j);
            if (IN_OUTDOOR == 1)
                LOS_NLOS = LOS_NLOS_select(SCENARIOS_INH,d);
                if (Node(1,i).WiFi_LTE == true)
                    pathloss(i,j,k) = 20 * log10(fc * 10 ^(-6)) + 26 * log10(d) + Pf  -28;
                elseif (Node(1,i).WiFi_LTE == false)
                    pathloss(i,j,k) = LTE_model(SCENARIOS_INH,IN_OUTDOOR,LOS_NLOS,d,fc);
                end
            elseif (IN_OUTDOOR == 0)
                LOS_NLOS = LOS_NLOS_select(SCENARIOS_UMA,d);
                if (Node(1,i).WiFi_LTE == true)
                    if (LOS_NLOS == 1)
                        pathloss(i,j,k) = 32.4 + 26 * log10(d* 10^(-3)) +20 * log10(fc * 10 ^(-6));
                    elseif(LOS_NLOS == 0) 
                        pathloss(i,j,k) = 32.4 + 20 * log10(d* 10^(-3)) + 20 * log10(fc * 10 ^(-6)) + LF  + LNLOS; % f  MHz
                    end
                elseif (Node(1,i).WiFi_LTE == false)
                    pathloss(i,j,k) = LTE_model(SCENARIOS_UMA,IN_OUTDOOR,LOS_NLOS,d,fc);
                end
            end
        end
    end
end