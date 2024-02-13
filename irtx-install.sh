#!/bin/bash

STEPS=12
CURSTEP=1
SLEEPTIME=2

# Install LIRC
echo "[$CURSTEP/$STEPS] LIRC installation..."
sleep 2 && ((CURSTEP++))
apt update
apt install -y lirc

# Backup original files
echo "[$CURSTEP/$STEPS] Backup..."
sleep 2 && ((CURSTEP++))
cp /boot/config.txt /boot/config.txt.backup
cp /etc/modules /etc/modules.backup
cp /etc/lirc/lirc_options.conf /etc/lirc/lirc_options.conf.backup
cp /etc/udev/rules.d/71-lirc.rules /etc/udev/rules.d/71-lirc.rules.backup 2>/dev/null || :

# Modify /boot/config.txt
echo "[$CURSTEP/$STEPS] Boot config..."
sleep 2 && ((CURSTEP++))
sed -i '/dtoverlay=lirc-rpi/d' /boot/config.txt
echo -e "\n# IR configuration added\n" >> /boot/config.txt
echo "dtoverlay=gpio-ir,gpio_pin=17" >> /boot/config.txt
echo "#dtoverlay=gpio-ir-tx,gpio_pin=18" >> /boot/config.txt
echo "dtoverlay=pwm-ir-tx,gpio_pin=18" >> /boot/config.txt

echo "[$CURSTEP/$STEPS] Module removal..."
sleep 2 && ((CURSTEP++))
sed -i '/lirc_rpi/d' /etc/modules

# Add udev rules for stable device names
echo "[$CURSTEP/$STEPS] Udev rules..."
sleep 2 && ((CURSTEP++))
rm /etc/udev/rules.d/71-lirc.rules
echo 'ACTION=="add", SUBSYSTEM=="lirc", DRIVERS=="gpio_ir_recv", SYMLINK+="lirc-rx"' > /etc/udev/rules.d/71-lirc.rules
echo 'ACTION=="add", SUBSYSTEM=="lirc", DRIVERS=="gpio-ir-tx", SYMLINK+="lirc-tx"' >> /etc/udev/rules.d/71-lirc.rules
echo 'ACTION=="add", SUBSYSTEM=="lirc", DRIVERS=="pwm-ir-tx", SYMLINK+="lirc-tx"' >> /etc/udev/rules.d/71-lirc.rules

# Change device and listening address in /etc/lirc/lirc_options.conf
echo "[$CURSTEP/$STEPS] Lirc RX options..."
sleep 2 && ((CURSTEP++))
sed -i 's|device.*|device          = /dev/lirc-rx|g' /etc/lirc/lirc_options.conf
sed -i 's|.*listen.*|listen          = 0.0.0.0:8766|g' /etc/lirc/lirc_options.conf

# Copy and edit lirc_options.conf for transmitter
echo "[$CURSTEP/$STEPS] Lirc TX options..."
sleep 2 && ((CURSTEP++))
cp /etc/lirc/lirc_options.conf /etc/lirc/lirc_tx_options.conf
sed -i 's|device.*|device          = /dev/lirc-tx|g' /etc/lirc/lirc_tx_options.conf
sed -i 's|output.*|output          = /var/run/lirc/lircd-tx|g' /etc/lirc/lirc_tx_options.conf
sed -i 's|pidfile.*|pidfile         = /var/run/lirc/lircd-tx.pid|g' /etc/lirc/lirc_tx_options.conf
sed -i 's|.*listen.*|listen          = 0.0.0.0:8765|g' /etc/lirc/lirc_tx_options.conf
sed -i 's|.*connect.*|connect         = 127.0.0.1:8766|g' /etc/lirc/lirc_tx_options.conf

# Create and edit /etc/systemd/system/lircd-tx.service
echo "[$CURSTEP/$STEPS] Lirc TX service"
sleep 2 && ((CURSTEP++))
cat > /etc/systemd/system/lircd-tx.service <<EOF
[Unit]
Documentation=man:lircd(8)
Documentation=http://lirc.org/html/configure.html
Description=Second lircd, the transmitter
Wants=lircd-setup.service
After=network.target lircd-setup.service lircd.service

[Service]
Type=simple
ExecStart=/usr/sbin/lircd --nodaemon --options-file /etc/lirc/lirc_tx_options.conf

[Install]
WantedBy=multi-user.target
EOF

# Create and edit /etc/systemd/system/lircd-tx.socket
echo "[$CURSTEP/$STEPS] Lirc TX socket"
sleep 2 && ((CURSTEP++))
cat > /etc/systemd/system/lircd-tx.socket <<EOF
[Socket]
ListenStream=/run/lirc/lircd-tx

[Install]
WantedBy=sockets.target
Also=lircd-tx.service
EOF

# Reload systemd, start and enable lircd-tx
echo "[$CURSTEP/$STEPS] Systemctl update"
sleep 2 && ((CURSTEP++))
systemctl daemon-reload
systemctl start lircd-tx
systemctl enable lircd-tx

# Create /usr/local/bin/irtx script and make it executable
echo "[$CURSTEP/$STEPS] IRTX script installation"
sleep 2 && ((CURSTEP++))
cat > /usr/local/bin/irtx <<EOF
#!/bin/sh
exec /usr/bin/irsend --device=/var/run/lirc/l
EOF

# Create Remotes directory
echo "[$CURSTEP/$STEPS] Remote directory"
sleep 2 && ((CURSTEP++))
cat > /usr/local/bin/irtx <<EOF
#!/bin/sh
exec /usr/bin/irsend --device=/var/run/lirc/l
