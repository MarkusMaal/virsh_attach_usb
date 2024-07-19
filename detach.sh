#!/bin/bash

# Arrays to store product IDs and vendor IDs
declare -a product_ids
declare -a vendor_ids
declare -a names

# Get the output of the lsusb command
lsusb_output=$(lsusb)

# Iterate over each line of the lsusb output
while IFS= read -r line; do
  # Use regex to extract the product and vendor IDs
  if [[ $line =~ ([0-9a-fA-F]{4}):([0-9a-fA-F]{4}) ]]; then
    vendor_id=${BASH_REMATCH[1]}
    product_id=${BASH_REMATCH[2]}
    # Append the IDs to the respective arrays
    vendor_ids+=("$vendor_id")
    product_ids+=("$product_id")
    names+=("${line:33}")
  fi
done <<< "$lsusb_output"

# Print the arrays
clear
id=0
echo
echo -e "\e[34;1mQuick and dirty USB detachment tool\e[0m"
echo
for dev in "${names[@]}"; do
	idx="$id"
	echo -e "$id.\t\e[32m[VID: ${vendor_ids[$idx]}]\e[0m \e[36m[PID: ${product_ids[$idx]}]\e[0m $dev"
	id="$(($id+1))"
done
echo
echo -en "Please enter a \e[32mnumber\e[0m corresponding to the device you want to detach or type \e[32mq\e[0m to quit: "
read -p "" ans
([ "$ans" == "Q" ] || [ "$ans" == "q" ]) && exit
clear
echo
echo -e "\e[34;1mQuick and dirty USB detachment tool\e[0m"
echo
sudo virsh list --all 2>/dev/null
read -p "Detach device from (name of VM): " vm
([ "$vm" == "Q" ] || [ "$vm" == "q" ]) && exit
detach_fname="./detach-usb.xml"
vid="${vendor_ids[$ans]}"
pid="${product_ids[$ans]}"
echo "<hostdev mode=\"subsystem\" type=\"usb\" managed=\"yes\">" > $detach_fname #remove old xml
echo "  <source>" >> $detach_fname
echo "    <vendor id=\"0x$vid\"/>" >> $detach_fname
echo "    <product id=\"0x$pid\"/>" >> $detach_fname
echo "  </source>" >> $detach_fname
echo "</hostdev>" >> $detach_fname
clear
echo
echo -e "\e[34;1mQuick and dirty USB detachment tool\e[0m"
echo
sudo virsh detach-device --domain $vm --file "$detach_fname" --current 2>/dev/null
