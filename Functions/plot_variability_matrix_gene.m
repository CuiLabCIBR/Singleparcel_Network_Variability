 function plot_variability_matrix_gene(real_matrix,colormin,colormax)
    load('/GPFS/cuizaixu_lab_permanent/wuguowei/python_code/repeat_code/Gene_data/no_lim_net_label.mat');
    start = 1;        
    lines = [1];
    k = 1;
    for i = [1:4,6,7]
        add=find(no_lim_net_label==i);
        start = start + length(add);
        lines(k+1)=start;
        k = k+1;
    end
    figure;
    graph=imagesc(real_matrix); % draw graph
    colorbar;
    caxis([colormin colormax]); % set scale bar by min/max
    m = brewermap(100,'Blues');
    colormap(m(sort(1:49,'ascend'),:)); 
    %(sort(1:49,'descend')
    hold on; 
    for j = 1:length(lines) % draw lines dividing network
      line_number = lines(j)-0.5;
      line([0,87],[line_number,line_number],'Color','black','Linewidth',0.1);
      line([line_number,line_number],[0,87],'Color','black','Linewidth',0.1);
    end
    box off
    axis square;
    name_order2 = {'Visual','Somatic Motor','Dorsal Attention','Ventral Attention','Frontoparietal','Default Mode'};
    tick_order2 = [5 14 23 36 54 75];
    set(gca, 'XTick',tick_order2 , 'XTickLabel', name_order2);
    xtickangle(30)
    set(gca, 'YTick',tick_order2, 'YTickLabel', name_order2);
    set(gca,'FontSize',30,'FontName','Times New Roman');
 end
