# copy the scripts
scripts=(ugreen-diskiomon ugreen-netdevmon ugreen-probe-leds ugreen-cputempmon)
for f in ${scripts[@]}; do
    chmod +x "scripts/$f"
    cp "scripts/$f" /usr/bin
done

# copy the configuration file, you can change it if needed
cp scripts/ugreen-leds.conf /etc/ugreen-leds.conf

# copy the systemd services 
cp scripts/*.service /etc/systemd/system/

# compile the disk activities monitor
g++ -std=c++17 -O2 scripts/blink-disk.cpp -o scripts/ugreen-blink-disk
# copy the binary file (the path can be changed, see BLINK_MON_PATH in ugreen-leds.conf)
cp scripts/ugreen-blink-disk /usr/bin

# compile the disk standby checker
g++ -std=c++17 -O2 scripts/check-standby.cpp -o scripts/ugreen-check-standby
# copy the binary file (the path can be changed, see STANDBY_MON_PATH in ugreen-leds.conf)
cp scripts/ugreen-check-standby /usr/bin

#Start the services last to fix Text file busy error
# start the services
systemctl daemon-reload

# change enp2s0 to the network device you want to monitor
systemctl start ugreen-netdevmon@enp2s0 
systemctl start ugreen-diskiomon
systemctl start ugreen-cputempmon

# if you confirm that everything works well, 
# run the command below to make the service start at boot
systemctl enable ugreen-netdevmon@enp2s0 
systemctl enable ugreen-diskiomon
systemctl enable ugreen-cputempmon