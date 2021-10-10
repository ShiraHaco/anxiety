%clear % - can't use clear if running in loop (e.g. SUMMARY==2) or using !!MAIN_figs!!

%changed DATA_DIR 

DATA_DIR = 'C:\Users\shirt\Documents\Documents old\Anxiety Data\anxiety project' %change accordingly
ALL_DIR = strcat(DATA_DIR,'\\All');
% SUB_DIR = strcat(DATA_DIR,'\\Subjects');
GRP_DIR = strcat(DATA_DIR,'\\Group');
WORK_DIR = strcat(DATA_DIR,'\\MatlabCode');

global CALC; CALC=0;                            %REcalculate everything (note: always calculates if there are no results saved even if CALC=0)
global SUMMARY; SUMMARY=1;                      %NB run from MAIN_. If SUMMARY=1 - pool subjects; if SUMMARY=2 - do for each subject seperately
global PLOT; PLOT=1;
global PLOT_type; PLOT_type=0;                  %Run from PLOT_adaptation: 0 = regular (plot all); 1 = for publication (best typical); 2 = specifc sessions; 3=simulated data
global SAVE_FIGS; SAVE_FIGS=1;
global VERBOSE; VERBOSE=1;
% changed from 5 to 1 for FB protocols
global COMNUM; COMNUM=1;                        %the number of steps for the vis-ves combined adaptation (middle) block
global DO_ALL; DO_ALL=1;                        %Do all subjects or only those in the array SUBJ (currently only for MAIN_)
global SUBJ; SUBJ=['ZZ';'JT'; 'EK'];            %matrix of subjects (e.g. ['ZZ','AS';'BK';'CZ'];) to use if DO_ALL==0; (NB: 'ZZ' should always be there)
global N_BOOTSTRP; N_BOOTSTRP=1000;             %INCREASE AT FINAL RUN
weighted_plot=1;                                %for type-II regressions, weight the points by their SD (1/SD)
reliability_factor=2.5;                         %sort the low/high reliability ratio (RR) based on that calculated <1/reliability_factor and >reliability_factor  (if =0 sort by coherence)
geomean_reliability=1;                          %use the a geometric mean of the PRE/POST reliability (o/w just the PRE)
linewidth=2;

%FIXED PARAMS - do not change
global COH; COH={'Low','Med','High','All'};     %FIXED PARAMS - do not change   
global ACCU; ACCU={'Ves' 'Vis' 'Halfway'};      %Which heading is accurate
global COH_level; COH_level=[1:3];              %TBD!!if vector form is used doesn't plot well...is the vector good for anything?            %vector (values 1-3) according to that defined in COH        
lim1=10;
%figures=[[1:4 6 8 9]];    %for summary ([1:4 6 8 9])
figures=1;

%Colors for plots - do not change
c0=0.8*[160 82 45]/255;
z=2; a=summer(COMNUM+z);
c1=[0 0 1]; c11=[0 0.8 1];
c2=[1 0 0]; c22=[1 0 1];
c3=[0 0.5 0];  c33=[0 1 0];
%c3=a(1,:); c32=a(COMNUM,:); c33=a(COMNUM+1,:);