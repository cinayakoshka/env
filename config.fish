set -gx MAVEN_OPTS "-Xmx512M -XX:MaxPermSize=512M -Djava.awt.headless=true"
set -gx JAVA_HOME /Library/Java/JavaVirtualMachines/jdk1.7.0_55.jdk/Contents/Home/jre

set -gx ALTERNATE_EDITOR emacs
set -gx EMACSCLIENT /Applications/Emacs.app/Contents/MacOS/bin/emacsclient
set -gx EDITOR $EMACSCLIENT
set -gx VISUAL $EMACSCLIENT