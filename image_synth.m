function [opimage] = image_synth(img1,img2)
%%%%%
%%%minesh
%%% minesh.mathew@gmail.com
%%%%
%%%%
%%%%



rws=size(img2,1);%no of rows in the 2nd image
cols=size(img2,2);%no of columns in the 2nd image

%where to keep image 1 in image2; the input is the point where the top left
%crner of img1 should be placed on image2
imagesc(img2);
axis image;
indicative=zeros(size(img2,1),size(img2,2));
%msgbox(['Click on the image where you want to place the first images top left corner and hit enter' ]);
point=ginput();

disp(point);

%getting exact pixel values
posx=round(point(1)); %postion along the x axis or how many columns from the origin
posy=round(point(2));%how many rows from the origin
disp(posx);
disp(posy);




if((posx+size(img1,2) > cols) || (posy+size(img1,1)> rws))
    disp('image 1 wont fit on image 2 if it is placed at the given position');
    return
end
%in the first iamge select  aregion whcih you insist to come from that
%image only



%in the rectangular matrix the area covered by img1 over img2 is marked by
%a new indcaiteve value=255 , white color in the indicative image
for i=posy:posy+size(img1,1)-1 %row by row
    for j=posx:posx+size(img1,2)-1 %column by column
        indicative(i,j)=255;
    end
end






imagesc(img1);
axis image;
%msgbox(['draw a recatnglualr region that must appear in the final output' ]);
rect=getrect();
%close(h2);


disp(rect);

%gettig exact pixel values
xmin=round(rect(1));
ymin=round(rect(2));
width=round(rect(3));
height=round(rect(4));


%in the iundicative matrix the rectangular portion is identified by a new
%indicative value =128  that is grey color ; so pixels comulsairly from
%image1 will be idetified by a value=128; view the indicativee matrix as an image for
%bteer understanding
for i=(posy+ymin):(posy+ymin+height-1) %row by row
    for j=(posx+xmin):(posx+xmin+width-1) %column by column
        %disp('eneterd');
        indicative(i,j)=128;
    end
end
%imshow(indicative);



%our graph will have number of vertices = no of pixels
%=size(img2,1)*size(img2,2) ie no fo pixels in the img2 ie the image on
%which the other image is aligned

%so the adjacency matrix will be a square matrix with dimension as
%nofpixels*nof pixels

%to store pixels as node, pixels are taken in column major oreder



A=sparse(rws*cols,rws*cols);
T=sparse(rws*cols,2);

%Now we need a matrix to save weights to the terminal nodes S and T
% so for that we need a matrix of dimension no.of pixels *2 
%because we have only two labels S or T 

border_img2=0;
border_img1=0;

img1_comp=0;
img2_comp=0;

img1_new=img1;%making copies of the two images
img2_new=img2;
img1=rgb2gray(img1);
img2=rgb2gray(img2);
img1=double(img1);%for calcuations double values are required
img2=double(img2);

for i=1:cols %traverse column by column
    for j=1:rws %in a column traverse row by row
        
         %%%%%FILLING THE T Matrix
        
        if(indicative(j,i)==0) %if the pixel is compulsairly from img2
             img2_comp=img2_comp+1;
            %disp('compulsary frm img2');
            T((i-1)*rws+j,1)=100000; %weight set for connection to label1
            
        end
        if(indicative(j,i)==128) %if pixel is compulsairly from img1
            
            img1_comp=img1_comp+1;
            T((i-1)*rws+j,2)=100000;%weight set for conncetion to label 2
            %disp('compulsary frm img1');
        end  
        if(indicative(j,i)==255)%if its a pixel in the overlap region
%                   Asr=img2(j,i,1);%red value of node in focus if color is from img2
%                   Asg=img2(j,i,2);
%                   Asb=img2(j,i,3);
%                   
%                   Bsr=img1(((j-posy)+1),((i-posx)+1),1); %red value of node in focus if color is frm img1
%                   Bsg=img1(((j-posy)+1),((i-posx)+1),2);
%                   Bsb=img1(((j-posy)+1),((i-posx)+1),3);
                  
                  
                  
                  
%                   disp('colors are');
%                   disp(Asr);
%                   disp(Asg);
%                   disp(Asb);
%                   disp(Bsr);
%                   disp(Bsg);
%                   disp(Bsb);
%                   
%                   
%                   
%                    disp('diff are');
%                   
%                   
%                   
%                   
%                   disp(Asr-Bsr);
%                       disp(Asg-Bsg);
%                       disp(Asb-Bsb);
%                   
%                   disp('powers are');
%                   
%                   
%                   
%                   
%                   disp((Asr-Bsr)^2);
%                       disp((Asg-Bsg)^2);
%                       disp((Asb-Bsb)^2);

