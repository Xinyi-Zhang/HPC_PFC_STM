%anatomical ROI
% ROI_name = {'lHPC','rFrontal_mOrb','lFrontal_mOrb','vmPFC','imPFC_noACC','imPFC_withACC','MCC','rMFC','rSFC','lOFC','ACC','frontal_med_orb','frontal_med_orb_withACC','Rectus'};
% ROI_name = {'PRc2','lMOFC','rRectus','lRectus','rmSFC','lmSFC'};
% ROI_name = {'PHc'};
% ROI_name = {'rIFC_oper','rIFC_tri','lMCC','rMCC','rSMA','lSMA','lIOFC','rSTC','rMTC'};
% ROI_name = {'anterior_rHPC','posterior_rHPC'};
% ROI_name = {'rACC'};

for nsub = [2:5 7:10 12:17]
    for nsess = 1:2
        %first, coregister with normalized BOLD
        spm('defaults','fmri');
        spm_jobman('initcfg');
        matlabbatch=[];
        matlabbatch{1}.spm.spatial.coreg.estwrite.ref = {'E:\zhang xinyi\fMRI\a_result\RSA_fixation_separate\tcontrast\LSS\OneSampleT-similar map vs nonsame\spmT_0001.nii'};
        matlabbatch{1}.spm.spatial.coreg.estwrite.source = {['E:\zhang xinyi\fMRI\a_result\RSA_fixation_separate\anatomical_ROI\ROI\lPRC_sub',num2str(nsub),'\s',num2str(nsess),'\aal_MNI_V4.nii']};
        %             matlabbatch{1}.spm.spatial.coreg.estwrite.other = {['E:\zhang xinyi\fMRI\a_result\RSA_fixation_separate\anatomical_ROI\MTL\lPRC_sub',num2str(nsub),'\s',num2str(nsess),'\',ROI_name{nROI},'_sub',num2str(nsub),'.nii']};
        matlabbatch{1}.spm.spatial.coreg.estwrite.other = {['E:\zhang xinyi\fMRI\a_result\RSA_fixation_separate\anatomical_ROI\ROI\lPRC_sub',num2str(nsub),'\s',num2str(nsess),'\rACC.nii']};
%             ['E:\zhang xinyi\fMRI\a_result\RSA_fixation_separate\anatomical_ROI\ROI\lPRC_sub',num2str(nsub),'\s',num2str(nsess),'\posterior_rHPC.nii']};
        matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.cost_fun = 'nmi';
        matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.sep = [4 2];
        matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
        matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.fwhm = [7 7];
        matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.interp = 4;
        matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.wrap = [0 0 0];
        matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.mask = 0;
        matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.prefix = 'r';
        spm_jobman('run',matlabbatch);
        
        %second, transform backward
        matlabbatch=[];
        matlabbatch{1}.spm.spatial.normalise.write.subj.def = {['E:\zhang xinyi\fMRI\Sub',num2str(nsub),'\t1\iy_t1_mprage_sag_iso_mww.nii']};
        matlabbatch{1}.spm.spatial.normalise.write.subj.resample = {['E:\zhang xinyi\fMRI\a_result\RSA_fixation_separate\anatomical_ROI\ROI\lPRC_sub',num2str(nsub),'\s',num2str(nsess),'\rrACC.nii'];...
%             ['E:\zhang xinyi\fMRI\a_result\RSA_fixation_separate\anatomical_ROI\ROI\lPRC_sub',num2str(nsub),'\s',num2str(nsess),'\rposterior_rHPC.nii'];
            ['E:\zhang xinyi\fMRI\a_result\RSA_fixation_separate\anatomical_ROI\ROI\lPRC_sub',num2str(nsub),'\s',num2str(nsess),'\raal_MNI_V4.nii']};
        matlabbatch{1}.spm.spatial.normalise.write.woptions.bb = nan(2,3);
        matlabbatch{1}.spm.spatial.normalise.write.woptions.vox = [1 0.5 0.5];
        matlabbatch{1}.spm.spatial.normalise.write.woptions.interp = 1;
        matlabbatch{1}.spm.spatial.normalise.write.woptions.prefix = 'w';
        spm_jobman('run',matlabbatch);
        
        %third, coregister again
        matlabbatch=[];
        if nsess==1
            matlabbatch{1}.spm.spatial.coreg.estwrite.ref = {['E:\zhang xinyi\fMRI\a_result\Sub',num2str(nsub),'\RSA_fixation_separate_LSS\RSA_fix_',num2str(nsess),'_1\beta_0001.nii']};
        elseif nsess==2
            matlabbatch{1}.spm.spatial.coreg.estwrite.ref = {['E:\zhang xinyi\fMRI\a_result\Sub',num2str(nsub),'\RSA_fixation_separate_LSS\uncoregistered\RSA_fix_',num2str(nsess),'_1\beta_0001.nii']};
        end
        matlabbatch{1}.spm.spatial.coreg.estwrite.source = {['E:\zhang xinyi\fMRI\a_result\RSA_fixation_separate\anatomical_ROI\ROI\lPRC_sub',num2str(nsub),'\s',num2str(nsess),'\mt1_mprage_sag_iso_mww.nii']};
        matlabbatch{1}.spm.spatial.coreg.estwrite.other = {['E:\zhang xinyi\fMRI\a_result\RSA_fixation_separate\anatomical_ROI\ROI\lPRC_sub',num2str(nsub),'\s',num2str(nsess),'\wrrACC.nii'];...
%             ['E:\zhang xinyi\fMRI\a_result\RSA_fixation_separate\anatomical_ROI\ROI\lPRC_sub',num2str(nsub),'\s',num2str(nsess),'\wrposterior_rHPC.nii'];
           ['E:\zhang xinyi\fMRI\a_result\RSA_fixation_separate\anatomical_ROI\ROI\lPRC_sub',num2str(nsub),'\s',num2str(nsess),'\wraal_MNI_V4.nii']};
        matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.cost_fun = 'nmi';
        matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.sep = [4 2];
        matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.tol = [0.02 0.02 0.02 0.001 0.001 0.001 0.01 0.01 0.01 0.001 0.001 0.001];
        matlabbatch{1}.spm.spatial.coreg.estwrite.eoptions.fwhm = [7 7];
        matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.interp = 4;
        matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.wrap = [0 0 0];
        matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.mask = 0;
        matlabbatch{1}.spm.spatial.coreg.estwrite.roptions.prefix = 'r';
        spm_jobman('run',matlabbatch);
    end
end




for nROI = 1
    %     r_pho = zeros(17,2,8);
    mkdir(['E:\zhang xinyi\fMRI\a_result\RSA_fixation_separate\anatomical_ROI\Similarity\',ROI_name{nROI}]);
    %      mkdir(['E:\zhang xinyi\fMRI\a_result\RSA_fixation_separate\anatomical_ROI\Similarity_new\',ROI_name{nROI}]);
    for nsub = [2:5 7:10 12:17]
        for nsess = 1:2
            %second, get voxel-wise activation from each subject of all trials
            image_ROI = spm_vol(['E:\zhang xinyi\fMRI\a_result\RSA_fixation_separate\anatomical_ROI\ROI\lPRC_sub',num2str(nsub),'\s',num2str(nsess),'\rwr',ROI_name{nROI},'.nii']);
            matrix_ROI = spm_read_vols(image_ROI);
            [fir_di, sec_di, thi_di] = size(matrix_ROI);%??????×é
            [d1, d2, d3] = ind2sub([fir_di, sec_di, thi_di],find(matrix_ROI>0));
            voxel_array = [d1, d2, d3];
            count_voxel = length(voxel_array);
            
            Bvalue = zeros(count_voxel,64);
            for ntrial = 1:64
                if nsess==1
                    image_beta = spm_vol(['E:\zhang xinyi\fMRI\a_result\Sub',num2str(nsub),'\RSA_fixation_separate_LSS\RSA_fix_',num2str(nsess),'_',num2str(ntrial),'\beta_0001.nii']);
                elseif nsess==2
                    image_beta = spm_vol(['E:\zhang xinyi\fMRI\a_result\Sub',num2str(nsub),'\RSA_fixation_separate_LSS\uncoregistered\RSA_fix_',num2str(nsess),'_',num2str(ntrial),'\beta_0001.nii']);
                end
                
                matrix_beta = spm_read_vols(image_beta);
                for ith = 1:count_voxel
                    Bvalue(ith,ntrial)= matrix_beta(voxel_array(ith,1),voxel_array(ith,2),voxel_array(ith,3));
                end
            end
            Bvalue = Bvalue(find(~isnan(Bvalue(:,1))),:);
            lB = size(Bvalue,1);
            Bvalue_z2 = zeros(lB,64);
            for ith = 1:lB
                m = mean(Bvalue(ith,:));
                %                 s = std(Bvalue(ith,:));
                Bvalue_z2(ith,:) = Bvalue(ith,:)-m;
            end
            save(['E:\zhang xinyi\fMRI\a_result\RSA_fixation_separate\anatomical_ROI\Similarity\',ROI_name{nROI},'\',num2str(nsub),'-',num2str(nsess),'-Bvalue.mat'],'Bvalue');
            save(['E:\zhang xinyi\fMRI\a_result\RSA_fixation_separate\anatomical_ROI\Similarity\',ROI_name{nROI},'\',num2str(nsub),'-',num2str(nsess),'-Bvalue_z2.mat'],'Bvalue_z2');
            
            disp(length(Bvalue))
            
            %             %remove outlier
            %             A = mean(Bvalue,1);
            %             ht = find(A==max(A));
            %             lt = find(A==min(A));
            %             Bvalue(:,[ht,lt])=[];
            %             save(['E:\zhang xinyi\fMRI\a_result\RSA_fixation_separate\anatomical_ROI\Similarity_new\',ROI_name{nROI},'\',num2str(nsub),'-',num2str(nsess),'-Bvalue.mat'],'Bvalue');
            
            %third, calculate similarity of any two trials
            Similarity = corr(Bvalue);
            Similarity = 0.5 * (log((1+Similarity)./(1-Similarity)));
            save(['E:\zhang xinyi\fMRI\a_result\RSA_fixation_separate\anatomical_ROI\Similarity\',ROI_name{nROI},'\',num2str(nsub),'-',num2str(nsess),'-Similarity.mat'],'Similarity');
            
            Similarity_z2 = corr(Bvalue_z2);
            Similarity_z2 = 0.5 * (log((1+Similarity_z2)./(1-Similarity_z2)));
            save(['E:\zhang xinyi\fMRI\a_result\RSA_fixation_separate\anatomical_ROI\Similarity\',ROI_name{nROI},'\',num2str(nsub),'-',num2str(nsess),'-Similarity_z2.mat'],'Similarity_z2');
        end
    end
end
