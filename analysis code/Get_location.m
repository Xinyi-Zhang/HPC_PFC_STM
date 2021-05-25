function location = Get_location(output_table,nsub)
location = zeros(64,1);
VerOrHor=mod(nsub,8);
if (0 < VerOrHor) &&(VerOrHor<5)
    for i=1:64
        if output_table{i,3}==1
            if output_table{i,5}== output_table{i,4}
                location(i,1)=1;
                location(i,2)=2;
            else
                location(i,1)=2;
                location(i,2)=1;
            end
        elseif output_table{i,3}==2
            if output_table{i,5}== output_table{i,4}
                location(i,1)=3;
                location(i,2)=4;
            else
                location(i,1)=4;
                location(i,2)=3;
            end
        elseif output_table{i,3}==3
            if output_table{i,5}== output_table{i,4}
                location(i,1)=1;
                location(i,2)=4;
            else
                location(i,1)=4;
                location(i,2)=1;
            end
        elseif output_table{i,3}==4
            if output_table{i,5}== output_table{i,4}
                location(i,1)=3;
                location(i,2)=2;
            else
                location(i,1)=2;
                location(i,2)=3;
            end
        end
    end
else
    for i=1:64
        if output_table{i,3}== 1
            if output_table{i,5}== output_table{i,4}
                location(i,1)= 1;
                location(i,2)= 3;
            else
                location(i,1)= 3;
                location(i,2)= 1;
            end
        elseif output_table{i,3}== 2
            if output_table{i,5}== output_table{i,4}
                location(i,1)= 2;
                location(i,2)= 4;
            else
                location(i,1)= 4;
                location(i,2)= 2;
            end
        elseif output_table{i,3}== 3
            if output_table{i,5}== output_table{i,4}
                location(i,1)= 1;
                location(i,2)= 4;
            else
                location(i,1)= 4;
                location(i,2)= 1;
            end
        elseif output_table{i,3}== 4
            if output_table{i,5}== output_table{i,4}
                location(i,1)= 3;
                location(i,2)= 2;
            else
                location(i,1)= 2;
                location(i,2)= 3;
            end
        end
    end
end
