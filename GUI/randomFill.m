function BusArray=randomFill(numberOfBus,arrtime,deptime)
    global Ri_soc_LookUp Imax_LookUp VoltSoc_LookUp TempCorrection_LookUp dt ;
    ids = randperm(400,numberOfBus);
    i=1;
    while i <= numberOfBus
        try
            BusArray(i)=aBus();
            %--- Bus Data ---%
            BusArray(i).ID=ids(i);
            BusArray(i).Arrival_time=returnRandomTime(0,2);
            BusArray(i).Departure_time=returnRandomTime(4,5);
            %---- SOC Variables ----% 
            BusArray(i).Arrival_SOC=randi([40 60],1);
            BusArray(i).Departure_SOC=randi([80 90],1);
            %---- Scheduling Variables ----% 
            BusArray(i).ChargingStart=0;
            BusArray(i).ChargingTime=0;
            BusArray(i).Pmax=randi([10 90],1)*10^3;
            %---- BatteryData ----% 
            BusArray(i).Battery = aBattery();
            %BusArray(i).Battery.ID=BusArray(i).ID;
            BusArray(i).Battery.Cmax=randi([20 100],1)*3600;
            BusArray(i).Battery.SOC=BusArray(i).Arrival_SOC;
            BusArray(i).Battery.endSOC=BusArray(i).Departure_SOC;
            BusArray(i).Battery.Temperatur=25;%randi([0 45],1);
            BusArray(i).Battery.NumberOfCellsPll=randi([10 20],1);
            BusArray(i).Battery.NumberOfCellsSerie=randi([80 120],1);
            %---- LookUps ----%
            BusArray(i).Battery.Ri_soc_LookUp=Ri_soc_LookUp;
            BusArray(i).Battery.Imax_LookUp=Imax_LookUp;
            BusArray(i).Battery.VoltSoc_LookUp=VoltSoc_LookUp;
            BusArray(i).Battery.TempCorrection_LookUp=TempCorrection_LookUp;
            BusArray(i).CalcP(dt,BusArray(i).Pmax,0,'s');
            start_time=abs(etime(datevec(arrtime),datevec(BusArray(i).Arrival_time)));
            BusArray(i).ChargingStart = start_time;
            BusArray(i).Arrival_seconds = start_time;
            
            all_time = abs(etime(datevec(BusArray(i).Arrival_time),datevec(BusArray(i).Departure_time)));
            all_time = round(all_time);
            [Energie_stored, Energie_grid] = CalC_Energie(BusArray(i),0.96,VoltSoc_LookUp);
            Pm = (Energie_grid*1000*3600)/(all_time) ;
            BusArray(i).Pmin=Pm;
            
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
    time = strcat(h1,':',m1);
    %time=datetime(time,'InputFormat','HH:mm:SS');
    
end