dataDir = 'D:\学习\毕设';
%第一步：检测参考帧
% Create a cascade detector object.
addpath(genpath('.'));
 
infilename='Plant-2200Hz-Mary_MIDI-input.avi';
% Read a video frame and run the detector. 
vidFile = fullfile(dataDir, infilename);
outfilename = [infilename(1:end-4),'_0st.avi'];%输出文件名字
outName = fullfile('D:\学习\毕设\代码\视频分割',outfilename);
vid = VideoReader(vidFile);
frame = read(vid,1);
imshow(frame);
h = imrect;
loc = getPosition(h); %获取手动标选框的坐标
delete(h);
fr = round(vid.FrameRate);
len = vid.NumberOfFrames;
%%输出文件创建
vidOut = VideoWriter(outName);
vidOut.FrameRate = 20;
open(vidOut)
videoFileReader = vision.VideoFileReader(vidFile);
videoFrame = step(videoFileReader);
imshow(videoFrame);
%drawnow
%标记选择区域，bbox四个参数分别对应剪裁后左上角像素在原图像位置，剪裁后图像宽和高
bbox=[loc(1) loc(2) loc(3) loc(4)];
boxInserter = vision.ShapeInserter ( 'BorderColor','Custom',...
 'CustomBorderColor',[255 0 0],'LineWidth',3);
videoOut_chest = step(boxInserter, videoFrame,bbox);
%videoOut_chest = step(boxInserter, videoOut_chest,bbox_right);
figure(1),imshow(videoOut_chest,'border','tight');title('Detected image');
% 保存裁剪区域的图像
%imwrite(faceImage, 'image_1.jpg'); % 将裁剪的图像保存为 JPEG 文件
%%第一帧图像裁剪
faceImage = imcrop(videoFrame,bbox);
% ? ?axes(handles.axes4);
imshow(faceImage);
drawnow
writeVideo(vidOut,im2uint8(faceImage));
h=waitbar(0,'开始检测...','Name','正在跟踪...');
%第二步：裁剪其他帧
n=1;
% Track the bbox over successive video frames until the video is finished.
while ~isDone(videoFileReader)
n=n+1;
% Extract the next video frame
 videoFrame = step(videoFileReader);
 % Insert a bounding box around the object being tracked
 % videoOut = step(boxInserter, videoFrame, bbox);
 faceImage = imcrop(videoFrame,bbox);
% Display the annotated video frame using the video player object
 % step(videoPlayer, faceImage);
 writeVideo(vidOut,im2uint8(faceImage));
h=waitbar(0.05+n*(0.85/len),h,[num2str(floor(100*(0.05+n*(0.85/len)))),'%']);
end
% Release resources
close(vidOut);
h=waitbar(0.9,h,[num2str(90),'%']);
release(videoFileReader);
h=waitbar(1,h,[num2str(1),'%']);
clear vid;
close(h)
%axes(handles.axes3);
cla
%axes(handles.axes4);
  cla
drawnow
