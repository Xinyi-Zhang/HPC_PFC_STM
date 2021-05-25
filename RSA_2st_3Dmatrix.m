function RSA_2st_3Dmatrix
% step1
% save to 3d matrix,  2d correlation matrix, 3d means voxel.
% generate a sphere for each voxel, calculate the correlation of any two trials within
% each sphere
% related tools  RSA_get_result_table_2nd
clear;
global_path =  'E:\zhang xinyi\fMRI\';
local_path='a_result\RSA_fixation_separate\3d_martix_for_each\LSS\';
mkdir([global_path,local_path]);
for nsub = [2:5 7:10 12:17]
    for nsession=1:2
    output_table=RSA_get_result_table_2nd(nsub,nsession);  % create_volumn_table_each_session_mdf_fsl   create_volumn_table_each_session_walking_fsl
    count_trialtype =  length(output_table(:,1));% output_table���������Դ�����
    %  count_trialtype=64;
    spherec_coordinate = sphericalRelativeRoi(6,[2 2 2]);%������Ȼ��֪���⼸��������ɶ��˼
    mask_brain = output_table{1,1};
    [fir_di, sec_di, thi_di] = size(mask_brain);%��ά����
    [d1, d2, d3] = ind2sub([fir_di, sec_di, thi_di],find(~isnan(mask_brain)));%�ҵ���Ϊ0��voxel���±�
    voxel_array = [d1, d2, d3];
    count_voxel = length(voxel_array);%��Ϊ0��voxel��������lengthȡ��������ά���������Ǹ�
    corr_3d_array = nan(count_trialtype, count_trialtype, count_voxel);%�����������Ǹ�3d����
    sphere_voxel_number = nan(count_voxel,1);
    
    %ÿ��voxel��ÿ���Դε�beta����������64��beta�����
    
    for voxel_index = 1:count_voxel %����ÿһ��voxel
        spherec = repmat(voxel_array(voxel_index,:), size(spherec_coordinate,1), 1) + spherec_coordinate;%�����Ǹ��������Ǳ߽�Ĵ��������仰����ֱ�ӳ�
        [row_ind, col_ind] = find(spherec(:,1) < 1 | spherec(:,2) < 1 | spherec(:,3) < 1 | spherec(:,1)>fir_di | spherec(:,2)>sec_di | spherec(:,3)>thi_di);
        spherec (row_ind, :) = [];
        eachspherec_by_trial = nan(length(spherec(:,1)), count_trialtype);
       
        
        for trialtype_th = 1:count_trialtype %��ÿ���Դε�beta
            ima = output_table{trialtype_th,1};
            for ith = 1:length(spherec(:,1))
                eachspherec_by_trial(ith, trialtype_th) = ima(spherec(ith,1), spherec(ith,2), spherec(ith,3));%64���Դε���һά��֮�����һ����������
            end
        end
        eachspherec_by_trial(find(isnan(eachspherec_by_trial(:,1)) | eachspherec_by_trial(:,1)==0),:)=[];
        if(isempty(eachspherec_by_trial) || length(eachspherec_by_trial(:,1))<5)
            corr_3d_array(:,:,voxel_index) = nan(count_trialtype, count_trialtype);
        else
            [rho,pval] = corr(eachspherec_by_trial, 'Type','Pearson');
            t_rho = 0.5 * (log((1+rho)./(1-rho)));%���ת���ǲ���Ϊ�˷Ŵ�rho�ı仯����ֱ����rho���beta��С��
            
            corr_3d_array(:,:,voxel_index) = t_rho;
           
        end
        
         sphere_voxel_number(voxel_index,1) = length(spherec(:,1));
        disp( ['corr_matrix -- sub-',num2str(nsub),'-session-',num2str(nsession), '-voxel-',num2str(voxel_index)]);
    end
    save([global_path, local_path, 'sub' , num2str(nsub), '_6mm_s',num2str(nsession),'.mat'], 'corr_3d_array','-v7.3');
    save([global_path, local_path, 'sub' , num2str(nsub), '_6mm_number_s',num2str(nsession),'.mat'], 'sphere_voxel_number');
    clear output_table;
    clear mask_brain;
    clear corr_3d_array;
    end
end








