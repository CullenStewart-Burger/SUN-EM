function [ortho_modes] = parseFEKOoutfileMaxModes(Const)
    %parseFEKOoutfileMaxModes v1.0
    %   Date: 16.05.2014
    %   Usage:
    %       [ortho_modes] = parseFEKOoutfileMaxModes(Const)
    %
    %   Input Arguments:
    %       Const: A global struct containing:
    %       FEKOoutfilename
    %           FEKO *.out filename (e.g. 'yagi.out')
    %
    %   Output Arguments:
    %       ortho_modes:
    %           The struct containing the R and X orthogonal mode data
    %
    %   Description:
    %       Reads in a FEKO *.out file which contains for the CMA
    %       the number of (R and X-) orthogonal modes.
    %
    %   =======================
    %   Written by Danie Ludick on May 16, 2014
    %   Last updated on May 16, 2014
    %   EM Systems & Software (Pty) Ltd.
    %   Email: dludick.emss.co.za

    %   Please note that additional information on reading the *.out files using FEKO can be found 
    %   on the FEKO website:
    %   http://www.feko.info/
    
    error(nargchk(1,1,nargin));

    fid = fopen(Const.FEKOoutfilename,'r');

    if fid == -1
        message(Const,sprintf('Error reading FEKO *.out file: %s',Const.FEKOoutfilename));
        error(['Error reading FEKO *.out file: %s' Const.FEKOoutfilename]);
    end

    message(Const,sprintf('Reading mode orthogonality data from *.out file: %s',Const.FEKOoutfilename) )
    
    end_flag = 0;
    ortho_modes.sample = [];
    freq_num = 0;
    while end_flag == 0
        line=fgetl(fid);
        
        % Check for end of file:
        if strcmp(line,'                    SUMMARY OF REQUIRED TIMES IN SECONDS');
            end_flag = 1;
        end%if
        
        % Extract the number of orthogonal modes from the *.out file
        g = strfind(line,'Number of orthogonal eigenmodes');        
        if g > 0
            freq_num = freq_num + 1;
            ortho_modes.sample(freq_num) = str2num(line(36:46));
        end%if
    end%while end_flag == 0
    fclose('all');
    
    ortho_modes.freq_num = freq_num;
    
    message(Const,sprintf('Read orthogonal mode quantities for: %d frequencies',freq_num));
    message(Const,sprintf('Finished processing the *.out file: %s',Const.FEKOoutfilename));
