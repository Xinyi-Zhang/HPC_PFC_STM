function item_table = Get_item_table(output_table)
item_table=zeros(64,2);
for i=1:64
    if output_table{i,2}==1
        if output_table{i,5}==1
            item_table(i,1)=5;
            item_table(i,2)=9;
        else
            item_table(i,1)=9;
            item_table(i,2)=5;
        end
    elseif output_table{i,2}==2
        if output_table{i,5}==1
            item_table(i,1)=9;
            item_table(i,2)=13;
        else
            item_table(i,1)=13;
            item_table(i,2)=9;
        end
    elseif output_table{i,2}==3
        if output_table{i,5}==1
            item_table(i,1)=13;
            item_table(i,2)=7;
        else
            item_table(i,1)=7;
            item_table(i,2)=13;
        end
    elseif output_table{i,2}==4
        if output_table{i,5}==1
            item_table(i,1)=7;
            item_table(i,2)=5;
        else
            item_table(i,1)=5;
            item_table(i,2)=7;
        end
    end
end
