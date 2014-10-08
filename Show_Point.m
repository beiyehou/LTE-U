function Show_Point(holdflag,varargin)
% 显示散点结构
if nargin < 2
    error('You must input a sturct to show');
end
if holdflag
    hold on;
else
    cla;
    hold on;
end
if nargin >= 2
    Struct = varargin{1};
    Struct_Point = reshape([Struct.point],2,[]);
    plot(Struct_Point(1,:),Struct_Point(2,:),'.r','MarkerSize',20);    
    legend(gca,'first','Location','SouthWestOutside');
end
if nargin >=3
    Struct = varargin{2};
    Struct_Point = reshape([Struct.point],2,[]);
    plot(Struct_Point(1,:),Struct_Point(2,:),'.g','MarkerSize',20);   
    legend(gca,'first','second','Location','SouthWestOutside');
end
if nargin >= 4
    Struct = varargin{3};
    Struct_Point = reshape([Struct.point],2,[]);
    plot(Struct_Point(1,:),Struct_Point(2,:),'.b','MarkerSize',20); 
    legend(gca,'first','second','third','Location','SouthWestOutside');
end
% Text
Node = [];
UE = [];
for i =1:length(varargin)
    Struct = varargin{i};
    if isfield(Struct,'UE_id')
        Node = [Node Struct];
    elseif isfield(Struct,'sender_id')
        UE = [UE Struct];
    end
end
if ~isempty(Node)
    Node_Text(Node);
end
if ~isempty(UE)
    Node_Text(UE);
end
% Line
if ~isempty(Node)
    for i=1:length(Node)
        if Node(1,i).UE_id ~= 0
            line([Node(1,i).point(1) UE(1,Node(1,i).UE_id).point(1)],[Node(1,i).point(2) UE(1,Node(1,i).UE_id).point(2)]);
        end
    end
end
% Text sub function
function result = Node_Text(Node)
if ~isempty(Node)
    for i=1:length(Node)
        text(Node(1,i).point(1)+0.4,Node(1,i).point(2)+0.4,num2str(Node(1,i).id),'EdgeColor',[0.5,0,0]);
    end
    result = true;
else
    result = false;
end
