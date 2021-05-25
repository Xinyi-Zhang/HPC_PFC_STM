function behavior_time=RSA_get_behavior_result_1st(nsub,nsess,ntrial)

global_path = 'E:\zhang xinyi\fMRI\';
load( [global_path,'RESULT\timepoint\timepoint_for_Sub',num2str(nsub),'_session',num2str(nsess),'.mat']);
load( [global_path,'RESULT\performance\result_for_Sub',num2str(nsub),'_session',num2str(nsess),'.mat']);

%using baseline,item1, item2, disk1 & disk2
%using baseline,item1, item2, disk1 & disk2
onset_baseline=TimePoint(2:65,1);
onset_disk1=TimePoint(2:65,2);
onset_item1=TimePoint(2:65,5);
onset_item2=TimePoint(2:65,8);
onset_disk2=TimePoint(2:65,11);
onset_maintanence=TimePoint(2:65,14);
duration_maintanence=TimePoint(2:65,15)-TimePoint(2:65,14);
onset_fixation=TimePoint(2:65,15);
duration_fixation=TimePoint(2:65,16)-TimePoint(2:65,15);
onset_combination = TimePoint(2:65,16);
onset_choice = TimePoint(2:65,17);
duration_choice = TimePoint(2:65,18)-TimePoint(2:65,17);
onset_confidence = TimePoint(2:65,19);
duration_confidence = TimePoint(2:65,21)-TimePoint(2:65,19);



%trial-wise beta
    onset_trial=TimePoint(ntrial+1,15);
    duration_trial=2;

    onset_item2(ntrial,:)=[];

    behavior_time1{1,1}=onset_trial;
    behavior_time1{2,1}=duration_trial;
    
    onset_other = [onset_baseline;onset_disk1;onset_item1;onset_item2;onset_disk2;onset_maintanence;onset_combination;onset_choice;onset_confidence];
    duration_other = 0;
    %[2;2;2;2;2;duration_maintanence;2;duration_fixation;duration_choice;duration_confidence]
    
behavior_time2 = {onset_other;duration_other};

behavior_time=[behavior_time1,behavior_time2];

for i=1:2
    for k=1:length(behavior_time)
        if isempty(behavior_time{i,k})
            behavior_time{i,k}=0;
        end
    end
end



