===================================
  Log4Delphi Logging Suite Readme
===================================

This readme will provide you with a quick startup guide and explain some
things that you might wish to know or that may not be obvious!

-----------------------------------

Contents:
 1. Welcome
 2. What is Log4Delphi?
 3. What is Logging?
 4. How Much Does Log4Delphi Cost?
 5. Project Status
 6. The Latest Version
 7. Documentation
 8. Installation
 9. License
10. Further Information
 

1. Welcome
-----------------------------------

Thank you for downloading Log4Delphi, if you have any queries or suggestions
please feel free to send them to the user's mailing list.

Here is a description of the top level directories within the distribution
archive and what each of them contains. Some of these directories may be 
absent depending on which distribution you downloaded.

bin/        Contains the project binaries.
build/      Temporary build directory.
docs/       Contains the HTML documentation.
example/    Contains an example configuration file.
lib/        Contains the DUnit libraries for running the Unit Tests.
src/        Contains all the source code for Log4Delphi.


2. What Is Log4Delphi?
-----------------------------------

Log4Delphi is an Open Source project that aims to produce a high quality 
and usable logging suite for Borland's Delphi based on the Log4J package 
from the Apache Software Foundation.


3. What Is Logging?
-----------------------------------

Inserting log statements into source code is a low-tech method for debugging 
it. It may also be the only way since debuggers are not always available or 
applicable, often the case for distributed applications.

With Log4Delphi it is possible to enable logging at runtime without modifying 
the application binary. The Log4Delphi suite is designed so that these 
statements can remain in shipped code without incurring a heavy performance 
cost. Logging behavior can be controlled by editing a configuration file, 
without touching the application binary.

Logging equips the developer with detailed context for application failures. 
On the other hand, testing provides quality assurance and confidence in the 
application. Logging and testing should not be confused. They are 
complementary. When logging is wisely used, it can prove to be an essential 
tool.

The target of the log output can be a console window, file or a TStream 
object, making it possible to send log statements to any imaginable 
destination, even to a log server!


4. How Much Does Log4Delphi Cost?
-----------------------------------

Since Log4Delphi is licenced under an Open Source license it is completely 
free of charge for any application. This means you can use it in your 
commercial applications without any worry. Support is also free, just join 
the mailing list and ask any questions you want.


5. Project Status
-----------------------------------

Log4Delphi is still in early stages of development and will continue to grow 
through a series of 0.x releases. It is important for users and developers to 
realise that this is evolving software and therefore, prior to a 1.0 release, 
ensuring quality of design is considered more important than retaining 
backwards compatibility. Having said that, the project strives not to make any 
undocumented backwards-incompatible changes.


6. The Latest Version
-----------------------------------

The latest version of Log4Delphi is available on the project's web-site
at: http://log4delphi.sourceforge.net


7. Documentation
-----------------------------------

The documentation is available in HTML format, readable using any web browser,
in the docs/ directory. Simply browse the index.html file.


8. Installation
-----------------------------------

Installation instructions can be found in the HTML documentation. See the
install.html file in the docs/ directory.


9. License
-----------------------------------

This software is licensed under the terms you may find in the file 
named "LICENSE.txt" in this directory.


10. Further Information
-----------------------------------

   o Homepage                @ http://log4delphi.sourceforge.net
   o Mailing List            @ http://og4delphi.sourceforge.net/contact.html
   o Forum                   @ http://log4delphi.sourceforge.net/contact.html
   o Troubleshooting         @ http://log4delphi.sourceforge.net/troubleshooting.html
   o Report bugs             @ http://log4delphi.sourceforge.net/contact.html
   o Request features        @ http://log4delphi.sourceforge.net/contact.html
   o CVS Repository          @ http://log4delphi.sourceforge.net/cvs.html
   o Latest Version          @ http://log4delphi.sourceforge.net/download.html
   o Contributing            @ http://log4delphi.sourceforge.net/developerguide.html
   o Project Bylaws          @ http://log4delphi.sourceforge.net/bylaws.html


Thanks for using Log4Delphi

                                          The Log4Delphi Project
                                    <http://log4delphi.sourceforge.net>