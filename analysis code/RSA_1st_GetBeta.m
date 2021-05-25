function RSA_1st_GetBeta
%rewrite RSA_1st_GLM


clc;
clear;
spm('defaults','fmri');
spm_jobman('initcfg');
global_path = 'E:\zhang xinyi\fMRI\';
local_path = 'a_result\';
for nsub= [2:5 7:10 12:17]
    
    % bold file for s1 and s2
    path_run1 = [global_path,'Sub', num2str(nsub), '\Session1\'];
    path_run2 = [global_path,'Sub', num2str(nsub), '\Session2\'];
    session1_dir = dir(fullfile(path_run1, 'ar*'));  %unsmoothed data
    session2_dir = dir(fullfile(path_run2, 'ar*'));
    session_dir{1,1} = strcat(path_run1,  {session1_dir.name}');
    session_dir{1,2} = strcat(path_run2,  {session2_dir.name}');
    % hm file for s1 and s2 ????
    path_hm_s1 = [global_path,'Sub', num2str(nsub), '\Session1\'];
    path_hm_s2 = [global_path,'Sub', num2str(nsub), '\Session2\'];
    dir_hm_s1 = dir(fullfile(path_hm_s1, 'rp*'));
    dir_hm_s2 = dir(fullfile(path_hm_s2, 'rp*'));
    hm_file{1,1} = strcat(path_hm_s1,  {dir_hm_s1.name}');
    hm_file{1,2} = strcat(path_hm_s2,  {dir_hm_s2.name}');
    
    for nsess=1:2
        for ntrial = 1:64
            %% batch
            path_result_store = [global_path,local_path,'\Sub', num2str(nsub), '\RSA_fixation_separate_LSS\RSA_fix_',num2str(nsess),'_',num2str(ntrial),'\'];
            
            matlabbatch = [];
            matlabbatch{1}.spm.stats.fmri_spec.dir = {path_result_store};
            matlabbatch{1}.spm.stats.fmri_spec.timing.units = 'secs';
            matlabbatch{1}.spm.stats.fmri_spec.timing.RT = 2;
            matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t = 62;
            matlabbatch{1}.spm.stats.fmri_spec.timing.fmri_t0 = 33;
            
            r_names1{1,1}=['trial_',num2str(ntrial)];
            
            r_names2= {'other'};
            %%anyway, this order_1 order_2 should not work like this
            r_names=[r_names1,r_names2];
            
            behavior_time = RSA_get_behavior_result_1st(nsub,nsess,ntrial);
            %%%%%%%%%%%%%%%%%%%%%%function get_behavior_result must change
            matlabbatch{1}.spm.stats.fmri_spec.sess(1).scans = session_dir{1,nsess};
            for n_con=1:length(r_names)
                matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(n_con).name = r_names{n_con};
                matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(n_con).onset = behavior_time{1,n_con};
                matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(n_con).duration = behavior_time{2,n_con};
                matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(n_con).tmod = 0;
                matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(n_con).pmod = struct('name', {}, 'param', {}, 'poly', {});
                matlabbatch{1}.spm.stats.fmri_spec.sess(1).cond(n_con).orth = 1;
            end
            matlabbatch{1}.spm.stats.fmri_spec.sess(1).multi = {''};
            matlabbatch{1}.spm.stats.fmri_spec.sess(1).regress = struct('name', {}, 'val', {});
            matlabbatch{1}.spm.stats.fmri_spec.sess(1).multi_reg = hm_file{1,nsess};
            matlabbatch{1}.spm.stats.fmri_spec.sess(1).hpf = 128;
            
            %% end
            matlabbatch{1}.spm.stats.fmri_spec.fact = struct('name', {}, 'levels', {});
            matlabbatch{1}.spm.stats.fmri_spec.bases.hrf.derivs = [0 0];
            matlabbatch{1}.spm.stats.fmri_spec.volt = 1;
            matlabbatch{1}.spm.stats.fmri_spec.global = 'None';
            matlabbatch{1}.spm.stats.fmri_spec.mthresh = 0.8;
            matlabbatch{1}.spm.stats.fmri_spec.mask = {''};
            %'C:\any toolbox\spm12\tpm\mask_ICV.nii'
            matlabbatch{1}.spm.stats.fmri_spec.cvi = 'AR(1)';
            spm_jobman('run',matlabbatch);
            disp([num2str(nsub),'-',num2str(nsess),'-',num2str(ntrial)]);
        end
    end
end

% % estimation
% clc;
clear;
spm('defaults','fmri');
spm_jobman('initcfg');
global_path = 'E:\zhang xinyi\fMRI\';
local_path = 'a_result\';
for nsub = [2:5 7:10 12:17]
    for nsess= 1:2
        for ntrial = 1:64
            output_path = [global_path,local_path,'Sub', num2str(nsub), '\RSA_fixation_separate_LSS\RSA_fix_',num2str(nsess),'_',num2str(ntrial),'\SPM.mat'];
            matlabbatch = [];
            matlabbatch{1}.spm.stats.fmri_est.spmmat = {output_path};
            matlabbatch{1}.spm.stats.fmri_est.write_residuals = 0;
            matlabbatch{1}.spm.stats.fmri_est.method.Classical = 1;
            spm_jobman('run',matlabbatch);
            disp([num2str(nsub),'-',num2str(nsess),'-',num2str(ntrial)]);
        end
    end
end



