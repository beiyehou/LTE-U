function Multiple_core(Loop)
% ����ܶ������
View = 0;
WiFi_num = 1;
LTE_num = 1;
UE_num = 2;
Channel_num = 4;
% function [  ] = LTE_U( Loop,WiFi_type ,WiFi_num,LTE_type ,LTE_num, Channel_num, UE_num ,View)
% SN=Composite();
% for i=1:M
%     SN{i}=SNs(i);
% end
% spmd .... end
%ʹ�ö����Ŀ
lab_num = 2; 
% �� MATLAB ������Դ��
if matlabpool('size') == 0
    matlabpool('open', lab_num);
else
    matlabpool close;
    matlabpool('open', lab_num);
end

WiFi_type = Composite();
LTE_type = Composite();


WiFi_type{1} = 'LTE_NOLBT';
LTE_type{1} = 'LTE_NOLBT';

WiFi_type{2} = 'LTE_LBT';
LTE_type{2} = 'LTE_LBT';


spmd
    [WiFi,LTE,UE] = LTE_U( Loop,WiFi_type ,WiFi_num,LTE_type ,LTE_num, Channel_num, UE_num ,View);
end
% for i=1:lab_num
%     figure;
%     Show_Point(0,WiFi{i},LTE{i},UE{i});
% end

matlabpool close;