function [AnaData]=analyze_single_Shira(filename_12,filename_21,priorCond,subj_NUM,DATA_DIR)

PLOTALL=1;

if nargin <4
    plotfig=1;
end

%neutral minus threat
%reference minus test
%1,2

results = importdata(filename_12);
% results=SavedInfo;
distanceX=[4 2 1 0.5 0.25 0.125 0.0625 0.03125 0.015625 0.0078125];
distanceX= [-1*distanceX 0 fliplr(distanceX)];
namedRefPerDist = containers.Map;
namedTotPerDist = containers.Map;
for ii=1:length(distanceX)
    namedRefPerDist(char(string(distanceX(ii)))) = 0;
    namedTotPerDist(char(string(distanceX(ii)))) = 0;
end
refPerDist=zeros(1,length(distanceX));
totPerDist=zeros(1,length(distanceX));
numOfTrials = length(results.Resp.refMinusTest);
for i=1:numOfTrials
    if results.Resp.response(i) == 3
        col = 2;
    else
        col = 1;
    end
    if results.Resp.intOrder(i,col) == 2
        namedRefPerDist(char(string(results.Resp.refMinusTest(i)))) = namedRefPerDist(char(string(results.Resp.refMinusTest(i)))) + 1;
    end
    namedTotPerDist(char(string(results.Resp.refMinusTest(i)))) = namedTotPerDist(char(string(results.Resp.refMinusTest(i)))) + 1;
end
for ii=1:length(distanceX)
    refPerDist(ii) = namedRefPerDist(char(string(distanceX(ii))));
    totPerDist(ii) = namedTotPerDist(char(string(distanceX(ii))));
end

refPerDist_12=refPerDist;
totPerDist_12=totPerDist;
% yVec = refPerDist./totPerDist;
yVec = refPerDist_12./totPerDist_12;

isFilesTheSame=strcmp(filename_12,filename_21);
if isFilesTheSame==1
  
