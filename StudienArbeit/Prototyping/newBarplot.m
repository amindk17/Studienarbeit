function newBarplot(BusArray,dt)
[~,nr_bus]=size(BusArray);
Y=zeros(nr_bus,2);
ID=strings(nr_bus);
for i=1:nr_bus
   Y(i,1) = BusArray(i).ChargingStart*dt/3600; 
   Y(i,2) = BusArray(i).ChargingTime/3600; 
end 
figure
h=barh(Y,'stacked');
h(1).FaceColor = 'white'; % color
h(1).EdgeColor ='white';
h(2).FaceColor = 'blue'; % color
h(2).EdgeColor ='blue';
xlabel('Time in h');
ylabel('Bus');
end

