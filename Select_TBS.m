function TBS = Select_TBS(SNR)
% 该函数由 输入 SNR 选择一个 TBS 的大小
TBS_table = [137 173 233 317 377 461 650 792 931 1262 1483 1742 2279 ...
    2583 3319 3565 4189 4664 5287 5887 6554 7168 9719 11418 14411 17237 21754 23370 24222 25558];
CQI = Select_CQI(SNR);
TBS = TBS_table(CQI);



function CQI = Select_CQI(SNR)
% 由 SNR 计算 CQI
CQI = 30;