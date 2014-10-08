function [Channel,Node1,Node2] = listen(Channel,varargin)
%该函数用于监听处理、CCA赋值

% Node 节点结构体数组 WiFi/LTE
%Channel 结构体数组 信道   
listenQueue = [];
Node1 = [];
Node2 = [];
Node = [];
if nargin == 1
    error('Input must has one Node Struct!');
elseif nargin == 2
     Node1 = varargin{1};
     Node = Node1;
     listenQueue = find([Node1.listen_enable]==true);
elseif nargin == 3
    Node1 = varargin{1};
    Node2 = varargin{2};
    if Node1(1,1).id > Node2(1,1).id
        Node = [Node2 Node1];
        listenQueue = find([Node2.listen_enable Node1.listen_enable]==true);
    else
        Node = [Node1 Node2];
        listenQueue = find([Node1.listen_enable Node2.listen_enable]==true);
    end
end
listenQueue = listenQueue(randperm(numel(listenQueue)));
index = [];
if ~isempty(listenQueue)
    for i=1:length(listenQueue)
        if Node(1,listenQueue(i)).WiFi_LTE == true
            if isempty(find([Channel.busy_check] == true,1))
                index = [index i];
                for i=1:length(Channel)
                    Channel(1,i).busy_check = true;
                end
            end
        elseif Node(1,listenQueue(i)).WiFi_LTE == false
            if (Channel(1,Node(1,listenQueue(i)).Channel_id).busy_check == false)
                index = [index i];
                Channel(1,Node(1,listenQueue(i)).Channel_id).busy_check = true;
            end
        end   
    end

    if ~isempty(index)
        for i=1:length(index)
            Node(1,listenQueue(index(i))).send_enable = true;
            Node(1,listenQueue(index(i))).listen_enable = false;
            Node(1,listenQueue(index(i))).packet_length = Node(1,listenQueue(index(i))).waitQueue(1);      
        end
        listenQueue(index) = [];
    end
    if ~isempty(listenQueue)
        for i=1:length(listenQueue)
            Node(1,listenQueue(i)).listen_enable = false;
            Node(1,listenQueue(i)).CCA = randperm(20,1);
        end
    end
end

 if nargin == 2
     Node1 = Node;
elseif nargin == 3
    Node1 = Node(1:length(Node1));
    Node2 = Node(length(Node1)+1:end);
end
end