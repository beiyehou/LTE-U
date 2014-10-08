function LOS_NLOS = LOS_NLOS_select(scenario,d)
% 视距与非视距概率   按照M.2135 TABLE A1-3


tempRand = rand();
% INH
if(scenario == 1)
   if(d <= 18)
       LOS_NLOS = 1;
   elseif(d > 18 && d <= 37)
       p = exp(-(d-18) / 27);
       if(p > tempRand)
           LOS_NLOS = 1;
       else
           LOS_NLOS = 0;
       end    
   elseif(d > 37)
       if(tempRand < 0.5)
           LOS_NLOS = 1;
       else
           LOS_NLOS = 0;     
       end
   end
% UMI
elseif(scenario == 2)
    p = min(18 / d,1) * (1-exp(-d / 36)) + exp(-d / 36);
    if(p > tempRand)
        LOS_NLOS = 1;
    else
        LOS_NLOS = 0;
    end     
% UMA
elseif(scenario == 3)
    p = min(18 / d,1) * (1-exp(-d / 63)) + exp(-d / 63);
    if(p>tempRand)
        LOS_NLOS = 1;
    else
        LOS_NLOS = 0;
    end	    
% RMA
elseif(scenario == 4)
    if(d<=  10)
        LOS_NLOS = 1;
    else
        p = exp(-(d-10) / 1000);
        if(p>tempRand)
            LOS_NLOS = 1;
        else
            LOS_NLOS = 0;
        end
    end
end