function [ Channel,UE,Node1,Node2 ] = Send_Packet( Channel,UE,varargin)
%该函数用于信道发送数据，记录包长，碰撞检测、处理等

% Node 节点结构体数组 WiFi/LTE
%Channel 结构体数组 信道
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
for j=1:length(Channel)
    index = [];
    for k=1:length(Node)
        if Node(1,k).WiFi_LTE == true
            if ~isempty(find([Node(1,k).Channel_id] == j,1))
                index = [index k];
            end
        elseif Node(1,k).WiFi_LTE == false
            if Node(1,k).Channel_id == j
                index = [index k];
            end
        end
    end 
    sending = find([Node.send_enable]==true);
    Channel(1,j).sendQueue = intersect(index,sending);
    if (length(Channel(1,j).sendQueue)>1)
        Channel(1,j).crashQueue = union(Channel(1,j).crashQueue,Channel(1,j).sendQueue);
    end
end
Send_Node = [];
for i=1:length(Node)
    if(Node(1,i).send_enable==true)
        Send_Node = [Send_Node i];    
    end
end

for i=1:length(Send_Node)
    channel_ID = [Node(1,Send_Node(i)).Channel_id];
    channel_num = length(channel_ID);
    Node(1,Send_Node(i)).packet_length = Node(1,Send_Node(i)).packet_length - channel_num;
    if Node(1,Send_Node(i)).packet_length<=0
       Node(1,Send_Node(i)).packet_length = 0;
       Node(1,Send_Node(i)).send_enable = false;
       if Node(1,Send_Node(i)).LBT_enable == true
            Node(1,Send_Node(i)).CCA = randperm(20,1);
       end
       crashQueue = [];
       index = [];
       for j=1:length(channel_ID)
           crashQueue = union([Channel(1,channel_ID(j)).crashQueue],crashQueue);
           for k=1:length(Node)
                if Node(1,k).WiFi_LTE == true
                    if ~isempty(find([Node(1,k).Channel_id] ==channel_ID(j),1))
                        index = [index k];
                    end
                elseif Node(1,k).WiFi_LTE == false
                    if Node(1,k).Channel_id == channel_ID(j)
                         index = [index k];
                    end
                end
           end 
           sending = find([Node.send_enable]==true);
           Channel(1,channel_ID(j)).sendQueue = intersect(index,sending);
           if isempty(Channel(1,channel_ID(j)).sendQueue)
                Channel(1,channel_ID(j)).busy_check = false;
           end
       end
       if isempty(crashQueue)
           index = find([UE.id]==Node(1,Send_Node(i)).UE_id);
            if ~isempty(index)
                UE(1,index).packetlength_receiver = UE(1,index).packetlength_receiver + Node(1,Send_Node(i)).packet_bit; 
            end
            Node(1,Send_Node(i)).waitQueue(1) = [];
       else
        % NOLBT 节点发完包就到 waitQueue 中清除这个包
            if Node(1,Send_Node(i)).LBT_enable == false
               Node(1,Send_Node(i)).waitQueue(1) = [];
            end
       end
       %包发完的Node,将其ID号从占用过的信道crashQueue中删除
       for j=1:length(channel_ID)
           index = find([Channel(1,channel_ID(j)).crashQueue] ==Send_Node(i));
           if ~isempty(index)
               Channel(1,channel_ID(j)).crashQueue(index) = [];
           end
       end       
    end
end
% 返回 Node1 Node2
 if nargin == 3
     Node1 = Node;
elseif nargin == 4
    Node1 = Node(1:length(Node1));
    Node2 = Node(length(Node1)+1:end);
end
end

