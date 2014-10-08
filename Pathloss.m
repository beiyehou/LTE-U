function [pathloss] = Pathloss(UE,Channel,varargin)
% �˺������ڼ��㴫���е�·���
% ����M.2135 TABLE A1-2 ����·�� (UMi��UMa)

% Node  ����WIFI��LTE�ڵ�
% IN_OUTDOOR  1������  0������
% LOS_NLOS  1���Ӿ�  0���Ӿ�

% Node �ڵ�ṹ������ WiFi/LTE
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

% ����·��ģ��
SCENARIOS_INH = 1;
SCENARIOS_UMI = 2;
SCENARIOS_UMA = 3;
SCENARIOS_RMA = 4;

% �������
IN_OUTDOOR = 0;
LF = 0;
LNLOS = 15;
%¥�㴩͸����
Pf = 16; 

distance = zeros(length(Node),length(UE));
pathloss = zeros(length(Node),length(UE),length(Channel));

% ���㴫�����
for i = 1:length(Node)
    for j = 1:length(UE)
        distance(i,j) = sqrt((Node(1,i).point(1)-UE(1,j).point(1))^2 +(Node(1,i).point(2)-UE(1,j).point(2))^2);  
    end   
end

% ����·��
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