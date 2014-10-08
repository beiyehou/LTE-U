function [Channel] = Set_Channel(Channel)
% 设置Channel 的 id 和 频率

Frequency = [5825 5805 5785 5765 5745 5300 5280 5260]*10^6;
for i=1:length(Channel)
    % id 
    Channel(1,i).id = i;
    % 频率 MHz
    Channel(1,i).frequency = Frequency(i);
end