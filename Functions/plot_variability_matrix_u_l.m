 function plot_variability_matrix_u_l(real_matrix1,real_matrix2,colormin,colormax)
    load('E:\MRI\varialibity_ind_project\HCPD\7_net_group_tabel.mat');
    order=[1 2 3 4 6 7 5]; %1 visual 2 SMN 3 DA 4 SAN 5 limbic 6 FPN 7 Default
    t=[];
    start = 1;        
    lines = [1];
    k = 1;
    mask = cell2mat({new_tabel.yeolabel});
    mask(1)=[];
    for i = 1:length(order)
        order(i)
        add=find(mask==order(i));
        t=[t add];
        start = start + length(add);
        lines(k+1)=start;
        k = k+1;
    end
    data1 = triu(real_matrix1(t,t));
    data2 = triu(real_matrix2(t,t))';
    data1 = data1 + data2;
    no_zero_data = data1;
    no_zero_data(data1==0)=[];
    lines(8)=[];
    data1(data1==0)=mean(mean(no_zero_data));
    % data = log(data);
    data1(375:400,:)=[]; 
    data1(:,375:400)=[]; 
    figure;
    graph=imagesc(data1); % draw graph
    colorbar;
    caxis([colormin colormax]); % set scale bar by min/max
%     colormap(brewermap(5,'YlGn'));
    m = redblue(50);
    %m = jet(50)
    colormap(m(25:38,:)); 
    hold on;
    for j = 1:length(lines) % draw lines dividing network
      if j<2
        line_number = lines(j)-0.1;
      else
        line_number = lines(j)-0.01; 
      end
      line([0,400],[line_number,line_number],'Color','black','Linewidth',0.1);
      line([line_number,line_number],[0,400],'Color','black','Linewidth',0.1);
    end
    %set(gca,'Visible','off');
    %name_order = {'Limbic','Default Mode','Frontoparietal','Ventral Attention','Dorsal Attention','Somatic Motor','Visual'};
    %tick_order = [14 74 146 194 241 305 373]
%     for n=1:7
%         tick_order(n) = (lines(n+1) - lines(n))/2 + lines(n);
%     end
    name_order2 = {'Visual','Somatic Motor','Dorsal Attention','Ventral Attention','Frontoparietal','Default Mode'};
    tick_order2 = [29 98 161 208 257 328];
    set(gca, 'XTick',tick_order2 , 'XTickLabel', name_order2);
    xtickangle(30)
    set(gca, 'YTick',tick_order2, 'YTickLabel', name_order2);
    set(gca,'FontSize',30,'FontName','Times New Roman');
    box off
    axis square;
    width=5000;
    height=5000;
end