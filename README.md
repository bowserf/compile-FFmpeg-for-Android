## Script to compile the audio extractor of FFmpeg for Android
Disable all FFmpeg features apart from audio extraction. We only keep enable MP3, WAV, Flac and M4A extraction.
The script uses ```configure``` file to generate accurate ```makefile``` according to selected options and call ```make```  to compile the library.
Compilation generates 4 files : ```libavcodec.so```, ```libavformat.so```, ```libavutil.so``` and ```libswresample.so```.

### Requirements :
* Android NDK : contains the cross compilator we will use to compile FFmpeg sources for Android as well as Android headers.
* [FFmpeg source code ](https://ffmpeg.org/download.html).
* Linux OS : if you are on Mac OS, you need to apply some modifications on the script by replacing ```linux``` reference by ```darwin```.
* GCC compilator.

### Compile FFmpeg :

To compile FFmpeg for Android, you need to follow these steps :
1. Define ```NDK``` variable in your development environnement with the path of your Android NDK directory.
2. Put the script inside FFmpeg directory.
3. Execute the script with one of the following paramter : ```x86```, ```ARMv6``` or ```ARMv7```.
4. Generated ```.so``` files are copied inside your personal directory.

### To know :

* This script has been developed to compile FFmpeg 3.3. Some flags can have changed with time if you compile for a newer version.
* Some optimizations are done during compilation (```-ffast-math -pipe -O2 -ftree-vectorize```) and more are done according to the choosen architecture.
* Script will generate a ```shared``` library with ```.so``` files.
* All generated files are inside their respective directory but also copied in your personal directory.
* Compilation is done with headers of the Android API 14.