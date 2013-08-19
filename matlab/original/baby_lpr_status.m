function baby_lpr_status(headerflag,varargin)
% BABY_LPR_STATUS

inistr = ''; %\t';
sepstr = '   ';

if headerflag==1
    header = 1;
    args = varargin(1:2:end);
    
    maxlen = 0;
    for idx=1:length(args)
        maxlen = max(maxlen,length(args{idx}));
    end
    
    for idx=1:length(args)
        args{idx} = sprintf([' %' num2str(maxlen) 's '],args{idx});
    end
    maxlen = maxlen+2;
    
    for x=1:maxlen
        fprintf(inistr);    
        for idx=1:length(args)
            fprintf(['%s' sepstr],args{idx}(x));    
        end
        fprintf('\n');
    end
end

args = varargin(2:2:end);

for idx = 1:length(args)
    arg = args{idx};
    if islogical(arg)
        if arg==true
            fprintf(['+' sepstr]);
        else
            fprintf([' ' sepstr]);
        end
    elseif isstr(arg)
        fprintf(['%1s' sepstr],arg);
    elseif isnumeric(arg)
        fprintf(['%1i' sepstr],arg);        
    end
    
end

fprintf('\n');
