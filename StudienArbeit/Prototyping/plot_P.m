function plot_P(Bm,WorstCase,timeformat)
    [n,sz]=size(Bm);
    if(~timeformat)
       t=Bm(1,:)/3600;
    else
       t0=Bm(1,:);
       t = datetime('00:00:00', 'InputFormat', 'HH:mm:ss')+ seconds(t0);
    end
    %
    
    figure('name','P');
    subplot(2,1,1);
    maxy=max(Bm(n,:));
    maxy=maxy*1.1;
    ylim([0 maxy]);
    plot(t,Bm(n,:)/1000);
    hold on;
    for i = 2:n-1
        plot(t,Bm(i,:)/1000);
        if(timeformat)
            datetick('x', 'HH:mm');
        end
    end
    Legend{1}='P_g_e_s';
    for i=2:n-1
       Legend{i}=strcat('P_B_u_s_', num2str(i-1));
    end
    hold off
    legend(Legend);
    title('P Plot');
    xlabel('Time in h');
    ylabel('Pwer in kW');
    subplot(2,1,2);
    maxy=WorstCase*1.1;
    ylim([0 maxy]);
    plot(t,Bm(n,:)/1000);
    hold on
    Pworst = ones(size(t))*WorstCase;
    plot(t,Pworst/1000);
    diff= (Pworst-max(Bm(n,:)));
    %for i=1:sz
    %    if(Bm(n,i)==0)
    %        diff(1,i)=0;
    %    end
    %end
    plot(t,diff/1000);
    title('P ges');
    Legend2{1}='P_g_e_s';
    Legend2{2}='P_w_o_r_s_t';
    Legend2{3}='P_d_i_f_f';
    legend(Legend2);
    xlabel('Time in h');
    ylabel('Pwer in kW');
    hold off
end

