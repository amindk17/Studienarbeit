%better = arrtime*ones(nr_bus)+opt_t0*dt
clc
for i=1:nr_bus
    arrArray(i)=arrtime;
    IDs(i,1)=cellstr( BusArray(i).ID);
    Arrs(i,1)= datestr(BusArray(i).Arrival_time(1));
    Deps(i,1)= datestr(BusArray(i).Departure_time(1));
    ChargeTime(i,1)= (BusArray(i).ChargingTime(1)*dt);

end


Start_charge=arrArray+seconds(opt_t0*dt);
Start_charge=datestr(Start_charge');

ChargeTime = int2str(ChargeTime)


csvwrite('yourfile.csv',[ChargeTime Arrs])