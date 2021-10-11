# flickerImageSearchDemo
An app that uses the Flickr image search API and shows the results in a 2- column scrollable view.

## **Architecture Of The app:**
I am following the MVVM-P pattern where we have 
- Model :fa-arrow-right: that holds data (in this case from network operations)
- View / View Controller :fa-arrow-right: that's the canvas and the binder for all elements
- View model :fa-arrow-right: that hold business logic including control on network connections and custodian of Model
- Presentation Layer :fa-arrow-right: which converts Data in the models from the View model to suit the Views need.

##### Reason For going with this approach:
The application can be made easier to maintain in the long go especially when UI changes happen
Business Logics can be kept hidden from UI changes thanks to the presentation layer.
VC can be kept to control the Views rather than making Business logic as the View model does it.

We have a Network Manager using URL sessions and a Local Notfication manager . This is kept separate for reusability accounts

## **UI**
 The App have one **VC (ImageSearchViewController)**, This has UI elemnts including a search bar, and a collection view. View controller facilitate user intractions and UI updates with viewmodel and presentations
 
 **Presentation Class (ImageSearchPresentation):**
 This class act as a bridgge modifying data to be used in UI, It converts data from viewmodel to hashable ImageSearchCellPresentation, which is stored in array and used to provide data for collection view.
 
 ** View model Class (ImageSearchViewModel): **
 All business logic are added here. Image information response download, actual image download trigger and pagination requests are all managed in view model.

**Manager Classes**
We have a Network manager and Image Download manger.
- Network manager takes any request confirming to base request to download request and respond back in closer passed along the call.
- Image downloader class is responsible for Image downloading caching and organizing calls.

**Network Models**
Search Request and response models are added to fecilitate JSON download

## Folder Structure:
###### Structure:
FlickerImageSearch: Root Folder for Project files 

   Extensions: where all Class extensions are added
   |
   ----Managers: Where all manager classes are added (Eg: Network Manager)
   |
   ----Life Cycle: App life cycle classes, app and scene delegates
   |
   ----Scenes: Where actual screen are added, It will have A view controller,  view model, presentations, views 
              |
              ---- Views: Can have nested folders for each having their own models and presentations
