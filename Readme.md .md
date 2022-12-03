# Picsum


## Project description
In this project I have consumed the public API of Lorem Picsum: https://picsum.photos/ . I have built it in UIKit using MVVM architecture and URLSession to take care of networking.


## Files organisation
🗂️ Delegates - AppDelegate and SceneDelegate
🗂️ Pictures - Architecture structure
🗂️ Networking - Classes responsible for networking
🗂️ Utilities - Extensions to make the development process faster


## Archtiecture
The architecture design pattern I have choose to use in this project is MVVM (Model View View Model) in order to have a better separation of concerns on the application and to make it easier to maintain.

### Model layer is responsible for storing and representing the data from the logic of implementation.The model I have created is Picture model that holds the data logic of the application.

#### The View layer is responsible for displaying the data to users and handling of layout.
The views I have created are:
PictureListView that displays the list of all pictures from https://picsum.photos/v2/list? . When the user taps on a picture it will be redirected to PictureView 
PictureView that displays the choosen image from the user, the title and a segmented control that changes the filter of the image to grayscale and blur. The blur image has a blur scale that can be changed with a slider.

### The ViewModel layer is responsible for data binding logic. It communicates between the View and the Model.
The ViewModels I have created are:
PictureListViewModel
PictureViewModel

## Networking
I have used URLSession that offers a first-party best-in-class API to make networking requests to get data from API since the data has to be retrived from an URL. For session configuration I have used ephemeral object since it prevents JSON from caching meaning that it will store in RAM and nothing on Disk. Once getting the data I parse it to model.

## Optimisations:
Since the images size taken from URL are large and this lead to latency I have optimised the download URL by descreasing width and height parameters in order for the application to be faster and more performant.
Image loading tasks have been performed asynchronously meaning that the function returns control to the current queue right after image loading task has been sent to be performed on the different queue. It doesn't block the queue by waiting until the task is finished.


