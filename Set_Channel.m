function [Channel] = Set_Channel(Channel)
% ����Channel �� id �� Ƶ��

Frequency = [5825 5805 5785 5765 5745 5300 5280 5260]*10^6;
for i=1:length(Channel)
    % id 
    Channel(1,i).id = i;
    % Ƶ�� MHz
    Channel(1,i).frequency = Frequency(i);
end