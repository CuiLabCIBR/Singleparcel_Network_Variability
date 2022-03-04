 function plot_variability_scheafer400_matrix(real_matrix,colormin,colormax)
    load('E:\MRI\code\scheafer_400_label.mat');
    order=[1 2 3 4 17 5 6 7 8 11 12 13 14 15 16 9 10]; 
    t=[];
    start = 1;        
    lines = [1];
    k = 1;
    mask = cell2mat({scheafer_label_table.network});
    mask(1)=[];
    for i = 1:length(order)
        order(i)
        add=find(mask==order(i));
        t=[t add];
        start = start + length(add);
        lines(k+1)=start;
        k = k+1;
    end
    data1 = real_matrix(t,t);
    no_zero_data = data1;
    no_zero_data(data1==0)=[];
    data1(data1==0)=mean(mean(no_zero_data));
    % data = log(data);
    figure;
    graph=imagesc(data1); % draw graph
    colorbar;
    caxis([colormin colormax]); % set scale bar by min/max
    colormap('jet');
    hold on;
    lines([2,4,7,9,11,12,14,15,17])=[];
    for j = 1:length(lines) % draw lines dividing network
      line([0,400],[lines(j),lines(j)],'Color','w','Linewidth',2)
      line([lines(j),lines(j)],[0,400],'Color','w','Linewidth',2)
    end
    axis square;
    width=5000;
    height=5000;
end