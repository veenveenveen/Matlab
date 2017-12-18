function f=enframe(x,win,inc)
%ENFRAME split signal up into (overlapping) frames: one per row. F=(X,WIN,INC)
%
%	F = ENFRAME(X,LEN) splits the vector X up into
%	frames. Each frame is of length LEN and occupies
%	one row of the output matrix. The last few frames of X
%	will be ignored if its length is not divisible by LEN.
%	It is an error if X is shorter than LEN.
%
%	F = ENFRAME(X,LEN,INC) has frames beginning at increments of INC
%	The centre of frame I is X((I-1)*INC+(LEN+1)/2) for I=1,2,...
%	The number of frames is fix((length(X)-LEN+INC)/INC)
%
%	F = ENFRAME(X,WINDOW) or ENFRAME(X,WINDOW,INC) multiplies
%	each frame by WINDOW(:)

%	Copyright (C) Mike Brookes 1997
%
%      Last modified Tue May 12 13:42:01 1998
%
%   VOICEBOX home page: http://www.ee.ic.ac.uk/hp/staff/dmb/voicebox/voicebox.html
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%   This program is free software; you can redistribute it and/or modify
%   it under the terms of the GNU General Public License as published by
%   the Free Software Foundation; either version 2 of the License, or
%   (at your option) any later version.
%
%   This program is distributed in the hope that it will be useful,
%   but WITHOUT ANY WARRANTY; without even the implied warranty of
%   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
%   GNU General Public License for more details.
%
%   You can obtain a copy of the GNU General Public License from
%   ftp://prep.ai.mit.edu/pub/gnu/COPYING-2.0 or by writing to
%   Free Software Foundation, Inc.,675 Mass Ave, Cambridge, MA 02139, USA.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

nx=length(x);                     %注：统计x的的长度，x为输入信号，win为分帧的长度，inc分帧的点数；
nwin=length(win);                 %注：统计win的的长度；
if (nwin == 1)
   len = win;
else
   len = nwin;
end
if (nargin < 3)                   %注：如果nargin输入的范围小于3就执行下一步；
   inc = len;
end                               %注：上面这三个if相当于加窗，滑动截断过程中，得到一帧一帧的信号；
nf = fix((nx-len+inc)/inc);  %确定帧数
f=zeros(nf,len);                  %注：得出nf x len 阶的全零矩阵，用于存储得到的帧信号；
indf= inc*(0:(nf-1)).';           %注：得出分帧的点数；
inds = (1:len);                   %注：inds取1到len的部分数字； 
f(:) = x(indf(:,ones(1,len))+inds(ones(nf,1),:));    %注：这个函数的作用是？
if (nwin > 1)
    w = win(:)';                  %注：win的全部元素转置赋给w；
    f = f .* w(ones(nf,1),:);     %注：由ones(nf,1）得出全1的矩阵，但是是怎么由这个式子得到分帧的？
end                               %注：这个分帧的算法我没有全部理解，这里的分帧采用一个窗函数对信号进行滑动截断
                                  %注：

