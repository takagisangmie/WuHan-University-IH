% 本示例程序将 C:\Users\kitty\test\目录下面所有的 pgm 图片转换为 jpg 图片 
% 如果仅对一张 pgm 图片作格式转换，请直接看 核心代码 部分。
function [  ] = pgm2jpg(  )

 % 读取指定目录下面所有的 pgm 格式图片
 pgms = dir('D:\paper\IH\pgm\*.pgm');
 num_pgms = length( pgms );
 for i = 1 : num_pgms
   pgm_file = fullfile( 'D:\paper\IH\pgm\' , pgms(i).name );
   pgm      = imread( pgm_file );
   
   %%% 核心代码：将 pgm_file 转换为 jpg 格式图片，并保存. %%%

  % 第一步，解析文件名 pgm_file ,注意，pgm_file 包括路径+文件名+后缀，如 pgm_file = 'C:\Users\kitty\test\test.pgm'
   % path = 'C:\Users\kitty\test'  name = 'test' ext = '.pgm'
   [ path , name , ext ] = fileparts( pgm_file ) ;

  % 第二步，生成新的文件名
   filename = strcat( name , '.jpg' );

  % 第三步，生成文件全称
   jpg_file = fullfile( 'D:\paper\IH\jpg\' , filename ) ;

  % 第四步，将 pgm 以 jpg_file 作为文件名，保存为 jpg 格式.
  imwrite( pgm , jpg_file , 'jpg','Quality',70 );

 end

end