%                 As_grey=(Asr+Asg+Asb)/3;
%                 Bs_grey=(Bsr+Bsg+Bsb)/3;
                  
                %  Snorm= ((Asr-Bsr)^2+(Asg-Bsg)^2+(Asb-Bsb)^2)^(1/2);
                  Snorm= abs (img2(j,i) - img1(((j-posy)+1),((i-posx)+1)));
                  
                 if (( (j+1) > 0) && ((j+1) <= rws))%pixel below %( indicative(j+1,i)==255)
             %above if checks if there is a pixel below the current pixel     
                  if ( indicative(j+1,i)==0)%if pixel below is compulsairly from img2,then it is a border pixel in the overlap region
                      %and so it is connected to img2 node with infinte
                      %weight
                      %disp('new');
                     T((i-1)*rws+j,1)=100000; 
                     border_img2=border_img2+1;%for counting the nof pixles bordering with img2
                  end
                  
                  if ( indicative(j+1,i)==128)
                       
                      %disp('new');
                       border_img1=border_img1+1;
                      T((i-1)*rws+j,2)=100000; 
                  end
                     
                     
                     if( (indicative(j+1,i)==255))% if the pixel  below is also in the overlaping region
                         % (1,2) and 2,1 cas ein adj matrix
                         % A((i-1)*rws+(j+1),(i-1)*rws+j) == 0 && 
                  %disp('below');
                
%                  
%                       Atr=img2(j+1,i,1);
%                       Atg=img2(j+1,i,2);
%                       Atb=img2(j+1,i,3);
% 
%                       Btr=img1(((j+1)-posy)+1,(i-posx)+1,1);
%                       Btg=img1(((j+1)-posy)+1,(i-posx)+1,2);
%                       Btb=img1(((j+1)-posy)+1,(i-posx)+1,3);
                      
                      
                     
                      

                   % Tnorm= ((Atr-Btr)^2+(Atg-Btg)^2+(Atb-Btb)^2)^(1/2);
                    Tnorm=abs(img2(j+1,i)-img1(((j+1)-posy)+1,(i-posx)+1));
                   A((i-1)*rws+j,(i-1)*rws+(j+1))=Snorm+Tnorm;
                   
%                     At_grey=(Atr+Atg+Atb)/3;
%                       Bt_grey=(Btr+Btg+Btb)/3;
%                       A((i-1)*rws+j,(i-1)*rws+(j+1))=(As_grey-Bs_grey)+(At_grey-Bt_grey);
                      
                   end
                  
                 end
                 
                 if (( (j-1) > 0) && ((j-1) <= rws))%pixel above % &&( indicative(j-1,i)==255)
         %if the above pixel is within limits of the image            
                     if  (indicative(j-1,i)==0)%if the pixel above is compulsairly frm image 2
                   %       disp('new');
                        T((i-1)*rws+j,1)=100000; 
                        border_img2=border_img2+1;
                     end
                     
                      if  (indicative(j-1,i)==128) %if compusairly frm img1 
                    %       disp('new');
                        T((i-1)*rws+j,2)=100000; 
                         border_img1=border_img1+1;
                     end
                         
                     if( ( indicative(j-1,i)==255))
                     %A((i-1)*rws+(j+1),(i-1)*rws+j)==0 &&
                     %disp('above');
                     % A((i-1)*rws+j,(i-1)*rws+(j-1))= equation;
%                       Atr=img2(j-1,i,1);
%                       Atg=img2(j-1,i,2);
%                       Atb=img2(j-1,i,3);
% 
%                       Btr=img1(((j-1)-posy)+1,(i-posx)+1,1);
%                       Btg=img1(((j-1)-posy)+1,(i-posx)+1,2);
%                       Btb=img1(((j-1)-posy)+1,(i-posx)+1,3);
                     % Tnorm= ((Atr-Btr)^2+(Atg-Btg)^2+(Atb-Btb)^2)^(1/2);
                      Tnorm=abs( img2(j-1,i) -  img1(((j-1)-posy)+1,(i-posx)+1) );
                      
                       A((i-1)*rws+j,(i-1)*rws+(j-1))=Snorm+Tnorm;
                       
