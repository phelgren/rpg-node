      *  This uses the core of Example 4 from the HTTPAPI examples
      *
     H DFTACTGRP(*NO) ACTGRP(*NEW) BNDDIR('HTTPAPI')

      *
      * When form data is sent to a web browser, it often has to be
      * 'encoded'. HTTPAPI contains some routines called 'WEBFORM'
      * routines to help you with that encoding.
      *
      * This demonstrates using HTTPAPI's WEBFORM functions
      * to submit a web form. The web "form" in this case is post to
      * a node.js express server that will take the post and route it to the
      * the express server to display
      *

      /define WEBFORMS
     D/copy qrpglesrc,httpapi_h
     D postchat        pr                  extpgm('POSTCHAT')
     D   message                   1000A   options(*varsize)

     D postchat        pi
     D   message                   1000A   options(*varsize)

     D cmd             pr                  extpgm('QCMDEXC')
     D  command                     200A   const
     D  length                       15P 5 const

     D CRLF            C                   CONST(x'0D25')
     D rc              s             10I 0
     D msg             s             52A

     D Form            s                   like(WEBFORM)
     D myPointer       s               *
     D dataSize        s             10I 0
     D msgout          s           1000A
     D

      **
      ** CHANGE THIS TO THE MESSAGE YOU'D LIKE SENT :
      **
     c/free
         Form = WEBFORM_open;
         msgout = %trim(message);
         callp     WEBFORM_SetVar(Form: 'message': msgout);

      **
      ** The WEBFORM_postData() routine retrieves data suitable for
      ** the http_url_post() API.  (there's also a WEBFORM_getData()
      ** if you need to call HTTP_url_get).
      **
         callp     WEBFORM_postData( Form : myPointer : dataSize );

      **
      **  The http_url_post() function does an HTTP POST operation
      **  sending any data at the pointer you specify.
      **
      **  The results, in this case, are saved to the IFS in a file
      **  called '/tmp/testpost.html'
      **
          rc = http_url_post(
                                   'http://10.0.10.205:2080/chat'
                                  : myPointer
                                  : dataSize
                                  : '/tmp/testpost.html'
                                  : HTTP_TIMEOUT
                                  : HTTP_USERAGENT
                                  : 'application/x-www-form-urlencoded' );

      *
      * This particular web page doesn't give a direct response
      * but instead asks you to visit another page.  This is done
      * by sending back a 302 ("Page Moved") response.  You can
      * call the http_redir_loc() routine in HTTPAPI to get the
      * URL that the redirection points to, and then the http_url_get()
      * routine to ask HTTPAPI to retrieve that page.
      *
          if rc=302;
             rc = http_url_get( http_redir_loc
                             : '/tmp/testpost.html');

          endif;

      *
      * If there's an error, use the DSPLY opcode to show it on the
      * screen.   If not, use the DSPF command from OS/400 to display
      * the data that was returned onto the screen.
      *
          if rc <> 1 ;
             msg = http_error;
             dsply msg;
          endif;

      **
      ** When done, make sure you call this function to free up
      ** the memory that the web form used
      **
               callp     WEBFORM_close(Form);

               *inlr = *on;
      /end-free 