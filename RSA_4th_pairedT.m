function RSA_4th_pairedT


result1_name = 'first sample';
%     early_name = ['E:\zhang xinyi\fMRI\a_result\RSA_disk2_separate\tcontrast\unnormalized\',result1_name,'\'];
%     %E:\zhang xinyi\a_result\RSA_disk2\Confidence\C4_C1+2+3\ItemSet_HC
%     later_name = ['E:\zhang xinyi\fMRI\a_result\RSA_disk2_separate\tcontrast\unnormalized\',result1_name,'\'];
%     output_name =['E:\zhang xinyi\fMRI\a_result\RSA_disk2_separate\tcontrast\unnormalized\',result1_name,'\OneSampleT\'];

early_name = ['E:\zhang xinyi\fMRI\a_result\RSA_fixation_separate\tcontrast\LSS\'];
later_name = ['E:\zhang xinyi\fMRI\a_result\RSA_fixation_separate\tcontrast\LSS\'];
%     %E:\zhang xinyi\a_result\RSA_disk2\Confidence\C4_C1+2+3\ItemSet_HC
% later_name = ['E:\zhang xinyi\fMRI\a_result\RSA_disk2_separate\tcontrast\unnormalized\one same and nonsame\'];
output_name =['E:\zhang xinyi\fMRI\a_result\RSA_fixation_separate\tcontrast\LSS\OneSampleT-second sample vs nonsame'];



sub = [2 3 4 5 7 8 9 10 12 13 14 15 16 17];

clc
s=cell(20,2);
%     for nsub=1:17
%         %wlocation temporal order_new_D_6mm_sub9
%         s{nsub,1}=[early_name,'w',result1_name,'_S_6mm_sub',num2str(nsub),'.nii,1'];
%         s{nsub,2}=[later_name,'w',result1_name,'_D_6mm_sub',num2str(nsub),'.nii,1'];
%     end

for nsub=1:17
    %wsmall set_nonconjunct
    %wsame map_6mm_sub2
    s{nsub,1}=[early_name,'wsecond sample_6mm_sub',num2str(nsub),'.nii,1'];
    s{nsub,2}=[later_name,'wnonsame_6mm_sub',num2str(nsub),'.nii,1'];
end

 


spm('defaults','fmri');
spm_jobman('initcfg');
matlabbatch=[];
matlabbatch{1}.spm.stats.factorial_design.dir = {output_name};
for i=1:14
    matlabbatch{1}.spm.stats.factorial_design.des.pt.pair(i).scans = {s{sub(i),1};s{sub(i),2}};
end
% s{3,1} s{3,2}; s{4,1},s{4,2}; s{5,1},s{5,2};...
%     s{7,1},s{7,2}; s{8,1},s{8,2}; s{9,1}, s{9,2}; s{10,1},s{10,2}; s{11,1},s{11,2}; s{12,1},s{12,2}; s{13,1},s{13,2};...
%     s{14,1},s{14,2}; s{15,1},s{15,2}; s{16,1},s{16,2}; s{17,1},s{17,2}};

matlabbatch{1}.spm.stats.factorial_design.des.pt.gmsca = 0;
matlabbatch{1}.spm.stats.factorial_design.des.pt.ancova = 0;
matlabbatch{1}.spm.stats.factorial_design.cov = struct('c', {}, 'cname', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{1}.spm.stats.factorial_design.multi_cov = struct('files', {}, 'iCFI', {}, 'iCC', {});
matlabbatch{1}.spm.stats.factorial_design.masking.tm.tm_none = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.im = 1;
matlabbatch{1}.spm.stats.factorial_design.masking.em = {''};
matlabbatch{1}.spm.stats.factorial_design.globalc.g_omit = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.gmsca.gmsca_no = 1;
matlabbatch{1}.spm.stats.factorial_design.globalm.glonorm = 1;
spm_jobman('run',matlabbatch);

%%estimate
clc;
spm('defaults','fmri');
spm_jobman('initcfg');
output_folder = output_name;
matlabbatch=[];
matlabbatch{1}.spm.stats.fmri_est.spmmat = {[output_folder, '\SPM.mat']};
matlabbatch{1}.spm.stats.fmri_est.write_residuals = 0;
matlabbatch{1}.spm.stats.fmri_est.method.Classical = 1;
spm_jobman('run',matlabbatch);

%%contrast
clc;
spm('defaults','fmri');
spm_jobman('initcfg');
output_folder = output_name;
output_path = [output_folder, '\SPM.mat'];
matlabbatch=[];
matlabbatch{1}.spm.stats.con.spmmat = {output_path};
matlabbatch{1}.spm.stats.con.consess{1}.tcon.name = 'na';
matlabbatch{1}.spm.stats.con.consess{1}.tcon.weights = [1,-1];
matlabbatch{1}.spm.stats.con.consess{1}.tcon.sessrep = 'none';
matlabbatch{1}.spm.stats.con.delete = 1;
spm_jobman('run',matlabbatch);