%                        
%                          At_grey=(Atr+Atg+Atb)/3;
%                       Bt_grey=(Btr+Btg+Btb)/3;
%                       A((i-1)*rws+j,(i-1)*rws+(j+1))=(As_grey-Bs_grey)+(At_grey-Bt_grey);
                     end
                 end
                 if (( (i-1) > 0) && ((i-1) <= cols) )%pixel to the left %&&( indicative(j,i-1)==255)
                     
                    if ( indicative(j,i-1)==0)
                      %   disp('new');
                     T((i-1)*rws+j,1)=100000; 
                     border_img2=border_img2+1;
                    end
                    
                    if ( indicative(j,i-1)==128)
                       %  disp('new');
                         border_img1=border_img1+1;
                     T((i-1)*rws+j,2)=100000;
                    end
                     
                 if(   ( indicative(j,i-1)==255))   
                     
                     
                     %A((i-1)*rws+(j+1),(i-1)*rws+j) ==0 &&
                     %disp('leftr');
                     % A((i-1)*rws+j,(i-2)*rws+j)= equation;
%                       Atr=img2(j,i-1,1);
%                       Atg=img2(j,i-1,2);
%                       Atb=img2(j,i-1,3);
% 
%                       Btr=img1((j-posy)+1,((i-1)-posx)+1,1);
%                       Btg=img1((j-posy)+1,((i-1)-posx)+1,2);
%                       Btb=img1((j-posy)+1,((i-1)-posx)+1,3);
                      
                    %  Tnorm= ((Atr-Btr)^2+(Atg-Btg)^2+(Atb-Btb)^2)^(1/2);
                      Tnorm=abs(img2(j,i-1) -img1((j-posy)+1,((i-1)-posx)+1)); 
                       A((i-1)*rws+j,(i-2)*rws+(j))=Snorm+Tnorm;
                       
                       
%                          At_grey=(Atr+Atg+Atb)/3;
%                       Bt_grey=(Btr+Btg+Btb)/3;
%                      A((i-1)*rws+j,(i-1)*rws+(j+1))=(As_grey-Bs_grey)+(At_grey-Bt_grey);
                 end
                 end
                 
                if (( (i+1) > 0) && ((i+1) <=cols) )%pixel to the right %&&( indicative(j,i+1)==255)
                    
                    if ( indicative(j,i+1)==0)
                      %   disp('new');
                       T((i-1)*rws+j,1)=100000; 
                       border_img2=border_img2+1;
                    end
                    
                    if ( indicative(j,i+1)==128)
                       %  disp('new');
                         border_img1=border_img1+1;
                        T((i-1)*rws+j,2)=100000;
                    end
                    
                    
                    
                   
                    
                    
                    
                    if(( indicative(j,i+1)==255))
                    
              % A((i-1)*rws+(j+1),(i-1)*rws+j)==0 &&
                        %disp('right');
                   %   A((i-1)*rws+j,(i*rws)+j)= equation;
%                       Atr=img2(j,i+1,1);
%                       Atg=img2(j,i+1,2);
%                       Atb=img2(j,i+1,3);
% 
%                       Btr=img1((j-posy)+1,((i+1)-posx)+1,1);
%                       Btg=img1((j-posy)+1,((i+1)-posx)+1,2);
%                       Btb=img1((j-posy)+1,((i+1)-posx)+1,3);
                      
                     % Tnorm= ((Atr-Btr)^2+(Atg-Btg)^2+(Atb-Btb)^2)^(1/2);
                      Tnorm=abs(img2(j,i+1) - img1((j-posy)+1,((i+1)-posx)+1));
                      
                       A((i-1)*rws+j,(i)*rws+(j))=Snorm+Tnorm;
                       
