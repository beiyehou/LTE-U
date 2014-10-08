function [Node1,Node2] = Comopute_SNR(UE,pathloss,varargin)
% �˺������ڼ�����ն˵��ź������ֵ

% �������
WiFi_Energy = 24;
LTE_Energy = 30;
WiFi_GT = 5;
LTE_GT = 15; 
UE_GR = -4;
ACLR = 45;
FEEDER_LOSS = 3;

% % ���ڲ���
% WiFi_Energy = 17;
% LTE_Energy = 20;
% WiFi_GT = 5;
% LTE_GT = 5; 
% UE_GR = -4;
% ACLR = 45;
% FEEDER_LOSS = 3;

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

receiving_Index_sum = [];  
sending_Index_sum = find([Node.send_enable] == true);
if ~isempty(sending_Index_sum)
    for i = 1:length(sending_Index_sum)
        index = [Node(1,sending_Index_sum(i)).UE_id];
        if (index ~= 0)
            %����������ڽ��յ�UE�±�
            receiving_Index_sum = union(receiving_Index_sum,index);
        end        
    end
    % ���ս��ն˵�UE����ѭ��
    for i = 1:length(receiving_Index_sum)
        % ������һUEֻ��һ�����Ͷ����
        sending_Index = find([Node.UE_id] == UE(1,receiving_Index_sum(i)).id); 
        % Ŀ��ڵ�ʹ�õ��ŵ���
        sending_Channel = [Node(1,sending_Index).Channel_id];
        if (Node(1,sending_Index).WiFi_LTE == true)
            Pt = WiFi_Energy;
            Gt = WiFi_GT;
        elseif (Node(1,sending_Index).WiFi_LTE == false)
            Pt = LTE_Energy;
            Gt = LTE_GT ;
        end
        % �������������ֵ
        for j = 1:length(sending_Index_sum)
            if (sending_Index_sum(j) == sending_Index)
                for k = 1:length(sending_Channel)
                    % Ŀ��ڵ��ڸ����ŵ��Ľ�������
                   Node(1,sending_Index).energy(k) =10^(( Pt + Gt - FEEDER_LOSS + UE_GR - pathloss(sending_Index,receiving_Index_sum(i),sending_Channel(k)))/10);
                end
                %Ŀ��ڵ�ĸ��ż���
            elseif(sending_Index_sum(j) ~= sending_Index)
                interference_Index_channel = [Node(1,sending_Index_sum(j)).Channel_id];
                for k = 1:length(sending_Channel)
                    for m = 1:length(interference_Index_channel)
                        % ͬƵ����
                        if (interference_Index_channel(m) == sending_Channel(k))
                            Pr = Pt + Gt - FEEDER_LOSS + UE_GR - pathloss(sending_Index_sum(j),receiving_Index_sum(i),sending_Channel(k));
                            Node(1,sending_Index).noise(k) = Node(1,sending_Index).noise(k) + 10^(Pr/10); 
                            % ��Ƶ����
                        elseif ((interference_Index_channel(m) == sending_Channel(k) + 1 )||(interference_Index_channel(m) == sending_Channel(k) -1 ))
                            Pr = Pt - ACLR + Gt - FEEDER_LOSS + UE_GR - pathloss(sending_Index_sum(j),receiving_Index_sum(i),interference_Index_channel(m));
                            Node(1,sending_Index).noise(k) = Node(1,sending_Index).noise(k) + 10^(Pr/10);
                        end
                    end
                end
            end           
        end  
    end
end    
% ���� Node1 Node2
if nargin == 3
     Node1 = Node;
elseif nargin == 4
    Node1 = Node(1:length(Node1));
    Node2 = Node(length(Node1)+1:end);
end
end
