#!/bin/bash

STEPS=7
CURSTEP=1
SLEEPTIME=2
REMOTES_DIR="~/Remotes"

# Download pigpio
echo "[$CURSTEP/$STEPS] Pigpio downloading..."
sleep $SLEEPTIME && ((CURSTEP++))
cd /tmp
wget https://github.com/joan2937/pigpio/archive/master.zip
unzip master.zip
cd pigpio-master

# Install pigpio
echo "[$CURSTEP/$STEPS] Pigpio installation..."
sleep $SLEEPTIME && ((CURSTEP++))
make
make install

# Configure pigpio daemon
echo "[$CURSTEP/$STEPS] Pigpio configuration..."
sleep $SLEEPTIME && ((CURSTEP++))
systemctl daemon-reload
systemctl enable pigpiod
systemctl start pigpiod

# Install irrp.py
echo "[$CURSTEP/$STEPS] Irpp.py installation..."
sleep $SLEEPTIME && ((CURSTEP++))
cd /tmp
wget https://abyz.me.uk/rpi/pigpio/code/irrp_py.zip
unzip irrp_py.zip
chmod +x irpp.py
mv irpp.py /usr/local/bin/

# Create /usr/local/bin/irtx script and make it executable
echo "[$CURSTEP/$STEPS] IRTX script installation"
sleep $SLEEPTIME && ((CURSTEP++))
cat > /usr/local/bin/irtx <<EOF
#!/bin/sh
REMOTE=$1
BUTTONS=${@:2}

if [ -z "$REMOTE" ]; then
  echo "Error : first argument must be a remote in $REMOTES_DIR directory"
  exit 1
fi

if [ -z "$BUTTONS" ]; then
  echo "Error : at least one button name is needed"
  exit 1
fi

/usr/local/bin/irrp.py -p -g 18 -f "$REMOTES_DIR/$REMOTE" $BUTTONS
EOF
chmod +x /usr/local/bin/irtx

# Create /usr/local/bin/irrx script and make it executable
echo "[$CURSTEP/$STEPS] IRRX script installation"
sleep $SLEEPTIME && ((CURSTEP++))
cat > /usr/local/bin/irrx <<EOF
#!/bin/sh
REMOTE=$1
BUTTON=${@:2}

if [ -z "$REMOTE" ]; then
  echo "Error : first argument must be a remote in $REMOTES_DIR directory"
  exit 1
fi

if [ -z "$BUTTONS" ]; then
  echo "Error : at least one button name is needed"
  exit 1
fi

/usr/local/bin/irrp.py -r -g 17 -f "$REMOTES_DIR/$REMOTE" $BUTTONS
EOF
chmod +x /usr/local/bin/irrx

# Create Remotes directory
echo "[$CURSTEP/$STEPS] Remote directory"
sleep $SLEEPTIME && ((CURSTEP++))
mkdir $REMOTES_DIR 2>/dev/null
echo "# Remotes
cd $REMOTES_DIR && ls -1
