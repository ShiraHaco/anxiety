clear
clc
initialize_human;
biasVes=[];
biasVis=[];
meanBias_Ves=[];
meanBias_Vis=[];
pVec=[];
pVec_ves=[];
pVec_vis=[];

% loading result files
condLabel={'ResultsVES_all.mat','ResultsVIS_all.mat',};
for priorCond=1:2
    load(strcat('C:\Users\shirt\Documents\Documents old\Anxiety Data\anxiety project\All\',...
        [condLabel{priorCond}]))
    if priorCond==1
       biasVes=sess_bias;
       threshVes=sess_thresh;
       RsquareVes=sess_Rsquare;
    elseif  priorCond==2
        biasVis=sess_bias;
        threshVis=sess_thresh;
        RsquareVis=sess_Rsquare;

    end
    
end 

% flagging excluded subjects and replacing their data with nans
for i=1:sess_i
    if subj_EXCL(i)==1
        biasVes(i)=nan;
        biasVis(i)=nan;
        threshVes(i)=nan;
        threshVis(i)=nan;
        subj_STAIT(i)=nan;
        subj_STAISAfter(i)=nan;
        subj_STAISBefore(i)=nan;
        subj_SEX(i)=nan;
        subj_AGE(i)=nan;    
    end
 end
    
%   removing nans

    biasVes=biasVes(~isnan(biasVes));
    biasVis=biasVis(~isnan(biasVis));
    threshVes=threshVes(~isnan(threshVes));
    threshVis=threshVis(~isnan(threshVis));
    subj_STAIT=subj_STAIT(~isnan(subj_STAIT));
    subj_STAISAfter=subj_STAISAfter(~isnan(subj_STAISAfter));
    subj_STAISBefore=subj_STAISBefore(~isnan(subj_STAISBefore));
    subj_SEX=subj_SEX(~isnan(subj_SEX));
    subj_AGE=subj_AGE(~isnan(subj_AGE));
    subj_STAIT=(subj_STAIT)';
    subj_STAISAfter=(subj_STAISAfter)';
    subj_STAISBefore=(subj_STAISBefore)';
    subj_SEX=(subj_SEX)';
    subj_AGE=(subj_AGE)';
    subj_STAISAfter=[nan(1,8) subj_STAISAfter] %8 first values are missing
    subj_STAISMean=nanmean([subj_STAISBefore;subj_STAISAfter],1)

% calculating mean and sem for variables    
meanBias_Ves=nanmean(biasVes); %ves
semBias_Ves=nanstd(biasVes)/sqrt(length(biasVes));
meanBias_Vis=nanmean(biasVis); %vis
semBias_Vis=nanstd(biasVis)/sqrt(length(biasVis));
meanThresh_Ves=nanmean(threshVes); %ves
semThresh_Ves=nanstd(threshVes)/sqrt(length(threshVes)); 
meanThresh_Vis=nanmean(threshVis);%vis
semThresh_Vis=nanstd(threshVis)/sqrt(length(threshVis));
meanSTAIT=nanmean(subj_STAIT);
semSTAIT=nanstd(subj_STAIT)/sqrt(length(subj_STAIT));
meanSTAISAfter=nanmean(subj_STAISAfter);
semSTAISAfter=nanstd(subj_STAISAfter)/sqrt(length(subj_STAISAfter));
meanSTAISBefore=nanmean(subj_STAISBefore);
semSTAISBefore=nanstd(subj_STAISBefore)/sqrt(length(subj_STAISBefore));
meanSTAISMean=nanmean(subj_STAISMean);
semSTAISMean=nanstd(subj_STAISMean)/sqrt(length(subj_STAISMean));
meanAGE=nanmean(subj_AGE);
semAGE=nanstd(subj_AGE)/sqrt(length(subj_AGE));

   

%%  Statistics 
% % Biases
% % one sample t-test
 [h_ves,pv_ves,ci_ves,stats_ves] = ttest(biasVes);
 [h_vis,pv_vis,ci_vis,stats_vis] = ttest(biasVis);
% paired t-test (Ves - Vis)
 [h_visvesBias,pv_visvesBias,ci_visvesBias,stats_visvesBias] = ttest(biasVes,biasVis);

% % Thresholds 
%  paired t-test(Ves - Vis)
    [h_visvesThresh,pv_visvesThresh,ci_visvesThresh,stats_visvesThresh] = ttest(threshVes,threshVis);
    
% STAI-S before-after t-test
   [h_STAIS,pv_STAIS,ci_STAIS,stats_STAIS] = ttest(subj_STAISAfter,subj_STAISBefore);

