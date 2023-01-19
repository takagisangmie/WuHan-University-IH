cover_dir='C:\Users\fuqin\Desktop\pic\cover-100';
stego_dir='C:\Users\fuqin\Desktop\pic\test_zhihu\test3\cover-80';
cover_QF=80;
num=1;
for i=1:1000
    cover_Path=[cover_dir,'\',num2str(i),'.jpg'];
    stego_Path=[stego_dir,'\',num2str(i),'.jpg'];
    imwrite(imread(cover_Path),stego_Path,'quality',cover_QF);
end

