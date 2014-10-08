function [UE,Channel,Node1,Node2] = Dispatch_Stream(UE,Channel,varargin)
% �ú����ƶ�Դ��Ŀ�Ľ��յ������
% �������ݵĸ�ʽ  UE,WiFi,[1 3 0 4],LTE,[0 2 0 3]
% 0 ��ʾ�����κ���֪��UE ��������
% ���㼴���ƶ� id �� UE ��������

Node1   = [];
Node2   = [];
Node     = [];
if mod(nargin,2) ~= 0
    error('Dispatch_Stream input data form not support ,UE,WiFi,[1 3 0 4],LTE,[0 2 0 3]');
end
if (nargin-2) == 2
    Node1 = varargin{1};
    UE_array1= varargin{2};
    for i=1:length(Node1)
        Node1(1,i).UE_id = UE_array1(i);
    end
elseif (nargin - 2) == 4
    Node1 = varargin{1};
    UE_array1= varargin{2};
    Node2 = varargin{3};
    UE_array2= varargin{4};
    for i=1:length(Node1)
        Node1(1,i).UE_id = UE_array1(i);
        if UE_array1(i) ~= 0
            UE(1,Node1(1,i).UE_id).sender_id = [UE(1,Node1(1,i).UE_id).sender_id Node1(1,i).id]; 
        end
    end
     for i=1:length(Node2)
        Node2(1,i).UE_id = UE_array2(i);
        if UE_array2(i) ~= 0
            UE(1,Node2(1,i).UE_id).sender_id = [UE(1,Node2(1,i).UE_id).sender_id Node2(1,i).id];
        end
     end
else
    error('Dispatch_Stream too many input !');
end
Node = [Node1 Node2];
 for i=1:length(Node)
     % WiFi ���ŵ�    LTE �� 1 ���ŵ� ����Ƶ  4 - 1 ���� ��֧�� ���Ͷ˶� 2 �ڵ�
     if  Node(1,i).WiFi_LTE == true
         Node(1,i).Channel_id = [1:length(Channel)];
     elseif Node(1,i).WiFi_LTE == false
         Node(1,i).Channel_id = 1;
     end

    % ��Ƶ���� ��Ƶ 1 - 1 ��֧�ַ��Ͷ� 2 �ڵ�  4 �ڵ㳡��
%      if(mod(i,2)==0)
%         Node(1,i).Channel_id = 2;
%      else
%         Node(1,i).Channel_id = 1;
%      end
 end
 
 % ���� Node
 if (nargin-2) == 2
     Node1 = Node(1:length(Node1));
 elseif (nargin-2) == 4
     Node1 = Node(1:length(Node1));
     Node2 = Node((length(Node1)+1):end);
 end