%                         At_grey=(Atr+Atg+Atb)/3;
%                       Bt_grey=(Btr+Btg+Btb)/3;
%                    A((i-1)*rws+j,(i-1)*rws+(j+1))=(As_grey-Bs_grey)+(At_grey-Bt_grey);
                    end
                end
                 %
                % =======
                %======= diagonal componedtes
                    %=============
                 if (( (i-1) > 0) && ((i-1) <=cols) && (j-1) >0 && (j-1) <=rws)%pixel to the left top %&&( indicative(j,i+1)==255)
                    
                    if ( indicative(j-1,i-1)==0)
                         %disp('new');
                       T((i-1)*rws+j,1)=100000; 
                       border_img2=border_img2+1;
                    end
                    
                    if ( indicative(j-1,i-1)==128)
                         %disp('new');
                         border_img1=border_img1+1;
                        T((i-1)*rws+j,2)=100000;
                    end
                    
                    
                    
                   
                    
                    
                    
                    if(( indicative(j-1,i-1)==255))
                    
              % A((i-1)*rws+(j+1),(i-1)*rws+j)==0 &&
                       % disp('right');
                   %   A((i-1)*rws+j,(i*rws)+j)= equation;
%                       Atr=img2(j,i+1,1);
%                       Atg=img2(j,i+1,2);
%                       Atb=img2(j,i+1,3);
% 
%                       Btr=img1((j-posy)+1,((i+1)-posx)+1,1);
%                       Btg=img1((j-posy)+1,((i+1)-posx)+1,2);
%                       Btb=img1((j-posy)+1,((i+1)-posx)+1,3);
                      
                     % Tnorm= ((Atr-Btr)^2+(Atg-Btg)^2+(Atb-Btb)^2)^(1/2);
                      Tnorm=abs(img2(j-1,i-1) - img1(((j-1)-posy)+1,((i-1)-posx)+1));
                      
                       A((i-1)*rws+j,(i-2)*rws+(j-1))=Snorm+Tnorm;
                       
%                         At_grey=(Atr+Atg+Atb)/3;
%                       Bt_grey=(Btr+Btg+Btb)/3;
%                    A((i-1)*rws+j,(i-1)*rws+(j+1))=(As_grey-Bs_grey)+(At_grey-Bt_grey);
                    end
                 end
                 
                 
                 
                 
                  if (( (i-1) > 0) && ((i-1) <=cols) && (j+1) >0 && (j+1) <=rws)%pixel to the left below position %&&( indicative(j,i+1)==255)
                    
                    if ( indicative(j+1,i-1)==0)
                      %   disp('new');
                       T((i-1)*rws+j,1)=100000; 
                       border_img2=border_img2+1;
                    end
                    
                    if ( indicative(j+1,i-1)==128)
                       
                        %disp('new');
                         border_img1=border_img1+1;
                        T((i-1)*rws+j,2)=100000;
                    end
                    
                    
                    
                   
                    
                    
                    
                    if(( indicative(j+1,i-1)==255))
                    
              % A((i-1)*rws+(j+1),(i-1)*rws+j)==0 &&
                     %   disp('right');
                   %   A((i-1)*rws+j,(i*rws)+j)= equation;
%                       Atr=img2(j,i+1,1);
%                       Atg=img2(j,i+1,2);
%                       Atb=img2(j,i+1,3);
% 
%                       Btr=img1((j-posy)+1,((i+1)-posx)+1,1);
%                       Btg=img1((j-posy)+1,((i+1)-posx)+1,2);
%                       Btb=img1((j-posy)+1,((i+1)-posx)+1,3);
                      
                     % Tnorm= ((Atr-Btr)^2+(Atg-Btg)^2+(Atb-Btb)^2)^(1/2);
                      Tnorm=abs(img2(j+1,i-1) - img1(((j+1)-posy)+1,((i-1)-posx)+1));
                      
                       A((i-1)*rws+j,(i-2)*rws+(j+1))=Snorm+Tnorm;
                       
%                         At_grey=(Atr+Atg+Atb)/3;
%                       Bt_grey=(Btr+Btg+Btb)/3;
%                    A((i-1)*rws+j,(i-1)*rws+(j+1))=(As_grey-Bs_grey)+(At_grey-Bt_grey);
                    end
                  end
                 
                  
                  
                    if (( (i+1) > 0) && ((i+1) <=cols) && (j-1) >0 && (j-1) <=rws)%pixel to the right top position %&&( indicative(j,i+1)==255)
                    
                    if ( indicative(j-1,i+1)==0)
                   %      disp('new');
                       T((i-1)*rws+j,1)=100000; 
                       border_img2=border_img2+1;
                    end
                    
                    if ( indicative(j-1,i+1)==128)
                      %   disp('new');
                         border_img1=border_img1+1;
                        T((i-1)*rws+j,2)=100000;
                    end
                    
                    
                    
                   
                    
                    
                    
                    if(( indicative(j-1,i+1)==255))
                    
              % A((i-1)*rws+(j+1),(i-1)*rws+j)==0 &&
                      %  disp('right');
                   %   A((i-1)*rws+j,(i*rws)+j)= equation;
