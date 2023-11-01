
function varargout = TheRealMazeSolver(varargin)
% THEREALMAZESOLVER MATLAB code for TheRealMazeSolver.fig
%      THEREALMAZESOLVER, by itself, creates a new THEREALMAZESOLVER or raises the existing
%      singleton*.
%
%      H = THEREALMAZESOLVER returns the handle to a new THEREALMAZESOLVER or the handle to
%      the existing singleton*.
%
%      THEREALMAZESOLVER('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in THEREALMAZESOLVER.M with the given input arguments.
%
%      THEREALMAZESOLVER('Property','Value',...) creates a new THEREALMAZESOLVER or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before TheRealMazeSolver_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to TheRealMazeSolver_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help TheRealMazeSolver

% Last Modified by GUIDE v2.5 31-Oct-2023 01:22:28

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @TheRealMazeSolver_OpeningFcn, ...
                   'gui_OutputFcn',  @TheRealMazeSolver_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT



end



% --- Executes just before TheRealMazeSolver is made visible.
function TheRealMazeSolver_OpeningFcn(hObject, eventdata, handles, varargin)

% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to TheRealMazeSolver (see VARARGIN)

    set(handles.solve,'enable','off');
    set(handles.submit,'enable','off');


    imagefile = '/preview.jpg';
    I = imread(imagefile);
    axes(handles.previewimage);
    imshow(I);



    % Choose default command line output for TheRealMazeSolver
    handles.output = hObject;

    % Update handles structure
    guidata(hObject, handles);

    % UIWAIT makes TheRealMazeSolver wait for user response (see UIRESUME)
    % uiwait(handles.figure1);
    
    readymazematrix =[];
    handles.readymazematrix=readymazematrix;
    guidata(hObject,handles)
    
end

% --- Outputs from this function are returned to the command line.
function varargout = TheRealMazeSolver_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
    % eventdata  reserved - to be defined in a future version of MATLAB
    % handles    structure with handles and user data (see GUIDATA)

    % Get default command line output from handles structure
    varargout{1} = handles.output;
end

% --- Executes on button press in randomize.
function randomize_Callback(hObject, eventdata, handles)
% hObject    handle to randomize (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    sz = str2double(get(handles.mazesize,'String'));
    if isnan(sz)
        errordlg('Please enter a valid integer First !', 'Input Error');
        return;
    end


    % randommaze = TheRealMazeGenerator(size);
    % pt=fix(size/2);
    % randommaze(pt+1, pt+1) = -1;
    % readymazematrix = randommaze;
    % randommaze = flipud(randommaze);
    % randommaze(end+1,:) = randommaze(end,:); % Append last row
    % randommaze(:,end+1) = randommaze(:,end); % Append last column
    % pcolor(handles.mazemap,randommaze);
        % iteration appraoch
        maze=zeros(sz);
        mid=fix(sz/2);
        maze(mid+1+[0,1],mid+1+[0,1])=1;
        middleSquareCoordinates = [mid+1, mid+1; mid+1, mid+1 + 1; mid+1 + 1, mid+1; mid+1 + 1, mid+1 + 1];
%         randxy =middleSquareCoordinates(randi(4),:);
        randxy=[mid+1,mid+1];
        
        rx=randxy(1);
        ry=randxy(2);
        maze(rx,ry)=2;
        stack = [rx, ry];
        outer=[mid+1, mid;mid, mid+1;  mid, mid+1 + 1 ; mid+1, mid+1 + 1+1;mid+1 + 1, mid ;mid+1 + 1+1, mid+1;mid+1 + 1+1, mid+1 + 1;mid+1 + 1, mid+1 + 1+1];
        directions = [0, 2; 2, 0; 0, -2; -2, 0];
        while ~isempty(stack)
    %         randommaze = flipud(maze);
    %         randommaze(end+1,:) = randommaze(end,:); % Append last row
    %         randommaze(:,end+1) = randommaze(:,end); % Append last column
    %         pcolor(handles.mazemap,randommaze);
    %         pause(0)
            x=stack(end, 1);
            y=stack(end, 2);
            % Find all unvisited neighbors
            neighbors = [];
            for i = 1:4
                nx = x + directions(i, 1);
                ny = y + directions(i, 2);
                if nx > 0 && ny > 0 && nx <= sz && ny <= sz && maze(nx, ny) == 0 && ~ismember([nx, ny], outer, 'rows')
                    neighbors = [neighbors; nx, ny,i];
                end
            end

            if  ~isempty(neighbors)

                idx = randi(size(neighbors, 1));
                nx = neighbors(idx, 1);
                ny = neighbors(idx, 2);
                stack = [stack; nx,ny];

                maze(x + directions(neighbors(idx, 3), 1)/2, y + directions(neighbors(idx, 3), 2)/2) = 1;
                maze(nx,ny)=1;


            else
                 stack = stack(1:end-1, :);
            end


        end

        cmap = [

            0.2,0.2,0.2;
            1, 1, 1;
            1,1,0;
            0,1,0;
        ];
        colormap(cmap);
        maze(rx,ry)=1;
        readymazematrix= maze;
        handles.readymazematrix=readymazematrix;
        guidata(hObject,handles)
        
        randommaze = flipud(maze);
        randommaze(end+1,:) = randommaze(end,:); % Append last row
        randommaze(:,end+1) = randommaze(:,end); % Append last column
        pcolor(handles.mazemap,randommaze);


    
    set(handles.solve,'enable','on');
end

% --- Executes on button press in solve.
function solve_Callback(hObject, eventdata, handles)
% hObject    handle to solve (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    readymazematrix=handles.readymazematrix;
    maze=readymazematrix ;
    
    sz=size(maze,1);
    mid=fix(sz/2);
    directions = [0, 1; 1, 0; 0, -1; -1, 0];
%     choose starting point 
    [sy,sx]=ginput(1);
    sx=sz-fix(sx)+1;
    sy=fix(sy);
    maze(sx,sy)=4;

    finmaze = flipud(maze);
    finmaze(end+1,:) = finmaze(end,:); % Append last row
    finmaze(:,end+1) = finmaze(:,end); % Append last column
    pcolor(handles.mazemap,finmaze);
    pause(0)
                    
                    
%     choose ending point

    [ey,ex]=ginput(1);
    ex=sz-fix(ex)+1;
    ey=fix(ey);
%     2 is the identifier of the ending point = destination
    maze(ex,ey)=2;
    

    queue=[sx,sy];
    exception=0;
    parent = cell(sz,sz);
    while size(queue)>0 

        for k=1:size(queue,1)
            x=queue(1,1);
            y=queue(1,2);
            queue=queue(2:end,:);
            neighbors = [];
            
            for i = 1:4
                nx = x + directions(i, 1);
                ny = y + directions(i, 2);
                if nx > 0 && ny > 0 && nx <= sz && ny <= sz && (maze(nx, ny) == 1 || maze(nx, ny) == 2)
                    neighbors = [neighbors; nx, ny,i];
                end
            end

             if  ~isempty(neighbors)
                for i = 1:size(neighbors)
                    neighbor = neighbors(i, :);
                    nx = neighbor(1);
                    ny = neighbor(2);
                    if maze(nx,ny)==2
                        destination = neighbor;
                        parent{nx, ny} = [x,y];
                        exception =1;
                        break
                    end
                    
                    finmaze = flipud(maze);
                    finmaze(end+1,:) = finmaze(end,:); % Append last row
                    finmaze(:,end+1) = finmaze(:,end); % Append last column
                    pcolor(handles.mazemap,finmaze);
                    pause(0)
                    maze(nx,ny)=3;
                    
                    parent{nx, ny} = [x,y];
                    
                    queue= [queue; nx,ny];
                end
             end
             if exception ==1
                 break
             end


        end
        if exception ==1
            break
        end
    end
    path=destination;
    while (path(end,1)~=sx || path(end,2)~=sy) 
        
        cmap = [

            0.2,0.2,0.2;
            1, 1, 1;
            1,1,0;
            0,1,0;
            0,0,1;
        ];
        colormap(cmap);
        finmaze = flipud(maze);
        finmaze(end+1,:) = finmaze(end,:); % Append last row
        finmaze(:,end+1) = finmaze(:,end); % Append last column
        pcolor(handles.mazemap,finmaze);
        pause(0)
        
        
       cellparent=parent{path(end,1),path(end,2)};
       cx=cellparent(end,1);
       cy=cellparent(end,2);
       maze(cx,cy)=4;

       path=cellparent; 
    end
    finmaze = flipud(maze);
    finmaze(end+1,:) = finmaze(end,:); % Append last row
    finmaze(:,end+1) = finmaze(:,end); % Append last column
    pcolor(handles.mazemap,finmaze);

end



% --- Executes on button press in submit.
function submit_Callback(hObject, eventdata, handles)
% hObject    handle to submit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    % Read the image
    sz = str2double(get(handles.mazesize,'String'));
    if isnan(sz)
        errordlg('Please enter a valid integer First !', 'Input Error');
        return;
    end
    img= imread(get(handles.imagepath,'String'));

    img = rgb2gray(img);

    % Binarize the image
    bin_img = imbinarize(img);

    % If you want 0s to represent white and 1s to represent black, you can invert the binary image
    % bin_img = ~bin_img;


    % This is done by taking the mean of each block of pixels that represents a cell of the maze
    % The round function is used to convert the mean values to 0 or 1
    mat = round(imresize(bin_img, [sz sz], 'bicubic'));
    
%     mid=fix(sz/2);
%     mat(mid+1+[0,1],mid+1+[0,1])=2;
    cmap = [

    0.2,0.2,0.2;
    1, 1, 1;
    1,1,0;
    0,1,0;
];
     colormap(cmap);
    
    % Flip the maze matrix in the up-down direction
    maze = flipud(mat);
    maze(end+1,:) = maze(end,:); % Append last row
    maze(:,end+1) = maze(:,end); % Append last column
    % Create a `pcolor` plot of the matrix

    pcolor(handles.mazemap , maze);
    
    
    
    readymazematrix = mat;
    
    handles.readymazematrix=readymazematrix;
    guidata(hObject,handles)
    set(handles.solve,'enable','on');
 
end



function imagepath_Callback(hObject, eventdata, handles)
% hObject    handle to imagepath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of imagepath as text
%        str2double(get(hObject,'String')) returns contents of imagepath as a double
end


% --- Executes during object creation, after setting all properties.
function imagepath_CreateFcn(hObject, eventdata, handles)
% hObject    handle to imagepath (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


% --- Executes on button press in choose_image.
function choose_image_Callback(hObject, eventdata, handles)
% hObject    handle to choose_image (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
    [filename, pathname] = uigetfile({'*.jpg;*.png;*.bmp;*.tiff;*.tif;*.gif', 'Image Files (*.jpg, *.png, *.bmp, *.tiff, *.tif, *.gif)'; '*.*', 'All Files (*.*)'}, 'Select Image');

    if isequal(filename,0) || isequal(pathname,0)
       disp('User pressed cancel')
    else
       imagefile = strcat(pathname,filename);
       set(handles.imagepath,'String',imagefile);
       I = imread(imagefile);
       axes(handles.previewimage);
       imshow(I);
       handles.I = I;
       guidata(hObject, handles);
       set(handles.randomize,'enable','on');
       set(handles.submit,'enable','on');
    end
end


function edit2_Callback(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of edit2 as text
%        str2double(get(hObject,'String')) returns contents of edit2 as a double
end


% --- Executes during object creation, after setting all properties.
function mazesize_CreateFcn(hObject, eventdata, handles)
% hObject    handle to edit2 (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

    % Hint: edit controls usually have a white background on Windows.
    %       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end




function mazesize_Callback(hObject, eventdata, handles)
% hObject    handle to size_label (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of size_label as text
%        str2double(get(hObject,'String')) returns contents of size_label as a double

% Get the input from the Edit UI control
    inputText = get(hObject, 'String');

    % Attempt to convert the input to a numeric value
    numericValue = str2double(inputText);

    % Check if the conversion was successful
    if isnan(numericValue)
        % Display an error message (you can customize this)
        errordlg('Please enter a valid integer.', 'Input Error');

        % Reset the Edit UI control to its previous value (if desired)
        set(hObject, 'String', ''); % Clears the invalid input
    else
        % The input is a valid integer; you can work with numericValue here
    end
end


% --- Executes during object creation, after setting all properties.
function size_label_CreateFcn(hObject, eventdata, handles)
% hObject    handle to size_label (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
    if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
        set(hObject,'BackgroundColor','white');
    end
end


% --- Executes on button press in Startingpt.
function Startingpt_Callback(hObject, eventdata, handles)
% hObject    handle to Startingpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


end

% --- Executes on button press in Endingpt.
function Endingpt_Callback(hObject, eventdata, handles)
% hObject    handle to Endingpt (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)


   set(handles.solve,'enable','on');
end


% --- Executes on button press in animation.
function animation_Callback(hObject, eventdata, handles)
% hObject    handle to animation (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of animation
end
