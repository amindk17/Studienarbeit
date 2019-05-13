function newBarplot3(BusArray_before,BusArray_after,tunit,BMnew,BMold)
% Correct the time according to used unit
if tunit==1%seconds
    correct = 3600;
elseif tunit==2%minutes 
    correct = 60;
else  %hours
    correct = 1;
end

% get the number of Bus to Plot
[~,nr_bus]=size(BusArray_after);
% Prepare some arrays
Y=zeros(nr_bus,2);
ticky=strings([1,nr_bus]);

% fill the matrixs to plot bar
for i=1:nr_bus
   % data after optimisation
   Y(i,1) = BusArray_after(i).ChargingStart/correct; 
   Y(i,2) = BusArray_after(i).ChargingTime/correct;
   % data before optimisation
   Z(i,1) = BusArray_before(1,i)/correct; 
   Z(i,2) = BusArray_before(2,i)/correct;
   % Bus IDs
   iD=BusArray_after(i).ID;
   ticky(1,i)=iD;
end 

% Create a figure and plot optimised data
figure
yyaxis left
h=barh(Y,'stacked');
h(1).FaceColor = 'white'; % color
h(1).EdgeColor ='white';
h(2).FaceColor = 'blue'; % color
h(2).EdgeColor ='blue';
% set Transparency 
h(1).FaceAlpha = 0.3;
h(1).EdgeAlpha = 0.3;
h(2).FaceAlpha = 0.6;
h(2).EdgeAlpha = 0.6;
% set X and Y labels
xlabel('Time in h');
ylabel('Bus ID');
xticks([0 1 2 3 4 5 6]);
xticklabels({'00:00','01:00','02:00','03:00','04:00','05:00','06:00'});
yticklabels(ticky);
grid on

% write Bus ID on every Bus
for i=1:nr_bus
   a = BusArray_after(i).ChargingStart/correct;  
   iD=BusArray_after(i).ID;
   text(a, i,iD , 'HorizontalAlignment','center', 'VerticalAlignment','bottom','color',[0.2 0.2 0.2])
end 

% if more than 20 bus remove the y Label
if nr_bus>20
    yticklabels([]);
end

% plot data before optimisation
hold on
h1=barh(Z,'stacked');
h1(1).FaceColor = 'white'; % color
h1(1).EdgeColor ='white';
h1(2).FaceColor = 'red'; % color
h1(2).EdgeColor ='red';
h1(1).FaceAlpha = 0.1;
h1(1).EdgeAlpha = 0.1;
h1(2).FaceAlpha = 0.2;
h1(2).EdgeAlpha = 0.2;
hold off
% plot number of chargers
hold on
yyaxis right
plot(BMold(1,:)/correct,BMold(nr_bus+3,:))
plot(BMnew(1,:)/correct,BMnew(nr_bus+3,:))
hold off
% Add legend
legend({'','after Optimisation','','before Optimisation','Number Of Chargers before','Number Of Chargers after'});
end