%% Figure 3D
% % high-low anxiety - RM anova figure

highAnxVes=[];
lowAnxVes=[];
highAnxVis=[];
lowAnxVis=[];
highAnxSEX=[];
highAnxAGE=[];
lowAnxSEX=[];
lowAnxAGE=[];

% deviding into groups by the mean STAI-T
for i=1:length(subj_STAIT)
    if subj_STAIT(i)>meanSTAIT
        highAnxVes=[highAnxVes biasVes(i)];
        highAnxVis=[highAnxVis biasVis(i)];
        highAnxSEX=[highAnxSEX subj_SEX(i)];
        highAnxAGE=[highAnxAGE subj_AGE(i)];
    elseif subj_STAIT(i)<meanSTAIT
        lowAnxVes=[lowAnxVes biasVes(i)];
        lowAnxVis=[lowAnxVis biasVis(i)];
        lowAnxSEX=[lowAnxSEX subj_SEX(i)];
        lowAnxAGE=[lowAnxAGE subj_AGE(i)];
    end
end

% group stats
mean(highAnxVes);
std(highAnxVes);
mean(highAnxVis);
std(highAnxVis);
mean(lowAnxVes);
std(lowAnxVes);
mean(lowAnxVis);
std(lowAnxVis);

% labeling anxiety groups (high/low)
g1 = cell(1, 88);
g1(1:40) = {'high'};
g1(41:88) = {'low'};

% labeling modality according to anxiety groups
g2 = cell(1, 88);
g2(1:20) = {'ves'};
g2(21:40) = {'vis'};
g2(41:64) = {'ves'};
g2(65:88) = {'vis'};

anxLevel=g1'
sensoryCond=g2'

% creating the anova mat
highAnx=[highAnxVes;highAnxVis]
lowAnx=[lowAnxVes;lowAnxVis]
highAnxForplots=[highAnxVes nan(1,4) highAnxVis nan(1,4)]'
lowAnxForplots=[lowAnxVes lowAnxVis]'
anxMat=[highAnxForplots lowAnxForplots]
group=sensoryCond(41:88)

% creating a mean and sem mat for anova plot
MEANS=grpstats(anxMat,group)
SEMS=grpstats(anxMat,group,'sem')
grpstats(anxMat,group,0.05);
close

%plotting anova figure
figure 
hold on
meanHighVes=scatter(1,MEANS(1,1),'k','MarkerFaceColor','k','SizeData',160,'LineWidth',1);
meanLowVes=scatter(1,MEANS(2,1),'k','SizeData',160,'LineWidth',1);
meanHighVes=scatter(1,MEANS(1,1),'MarkerEdgeColor',[0 0 0.8],'MarkerFaceColor',[0 0 0.8],'SizeData',160,'LineWidth',1)
errorHighVes=errorbar(1,MEANS(1,1),SEMS(1,1),'color',[0 0 0.8])
meanLowVes=scatter(1,MEANS(2,1),'MarkerEdgeColor',[0 0 0.8],'SizeData',160,'LineWidth',2)
errorLowVes=errorbar(1,MEANS(2,1),SEMS(2,1),'color',[0 0 0.8])

meanHighVis=scatter(2,MEANS(1,2),'MarkerEdgeColor',[0.8 0 0],'MarkerFaceColor',[0.8 0 0],'SizeData',160,'LineWidth',1)
errorHighVis=errorbar(2,MEANS(1,2),SEMS(1,2),'color',[0.8 0 0])
meanLowVis=scatter(2,MEANS(2,2),'MarkerEdgeColor',[0.8 0 0],'SizeData',160,'LineWidth',2)
errorLowVis=errorbar(2,MEANS(2,2),SEMS(2,2),'color',[0.8 0 0])
plot([1,2],[MEANS(1,1),MEANS(1,2)],'k','LineWidth',2)
plot([1,2],[MEANS(2,1),MEANS(2,2)],'k','LineStyle','--','LineWidth',2)