%                       Atr=img2(j,i+1,1);
%                       Atg=img2(j,i+1,2);
%                       Atb=img2(j,i+1,3);
% 
%                       Btr=img1((j-posy)+1,((i+1)-posx)+1,1);
%                       Btg=img1((j-posy)+1,((i+1)-posx)+1,2);
%                       Btb=img1((j-posy)+1,((i+1)-posx)+1,3);
                      
                     % Tnorm= ((Atr-Btr)^2+(Atg-Btg)^2+(Atb-Btb)^2)^(1/2);
                      Tnorm=abs(img2(j-1,i+1) - img1(((j-1)-posy)+1,((i+1)-posx)+1));
                      
                       A((i-1)*rws+j,(i)*rws+(j-1))=Snorm+Tnorm;
                       
%                         At_grey=(Atr+Atg+Atb)/3;
%                       Bt_grey=(Btr+Btg+Btb)/3;
%                    A((i-1)*rws+j,(i-1)*rws+(j+1))=(As_grey-Bs_grey)+(At_grey-Bt_grey);
                    end
                    end
              
                 
                    
                    
                    
                      if (( (i+1) > 0) && ((i+1) <=cols) && (j+1) >0 && (j+1) <=rws)%pixel to the right below position %&&( indicative(j,i+1)==255)
                    
                    if ( indicative(j+1,i+1)==0)
                     %    disp('new');
                       T((i-1)*rws+j,1)=100000; 
                       border_img2=border_img2+1;
                    end
                    
                    if ( indicative(j+1,i+1)==128)
                    %     disp('new');
                         border_img1=border_img1+1;
                        T((i-1)*rws+j,2)=100000;
                    end
                    
                    
                    
                   
                    
                    
                    
                    if(( indicative(j+1,i+1)==255))
                    
              % A((i-1)*rws+(j+1),(i-1)*rws+j)==0 &&
                     %   disp('right');
                   %   A((i-1)*rws+j,(i*rws)+j)= equation;
%                       Atr=img2(j,i+1,1);
%                       Atg=img2(j,i+1,2);
%                       Atb=img2(j,i+1,3);
% 
%                       Btr=img1((j-posy)+1,((i+1)-posx)+1,1);
%                       Btg=img1((j-posy)+1,((i+1)-posx)+1,2);
%                       Btb=img1((j-posy)+1,((i+1)-posx)+1,3);
                      
                     % Tnorm= ((Atr-Btr)^2+(Atg-Btg)^2+(Atb-Btb)^2)^(1/2);
                      Tnorm=abs(img2(j+1,i+1) - img1(((j+1)-posy)+1,((i+1)-posx)+1));
                      
                       A((i-1)*rws+j,(i)*rws+(j+1))=Snorm+Tnorm;
                       
%                         At_grey=(Atr+Atg+Atb)/3;
%                       Bt_grey=(Btr+Btg+Btb)/3;
%                    A((i-1)*rws+j,(i-1)*rws+(j+1))=(As_grey-Bs_grey)+(At_grey-Bt_grey);
                    end
                 end
                  
        end
       
        
    end

end

[flow,labels] = maxflow(A,T);
disp(rect);


disp('no of border pixels with image1 is');
disp(border_img1);

disp('no ofpixels for which infinte weigt added to img 1');
disp(img1_comp);


disp('no ofpixels for which infinte weigt added to img 2');
disp(img2_comp);


label_mat=reshape(labels,rws,cols);

opimage=zeros(rws,cols,3);
opimage=uint8(opimage);


for i=1:rws
    for j=1:cols
        if(label_mat(i,j)==0)
            opimage(i,j,1)=img2_new(i,j,1);
             opimage(i,j,2)=img2_new(i,j,2);
              opimage(i,j,3)=img2_new(i,j,3);
        else
            
            opimage(i,j,1)=img1_new((i-posy)+1,(j-posx)+1,1);
             opimage(i,j,2)=img1_new((i-posy)+1,(j-posx)+1,2);
              opimage(i,j,3)=img1_new((i-posy)+1,(j-posx)+1,3);
        end
    end
end

                




end

            
            

