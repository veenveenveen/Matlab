function splash(filename,varargin)
%SPLASH(FILENAME,FMT,TIME) creats a splash screen using image from the
%   file specified by the string FILENAME, where the string FMT specifies
%   the format of the file, and TIME is the duration time of the splash 
%   screen in milisecond. If the file is not in the current directory or in a
%   directory in the MATLAB path,specify the full pathname of the location 
%   on your system.  If SPLASH cannot find a file named FILENAME, it looks
%   for a file named FILENAME.FMT.
% 
%   Supported file types ---- formats supported by the imread function
%   --------------------
%   JPEG  Any baseline JPEG image; JPEG images with some
%         commonly used extensions; 8-bit and 12-bit lossy
%         compressed RGB and grayscale images; 8-bit and 12-bit
%         lossless compressed RGB images; 8-bit, 12-bit, and
%         16-bit lossless compressed grayscale images
%
%   TIFF  Any baseline TIFF image, including 1-bit, 8-bit, and
%         24-bit uncompressed images; 1-bit, 8-bit, and 24-bit
%         images with packbits compression; 1-bit images with
%         CCITT compression; 16-bit grayscale, 16-bit indexed, 
%         and 48-bit RGB images; 24-bit and 48-bit ICCLAB
%         and CIELAB images; 32-bit and 64-bit CMYK images; and
%         8-bit tiled TIFF images with any compression and colorspace
%         combination listed above.
%
%   GIF   Any 1-bit to 8-bit GIF image
%
%   BMP   1-bit, 4-bit, 8-bit, 16-bit, 24-bit, and 32-bit uncompressed
%         images; 4-bit and 8-bit run-length encoded (RLE) images
%
%   PNG   Any PNG image, including 1-bit, 2-bit, 4-bit, 8-bit,
%         and 16-bit grayscale images; 8-bit and 16-bit
%         indexed images; 24-bit and 48-bit RGB images
%
%   HDF   8-bit raster image datasets, with or without an
%         associated colormap; 24-bit raster image datasets
%
%   PCX   1-bit, 8-bit, and 24-bit images
%
%   XWD   1-bit and 8-bit ZPixmaps; XYBitmaps; 1-bit XYPixmaps
%
%   ICO   1-bit, 4-bit, and 8-bit uncompressed images
%
%   CUR   1-bit, 4-bit, and 8-bit uncompressed images
%
%   RAS   Any RAS image, including 1-bit bitmap, 8-bit indexed,
%         24-bit truecolor and 32-bit truecolor with alpha.
%
%   PBM   Any 1-bit PBM image.  Raw (binary) or ASCII (plain) encoded.
%
%   PGM   Any standard PGM image.  ASCII (plain) encoded with
%         arbitrary color depth.  Raw (binary) encoded with up
%         to 16 bits per gray value.
%
%   PPM   Any standard PPM image.  ASCII (plain) encoded with
%         arbitrary color depth. Raw (binary) encoded with up
%         to 16 bits per color component.
%
%   See also IMFINFO, IMWRITE, IMFORMATS, FREAD, IMAGE, DOUBLE, UINT8.
% 
%   Example 
%           splash('C:\MATLAB7\toolbox\matlab\demos\html\wernerboy_01','png',3);
%       or  splash('C:\MATLAB7\toolbox\matlab\demos\html\wernerboy_01.png',3); 
%       or  splash('C:\MATLAB7\toolbox\matlab\demos\html\wernerboy_01.png');
 
%   Note     
%     Java requires uint8 data to create an instance of the Java image class,
%     java.awt.Image. If the input image is of class uint8, jimage contains 
%     the same uint8 data. If the input image is of class double or uint16, 
%     im2java makes an equivalent image of class uint8, rescaling or offsetting
%     the data as necessary, and then converts this uint8 representation to an 
%     instance of the Java image class, java.awt.Image. So some image formats may
%     appear different form the source image in the splash screen created by SPLASH.
%     To reduce the distortion, the following image formats are recommend: JPEG,PNG,
%     BMP,TIFF,PCX,ICO.

%   Han Qun, Sept. 2004
%   Copyright 2004-2005 Han Qun 
%   College of Precision Instrument and Opto-Electronics Engineering,
%   Tianjin University, 300072, P.R.China. 
%   Email: junziyang@126.com 

if nargin ==1  % filename with format, defualt duration time 3000 miliseconds
    I = imread(filename);
    time = 3000;
elseif (nargin == 2)&(ischar(varargin{1})) % filename without format, defualt duration time
    fmt = varargin{1};
    I = imread(filename,fmt);
    time = 3000;
elseif (nargin == 2)&(isnumeric(varargin{1})) %filename with format, user specified duration time
    I = imread(filename);
    time = varargin{1};
elseif nargin == 3 % filename without format, user specified duration time
    fmt = varargin{1};
    I = imread(filename,fmt);
    time = varargin{2};
    if (~isnumeric(time))| (length(time)~=1)
        error('INPUT ERROR: TIME must be a numeric number in seconds');    
    end
else
    error('INPUT ERROR: Too many imput arguments!');
end        
splashImage = im2java(I);
win = javax.swing.JWindow;
icon = javax.swing.ImageIcon(splashImage);
label = javax.swing.JLabel(icon);
win.getContentPane.add(label);

% get the actual screen size
screenSize = win.getToolkit.getScreenSize;
screenHeight = screenSize.height;
screenWidth = screenSize.width;
% get the actual splashImage size
imgHeight = icon.getIconHeight;
imgWidth = icon.getIconWidth;
% set the splash image to the center of the screen
win.setLocation((screenWidth-imgWidth)/2,(screenHeight-imgHeight)/2);
win.pack
win.show % show the splash screen

% controling the duration time
tic;
while toc < time/1000
end

win.dispose()   % close the splash screen