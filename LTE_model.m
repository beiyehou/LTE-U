function [PL] = LTE_model (scenario,IN_OUTDOOR,LOS_NLOS,d,fc)
% LTE的路损模型
PL=0;
FC_STANDARD = 1000000000.0;
MAX_SPEED = 3 * 10^8;
%需要查询
DIN_FOR_UMI = 20 ; 

% SCENARIOS_INH
if(scenario == 1)
    if (LOS_NLOS == 1) 
        PL = 16.9 * log10(d) + 32.8 + 20 * log10(fc / FC_STANDARD);
    elseif (LOS_NLOS == 0)
        PL = 43.3 * log10(d) + 11.5 + 20 * log10(fc / FC_STANDARD);
    end
% SCENARIOS_UMI    
elseif(scenario == 2)
    hBS = 10;
    %LOS = 1.5m NLOS = 1~2.5M
    hUT = 1.5; 
    hBSEFF = hBS - 1;
    hUTEFF = hUT - 1;
    dBP1 = 4 * hBSEFF * hUTEFF * fc / MAX_SPEED;  
    % LOS indoor
    if ((IN_OUTDOOR == 1) && (LOS_NLOS == 1))
       dout = d - DIN_FOR_UMI;
        %10 m  <  d1  <  d′BP
        if(dout < dBP1)
            PLb = 22.0 * log10(dout) + 28.0 + 20 * log10(fc / FC_STANDARD);
            %d′BP  <  d1  <  5 000 m
        elseif(dout >  dBP1 && dout < 5000)
            PLb = 40 * log10(dout) + 7.8 - 18 * log10(hBSEFF) - 18 * log10(hUTEFF) + 2 * log10(fc / FC_STANDARD);
        end
        PLin = 0.5 * DIN_FOR_UMI;
        PL = PLb + PLin;
    elseif ((IN_OUTDOOR == 1) && (LOS_NLOS == 0))
        dout = d - DIN_FOR_UMI;
        PLb = 36.7 * log10(dout) + 22.7 + 26 * log10(fc / FC_STANDARD);
        PLin = 0.5 * DIN_FOR_UMI;
        PL = PLb + PLin;
    elseif ((IN_OUTDOOR == 0) && (LOS_NLOS == 1))
        % 防止错误修正值
        if (d <= 10)  
            PL = 32.4 + 26 * log10(d* 10^(-3)) +20 * log10(fc * 10 ^(-6));
        elseif(d >  10 && d < dBP1)
            PL = 22.0 * log10(d) + 28.0 + 20 * log10(fc / FC_STANDARD);
        elseif(d >  dBP1 && d < 5000)
            PL = 40 * log10(d) + 7.8 - 18 * log10(hBSEFF) - 18 * log10(hUTEFF) + 2 * log10(fc / FC_STANDARD);
        end;
    elseif ((IN_OUTDOOR == 0) && (LOS_NLOS == 0))
        PL = 36.7 * log10(d) + 22.7 + 26 * log10(fc / FC_STANDARD);
    end
% SCENARIOS_UMA    
elseif(scenario == 3)
    if (LOS_NLOS == 1)
        hBS = 25;
        hUT = 1.5;
        hBSEFF = hBS - 1;
        hUTEFF = hUT - 1;
        dBP1 = 4 * hBSEFF * hUTEFF * fc / MAX_SPEED;
        if(d <= 10) 
            PL = 32.4 + 26 * log10(d* 10^(-3)) +20 * log10(fc * 10 ^(-6));
        elseif(d >  10 && d < dBP1)
            PL = 22.0 * log10(d) + 28.0 + 20 * log10(fc / FC_STANDARD);
        elseif(d >  dBP1 && d < 5000)
            PL = 40.0 * log10(d) + 7.8 - 18.0 * log10(hBSEFF) - 18.0 * log10(hUTEFF) + 2.0 * log10(fc / FC_STANDARD);
        end
    elseif (LOS_NLOS == 0)
        W = 20;
        h = 20;
        hBS = 25;
        hUT = 1.5;
        PL = 161.04 - 7.1 * log10(W) + 7.5 * log10(h) - (24.37 - 3.7 * power(h / hBS,2)) * log10(hBS) + (43.42 - 3.1 * log10(hBS)) * (log10(d) - 3)...
            + 20 * log10(fc / FC_STANDARD) - (3.2 * power(log10(11.75 * hUT),2) - 4.97);
    end
%  SCENARIOS_RMA
elseif(scenario == 4)
    hBS = 35; 
    hUT = 1.5; 
    W = 20; 
    h = 5; 
    dBP2 = 2 * pi * hBS * hUT * fc / MAX_SPEED;
    if (LOS_NLOS == 1)
        if(d > 10 && d < dBP2)
            PL = 20 * log10(40 * pi * d * fc / (3 * FC_STANDARD)) + min(0.03 * power(h,1.72),10) * log10(d) - min(0.044 * power(h,1.72),14.77) + 0.002 * log10(h) * d;
        elseif(d > dBP2 && d < 10000)
            PL = 20 * log10(40 * pi * dBP2 * fc / (3 * FC_STANDARD)) + min(0.03 * power(h,1.72),10) * log10(dBP2) - min(0.044 * power(h,1.72),14.77) + 0.002 * log10(h) * dBP2 + 40 * log10(d / dBP2);
        end
    elseif (LOS_NLOS == 0)
        PL = 161.04 - 7.1 * log10(W) + 7.5 * log10(h) - (24.37 - 3.7 * power((h / hBS),2)) * log10(hBS) + (43.42 - 3.1 * log10(hBS)) * (log10(d) - 3)...
            + 20 * log10(fc / FC_STANDARD) - (3.2 * power(log10(11.75 * hUT),2) - 4.97);
    end    
end
