python << EOF
import os
import sys
path = os.path.expanduser("/usr/local/.pyenv/versions/2.7.13/lib/python2.7/site-packages")
if not path in sys.path:
  sys.path.append(path)
path = os.path.expanduser("/usr/local/.pyenv/versions/3.6.0/lib/python3.6/site-packages")
if not path in sys.path:
  sys.path.append(path)
EOF
