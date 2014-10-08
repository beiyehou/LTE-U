function [fileName] = WriteStruct(create_fileName,plotName,Comment,Struct,varargin)
%  向文件写入 LTE-U 平台 结构体，不通用只适用于 LTE-U 的结构体
%  预先显示 Node id、type 
if create_fileName 
    fileName = ['data/',date,'_',plotName,'.txt'];
    CommentToFile = ['#','  ',Comment];
else
    fileName = plotName;
end

fid = fopen(fileName,'a');
if create_fileName
    fprintf(fid,'%s\n',CommentToFile);
end
fields = {'id','WiFi_LTE'};
fields = [fields varargin];
if nargin >= 4
%     fields = fieldnames(Struct);
    for i=1:length(fields)
        fprintf(fid,'%s\t',char(fields(i)));
    end
    fprintf(fid,'\n');
    for i=1:length(Struct)
        for j=1:length(fields)
            if isequal(fields(j), {'id'})
                    fprintf(fid,'%-2d\t',Struct(1,i).id);
            end
            if isequal(fields(j), {'WiFi_LTE'})
                    if Struct(1,i).WiFi_LTE == true
                        fprintf(fid,'%-5s\t','WiFi');
                    else
                        fprintf(fid,'%-5s\t','LTE');
                    end
            end
            if isequal(fields(j),{'LBT_enable'})
                if Struct(1,i).LBT_enable == true
                    fprintf(fid,'%-5s\t','LBT');
                else
                    fprintf(fid,'%-5s\t','NOLBT');
                end
            end
            if isequal(fields(j),{'UE_id'})
                temp = [Struct(1,i).UE_id];
                if ~isempty(temp)
                    for k=1:length(temp)
                        fprintf(fid,'%-2d\t ',temp(k));
                    end
                end
            end
            if isequal(fields(j),{'packet_bit'})
                fprintf(fid,'%-6d',Struct(1,i).packet_bit);
            end
            if isequal(fields(j),{'total_input'}) || isequal(fields(j),{'total_date'})
                if isequal(fields(j),{'total_input'})
                    temp = [Struct(1,i).total_input];
                else
                    temp = [Struct(1,i).total_date];
                end
                fprintf(fid,'\n');
                if ~isempty(temp)
                    for k=1:length(temp)
                        fprintf(fid,'%-12.0f\t',temp(k));
                    end
                end
            end            
        end
        fprintf(fid,'\n\n');
    end
end
fclose(fid);