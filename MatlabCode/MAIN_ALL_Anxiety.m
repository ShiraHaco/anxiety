clear;clc;close all;
initialize_human;
HO = 1; %heading offset (m=1 is the headings for INstring. INnum, however, starts at 1)
condLabel={'VES_all','VIS_all'};
for priorCond=1:2 %1 for ves, 2 for vis
%read in subject information 
[INnum, INstring] = xlsread(strcat(DATA_DIR,'\All input_',[condLabel{priorCond}],'.xlsx'),'subjects');
[~,IX] = sort(INnum(:,1)); %in order of ascending subj_NUM
subj_NUM = INnum(IX,1);
subj_AGE = INnum(IX,3);
subj_SEX = INnum(IX,4); 
subj_STAISAfter = INnum(IX,5); % STAI-S score after task 
subj_EXCL = INnum(IX,6);  % exclude list
subj_STAIT = INnum(IX,7); % STAI-T score 
subj_STAISBefore = INnum(IX,8);  % STAI-S score before task 

%read in session information
[INnum, INstring] = xlsread(strcat(DATA_DIR,'\All input_',[condLabel{priorCond}],'.xlsx'),'sessions');
sess_n = size(INnum,1);
i=0;
%get session info
    for sess_i=1:sess_n
     i = i+1;
     disp(sprintf('Processing session %u',sess_i));
     filename_12 = INstring{sess_i+HO,3}; %two blocks of every condition
     filename_21 = INstring{sess_i+HO,6};
     % Reading data file
     disp(sprintf('Reading file - %s',filename_12));
     filename_full_in_12=sprintf('%s\\Data\\%s.mat',DATA_DIR,filename_12);
     disp(sprintf('Reading file - %s',filename_12));
     filename_full_in_21=sprintf('%s\\Data\\%s.mat',DATA_DIR,filename_21);
    
%     filename_full_out=sprintf('%s\\Subjects\\%s.mat',DATA_DIR,filename);
      data = importdata(filename_full_in_12);
      if isfield(data, 'SavedInfo') %sometimes the data is saved in a field called "SavedInfo" - I don't know why it sometimes is/not?
         data=data.SavedInfo
      end
    
       AnaData{i} = analyze_single_Shira(filename_full_in_12,filename_full_in_21,priorCond);
    
%   Adam's analyze single for multisensory
          
    sess_bias(i)=AnaData{i}.bias;
    sess_thresh(i)=AnaData{i}.thresh;
    sess_Rsquare(i)=AnaData{i}.Rsquare;

    end

save(strcat(DATA_DIR,'\\All\Results',[condLabel{priorCond}]),'sess_*','subj_*','AnaData');
end
close all