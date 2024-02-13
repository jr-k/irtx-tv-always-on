TV-ALWAYS-ON
=

##  1. Download
```bash
cd /opt
sudo git clone https://github.com/jr-k/irtx-tv-always-on && cd irtx-tv-always-on
```

## 2. Configure
Edit your `Remotes` directory in `pigpio-irtx-irrx-install.sh` file by executing this (replace ____REMOTEDIR____)
```bash
sudo sed -i 's|REMOTES_DIR="/home/pi/Remotes"|REMOTES_DIR="____REMOTEDIR____"|g' pigpio-irtx-irrx-install.sh
```

## 3. Install
```bash
sudo apt update
sudo apt install cec-utils
sudo ./pigpio-irtx-irrx-install.sh
sudo cp ./tv-always-on.service /etc/systemd/system
sudo systemctl daemon-reload
sudo systemctl enable tv-always-on
```

## 4. Run
```bash
sudo systemctl start tv-always-on
```

## 5. RaspberryPi wiring

- GPIO17: Receiver
- GPIO18: Emitter

## 6. Debug

### Capture remote
Let's try to capture power buttons and three channel buttons
```bash
irrx philips_tv power 1 2 3
```

### Replay remote
```bash
irtx philips_tv power
```


