# About iBand

iBand is a musical instrument app that allows users in the same Wireless LAN to play instruments together, hearing others in the meantime on their own device. This app is built mainly in the purpose of learning programming on iOS.


## Components

There are two major part of this app, **instrument** and **network**. All additional libraries or frameworks are added using **CocoaPods**. Please open the project by ***iBand.xcworkspace***.

### Instruments

Currently, iBand has two instruments, piano and drum. Any instrument can be easily added using the existing structure.

Piano and drum in this app use the approach of playing WAV audio files to simulate the instrument. In order to play WAV audio files efficiently, I used **ObjectAL** (<http://kstenerud.github.io/ObjectAL-for-iPhone/>) to pre-load all the audio files. Then it can be played in very low latency.


#### Piano

The implementation of piano in iBand is modified from **MusicNotes** (<https://github.com/yepher/MusicNotes>). It has 88 WAV audio files, each of them is associated with one piano key.

The visible piano keys can be changed from the octave selection view. Move the dark rectangle to change the visible area, and zoom in/out the rectangle to change the number of visible keys.

#### Drum

Drum is implemented using a library called **BBGroover** (<https://github.com/pwightman/BBGroover>). **BBGroover** provides an easy-to-use drum machine library. I added some methods and wrapped them up with the methods in the library for the usage of network communication as well as to follow the code structure.

### Network

**DTBonjour** framework (<https://github.com/Cocoanetics/DTBonjour>) is used to do the WLAN network communication. I created a helper class to wrap up all the network communication method into one place so that other class can easily use those method without considering too much. 

I made the helper class singleton to ensure all the classes share the same information, such as how many devices, in WLAN. However there are different instruments require network communication and singleton means there's only one class can be the delegate. My approach to solve this problem is to create a new class, behaving as the interface between instrument and network. The interface is like a translator. The instrument tell the interface its needs of network communication, and then the interface translate those needs to the helper class. When there are new incoming network data, the helper class pass the data to the interface and let it translate back to the instruments.

## Class Relationship

![Diagram](http://farm8.staticflickr.com/7286/8736964613_24ebe5d8a7_z.jpg)