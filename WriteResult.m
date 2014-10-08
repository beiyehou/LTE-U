function [fileName]=WriteResult(create_fileName,plotName,Comment,varargin)
%Datename1,Date1,Datename2,Date2,Datename3,Date3,Datename4,Date4
if create_fileName 
    fileName = ['data/',date,'_',plotName,'.txt'];
else
    fileName = plotName;
end

if nargin>3 && nargin<5
    warning('You must at least input one date!');
elseif nargin<3
    error('Input error: please input variable N and Comment,and at least one Date');
end
if mod(nargin-1,2)~=0
    error('Date must have name and value!');
end
numvariable = nargin-1;
numvariable = ceil((numvariable -2)/2);

% fileName = ['data/',date,'_',plotName,'.txt'];
CommentToFile = ['#','  ',Comment];
fid = fopen(fileName,'a');
if create_fileName
    fprintf(fid,'%s\n',CommentToFile);
end

for i=1:numvariable
    fprintf(fid,'%s\n',varargin{2*i-1});
    tempdata = varargin{2*i};
    tempdata_dim = size(tempdata);
    switch length(tempdata_dim)
        case 2
            if tempdata_dim(1) == 1
                for j=1:tempdata_dim(2)
                    fprintf(fid,'%-15.6f\t',tempdata(1,j));
                end
                fprintf(fid,'\n');
            else
               for j = 1:tempdata_dim(1)
                    fprintf(fid,'%d:\t',j);
                    for k = 1:tempdata_dim(2)
                        fprintf(fid,'%-15.6f\t',tempdata(j,k));
                    end
                    fprintf(fid,'\n');
                end                
            end
            continue;
        case 3
            for j = 1:tempdata_dim(1)
                fprintf(fid,'%d:\t\n',j);
                for k = 1:tempdata_dim(2)
                    fprintf(fid,'%d:\t',k);
                    for l = 1:tempdata_dim(3)
                        fprintf(fid,'%-15.6f\t',tempdata(j,k,l));
                    end
                    fprintf(fid,'\n');
                end
            end
            continue;
        otherwise
                fprintf(fid,'%s','You fool ! Not support dim more than 3!');
    end
end
fclose(fid);