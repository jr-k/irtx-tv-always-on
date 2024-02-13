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

## 4. RaspberryPi wiring

- GPIO17: Receiver signal
- GPIO18: Emitter signal

## 5. Learn power button & test

### Capture remote
Let's try to capture power button:
- Replace philips_tv by any name you want
- Ignore capture errors and push button until process ends
```bash
irrx philips_tv power
```

### Replay remote
Test your newly created gpio remote
- Replace philips_tv with remote name specified during capture process
```bash
irtx philips_tv power
```


## 6. Configure (again)
```bash
sudo cp tv-power-on.sh.dist tv-power-on.sh
sudo chmod +x tv-power-on.sh
sudo nano tv-power-on.sh # add your emitter command: irtx philips_tv power
```


## 7. Run
```bash
sudo systemctl start tv-always-on
```


