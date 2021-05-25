function output_table=RSA_get_result_table_2nd(nsub,nsession)



% tool for generate sphere and calculate correlations
% sort two sessions in the same way then add session2 at the end of
% session1. beacuse any session for each subject has the same trial
% distribution, the final array should be the same.

%    ItemSet=TrialCondition(m,1);%????????
%    TemporalOrder=TrialCondition(m,4);
%    PlaceSet=TrialCondition(m,2);
%    LocationExchange=TrialCondition(m,3);
%    Tilted=TrialCondition(m,5);
%    MatchOrNot=TrialCondition(m,6);

%temporal order in program is to change the order of item


output_table=cell(64,5);
global_path =  'F:\fMRI\1-raw data\';
% local_path = ['\',period,'_',num2str(nsession),'\beta_'];

load([global_path,'RESULT\performance\result_for_Sub',num2str(nsub),'_session',num2str(nsession),'.mat']);
Result(65,:)=[];
% [table1,index1] = sortrows(Result);
% [table2,index2] = sortrows(table1,2);
% [table3,index3] = sortrows(table2,3);
% [table4,index4] = sortrows(table3,4);


output_table=cell(64,5);
beta_list=cell(64,2);
% beta_ima = MRIread(beta_list{i});

%E:\Sub2\RSA_1st_GLM\beta_0002.nii
% first column is for fixation period
%E:\zhang xinyi\a_result\Sub2\RSA_fixation_separate\RSA_fix_1_1
% for i=1:64
%     %     if index1(i,1)<10
%     %         beta_list{i,1}=[global_path,'a_result\Sub',num2str(nsub),local_path,'000',num2str(index1(i,1)),'.nii'];
%     %
%     %     else
%     %         beta_list{i,1}=[global_path,'a_result\Sub',num2str(nsub),local_path,'00',num2str(index1(i,1)),'.nii'];
%     %
%     %     end
%     %              if i<10
%     %             beta_list{i,1}=[global_path,'a_result\Sub',num2str(nsub),'\RSA_fixation_',num2str(nsession),'\beta_000',num2str(i),'.nii'];
%     %         elseif i>9
%     %             beta_list{i,1}=[global_path,'a_result\Sub',num2str(nsub),'\RSA_fixation_',num2str(nsession),'\beta_00',num2str(i),'.nii'];
%     %         end
%     if nsession == 1
%         beta_list{i,1}=[global_path,'a_result\Sub',num2str(nsub),'\RSA_fixation_separate_LSS\RSA_fix_',num2str(nsession),'_',num2str(i),'\beta_0001.nii'];
%     else
%         beta_list{i,1}=[global_path,'a_result\Sub',num2str(nsub),'\RSA_fixation_separate_LSS\uncoregistered\RSA_fix_',num2str(nsession),'_',num2str(i),'\beta_0001.nii'];
%     end
% end

% beta_list = beta_list(index2,:);
% beta_list = beta_list(index3,:);
% beta_list = beta_list(index4,:);


start_trial=1;
end_trial=64;
k=1;
for i=start_trial:end_trial
%     beta_ima = spm_read_vols(spm_vol(beta_list{k,1}));
%     output_table{i,1}=beta_ima;%beta
    output_table{i,2}=Result(k,1);%item
    output_table{i,3}=Result(k,2);%location
    output_table{i,4}=Result(k,3);%exchange
    output_table{i,5}=Result(k,4);%temporal order
    output_table{i,6}=Result(k,5);%*30 rotation
    output_table{i,7}=Result(k,6);%match or not
    output_table{i,8}=Result(k,8);% correct or not
    output_table{i,9}=Result(k,10);%confidence level
    k=k+1;
end