ylim([-0.5 0.5]);
xlim([0.5 2.5]);
set(gca,'xtick',[1:1:2],'xticklabel',({'Vestibular','Visual'}),'fontsize',20);
set(gca,'ytick',[-0.8:0.4:0.8]);
set(get(get(errorHighVes,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
legend('High Anxiety','Low Anxiety')
ylabel('PSE [cm]','fontsize',24);



filename_fig=strcat(GRP_DIR,'\\Figure_3D');
print(gcf,'-dtiff','-r300', filename_fig);
saveas(gcf,strcat(filename_fig,'.eps'));
saveas(gcf,strcat(filename_fig,'.tif'));
saveas(gcf,strcat(filename_fig,'.fig'));
%% Figure 3C - Ancova

% setting variables
biasAll=[biasVes biasVis] %depandent variable
modalityLabel = cell(1, 88); %indepandent variable
modalityLabel(1:44) = {'ves'};
modalityLabel(45:88) = {'vis'};
STAITForAncova=[subj_STAIT subj_STAIT]; %covariate 
aoctool(STAITForAncova,biasAll,modalityLabel) %ancova test

% %  figure settings
ylabel('PSE [cm]','fontsize',24);
xlabel('STAI-T Score','fontsize',24)
set(gca,'ytick',[-2:1:2],'fontsize',20);
set(gca,'xtick',[20:20:80]);
xlim([20 80]);
ylim([-2 2]);
xHalfLine = [20:1:80];
yHalfLine = (zeros(1,length(xHalfLine)));
py=plot(xHalfLine,yHalfLine,'k','LineStyle','--','LineWidth',0.3);
set(get(get(py,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
legend({'Vestibular' 'Visual'},'fontsize',20,'location','northeast');
        
filename_fig=strcat(GRP_DIR,'\\Figure_3C');
print(gcf,'-dtiff','-r300', filename_fig);
saveas(gcf,strcat(filename_fig,'.eps'));
saveas(gcf,strcat(filename_fig,'.tif'));
saveas(gcf,strcat(filename_fig,'.fig'));


%% Supplementary Figure 1A - Threshold VIS & STAI

% % % mean STAI-S

% %  figure settings
f=figure; hold on;
set(gcf,'Units','normalized','color','w','PaperPositionMode','auto')
set(gca,'ytick',log([0.25 0.5 1 2 4 8]),'yticklabel', [0.25 0.5 1 2 4 8],'fontsize',20);
set(gca,'xtick',[20:20:80]);
xlabel('STAI score','fontsize',24);
ylabel('Threshold [cm]','fontsize',24);
xlim([10 80]);
ylim([-0.75 1.5]);
set(f,'Units','normalized','color','w','PaperPositionMode','auto');
set(f,'name','Correlation - Threshold (Vis) and mean STAIS','NumberTitle','off');

% plotting scatter of data - threshold vis & mean STAI-S
hthreshVisSTAISB=scatter([subj_STAISMean(1:2) subj_STAISMean(4:44)],log([threshVis(1:2) threshVis(4:44)]))
set(hthreshVisSTAISB,'LineWidth',1.2,'MarkerEdgeColor',[0.8 0 0])
set(hthreshVisSTAISB,'SizeData',100,'LineWidth',1)
legend({'State-anxiety'},'fontsize',20,'location','southeast');

% plotting regression line
x = [subj_STAISMean(1:2) subj_STAISMean(4:44)];
y = log([threshVis(1:2) threshVis(4:44)]);
P = polyfit(x,y,1);
x0 = min(x) ; x1 = max(x) ;
xi = linspace(x0,x1) ;
yi = P(1)*xi+P(2);x0 = min(x) ; x1 = max(x) ;
xi = linspace(x0,x1) ;
yi = P(1)*xi+P(2);
hold on
plot(xi,yi,'r') ;

% saving
filename_fig=strcat(GRP_DIR,'\\Supp_Figure_1A_STAIS');
print(gcf,'-dtiff','-r300', filename_fig);
saveas(gcf,strcat(filename_fig,'.eps'));
saveas(gcf,strcat(filename_fig,'.tif'));
saveas(gcf,strcat(filename_fig,'.fig'));

% % % STAI-T
 
% figure settings
f=figure; hold on;
set(gcf,'Units','normalized','color','w','PaperPositionMode','auto')
set(gca,'ytick',log([0.25 0.5 1 2 4 8]),'yticklabel', [0.25 0.5 1 2 4 8],'fontsize',20);
set(gca,'xtick',[20:20:80]);
xlabel('STAI score','fontsize',24);
ylabel('Threshold [cm]','fontsize',24);
xlim([10 80]);
ylim([-0.75 1.5]);
set(f,'Units','normalized','color','w','PaperPositionMode','auto');
set(f,'name','Correlation - Threshold (Vis) and STAIT','NumberTitle','off');

% plotting scatter of data - threshold vis & STAI-T
hthreshVisSTAISA=scatter(subj_STAIT,log(threshVis))
set(hthreshVisSTAISA,'LineWidth',1.2,'MarkerEdgeColor',[0.8 0 0],'Marker','d')
set(hthreshVisSTAISA,'SizeData',100,'LineWidth',1)
legend({'Trait-anxiety'},'fontsize',20,'location','southeast');

% plotting regression line
x = subj_STAIT;
y = log(threshVis);
P = polyfit(x,y,1);
x0 = min(x) ; x1 = max(x) ;
xi = linspace(x0,x1) ;
yi = P(1)*xi+P(2);x0 = min(x) ; x1 = max(x) ;
xi = linspace(x0,x1) ;
yi = P(1)*xi+P(2);
hold on
plot(xi,yi,'r') ;

% saving
filename_fig=strcat(GRP_DIR,'\\Supp_Figure_1A_STAIT');
print(gcf,'-dtiff','-r300', filename_fig);
saveas(gcf,strcat(filename_fig,'.eps'));
saveas(gcf,strcat(filename_fig,'.tif'));
saveas(gcf,strcat(filename_fig,'.fig'));

%% Supplementary Figure 1B - Threshold VES & STAI

% % % mean STAI-S

% %  figure settings
f=figure; hold on;
set(gcf,'Units','normalized','color','w','PaperPositionMode','auto')
set(gca,'ytick',log([0.25 0.5 1 2 4]),'yticklabel', [0.25 0.5 1 2 4],'fontsize',20);
set(gca,'xtick',[20:20:80]);
xlabel('STAI score','fontsize',24);
ylabel('Threshold [cm]','fontsize',24);
xlim([10 80]);
ylim([-1.5 1.75]);
set(f,'Units','normalized','color','w','PaperPositionMode','auto');
set(f,'name','Correlation - Threshold (Ves) and mean STAIS','NumberTitle','off');

% plotting scatter of data - threshold ves & mean STAI-S
hthreshVesSTAISB=scatter(subj_STAISMean,log(threshVes))
set(hthreshVesSTAISB,'LineWidth',1.2,'MarkerEdgeColor',[0 0 0.8])
set(hthreshVesSTAISB,'SizeData',100,'LineWidth',1)
legend({'State-anxiety'},'fontsize',20,'location','southeast');
 
% plotting regression line
x = subj_STAISMean;
y = log(threshVes);
P = polyfit(x,y,1);
x0 = min(x) ; x1 = max(x) ;
xi = linspace(x0,x1) ;
yi = P(1)*xi+P(2);x0 = min(x) ; x1 = max(x) ;
xi = linspace(x0,x1) ;
yi = P(1)*xi+P(2);
hold on
plot(xi,yi,'b') ;

% saving
filename_fig=strcat(GRP_DIR,'\\Supp_Figure_1B_STAIS');
print(gcf,'-dtiff','-r300', filename_fig);
saveas(gcf,strcat(filename_fig,'.eps'));
saveas(gcf,strcat(filename_fig,'.tif'));
saveas(gcf,strcat(filename_fig,'.fig'));

% % % STAI-T
 
% figure settings
f=figure; hold on;
set(gcf,'Units','normalized','color','w','PaperPositionMode','auto')
set(gca,'ytick',log([0.25 0.5 1 2 4]),'yticklabel', [0.25 0.5 1 2 4],'fontsize',20);
set(gca,'xtick',[20:20:80]);
xlabel('STAI score','fontsize',24);
ylabel('Threshold [cm]','fontsize',24);
xlim([10 80]);
ylim([-1.5 1.75]);
set(f,'Units','normalized','color','w','PaperPositionMode','auto');
set(f,'name','Correlation - Threshold (Ves) and STAIT','NumberTitle','off');

% plotting scatter of data - threshold ves & STAI-T
hthreshVesSTAISA=scatter(subj_STAIT,log(threshVes))
set(hthreshVesSTAISA,'LineWidth',1.2,'MarkerEdgeColor',[0 0 0.8],'Marker','d')
set(hthreshVesSTAISA,'SizeData',100,'LineWidth',1)
legend({'Trait-anxiety'},'fontsize',20,'location','southeast');
 
% plotting regression line
x = subj_STAIT;
y = log(threshVes);
P = polyfit(x,y,1);
x0 = min(x) ; x1 = max(x) ;
xi = linspace(x0,x1) ;
yi = P(1)*xi+P(2);x0 = min(x) ; x1 = max(x) ;
xi = linspace(x0,x1) ;
yi = P(1)*xi+P(2);
hold on
plot(xi,yi,'b') ;

% saving
filename_fig=strcat(GRP_DIR,'\\Supp_Figure_1B_STAIT');
print(gcf,'-dtiff','-r300', filename_fig);
saveas(gcf,strcat(filename_fig,'.eps'));
saveas(gcf,strcat(filename_fig,'.tif'));
saveas(gcf,strcat(filename_fig,'.fig'));


%% Figure 2B - PSE distribution 
% %  histogram (Ves vs. Vis)
  
% figure settings
f=figure; hold on;
set(gca,'xtick',[-2:1:2],'fontsize',20);
set(gca,'ytick',[0:2:10],'fontsize',20);
ylabel('Participants [count]','fontsize',24);
xlabel('PSE [cm]','fontsize',24);
ylim([0 10]);
xlim([-2 2]);
yZeroLine = [0:0.5:10];
xZeroLine = zeros(1,(length(yZeroLine)));

% sharpening resolution
step=0.1; 
xout=-2:step:2; 
gw = 0.8; % sets the width of the bars 0.9 almost touching (if there is no border), 1 is touching
xout1=xout+step/4;
xout2=xout-step/4;  %plotted seperately o/w matlab makes spaces between the groups in barh

%histogram of PSEs
[nves,xves]=hist(biasVes,xout1);
[nvis,xvis]=hist(biasVis,xout2);

% plot histogram
Vestibular=bar(xout1,nves',0.4,'FaceColor',[0 0 0.8],'EdgeColor','k');
Visual=bar(xout2,nvis',0.4,'FaceColor',[0.8 0 0],'EdgeColor','k');

% plotting mean and sem on figure
plot([meanBias_Ves-semBias_Ves,meanBias_Ves+semBias_Ves],[9,9],'color',[0 0 0.8],'LineWidth',3)
plot([meanBias_Vis-semBias_Vis,meanBias_Vis+semBias_Vis],[9,9],'color',[0.8 0 0],'LineWidth',3)
scatter(meanBias_Ves,9,'MarkerFaceColor',[0 0 0.8],'MarkerEdgeColor',[0 0 0.8],'LineWidth',5,'Marker','d')
scatter(meanBias_Vis,9,'MarkerFaceColor',[0.8 0 0],'MarkerEdgeColor',[0.8 0 0],'LineWidth',5,'Marker','d')

plot(xZeroLine, yZeroLine,'color',[0.4,0.4,0.4],'LineStyle','--','LineWidth',0.1)
legend ('Vestibular','Visual') 

% saving 
filename_fig=strcat(GRP_DIR,'\\Figure_2B');
print(gcf,'-dtiff','-r300', filename_fig);
saveas(gcf,strcat(filename_fig,'.eps'));
saveas(gcf,strcat(filename_fig,'.tif'));
saveas(gcf,strcat(filename_fig,'.fig'));
%% Figure 2C - delta PSEs distribution 

% figure settings
f=figure; hold on; 
ylabel('PSE Visual [cm]','fontsize',24);
xlabel('PSE Vestibular [cm]','fontsize',24);
ylim([-2 4]);
xlim([-2 4]);
xZeroLine = [-3:0.5:3];
yZeroLine = zeros(1,(length(xZeroLine)));
zeroLine=plot(xZeroLine, yZeroLine,'color',[0.4,0.4,0.4],'LineStyle','--','LineWidth',0.1);
yZeroLine = [-3:0.5:3];
xZeroLine = zeros(1,(length(yZeroLine)));
plot(xZeroLine, yZeroLine,'color',[0.4,0.4,0.4],'LineStyle','--','LineWidth',0.1)
refLine=refline(1,0);
set(refLine,'color','k','LineStyle','--')

% plotting scatter and diagonal histogram
[hscatter,hbar,ax]=scatterDiagHist(biasVes,biasVis,20)

% setting figure properties 
set(hscatter,'LineWidth',1.2,'MarkerEdgeColor',[0.8 0 0.80])
set(hbar,'FaceColor',[0.5 0 0.5])
daspect([1 1 1])
pbaspect([1 1 1])
set(hscatter,'SizeData',80,'LineWidth',1)
biasDiff=biasVes-biasVis;
meanBiasDiff=mean(biasDiff)
semBiasDiff=nanstd(biasDiff)/sqrt(length(biasDiff));
set(ax,'xtick',[-2:1:3],'fontsize',16);
set(ax,'ytick',[-2:1:3],'fontsize',16);
  
% saving
filename_fig=strcat(GRP_DIR,'\\Figure_2C');
print(gcf,'-dtiff','-r300', filename_fig);
saveas(gcf,strcat(filename_fig,'.eps'));
saveas(gcf,strcat(filename_fig,'.tif'));
saveas(gcf,strcat(filename_fig,'.fig'));
%% 
%  close all