# rpg-node
Using node.js and RPGLE in peaceful coexistence

The first example we are going to use is the standard "chat" application which you can find at http://socket.io/get-started/chat/ It is a simple app which allows multiple folks to chat in real time with a display of the chat messages.  It is simple to get started with node.js and the required additional libraries will all work on the node.js implementation on IBM i.  

The chat is all well and good but what if you wanted to post messages from another source?  The first thing that came to mind for me was system messages sent from IBM to alert you to issues that you might want to address immediately.  So the question in my mind was, how do you get started in implementing this approach?  Well, for one, you'd need to communicate with the chat server!  I originally looked at communicating directly with the socket.io server at the socket level but I quickly abandoned that idea as I looked around for an example I could digest.  Instead, I figured I should be able to use an HTTP POST to post a message to the chat server. The code listed in chat.html does this with the modified chat application for socket.io (express.js) which you can find in chattypost.js.  chattypost.js just takes the standard chat example and extends it by using a restful post route that looks for /chat URI retrieves that data and then emits it back to the chat server.  It is a bit of a convoluted way to get the post into the chat stream, but it works!

I dumped the chat,html and the chattypost.js into the same folder that I used when I created the chat server example from socket.io.  This is the easiet way to do a sanity check on the components.  Change the IP address to whatever you are using on IBM i.  Check to make sure all is well before proceeding.

Then start the chattypost.js server using node.js (making sure that the basic chat server was working originally) and then use the chat.html page to post new data to the chat.  If all that works you are ready to give a post from IBM i a whirl as well.

The POST we do from IBM i takes a bit more plumbing.  Scott Klement has a wonderful http tool called HTTPAPI that you can use to communicate directly with an HTTP server from RPG.  You'll find the code and instructions here: http://www.scottklement.com/httpapi/  Scott has graciously made the effort to get the HTTPAPI working all the way back to V5R1 (V4R2 for some function) BUT you will need to be on V7R1 or V7R2 and have the "IBM i Open Source Solutions" 5733OPS licensed program installed and be fairly current on your PTF's in order for all things to work smoothly.

If you have HTTPAPI installed, you can then compile the RPGLE program (source POSTCHAT.RPGLE) and if that compiles correctly, then compile the CHAT.CMD file using the POSTCHAT program as the run target. Then you are ready to go!

Check to make sure that your chattypost.js server is running.  Test by posting a chat or two and then use the chat.html file to post an "external" bit of data.  If all that works then try running your CHAT command from the command line (your library containing your programs and HTTPAPI should be in the library list).  The CHAT command is something like this:  CHAT 'This is a test from IBM i!.  You should see that chat appear in the chat list from index.html (the main file served by chattypost.js).

This is just the beginning.  If you have it all working correctly, you can then monitor for message on IBM i and use your CHAT command to send them to the chat stream (no, I haven't provided THAT code as well...Google is your friend here....)  You could "chat" completion messages.  Make the CHAT command available to your end user to send you messages.  You *could* build a two-way chat as well.  The sky is the limit and since you are using HTTP, you could integrate PHP, Ruby, Python, net.data, whatever, into the stream.  

Happy coding on IBM i!
