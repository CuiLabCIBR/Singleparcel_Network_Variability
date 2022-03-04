function [r,p] = matrixCorr(input,corrMethod,threshold_cfg)
threshold_mask = input{threshold_cfg(1)} > threshold_cfg(2);
calcUse_1_temp = input{1} .* threshold_mask;
calcUse_2_temp = input{2} .* threshold_mask;

templateMatrix = ones(size(calcUse_1_temp));
extractIndex = find([triu(templateMatrix)-diag(diag(templateMatrix))]);
calcUse{1} = calcUse_1_temp(extractIndex);calcUse{2} = calcUse_2_temp(extractIndex);

withDirectConn = find(calcUse{threshold_cfg(1)}~=0);

useADJ_1 = calcUse{1}(withDirectConn);
useADJ_2 = calcUse{2}(withDirectConn);

mask = useADJ_2>0.3 | useADJ_2<0.1;
useADJ_1(mask)=[];
useADJ_2(mask)=[];
% useADJ_2 = (useADJ_2-mean(useADJ_2))/std(useADJ_2);
try
    [r,p] = corr(useADJ_1,useADJ_2,'type',corrMethod);
catch
    [r,p] = corr(useADJ_1,useADJ_2,'type',corrMethod);
end
figure
try
    plot(log(useADJ_1),useADJ_2,'.'),axis square
catch
    plot(useADJ_1,useADJ_2,'.'),axis square
end
print(gcf,'-dpng', '-r300', 'temp1.png') 
close all
% %Create point cloud with two categories
clear g
%Plot density as heatmaps (Heatmaps don't work with multiple colors, so we separate
%the categories with facets). With the heatmap we see better the
%distribution in high-density areas

g(1,1)=gramm('x',log(useADJ_1),'y',(useADJ_2));
%test=repmat([0 0 0 0],1,size(useADJ_1,1)/4);
test=zeros(1,size(useADJ_1,1));
g(1,1).facet_grid([],test);
g(1,1).stat_bin2d('nbins',[50 50],'geom','image');
%g(1,1).set_continuous_color('colormap','RdPu');
%g(1,1).set_title('stat_bin2d(''geom'',''image'')');
g(1,1).set_names('x','Log SC','y','FC','column','grp','color','count');
g.set_title('SC-FC Correlation');
g(1,1).stat_glm('distribution','normal','geom','lines','fullrange','false')
%g(1,1).axe_property('XLim',[-10 5]);
g(1,1).axe_property('YLim',[0.16,0.24]);
figure('Position',[100 100 400 400])

%axis square
g.draw();
print(gcf,'-dpng', '-r300', 'temp2.png') 
end