Last update 13.01.2021 by mcash

How to visualize the local doc as rendered on the web (for Windows users)?

In order to visualize the local documentation as rendered on the web, you will need to:
- install Ruby
- install Bundler and Jekyll
- update the Gemfile dependencies to the newest versions
- create a local rendering server
- open the doc with your browser

If you are on a windows machine, perform the following steps in this specific order:
1. download RubyInstaller.exe at https://rubyinstaller.org/downloads/
2. install Ruby and Msys2 by running the .exe file and following the instructions
3. open the Windows console (search for cmd.exe in the starting menu) and install bundler and jekyll by entering the command:

   gem install bundler jekyll

4. Update the Gemfile to the latest versions of the dependencies by:
-  going to the location of MASH-FRET documentation by entering the command:

   cd $MASH-FRET directory$\docs

   where $MASH-FRET durectory$ is the location of MASH-FRET folder on your computer (C:\Users\mcash\Documents\MASH-FRET in my case)
-  updating the Gemfile by entering the command:
	
   bundle update

5. You can now start your local server by entering the command:
	
   bundle exec jekyll serve

   Any changes made to the files located in docs/ will be tracked and the server will be updated accordingly.
   You can visualuze the local documentation via your browser using the url given in the console at line "Server address:"
   To stop the server, press Ctrl+C in the console
	
