% The purpose of this code is to use NSI to compare two groups 

% ------If you use any variable names that may be unclear to a new user please define here (ie: KFaGC = Knee Flexion at Ground Contact). 

%% Code Starts here…
%This is the general code and format, it will not run on its own without
%edits made to it! 

clear
clc

%% reading in Data
% read in the data sheet with demographics including all ones listed 
[Group_Data, Group_Text, Group_Raw] = xlsread ('filepath\Group Data Sheet.xlsx');
%the row in the data sheet for subjects you want to pull into the code
Group_subjects = [3:6 9 12:14 17 20:24];%example 
% Identifying  which columns in the data sheet have which information 
Group_sub_ID = Group_Raw(Group_subjects,1);
Group_gen =  cell2mat(Group_Raw(HOAW_subjects,5));
Gourp_age = Group_Raw(Group_subjects,6);
Group_dom_limb = Group_Raw(Group_subjects,7);
Group_avg_walking_speed = nanmean(5./(Group_Data(Group_subjects-2,14:20)),2);
Group_BMI = Group_Data(Group_subjects-2,3)./Group_Data(HOAW_subjects-2,1).^2;
Group_output = {};

Groupsym = [];

%filepath to data
filepath = ['filepath\Data';];

%for loop for pulling in the V3D exported data
for i = 1:size(Group_sub_ID,1)
    i;
    Group_sub_ID{i}
    
    %% Pull in Data that you are interested in looking at with the NSI 
    %this pulls in GRF, Knee angles, Hip angles, Ankle Angles
    L_headers = [filepath,'/',Group_sub_ID{i},'/Reduced/L_n_',Group_sub_ID{i},'_GRF.txt'];
    L_headers1 = importdata(L_headers);
    R_headers = [filepath,'/',Group_sub_ID{i},'/Reduced/R_n_',Group_sub_ID{i},'_GRF.txt'];
    R_headers1 = importdata(R_headers);
    
    fileLGRF = [filepath,'/',Group_sub_ID{i},'/Reduced/L_n_',Group_sub_ID{i},'_GRF.txt'];
    fileRGRF = [filepath,'/',Group_sub_ID{i},'/Reduced/R_n_',Group_sub_ID{i},'_GRF.txt'];
    fileLkneea = [filepath,'/',Group_sub_ID{i},'/Reduced/L_n_',Group_sub_ID{i},'_kneea.txt'];
    fileRkneea = [filepath,'/',Group_sub_ID{i},'/Reduced/R_n_',Group_sub_ID{i},'_kneea.txt'];
    fileLhipa = [filepath,'/',Group_sub_ID{i},'/Reduced/L_n_',Group_sub_ID{i},'_hipa.txt'];
    fileRhipa = [filepath,'/',Group_sub_ID{i},'/Reduced/R_n_',Group_sub_ID{i},'_hipa.txt'];
    fileLanklea = [filepath,'/',Group_sub_ID{i},'/Reduced/L_n_',Group_sub_ID{i},'_anklea.txt'];
    fileRanklea = [filepath,'/',Group_sub_ID{i},'/Reduced/R_n_',Group_sub_ID{i},'_anklea.txt'];
    
    file1RGRF = importdata(fileRGRF);
    file1LGRF = importdata(fileLGRF);
    file1Rkneea = importdata(fileRkneea);
    file1Lkneea = importdata(fileLkneea);
    file1Rhipa = importdata(fileRhipa);
    file1Lhipa = importdata(fileLhipa);
    file1Ranklea = importdata(fileRanklea);
    file1Lanklea = importdata(fileLanklea);
    
    file2RGRF = file1RGRF.data;
    file2LGRF = file1LGRF.data;
    file2Rkneea = file1Rkneea.data;
    file2Lkneea = file1Lkneea.data;
    file2Rhipa = file1Rhipa.data;
    file2Lhipa = file1Lhipa.data;
    file2Ranklea = file1Ranklea.data;
    file2Lanklea = file1Lanklea.data;
    
    R_colheaders = strsplit(file1RGRF.textdata{1,1});
    L_colheaders = strsplit(file1LGRF.textdata{1,1});
    
    %parting the headers to identify the trials
    trial_nums =[];
    for c = 11:size(R_colheaders,2)
        period_split = strsplit(R_colheaders{1,c},'.');
        trial_nums = [trial_nums str2double(period_split{1}(end))];
    end
    trial_nums = unique(trial_nums);
    
    %% Average within trial
    LGRF_temp = [];
    RGRF_temp = [];
    Lkneea_temp = [];
    Rkneea_temp = [];
    Lhipa_temp = [];
    Rhipa_temp = [];
    Lanklea_temp = [];
    Ranklea_temp = [];
   
    if size(trial_nums,2)<3
       return 
    end
    
    for t = 1:size(trial_nums,2)
        disp(['Trial ',num2str(trial_nums(t)),''])
        R_cols = find(strcmp(R_colheaders,['walk000',num2str(trial_nums(t)),'.c3d']));
        L_cols = find(strcmp(L_colheaders,['walk000',num2str(trial_nums(t)),'.c3d']));

        if isempty(R_cols)
            R_cols = find(strcmp(R_colheaders,['',Group_sub_ID{i},'_walk000',num2str(trial_nums(t)),'.c3d']));
            L_cols = find(strcmp(L_colheaders,['',Group_sub_ID{i},'_walk000',num2str(trial_nums(t)),'.c3d']));
        end
        
        if isempty(R_cols)==0
            for k = 1:3:size(R_cols,2)
                RGRF_temp = [RGRF_temp file2RGRF(:,R_cols(k)-3+2)];
                Rkneea_temp = [Rkneea_temp file2Rkneea(:,R_cols(k)-3)];
                Rhipa_temp = [Rhipa_temp file2Rhipa(:,R_cols(k)-3)];
                if size(file2Ranklea,2)>R_cols(k)-3
                    Ranklea_temp = [Ranklea_temp file2Ranklea(:,R_cols(k)-3)];
                end
            end
            
            % The numbers may need to change here bassed on your data or
            % dataset you are looking at 
            for m = 1:3:size(L_cols,2)
                LGRF_temp = [LGRF_temp file2LGRF(:,L_cols(m)-3+2)];
                Lkneea_temp = [Lkneea_temp file2Lkneea(:,L_cols(m)-3)];
                Lhipa_temp = [Lhipa_temp file2Lhipa(:,L_cols(m)-3)];
                if size(file2Lanklea,2)>L_cols(m)-3
                    Lanklea_temp = [Lanklea_temp file2Lanklea(:,L_cols(m)-3)];
                end
            end
        
            RGRF(:,t) = mean(RGRF_temp,2);
            LGRF(:,t) = mean(LGRF_temp,2);
            Rkneea(:,t) = mean(Rkneea_temp,2);
            Lkneea(:,t) = mean(Lkneea_temp,2);
            Rhipa(:,t) = mean(Rhipa_temp,2);
            Lhipa(:,t) = mean(Lhipa_temp,2); 
            Ranklea(:,t) = mean(Ranklea_temp,2);
            Lanklea(:,t) = mean(Lanklea_temp,2);   
        end
        
    end
    
    %Take max and min from each trial
    Lpeak_vGRF1=(max(LGRF(1:50,1:size(LGRF,2))));
    Rpeak_vGRF1=(max(RGRF(1:50,1:size(RGRF,2))));
    Lpeak_vGRF2=(max(LGRF(51:101,1:size(LGRF,2))));
    Rpeak_vGRF2=(max(RGRF(51:101,1:size(RGRF,2))));
    
    Lpeak_kneea_flx=(min(Lkneea(:,1:size(Lkneea,2))));
    Rpeak_kneea_flx=(min(Rkneea(:,1:size(Rkneea,2))));
    Lpeak_hipa_ext=(min(Lhipa(:,1:size(Lhipa,2))));
    Rpeak_hipa_ext=(min(Rhipa(:,1:size(Rhipa,2))));
    Lpeak_anklea_pf=(min(Lanklea(:,1:size(Lanklea,2))));
    Rpeak_anklea_pf=(min(Ranklea(:,1:size(Ranklea,2))));
    
    Lpeak_kneeROM=(max(Lkneea(:,1:size(Lkneea,2)))) - (min(Lkneea(:,1:size(Lkneea,2))));
    Rpeak_kneeROM=(max(Rkneea(:,1:size(Rkneea,2)))) - (min(Rkneea(:,1:size(Rkneea,2))));
    Lpeak_hipROM=(max(Lhipa(:,1:size(Lhipa,2)))) - (min(Lhipa(:,1:size(Lhipa,2))));
    Rpeak_hipROM=(max(Rhipa(:,1:size(Rhipa,2)))) - (min(Rhipa(:,1:size(Rhipa,2))));
    
    %Average
    vals1(i,:) = [mean(Lpeak_vGRF1) mean(Rpeak_vGRF1) mean(Lpeak_vGRF2) mean(Rpeak_vGRF2) mean(Lpeak_kneea_flx) mean(Rpeak_kneea_flx) mean(Lpeak_hipa_ext) mean(Rpeak_hipa_ext) mean(Lpeak_anklea_pf) mean(Rpeak_anklea_pf) mean(Lpeak_kneeROM) mean(Rpeak_kneeROM) mean(Lpeak_hipROM) mean(Rpeak_hipROM)];

    %Overall max/min
    vals2(i,:) = [max(Lpeak_vGRF1) max(Rpeak_vGRF1) max(Lpeak_vGRF2) max(Rpeak_vGRF2) min((Lpeak_kneea_flx)) min((Rpeak_kneea_flx)) min((Lpeak_hipa_ext)) min((Rpeak_hipa_ext)) min((Lpeak_anklea_pf)) min((Rpeak_anklea_pf)) max(Lpeak_kneeROM) max(Rpeak_kneeROM) max(Lpeak_hipROM) max(Rpeak_hipROM)];

    %Trial by trial
    vals3(i,:) = [{Lpeak_vGRF1} {Rpeak_vGRF1} {Lpeak_vGRF2} {Rpeak_vGRF2} {Lpeak_kneea_flx} {Rpeak_kneea_flx} {Lpeak_hipa_ext} {Rpeak_hipa_ext} {Lpeak_anklea_pf} {Rpeak_anklea_pf} {Lpeak_kneeROM} {Rpeak_kneeROM} {Lpeak_hipROM} {Rpeak_hipROM}];

    %% NSI Calculations
    for j = 1:2:size(vals3,2)
        if strcmp(Group_dom_limb{i},'R') %if R is dominant
            NSI=nanmean((vals3{i,j+1}-vals3{i,j})./((max([0,vals3{i,j},vals3{i,j+1}])-min([0,vals3{i,j},vals3{i,j+1}]))).*100);
        else
            NSI=nanmean((vals3{i,j}-vals3{i,j+1})./((max([0,vals3{i,j},vals3{i,j+1}])-min([0,vals3{i,j},vals3{i,j+1}]))).*100);
        end
        Groupsym(i,(j+1)/2) = NSI;
    end
     %% Output
     Group_output(size(Group_output,1)+1,:) = cat(2,Group_sub_ID(i),num2cell(Group_age{i}),num2cell(Group_BMI(i)),num2cell(Group_avg_walking_speed(i)),num2cell(Groupsym(i,:)));
end

