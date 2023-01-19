function tiqu2(cover_dir,stego_dir,payload,cover_QF,attack_QF,num_const,stc_msg_bits)
% 

afterchannel_stego_dir = [stego_dir,'_attackBy',num2str(attack_QF)]; if ~exist(afterchannel_stego_dir,'dir'); mkdir(afterchannel_stego_dir); end  %信道处理后载密图像所在文件夹
cover_num = num_const; %number of test images

% cumpute DCT coefficients to spatial
dct0 = zeros(8,8);
spatail = zeros(8,8,64);
for i = 1 : 8
    for j = 1 : 8
        dct = dct0;
        dct(i,j) = dct(i,j) + 1;
        fun = @(x) dct2(x.data);
        spatail(:,:,j+(i-1)*8) = blockproc(double(dct.*quantizationTable(cover_QF)),[8 8],fun);
    end
end

% poolnum = str2double(getenv('SLURM_CPUS_PER_TASK'));
% parpool(poolnum);
for i_img = num_const:cover_num
    % image address
    cover_Path = fullfile([cover_dir,'\',num2str(i_img),'.jpg']);
    stego_Path = fullfile([stego_dir,'\',num2str(i_img),'.jpg']);
    afterchannel_stego_Path = fullfile([afterchannel_stego_dir,'\',num2str(i_img),'.jpg']);
    %% stegaongraphy
    stego_step = ones(8,8); % 
    
    % pre-process
    msg_dir = [cover_dir,'\','data',num2str(i_img)];
    msg_id=fopen( msg_dir, 'r');
    [msg,msg_len]=fread(msg_id,'ubit1');
    msg2=zeros(1,msg_len);
    for i=1:msg_len
        msg2(1,i)=msg(i,1);
    end
    try

    

    %%  extract message
    [stc_decoded_msg] = stcExtractQMAS(afterchannel_stego_Path,stc_msg_bits, cover_QF, stego_step,attack_QF);
    %%  cumpute error rate
    if length(stc_decoded_msg)<msg_len
        for i=(length(stc_decoded_msg)+1):msg_len
            stc_decoded_msg(i)=0;
        end
    end
    bit_error = double(msg2) - double(stc_decoded_msg);
    bit_error_number = sum(abs(bit_error));
    bit_error_rate(1,i_img) = bit_error_number/msg_len;
    %wet_rate(1,i_img) = wetratei;
%      output error rate
%     fprintf('%s\n',['payload: ',num2str(payload),'  image_number: ',num2str(i_img),'  error_rate: ',num2str(bit_error_rate(1,i_img)),'  wet_rate:',num2str(wet_rate(1,i_img))]);
    catch
        bit_error_rate(1,i_img) = 0;
        fprintf('%s\n',['error at  image_number: ',num2str(i_img),', stc extracted wrong msg ']);
    end
end
%     poolobj = gcp('nocreate');
%         delete(poolobj);
%%  output error rate
ave_error_rate = mean(bit_error_rate);
ave_error_rate1 = nnz(bit_error_rate)/numel(bit_error_rate);
fprintf('%s\n',['payload: ',num2str(payload),'  ave_error_rate: ',num2str(ave_error_rate),'  ave_0error_rate: ',num2str(ave_error_rate1)]);
%ave_wet_rate = mean(wet_rate);
%ave_wet_rate1 = mean(wet_rate(bit_error_rate==0));
%ave_wet_rate2 = mean(wet_rate(bit_error_rate~=0));
%fprintf('%s\n',['ave_wet_rate: ',num2str(ave_wet_rate),'  0_wet_rate: ',num2str(ave_wet_rate1),'  n0_wet_rate: ',num2str(ave_wet_rate2)]);
