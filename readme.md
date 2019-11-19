# ElixShare
### Description
Peer Audio Sharing is a desktop application in Elixir used to share audio files peer to peer instead of downloading it from main server. When a user wants an audio file, he/she searches for it. This application will check whether that file is availabe on any  peer's application. If the file is available, it will download it from peer. Otherwise it will download it from main server. Peer Sharing reduces the traffic between client-server communication.
### Technologies Used
* Language: Elixir
* Client-side: Json, mint, libcluster, CSV
* Database: Sqlite3
* Library for Backend: SqliteX, Plug, Json, Poison
### Prerequisits
To run this application, it is necessary to install Elixir on the desktop. You can download Elixir here: https://elixir-lang.org/install.html
### How to use?
* Step 1: After downloading Elixir, you need to clone our git repository. The link to download is here: https://github.com/D-Beall/Group14Client

![1213_LI](https://user-images.githubusercontent.com/55159894/69183154-6f087a00-0ae0-11ea-8276-c421666414fc.jpg)


* Step 2: In any terminal, get to the folder in which the repository is downloaded.
* Step 3: Type iex
* Step 4: Type Ctrl + C
* Step 5: Type Ctrl + C again
* Step 4: Type iex --sname yourname@localhost --cookie token -S mix          (yourname is any name you want to type)
* Step 6: Type UI.start
* Step 7: Enter the command download
* Step 8: Here you need to enter the name of artist or author of the audio you are looking for.
* Step 9: Here you need to enter the title of song or book you are looking for.
* If the file is not there on local server, it will display message "File not found on local server" and download it directly from the main server and will display message "Downloaded from server".

<img width="674" alt="2019-11-19 (5)" src="https://user-images.githubusercontent.com/55159894/69185407-b3961480-0ae4-11ea-9ccc-306250ffc606.png">






