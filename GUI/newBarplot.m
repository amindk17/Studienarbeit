function newBarplot(BusArray,dt,tunit)
if tunit==1%seconds
    correct = 3600;
elseif tunit==2%minutes 
    correct = 60;
else  %hours
    correct = 1;
end
[~,nr_bus]=size(BusArray);
Y=zeros(nr_bus,2);
ID=strings(nr_bus);
ticky=strings([1,nr_bus])
for i=1:nr_bus
   Y(i,1) = BusArray(i).ChargingStart/correct; 
   Y(i,2) = BusArray(i).ChargingTime/correct; 
   iD=BusArray(i).ID;
   ticky(1,i)=iD;
end 
figure
h=barh(Y,'stacked');
h(1).FaceColor = 'white'; % color
h(1).EdgeColor ='white';
h(2).FaceColor = 'blue'; % color
h(2).EdgeColor ='blue';
xlabel('Time in h');
ylabel('Bus ID');
xticks([0 1 2 3 4 5 6])
xticklabels({'00:00','01:00','02:00','03:00','04:00','05:00','06:00'})
yticklabels(ticky);
end

