% Kefei Liu. 2017.5.5
function [h1,h2,a1]=scatterDiagHist(x,y,dedge,varargin)
d=x-y;
rlim=[min([x(:);y(:)]),max([x(:);y(:)])];rlim(2)=rlim(2)+rlim(2)-rlim(1);
diflim=sqrt(2)/2* ((rlim(2)-rlim(1))/2);
if nargin<3 || isempty(dedge)
dedge=linspace(-diflim,diflim,13);
end

if length(dedge)==1
    dedge=linspace(-diflim,diflim,dedge+1);
end
dx=dedge(1:end-1)+(dedge(2)-dedge(1))/2;
dn=histcounts(d,dedge,'Normalization','probability');

a1=gca;
h1=scatter(x,y,varargin{:});
meanBiasDiff=mean(x-y)
semBiasDiff=nanstd(x-y)/sqrt(length(x));
 
hold on;
diagxy=[rlim(1),rlim(2)-(rlim(2)-rlim(1))/2];
plot(diagxy,diagxy,'k:');
a2=axes('position',get(a1,'position'));
h2=bar(dx,dn);
hold on;plot([0,0],[0,max(dn)*1.5],'k:');
plot([meanBiasDiff-semBiasDiff,meanBiasDiff+semBiasDiff],[0.3,0.3],'color',[0.5 0 0.5],'LineWidth',3)
scatter(meanBiasDiff,0.3,'MarkerFaceColor',[0.5 0 0.5],'MarkerEdgeColor',[0.5 0 0.5],'LineWidth',1,'Marker','d')
pos1=get(a1,'Position');posfig=get(gcf,'Position');
tmp=min(pos1([3,4]).*posfig([3,4]));
pos1(3)=tmp/posfig(3);pos1(4)=tmp/posfig(4);
pos2=[pos1(1)+(pos1(3))/2-pos1(3)/6,pos1(2)+(pos1(4))/2-pos1(4)/6,pos1(3),pos1(4)];
set(a1,'ActivePositionProperty','position','position',pos1,'xlim',rlim,...
    'ylim',rlim,'color','none');
set(a2,'Position',pos2,'ActivePositionProperty','position','color','none');
     set(a2,'View',[45,90])
     set(a2,'box','off')
     set(a2,'ycolor','none')
     set(a2,'xlim',[-1,1]*diflim)
     set(a2, 'xtick',[])
     set(a2,'Nextplot','add');
set(gcf,'CurrentAxes',a1)