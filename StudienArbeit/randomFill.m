function BusArray=randomFill(numberOfBus,Pc)
    global Ri_soc_LookUp Imax_LookUp VoltSoc_LookUp TempCorrection_LookUp dt ;
    ids = randperm(400,numberOfBus);
    i=1;
    while i <= numberOfBus
        try
            BusArray(i)=aBus();
            %--- Bus Data ---%
            BusArray(i).ID=num2str(ids(i));
            BusArray(i).Arrival_time=returnRandomTime(0,2);
            BusArray(i).Departure_time=returnRandomTime(5,6);
            %---- SOC Variables ----% 
            BusArray(i).Arrival_SOC=randi([40 60],1);
            BusArray(i).Departure_SOC=randi([80 90],1);
            %---- Scheduling Variables ----% 
            BusArray(i).ChargingStart=0;
            BusArray(i).ChargingTime=0;
            %---- BatteryData ----% 
            BusArray(i).Battery = aBattery();
            %BusArray(i).Battery.ID=BusArray(i).ID;
            BusArray(i).Battery.Cmax=randi([80*10^3 100*10^3],1);
            BusArray(i).Battery.SOC=BusArray(i).Arrival_SOC;
            BusArray(i).Battery.endSOC=BusArray(i).Departure_SOC;
            BusArray(i).Battery.Temperatur=25;%randi([0 45],1);
            BusArray(i).Battery.NumberOfCellsPll=randi([1 4],1);
            BusArray(i).Battery.NumberOfCellsSerie=randi([80 120],1);
            %---- LookUps ----%
            BusArray(i).Battery.Ri_soc_LookUp=Ri_soc_LookUp;
            BusArray(i).Battery.Imax_LookUp=Imax_LookUp;
            BusArray(i).Battery.VoltSoc_LookUp=VoltSoc_LookUp;
            BusArray(i).Battery.TempCorrection_LookUp=TempCorrection_LookUp;
            BusArray(i).CalcP(dt,Pc,0,'s');
            FillBigMatrix(BusArray(i),dt,1);
            i=i+1;
        catch
            disp('bad BUS')
        end
        
    end
end

function time = returnRandomTime(hmin,hmax)
    h1=sprintf('%02d',randi([hmin hmax],1));
    m1=sprintf('%02d',randi([0 59],1));
    s1='00';
    time = strcat(h1,':',m1,':',s1);
    time=datetime(time,'InputFormat','HH:mm:SS');
    
end