function [  ] = main( )
WiFi_num = 16;
LTE_num = 16;
Channel_num = 4;
UE_num =4;
% ȫ�ֱ���
WiFi_Energy = 24;
LTE_Energy = 30;
WiFi_Rate = 54*10^6;
% WiFi �� LTE �ṹ�嶨��

WiFi = struct ( ...
	'point',[0,0], ...
	'distance', 0, ...
	'energy', WiFi_Energy, ...
	'id', num2cell(1:WiFi_num), ...
    'UE_id',0, ...
    'Channel_id',1, ...
	'listen_enable', false, ...
	'send_enable', false, ...
    'total_date', 0, ...
    'total_input',[0 0 0],...
    'packet_length', 0, ...
	'noise', 0, ...
    'LBT_enable', true , ...
    'WiFi_LTE',true, ...
    'CCA',0,...
    'detaT',0.0, ...
	'waitQueue', [] ...
	);

LTE = struct(...
	'point', [0,0], ...
	'distance', 0, ...
	'energy', LTE_Energy, ...
	'id', num2cell(1:LTE_num), ...
    'UE_id',0, ...
    'Channel_id',2, ...
	'listen_enable', false , ...
	'send_enable', false , ...
    'total_date' ,0, ...
    'total_input',[0 0 0],...
    'packet_length', 0, ...
	'noise', 0 , ...
    'LBT_enable', true ,...
    'WiFi_LTE',false,...
    'CCA',0,...
    'detaT',0.0,...
	'waitQueue', [] ... 
	);
% �����ŵ��ṹ��
Channel = struct(...
    'busy_check',false, ...
    'id', num2cell(1:Channel_num) ,...
    'frequency',0.0, ...
    'sendQueue', [] , ...
    'crashQueue', [] ... 
    );
% ���� UE �ṹ��
UE = struct(...
    'id',num2cell(1:UE_num),...
    'point', [0,0], ...
    'sender_id',[],...
    'energy_received', 0.0 , ...
    'packetlength_receiver',0 ...
    );
% ��ʼ�� WiFi �� LTE �ڵ�ṹ������
% function [Struct] = Set_Point(Struct, centerPoint ,area,start_id)
WiFi_leftupPoint.x = 0.0;
WiFi_leftupPoint.y = 0.0;
LTE_leftupPoint.x = 10.0;
LTE_leftupPoint.y = 10.0;
UE_centerPoint.x = 5.0;
UE_centerPoint.y = 5.0;
UE_area.width = 4.0;
UE_area.length = 4.0;
WiFi_area.divx = 20;
WiFi_area.divy = 20;
LTE_area.divx = 20;
LTE_area.divy = 20;
% ���и�״����
[WiFi] = Set_Grid_Point(WiFi,WiFi_area,WiFi_leftupPoint,0,'WiFi_LBT');
[LTE] = Set_Grid_Point(LTE,LTE_area,LTE_leftupPoint,length(WiFi),'LTE_LBT');
[UE] = Set_Rnd_Point(UE, UE_centerPoint ,UE_area,0 );
Show_Point(0,WiFi,LTE,UE);