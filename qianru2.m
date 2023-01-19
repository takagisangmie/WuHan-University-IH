function qianru2(cover_dir,stego_dir,payload,cover_QF,attack_QF)
% 
afterchannel_stego_dir = [stego_dir,'_attackBy',num2str(attack_QF)]; if ~exist(afterchannel_stego_dir,'dir'); mkdir(afterchannel_stego_dir); end  %信道处理后载密图像所在文件夹
cover_num = 9; %number of test images

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
for i_img = 1:cover_num
    % image address
    cover_Path = fullfile([cover_dir,'\',num2str(i_img),'.jpg']);
    fprintf('%s\n',cover_Path);
    stego_Path = fullfile([stego_dir,'\',num2str(i_img),'.jpg']);
    
    fprintf('%s\n',stego_Path);
    afterchannel_stego_Path = fullfile([afterchannel_stego_dir,'\',num2str(i_img),'.jpg']);
    %% stegaongraphy
    stego_step = ones(8,8); % 
    % pre-process

    [cover,rhoM,rhoP,wetratei] = preprocessQIM(cover_Path,stego_step,cover_QF,attack_QF,spatail);
    % message
    [msg,msg_len] = generateRandMsg(cover_Path,payload);
    %[msg,msg_len] = generateRandMsg(cover_Path,payload);
     
%     [msg,msg_len]=fread(msg_id,'ubit1');
%     msg2=zeros(1,msg_len);
%     for i=1:msg_len
%         msg2(1,i)=msg(i,1);
%     end
    
    msg_dir = [cover_dir,'\','data',num2str(i_img)];
    msg_id=fopen( msg_dir, 'w');
    for i = 1:msg_len
        fwrite(msg_id, msg(i), 'ubit1');
    end
    fclose(msg_id);
    % STC embedding
    % cover
    cover1 = int32(reshape(cover,1,[]));
    % distortion
    costs = zeros(3,size(cover1,2),'single');
    costs(1,:) = reshape(rhoM,1,[]);
    costs(3,:) = reshape(rhoP,1,[]);
    % embed message   
    H = 10;

    [~, stc_msg,stc_n_msg_bits,~] = stc_pm1_pls_embed(int32(cover1), costs, uint8(msg), H);

    stc_extract_msg2 = stc_ml_extract(int32(stc_msg), stc_n_msg_bits, H); % extract message
    stego = reshape(stc_msg,size(cover,1),size(cover,2));
    fprintf('stc_n_msg_bits=%d\n',stc_n_msg_bits);
    fprintf('wetratei=%f\n',wetratei);
    % generate final embedded image
    generateStegoQMAS(cover_Path,stego_Path,cover,stego,stego_step,cover_QF,attack_QF);
end
