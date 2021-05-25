function RSA_3rd_similarity

clear;


global_path =  'E:\zhang xinyi\fMRI\';
local_path='a_result\RSA_fixation_separate\';
store_path = 'tcontrast\LSS\';
result1_name = 'first sample';
result2_name = 'second sample';
% or 'two sample' 'single sample' 'item2' 'location2' 'item set' 'location
% set'


for nsub = [2:5 7:10 12:17]
    for nsession = 1:2
        output_table=RSA_get_result_table_2nd('RSA_fixation_separate',nsub,nsession);
        location = Get_location(output_table,nsub);
        item_table = Get_item_table(output_table);%item1,item2,itemset,location1,location2,locationset,combination1,combination2,itemtemporalorder,locationtemporalorder
        corr_3d_array = load([global_path, local_path, '3d_martix_for_each\LSS\sub' , num2str(nsub), '_6mm_s',num2str(nsession),'.mat']);
        corr_3d_array = corr_3d_array.corr_3d_array;
        
        count_voxel = length(corr_3d_array);
        beta_1 = zeros(count_voxel,1);
        beta_2 = zeros(count_voxel,1);
        %         beta_3 = zeros(count_voxel,1);
        %         beta_4 = zeros(count_voxel,1);
        %         beta_5 = zeros(count_voxel,1);
        for nvoxel = 1:count_voxel
            %             Sum = 0;
            %             inde = 0;
            R1 = zeros(1,1);
            R2 = zeros(1,1);
            %             R3 = zeros(1,1);
            %             R4 = zeros(1,1);
            %             R5 = zeros(1,1);
            inde1=0;
            inde2=0;
            %             inde3=0;
            %             inde4=0;
            %             inde5=0;
            for row = 1:64
                for col = 1:64
                    if row ~= col
                        if location(row,1)==location(col,1)&&location(row,2)~=location(col,2)&&item_table(row,1)==item_table(col,1)&&item_table(row,2)~=item_table(col,2)
                            inde1 = inde1+1;
                            R1(inde1,1) = corr_3d_array(row,col,nvoxel);
                        end
                        
                        if location(row,2)==location(col,2)&&location(row,1)~=location(col,1)&&item_table(row,2)==item_table(col,2)&&item_table(row,1)~=item_table(col,1)
                            inde2 = inde2+1;
                            R2(inde2,1) = corr_3d_array(row,col,nvoxel);
                        end
                        
                        %                         if output_table{row,3}==output_table{col,3}&&item_table(row,1)~=item_table(col,1)&&item_table(row,2)~=item_table(col,2)&&item_table(row,1)~=item_table(col,2)&&item_table(row,2)~=item_table(col,1)
                        %                             inde3= inde3+1;
                        %                             R3(inde3,1) = corr_3d_array(row,col,nvoxel);
                        %                         end
                        
                        
                    end
                end
            end
            
            %             %%remove outlier
            %             m = mean(Sum);
            %             s = std(Sum);
            %             R1(find(R1(:,1)>m+2*s),:)=[];
            %             R2(find(R2(:,1)>m+2*s),:)=[];
            %             R1(find(R1(:,1)<m-2*s),:)=[];
            %             R2(find(R2(:,1)<m-2*s),:)=[];
            %             R3(find(R3(:,1)>m+2*s),:)=[];
            %             R3(find(R3(:,1)<m-2*s),:)=[];
            %
            beta_1(nvoxel,1)= mean(R1);
            beta_2(nvoxel,1)= mean(R2);
            %             beta_3(nvoxel,1)=mean(R3);
            %             %             beta_4(nvoxel,1)=mean(R4);
            %             %             beta_5(nvoxel,1)=mean(R5);
            disp([num2str(nsub),'-',num2str(nsession),'-',num2str(nvoxel)]);
        end
        
        mkdir([global_path,local_path,store_path,'\Sub',num2str(nsub)]);
        save([global_path,local_path,store_path,'\Sub',num2str(nsub),'\beta_',result1_name,'_6mm_',num2str(nsession),'.mat'],'beta_1');
        save([global_path,local_path,store_path,'\Sub',num2str(nsub),'\beta_',result2_name,'_6mm_',num2str(nsession),'.mat'],'beta_2');
        %         save([global_path,local_path,store_path,'\Sub',num2str(nsub),'\beta_',result3_name,'_6mm_',num2str(nsession),'.mat'],'beta_3');
        %         save([global_path,local_path,store_path,'\Sub',num2str(nsub),'\beta_',result4_name,'_6mm_',num2str(nsession),'.mat'],'beta_4');
        %         save([global_path,local_path,store_path,'\Sub',num2str(nsub),'\beta_',result5_name,'_6mm_',num2str(nsession),'.mat'],'beta_5');
        
        
        %         save([global_path,local_path,store_path,result1_name,'\Sub',num2str(nsub),'\Mean_R3_6mm_',num2str(nsession),'.mat'],'Mean_3');
        disp([num2str(nsub),'-',num2str(nsession)]);
        
        
        %         % step 3: get z value
        %         Z12_matrix = nan(count_voxel,1);
        %         Z23_matrix = nan(count_voxel,1);
        %         Z13_matrix = nan(count_voxel,1);
        %         load([global_path, local_path, '3d_martix_for_each\sub' , num2str(nsub), '_4mm_number_s',num2str(nsession),'.mat']);
        %         for nvoxel = 1:length(count_voxel)
        %             n = sphere_voxel_number(nvoxel,1);
        %             z12 = (Mean_1(nvoxel)-Mean_2(nvoxel))/sqrt(1/(n-3)+1/(n-3));
        %             Z12_matrix(nvoxel,1) = z12;
        %
        %             z23 = (Mean_2(nvoxel)-Mean_3(nvoxel))/sqrt(1/(n-3)+1/(n-3));
        %             Z23_matrix(nvoxel,1) = z23;
        %
        %             z13 = (Mean_1(nvoxel)-Mean_3(nvoxel))/sqrt(1/(n-3)+1/(n-3));
        %             Z13_matrix(nvoxel,1) = z13;
        %         end
        
        % step 4: write into beta head
        output_table=RSA_get_result_table_2nd(nsub,nsession);
        mask_volume = output_table{1,1};
        [d1, d2, d3] = ind2sub(size(mask_volume),find(~isnan(mask_volume)));
        count_voxel = length(d1);
        
        Beta_Z1 = zeros(size(mask_volume));
        Beta_Z2 = zeros(size(mask_volume));
        %         Beta_Z3 = zeros(size(mask_volume));
        %         Beta_Z4 = zeros(size(mask_volume));
        %         Beta_Z5 = zeros(size(mask_volume));
        %         Beta_Z6 = zeros(size(mask_volume));
        %         Beta_Z3 = zeros(size(mask_volume));
        for voxel =  1:count_voxel
            Beta_Z1(d1(voxel),d2(voxel),d3(voxel)) = beta_1(voxel,1);
            Beta_Z2(d1(voxel),d2(voxel),d3(voxel)) = beta_2(voxel,1);
            %             Beta_Z3(d1(voxel),d2(voxel),d3(voxel)) = beta_3(voxel,1);
            %             Beta_Z4(d1(voxel),d2(voxel),d3(voxel)) = beta_4(voxel,1);
            %             Beta_Z5(d1(voxel),d2(voxel),d3(voxel)) = beta_5(voxel,1);
            %             Beta_Z3(d1(voxel),d2(voxel),d3(voxel)) = Mean_3(voxel,1);
        end
        
        if nsession == 1
            beta_ima = spm_vol(['E:\zhang xinyi\fMRI\a_result\Sub',num2str(nsub),'\RSA_fixation_separate_LSS\RSA_fix_',num2str(nsession),'_1\beta_0001.nii']);
            beta_ima.fname=[global_path,local_path,store_path,'\',result1_name,'_6mm_sub',num2str(nsub), '_session',num2str(nsession),'.nii'];
            spm_write_vol(beta_ima,Beta_Z1);
            
            beta_ima = spm_vol(['E:\zhang xinyi\fMRI\a_result\Sub',num2str(nsub),'\RSA_fixation_separate_LSS\RSA_fix_',num2str(nsession),'_1\beta_0001.nii']);
            beta_ima.fname=[global_path,local_path,store_path,'\',result2_name,'_6mm_sub',num2str(nsub), '_session',num2str(nsession),'.nii'];
            spm_write_vol(beta_ima,Beta_Z2);
        else
            beta_ima = spm_vol(['E:\zhang xinyi\fMRI\a_result\Sub',num2str(nsub),'\RSA_fixation_separate_LSS\uncoregistered\RSA_fix_',num2str(nsession),'_1\beta_0001.nii']);
            beta_ima.fname=[global_path,local_path,store_path,'\',result1_name,'_6mm_sub',num2str(nsub), '_session',num2str(nsession),'.nii'];
            spm_write_vol(beta_ima,Beta_Z1);
            
            beta_ima = spm_vol(['E:\zhang xinyi\fMRI\a_result\Sub',num2str(nsub),'\RSA_fixation_separate_LSS\uncoregistered\RSA_fix_',num2str(nsession),'_1\beta_0001.nii']);
            beta_ima.fname=[global_path,local_path,store_path,'\',result2_name,'_6mm_sub',num2str(nsub), '_session',num2str(nsession),'.nii'];
            spm_write_vol(beta_ima,Beta_Z2);
        end
        %
        %         beta_ima = spm_vol(['E:\zhang xinyi\fMRI\a_result\Sub',num2str(nsub),'\RSA_fixation_separate_LSS\RSA_fix_',num2str(nsession),'_1\beta_0001.nii']);
        %         beta_ima.fname=[global_path,local_path,store_path,'\',result3_name,'_6mm_sub',num2str(nsub), '_session',num2str(nsession),'.nii'];
        %         spm_write_vol(beta_ima,Beta_Z3);
        %
        %         beta_ima = spm_vol(['E:\zhang xinyi\fMRI\a_result\Sub',num2str(nsub),'\RSA_item1_separate_LSS\RSA_i1_',num2str(nsession),'_1\beta_0001.nii']);
        %         beta_ima.fname=[global_path,local_path,store_path,'\',result4_name,'_6mm_sub',num2str(nsub), '_session',num2str(nsession),'.nii'];
        %         spm_write_vol(beta_ima,Beta_Z4);
        
        %         beta_ima = spm_vol(['E:\zhang xinyi\fMRI\a_result\Sub',num2str(nsub),'\RSA_fixation_separate_LSS\RSA_de_',num2str(nsession),'_1\beta_0001.nii']);
        %         beta_ima.fname=[global_path,local_path,store_path,'\',result5_name,'_6mm_sub',num2str(nsub), '_session',num2str(nsession),'.nii'];
        %         spm_write_vol(beta_ima,Beta_Z5);
        
        %         beta_ima = spm_vol(['E:\zhang xinyi\a_result\Sub',num2str(nsub),'\RSA_fixation_separate\RSA_fix_1_1\beta_0001.nii']);
        %         beta_ima.fname=[global_path,local_path,store_path,result1_name,'\Z3_6mm_sub',num2str(nsub), '_session',num2str(nsession),'.nii'];
        %         spm_write_vol(beta_ima,Beta_Z3);
    end
end



% step 5: normalize
clc;
spm('defaults','fmri');
spm_jobman('initcfg');
name = {'first sample','second sample'};
for nsub= [2:5 7:10 12:17]
    for nsession=1:2
        for i = 1:2
            %normalise write
            matlabbatch = [];
            matlabbatch{1}.spm.spatial.normalise.write.subj.def = {['E:\zhang xinyi\fMRI\Sub',num2str(nsub),'\t1\y_t1_mprage_sag_iso_mww.nii']};
            matlabbatch{1}.spm.spatial.normalise.write.subj.resample = {[global_path,local_path,store_path,'\',name{i},'_6mm_sub',num2str(nsub),'_session',num2str(nsession),'.nii']};
            matlabbatch{1}.spm.spatial.normalise.write.woptions.bb = [-78 -112 -70
                78 76 85];
            matlabbatch{1}.spm.spatial.normalise.write.woptions.vox = [2 2 2];
            matlabbatch{1}.spm.spatial.normalise.write.woptions.interp = 4;
            matlabbatch{1}.spm.spatial.normalise.write.woptions.prefix = 'w';
            spm_jobman('run',matlabbatch);
            disp([num2str(nsub),'-',num2str(nsession)]);
        end
    end
end

% step avergae

for k = 1:2
    for nsub = [2:5 7:10 12:17]
        beta1 = spm_vol([global_path,local_path,store_path,'\w',name{k},'_6mm_sub',num2str(nsub), '_session1.nii']);
        beta2 = spm_vol([global_path,local_path,store_path,'\w',name{k},'_6mm_sub',num2str(nsub), '_session2.nii']);
        ima1 = spm_read_vols(beta1);
        ima2 = spm_read_vols(beta2);
        ima = (ima1+ima2)./2;
        beta1.fname = [global_path,local_path,store_path,'\w',name{k},'_6mm_sub',num2str(nsub), '.nii'];
        spm_write_vol(beta1,ima);
        
    end
end







