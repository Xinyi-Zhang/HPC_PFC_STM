function pre_process_SessSeperated
%DICM import

 dicm2nii('E:\zhang xinyi\raw data\STMA02\1007-sms_bold_20CH_2mm_run1','E:\zhang xinyi\Sub2\Session1',4);
 
clc;
clear;
spm('defaults','fmri');
spm_jobman('initcfg');
path = 'E:\zhang xinyi\fMRI\';
for sub = [2:5 7:10 12:17]
    for nsess=1:2
%         realign, generate head movement parameters.
        path_nii_s1 = [path,'Sub', num2str(sub),'\Session',num2str(nsess),'\'];
%          path_nii_s2 = [path,'Sub', num2str(sub),'\Session2\'];
        
        nii_dir_s1 = dir(fullfile(path_nii_s1, 'sms*'));
%         nii_dir_s2 = dir(fullfile(path_nii_s2, 'sms*'));
        
        nii_list_s1 = strcat(path_nii_s1,  {nii_dir_s1.name}');
%         nii_list_s2 = strcat(path_nii_s2,  {nii_dir_s2.name}');
        
        matlabbatch = [];
        matlabbatch{1}.spm.spatial.realign.estwrite.data = {nii_list_s1}';
        matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.quality = 0.9;
        matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.sep = 4;
        matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.fwhm = 5;
        matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.rtm = 1;
        matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.interp = 2;
        matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.wrap = [0 0 0];
        matlabbatch{1}.spm.spatial.realign.estwrite.eoptions.weight = '';
        matlabbatch{1}.spm.spatial.realign.estwrite.roptions.which = [2 1];
        matlabbatch{1}.spm.spatial.realign.estwrite.roptions.interp = 4;
        matlabbatch{1}.spm.spatial.realign.estwrite.roptions.wrap = [0 0 0];
        matlabbatch{1}.spm.spatial.realign.estwrite.roptions.mask = 1;
        matlabbatch{1}.spm.spatial.realign.estwrite.roptions.prefix = 'r';
        spm_jobman('run',matlabbatch);
        F = spm_figure('GetWin','Graphics');
        spm_figure('Print',F, [path, 'realign_output']);
        disp(sub)
% %         
% %                        slice timing
% %          divided by two session
% %         image were get contiguouly, using slice timing to choose
% %         out slice for some brain location in different time
% %         
        load([path,'Sub',num2str(sub),'\Session',num2str(nsess),'-twosessioncombined\dcmHeaders.mat']);
        path_nii_s1 = [path,'Sub', num2str(sub),'\Session',num2str(nsess),'-twosessioncombined\'];
        nii_dir_s1 = dir(fullfile(path_nii_s1, 'rs*'));
        nii_list_s1 = strcat(path_nii_s1,  {nii_dir_s1.name}');
        if nsess==1
            SliceTiming=h.sms_bold_20CH_2mm_run1;
        else
            SliceTiming=h.sms_bold_20CH_2mm_run2;
        end
        SliceTiming=SliceTiming.MosaicRefAcqTimes;
        matlabbatch = [];
        matlabbatch{1}.spm.temporal.st.scans = {nii_list_s1}';
        matlabbatch{1}.spm.temporal.st.nslices = 62;
        matlabbatch{1}.spm.temporal.st.tr = 2;
        matlabbatch{1}.spm.temporal.st.ta = 0;
        matlabbatch{1}.spm.temporal.st.so =SliceTiming';
        matlabbatch{1}.spm.temporal.st.refslice = SliceTiming(1,1);
        matlabbatch{1}.spm.temporal.st.prefix = 'a';
        spm_jobman('run',matlabbatch);
        disp(sub)
        
    
%         
% %         coregister
% %         SPM will then implement a coregistration between the structural and functional data that
% %         maximises the mutual information.
        path_meanbold_image = [path,'Sub', num2str(sub),'\Session1-twosessioncombined\'];
        path_structure_image = [path,'Sub', num2str(sub),'\t1_1\'];
        nii_dir_meanbold_image = dir(fullfile(path_meanbold_image, 'mean*'));
        nii_dir_structure_image = dir(fullfile(path_structure_image, 't1*'));
        nii_meanbold_image = strcat(path_meanbold_image,  {nii_dir_meanbold_image.name}');
        nii_structure_image = strcat(path_structure_image,  {nii_dir_structure_image.name}');
        matlabbatch=[];
        matlabbatch{1}.spm.spatial.coreg.estimate.ref = nii_meanbold_image;
        matlabbatch{1}.spm.spatial.coreg.estimate.source = nii_structure_image;
        matlabbatch{1}.spm.spatial.coreg.estimate.other = {''};
        matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.cost_fun = 'nmi';
        matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.sep = [4 2];
        matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
        matlabbatch{1}.spm.spatial.coreg.estimate.eoptions.fwhm = [7 7];
        spm_jobman('run',matlabbatch);
        disp(sub)
        
%         segment
%         coregistered anatomical image
%         SPM will segment the structural image using the default tissue probability maps as priors
        path_co_structure_image = [path,'Sub', num2str(sub),'\t1_1\'];
        nii_dir_co_structure_image = dir(fullfile(path_co_structure_image, 't1*'));
        nii_co_structure_image = strcat(path_co_structure_image,  {nii_dir_co_structure_image.name}');
        matlabbatch=[];
        matlabbatch{1}.spm.spatial.preproc.channel.vols = nii_co_structure_image;
        matlabbatch{1}.spm.spatial.preproc.channel.biasreg = 0.001;
        matlabbatch{1}.spm.spatial.preproc.channel.biasfwhm = 60;
        matlabbatch{1}.spm.spatial.preproc.channel.write = [0 1];
        matlabbatch{1}.spm.spatial.preproc.tissue(1).tpm = {'C:\any toolbox\spm12\tpm\TPM.nii,1'};
        matlabbatch{1}.spm.spatial.preproc.tissue(1).ngaus = 1;
        matlabbatch{1}.spm.spatial.preproc.tissue(1).native = [1 0];
        matlabbatch{1}.spm.spatial.preproc.tissue(1).warped = [0 0];
        matlabbatch{1}.spm.spatial.preproc.tissue(2).tpm = {'C:\any toolbox\spm12\tpm\TPM.nii,2'};
        matlabbatch{1}.spm.spatial.preproc.tissue(2).ngaus = 1;
        matlabbatch{1}.spm.spatial.preproc.tissue(2).native = [1 0];
        matlabbatch{1}.spm.spatial.preproc.tissue(2).warped = [0 0];
        matlabbatch{1}.spm.spatial.preproc.tissue(3).tpm = {'C:\any toolbox\spm12\tpm\TPM.nii,3'};
        matlabbatch{1}.spm.spatial.preproc.tissue(3).ngaus = 2;
        matlabbatch{1}.spm.spatial.preproc.tissue(3).native = [1 0];
        matlabbatch{1}.spm.spatial.preproc.tissue(3).warped = [0 0];
        matlabbatch{1}.spm.spatial.preproc.tissue(4).tpm = {'C:\any toolbox\spm12\tpm\TPM.nii,4'};
        matlabbatch{1}.spm.spatial.preproc.tissue(4).ngaus = 3;
        matlabbatch{1}.spm.spatial.preproc.tissue(4).native = [1 0];
        matlabbatch{1}.spm.spatial.preproc.tissue(4).warped = [0 0];
        matlabbatch{1}.spm.spatial.preproc.tissue(5).tpm = {'C:\any toolbox\spm12\tpm\TPM.nii,5'};
        matlabbatch{1}.spm.spatial.preproc.tissue(5).ngaus = 4;
        matlabbatch{1}.spm.spatial.preproc.tissue(5).native = [1 0];
        matlabbatch{1}.spm.spatial.preproc.tissue(5).warped = [0 0];
        matlabbatch{1}.spm.spatial.preproc.tissue(6).tpm = {'C:\any toolbox\spm12\tpm\TPM.nii,6'};
        matlabbatch{1}.spm.spatial.preproc.tissue(6).ngaus = 2;
        matlabbatch{1}.spm.spatial.preproc.tissue(6).native = [0 0];
        matlabbatch{1}.spm.spatial.preproc.tissue(6).warped = [0 0];
        matlabbatch{1}.spm.spatial.preproc.warp.mrf = 1;
        matlabbatch{1}.spm.spatial.preproc.warp.cleanup = 1;
        matlabbatch{1}.spm.spatial.preproc.warp.reg = [0 0.001 0.5 0.05 0.2];
        matlabbatch{1}.spm.spatial.preproc.warp.affreg = 'mni';
        matlabbatch{1}.spm.spatial.preproc.warp.fwhm = 0;
        matlabbatch{1}.spm.spatial.preproc.warp.samp = 3;
        matlabbatch{1}.spm.spatial.preproc.warp.write = [0 1];
        spm_jobman('run',matlabbatch);
        disp(sub)
                %
% %         normalise_bold
%         path_y_file = [path,'Sub', num2str(sub),'\t1\'];
%         nii_dir_y_file = dir(fullfile(path_y_file, 'y_*'));
%         nii_y_file = strcat(path_y_file,  {nii_dir_y_file.name}');
%         path_ar_s1 = [path,'Sub', num2str(sub),'\Session',num2str(nsess),'\'];
%         nii_dir_ar_s1 = dir(fullfile(path_ar_s1, 'ar*'));
%         nii_ar_s1 = strcat(path_ar_s1,  {nii_dir_ar_s1.name}');
%         path_meanbold = [path,'Sub', num2str(sub),'\Session',num2str(nsess),'\'];
%         nii_dir_meanbold = dir(fullfile(path_meanbold, 'mean*'));
%         nii_meanbold = strcat(path_meanbold,  {nii_dir_meanbold.name}');
%         matlabbatch = [];
%         matlabbatch{1}.spm.spatial.normalise.write.subj.def = nii_y_file;
%         matlabbatch{1}.spm.spatial.normalise.write.subj.resample = [nii_ar_s1;nii_meanbold];
%         matlabbatch{1}.spm.spatial.normalise.write.woptions.bb = [-78 -112 -70
%             78 76 85];
%         matlabbatch{1}.spm.spatial.normalise.write.woptions.vox = [2 2 2];
%         matlabbatch{1}.spm.spatial.normalise.write.woptions.interp = 4;
%         matlabbatch{1}.spm.spatial.normalise.write.woptions.prefix = 'w';
%         spm_jobman('run',matlabbatch);
%         disp(sub)
        
% %         normalise_structual
        path_y_file = [path,'Sub', num2str(sub),'\t1_',num2str(nsess),'\'];
        nii_dir_y_file = dir(fullfile(path_y_file, 'y_*'));
        nii_y_file = strcat(path_y_file,  {nii_dir_y_file.name}');
        path_struction_image = [path,'Sub', num2str(sub),'\t1_',num2str(nsess),'\'];
        nii_dir_struction_image  = dir(fullfile(path_struction_image, 'mt1*'));
        nii_struction_image  = strcat(path_struction_image,  {nii_dir_struction_image.name}');
        matlabbatch{1}.spm.spatial.normalise.write.subj.def = nii_y_file;
        matlabbatch{1}.spm.spatial.normalise.write.subj.resample = nii_struction_image;
        matlabbatch{1}.spm.spatial.normalise.write.woptions.bb = [-78 -112 -70
            78 76 85];
        matlabbatch{1}.spm.spatial.normalise.write.woptions.vox = [1 1 1];
        matlabbatch{1}.spm.spatial.normalise.write.woptions.interp = 4;
        matlabbatch{1}.spm.spatial.normalise.write.woptions.prefix = 'w';
        spm_jobman('run',matlabbatch);
        disp(sub)
%         
%         %     smooth
%         path_nii_s1 = [path,'Sub', num2str(sub),'\Session',num2str(nsess),'\'];
% %         path_nii_s2 = [path,'Sub', num2str(sub),'\Session2\'];
%         nii_dir_s1 = dir(fullfile(path_nii_s1, 'war*'));
% %         nii_dir_s2 = dir(fullfile(path_nii_s2, 'war*'));
%         nii_list_s1 = strcat(path_nii_s1,  {nii_dir_s1.name}');
% %         nii_list_s2 = strcat(path_nii_s2,  {nii_dir_s2.name}');
%         matlabbatch{1}.spm.spatial.smooth.data = [nii_list_s1];
%         matlabbatch{1}.spm.spatial.smooth.fwhm = [8 8 8];
%         matlabbatch{1}.spm.spatial.smooth.dtype = 0;
%         matlabbatch{1}.spm.spatial.smooth.im = 0;
%         matlabbatch{1}.spm.spatial.smooth.prefix = 's';
%         spm_jobman('run',matlabbatch);
%         disp(sub)
    end
end


