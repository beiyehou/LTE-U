function [] = Display_status(Node,bar_handler,Loop,barh_handler,Channel,Channel_bar_handler,axes_Channel_handler)
% 该函数用视图形式显示各节点的状态信息
% Node 输入的结构体数组，包括 WiFi 和 LTE
Node_total_date = [];
for i=1:length(Node)
    Node_total_date(i) = Node(1,i).total_date(1)*10^9 + Node(1,i).total_date(2)*10^7 + Node(1,i).total_date(3);
end
bar_group = [Node_total_date*10^(-3) ; [Node.detaT].*20;[Node.CCA].*200;[Node.send_enable].*400;[Node.LBT_enable].*400];

Channel_send_queue = [];
Channel_crash_queue = [];
for i=1:length(Channel)
    Channel_send_queue(i) =  length(Channel(1,i).sendQueue);
    Channel_crash_queue(i) = length((Channel(1,i).crashQueue));    
end
set(axes_Channel_handler,'XLim',[0 max([max(Channel_send_queue) max(Channel_crash_queue)]) + 1]);
Channel_group = [Channel_send_queue;Channel_crash_queue];


for i=1:length(bar_handler)
    set(bar_handler(i),'YData',bar_group(i,:));
end
for i=1:length(barh_handler)
    set(barh_handler(i),'YData',Loop);
end
for i=1:length(Channel_bar_handler)
    set(Channel_bar_handler(i),'YData',Channel_group(i,:));
end
drawnow;
% legend(bar_handler,'Location','SouthEastOutside','total date','detaT');