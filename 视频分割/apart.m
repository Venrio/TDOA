dataDir = 'D:\ѧϰ\����';
%��һ�������ο�֡
% Create a cascade detector object.
addpath(genpath('.'));
 
infilename='Plant-2200Hz-Mary_MIDI-input.avi';
% Read a video frame and run the detector. 
vidFile = fullfile(dataDir, infilename);
outfilename = [infilename(1:end-4),'_0st.avi'];%����ļ�����
outName = fullfile('D:\ѧϰ\����\����\��Ƶ�ָ�',outfilename);
vid = VideoReader(vidFile);
frame = read(vid,1);
imshow(frame);
h = imrect;
loc = getPosition(h); %��ȡ�ֶ���ѡ�������
delete(h);
fr = round(vid.FrameRate);
len = vid.NumberOfFrames;
%%����ļ�����
vidOut = VideoWriter(outName);
vidOut.FrameRate = 20;
open(vidOut)
videoFileReader = vision.VideoFileReader(vidFile);
videoFrame = step(videoFileReader);
imshow(videoFrame);
%drawnow
%���ѡ������bbox�ĸ������ֱ��Ӧ���ú����Ͻ�������ԭͼ��λ�ã����ú�ͼ���͸�
bbox=[loc(1) loc(2) loc(3) loc(4)];
boxInserter = vision.ShapeInserter ( 'BorderColor','Custom',...
 'CustomBorderColor',[255 0 0],'LineWidth',3);
videoOut_chest = step(boxInserter, videoFrame,bbox);
%videoOut_chest = step(boxInserter, videoOut_chest,bbox_right);
figure(1),imshow(videoOut_chest,'border','tight');title('Detected image');
% ����ü������ͼ��
%imwrite(faceImage, 'image_1.jpg'); % ���ü���ͼ�񱣴�Ϊ JPEG �ļ�
%%��һ֡ͼ��ü�
faceImage = imcrop(videoFrame,bbox);
% ? ?axes(handles.axes4);
imshow(faceImage);
drawnow
writeVideo(vidOut,im2uint8(faceImage));
h=waitbar(0,'��ʼ���...','Name','���ڸ���...');
%�ڶ������ü�����֡
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