mat = [(distanceX)', (yVec)',(totPerDist_12)']
tempmat=mat
mat((mat(:,3)==0),3)=nan
mat(any(isnan(mat),2),:) = []

else 
%threat minus neutral
%test minus reference 
% 2 1
results = importdata(filename_21);
% results=SavedInfo;
distanceX=[4 2 1 0.5 0.25 0.125 0.0625 0.03125 0.015625 0.0078125];
distanceX= [-1*distanceX 0 fliplr(distanceX)];
namedRefPerDist = containers.Map;
namedTotPerDist = containers.Map;
for ii=1:length(distanceX)
    namedRefPerDist(char(string(distanceX(ii)))) = 0;
    namedTotPerDist(char(string(distanceX(ii)))) = 0;
end
refPerDist=zeros(1,length(distanceX));
totPerDist=zeros(1,length(distanceX));
numOfTrials = length(results.Resp.refMinusTest);
for i=1:numOfTrials
    if results.Resp.response(i) == 3
        col = 2;
    else
        col = 1;
    end
    if results.Resp.intOrder(i,col) == 1
        namedRefPerDist(char(string(-1.*(results.Resp.refMinusTest(i))))) = namedRefPerDist(char(string(-1.*(results.Resp.refMinusTest(i))))) + 1;
    end
    namedTotPerDist(char(string(-1.*(results.Resp.refMinusTest(i))))) = namedTotPerDist(char(string(-1.*(results.Resp.refMinusTest(i))))) + 1;
end
for ii=1:length(distanceX)
    refPerDist(ii) = namedRefPerDist(char(string(distanceX(ii))));
    totPerDist(ii) = namedTotPerDist(char(string(distanceX(ii))));
end

refPerDist_21=refPerDist;
totPerDist_21=totPerDist;
% yVec = refPerDist./totPerDist;
yVec = refPerDist_21./totPerDist_21;

% combining both blocks for each condition
refPerDist=refPerDist_12+refPerDist_21
totPerDist=totPerDist_12+totPerDist_21
yVec = refPerDist./totPerDist;
mat = [(distanceX)', (yVec)',(totPerDist)']
tempmat=mat
mat((mat(:,3)==0),3)=nan
mat(any(isnan(mat),2),:) = []
end

%     if priorCond==1
%         modality='ves';
%     else
%         modality='vis';
%     end
    
if plotfig %plotting the curve
  filename_fig=filename_12(1:findstr(filename_12,'.mat')-1);
    filename_fig=strcat(filename_fig,'_figure');
    if PLOTALL || size(dir(strcat(filename_fig,'.tif')),1)==0 %if the file doesn't already exist
        figure
        set(gcf,'Units','normalized'); set(gcf,'Position',[0.25 0.05 0.5 0.85],'Name','Offline Analysis','NumberTitle','off');
        c1=[0 0 0.5]; c2=[0.7 0 0]; c3=[0 0.7 0];
        linewidth=2;
        sizeData = 5*mat(:,3)*((10000./sum(mat(:,3)))/10);
        %mat(find(isnan(mat))) = 0;
        global is_new_pfit
        is_new_pfit = 1;
        %mat(mat==0)= nan;
        subject_info=getPfitData(mat, mat(:,1)')
        AnaData= getPfitData(mat, mat(:,1)');
        hold on
        
          %zeroYaxisForGraph
        yZeroLine = [0:0.1:1];
        xZeroLine = zeros(1,(length(yZeroLine)));
        px=plot(xZeroLine, yZeroLine,'k','LineStyle','--','LineWidth',0.3);
        set(get(get(px,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');

        %o.5axisForGraph
        xHalfLine = distanceX;
        yHalfLine = 0.5.*(ones(1,length(distanceX)));
        py=plot(xHalfLine,yHalfLine,'k','LineStyle','--','LineWidth',0.3);
        set(get(get(py,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');

        xlabel('Distance Difference (Neutral - Threat) [cm]','fontsize',24)
        ylabel('Choice Ratio (Neutral > Threat)','fontsize',24)
        
        if priorCond==1 %%vestibular
         s_Ves=scatter(mat(:,1),mat(:,2),sizeData,'MarkerEdgeColor',[0 0 0.8],'LineWidth',2)
         set(get(get(s_Ves,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
         p_Ves=plot(AnaData.xi, AnaData.pfitcurve,'color',[0 0 0.8],'LineStyle','-','LineWidth',5)
         yBiasLine = [0:0.1:0.5];
         xBiasLine = subject_info.bias.*ones(1,(length(yBiasLine)));
         p_bias=plot(xBiasLine,yBiasLine,'k','LineStyle','--','LineWidth',0.3)
         subject_info.bias68CI(2)-subject_info.bias68CI(1)
         errorBias=errorbar(subject_info.bias,0.5,subject_info.bias68CI(2)-subject_info.bias,'horizontal','color',[0 0 0.8])

           title('Vestibular','fontsize',28);
           
        else %%visual
            
         s_Vis=scatter(mat(:,1),mat(:,2),sizeData,'MarkerEdgeColor',[0.8 0 0],'LineWidth',2)
         set(get(get(s_Vis,'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
         p_Vis=plot(AnaData.xi, AnaData.pfitcurve,'color',[0.8 0 0],'LineStyle','-','LineWidth',5)
         yBiasLine = [0:0.1:0.5];
         xBiasLine = subject_info.bias.*ones(1,(length(yBiasLine)));
         p_bias=plot(xBiasLine,yBiasLine,'k','LineStyle','--','LineWidth',0.3)
         subject_info.bias68CI(2)-subject_info.bias68CI(1)
         errorBias=errorbar(subject_info.bias,0.5,subject_info.bias68CI(2)-subject_info.bias,'horizontal','color',[0.8 0 0])

           title('Visual','fontsize',28);
        end
       
    end
end

    set(gcf,'paperpositionmode','auto');
    print(gcf,'-dtiff','-r300', filename_fig)
    print(gcf,'-dpdf','-r300', filename_fig)
    savefig(gcf,filename_fig)
    
if PLOTALL
   close(gcf)
end
end
