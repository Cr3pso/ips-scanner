#!/bin/bash

#Colors
RED='\033[00;31m'
GREEN='\033[00;32m'
YELLOW='\033[00;33m'
BLUE='\033[00;34m'
CYAN='\033[00;36m'
LIGHTGRAY='\033[00;37m'
PURPLE='\033[00;35m'
ENDCOLOUR="\033[0m\e[0m"

#Ctrl+C
function ctrl_c(){
        echo -e "${CYAN}\n\n[!] Exiting..."
        tput cnorm; exit 1
}

trap ctrl_c INT

#Hide mouse
tput civis

#Distribute ip ranges
ip_range=$1
ip=$(echo $ip_range | tr '/' ' ' | awk '{print $1}')
first_seg_ip=$(echo $ip | tr '.' ' ' | awk '{print $1}')
second_seg_ip=$(echo $ip | tr '.' ' ' | awk '{print $2}')
third_seg_ip=$(echo $ip | tr '.' ' ' | awk '{print $3}')
fourth_seg_ip=$(echo $ip | tr '.' ' ' | awk '{print $4}')
range=$(echo $ip_range | tr '/' ' ' | awk '{print $2}')
echo

#Third octect
if [[ $third_seg_ip == *-* && $fourth_seg_ip != *-* ]]; then
    range_first=$(echo $third_seg_ip | tr '-' ' ' | awk '{print $1}')
    range_sec=$(echo $third_seg_ip | tr '-' ' ' | awk '{print $2}')
    for ((num = range_first; num <= range_sec; num++)); do
        (
            ping_result=$(timeout 1 ping -c 1 $first_seg_ip.$second_seg_ip.$num.$fourth_seg_ip)
                if [ $? -eq 0 ]; then
                    ttl=$(echo "$ping_result"| head -n 2 | tail -n 1 | awk -F' ' '{print $6}' | awk -F'=' '{print $2}')
                    echo -e "${BLUE}[+] ${YELLOW}$first_seg_ip.$second_seg_ip.$num.$fourth_seg_ip ${LIGHTGRAY}- ${GREEN}ACTIVE $(if (( $ttl >= 50 && $ttl <= 75 )); then echo "${LIGHTGRAY}[${ENDCOLOUR}${PURPLE}Linux${ENDCOLOUR}${LIGHTGRAY}]${ENDCOLOUR}"; elif (( $ttl >= 90 && $ttl <= 140 )); then echo "${LIGHTGRAY}[${ENDCOLOUR}${RED}Windows${ENDCOLOUR}${LIGHTGRAY}]${ENDCOLOUR}"; fi)"
                fi        
        ) &
    done
    wait
    tput cnorm

#Fourth octet
elif [[ $third_seg_ip != *-* && $fourth_seg_ip == *-* ]]; then
    range_first=$(echo $fourth_seg_ip | tr '-' ' ' | awk '{print $1}')
    range_sec=$(echo $fourth_seg_ip | tr '-' ' ' | awk '{print $2}')
    for ((num = range_first; num <= range_sec; num++)); do
        (
            ping_result=$(timeout 1 ping -c 1 $first_seg_ip.$second_seg_ip.$third_seg_ip.$num)
                if [ $? -eq 0 ]; then
                    ttl=$(echo "$ping_result"| head -n 2 | tail -n 1 | awk -F' ' '{print $6}' | awk -F'=' '{print $2}')
                    echo -e "${BLUE}[+] ${YELLOW}$first_seg_ip.$second_seg_ip.$third_seg_ip.$num ${LIGHTGRAY}- ${GREEN}ACTIVE $(if (( $ttl >= 50 && $ttl <= 75 )); then echo "${LIGHTGRAY}[${ENDCOLOUR}${PURPLE}Linux${ENDCOLOUR}${LIGHTGRAY}]${ENDCOLOUR}"; elif (( $ttl >= 90 && $ttl <= 140 )); then echo "${LIGHTGRAY}[${ENDCOLOUR}${RED}Windows${ENDCOLOUR}${LIGHTGRAY}]${ENDCOLOUR}"; fi)"
                fi        
        ) &
    done
    wait
    tput cnorm

#Third & fourth octet
elif [[ $third_seg_ip == *-* && $fourth_seg_ip == *-* ]]; then
    range_third_first=$(echo $third_seg_ip | tr '-' ' ' | awk '{print $1}')
    range_third_sec=$(echo $third_seg_ip | tr '-' ' ' | awk '{print $2}')
    range_fourth_first=$(echo $fourth_seg_ip | tr '-' ' ' | awk '{print $1}')
    range_fourth_sec=$(echo $fourth_seg_ip | tr '-' ' ' | awk '{print $2}')
    for ((num = range_third_first; num <= range_third_sec; num++)); do
        for ((n = range_fourth_first; n <= range_fourth_sec; n++)); do
            (
                ping_result=$(timeout 1 ping -c 1 $first_seg_ip.$second_seg_ip.$num.$n)
                if [ $? -eq 0 ]; then
                    ttl=$(echo "$ping_result"| head -n 2 | tail -n 1 | awk -F' ' '{print $6}' | awk -F'=' '{print $2}')
                    echo -e "${BLUE}[+] ${YELLOW}$first_seg_ip.$second_seg_ip.$num.$n ${LIGHTGRAY}- ${GREEN}ACTIVE $(if (( $ttl >= 50 && $ttl <= 75 )); then echo "${LIGHTGRAY}[${ENDCOLOUR}${PURPLE}Linux${ENDCOLOUR}${LIGHTGRAY}]${ENDCOLOUR}"; elif (( $ttl >= 90 && $ttl <= 140 )); then echo "${LIGHTGRAY}[${ENDCOLOUR}${RED}Windows${ENDCOLOUR}${LIGHTGRAY}]${ENDCOLOUR}"; fi)"
                fi
            ) &
        done
    done
    wait
    tput cnorm

#24 bits
elif [[ $range == 24 ]]; then
    for num in $(seq 1 255); do
        for n in $(seq 1 255); do
            (
                ping_result=$(timeout 1 ping -c 1 $first_seg_ip.$second_seg_ip.$num.$n)
                if [ $? -eq 0 ]; then
                    ttl=$(echo "$ping_result"| head -n 2 | tail -n 1 | awk -F' ' '{print $6}' | awk -F'=' '{print $2}')
                    echo -e "${BLUE}[+] ${YELLOW}$first_seg_ip.$second_seg_ip.$num.$n ${LIGHTGRAY}- ${GREEN}ACTIVE $(if (( $ttl >= 50 && $ttl <= 75 )); then echo "${LIGHTGRAY}[${ENDCOLOUR}${PURPLE}Linux${ENDCOLOUR}${LIGHTGRAY}]${ENDCOLOUR}"; elif (( $ttl >= 90 && $ttl <= 140 )); then echo "${LIGHTGRAY}[${ENDCOLOUR}${RED}Windows${ENDCOLOUR}${LIGHTGRAY}]${ENDCOLOUR}"; fi)"
                fi
            ) &
        done
    done
    wait
    tput cnorm

#12 bits
elif [[ $range == 12 ]]; then
    for num in $(seq 1 255); do
        (
            ping_result=$(timeout 1 ping -c 1 $first_seg_ip.$second_seg_ip.$third_seg_ip.$num)
                if [ $? -eq 0 ]; then
                    ttl=$(echo "$ping_result"| head -n 2 | tail -n 1 | awk -F' ' '{print $6}' | awk -F'=' '{print $2}')
                    echo -e "${BLUE}[+] ${YELLOW}$first_seg_ip.$second_seg_ip.$third_seg_ip.$num ${LIGHTGRAY}- ${GREEN}ACTIVE $(if (( $ttl >= 50 && $ttl <= 75 )); then echo "${LIGHTGRAY}[${ENDCOLOUR}${PURPLE}Linux${ENDCOLOUR}${LIGHTGRAY}]${ENDCOLOUR}"; elif (( $ttl >= 90 && $ttl <= 140 )); then echo "${LIGHTGRAY}[${ENDCOLOUR}${RED}Windows${ENDCOLOUR}${LIGHTGRAY}]${ENDCOLOUR}"; fi)"
                fi        
        ) &
    done
    wait
    tput cnorm

else
    echo -e "\n${LIGHTGRAY}[${ENDCOLOUR}${RED}!${ENDCOLOUR}${LIGHTGRAY}]${ENDCOLOUR} ${CYAN}Please indicate a valid ip range${ENDCOLOUR} ${LIGHTGRAY}[${ENDCOLOUR}${YELLOW}12/24${ENDCOLOUR}${LIGHTGRAY}]${ENDCOLOUR} ${CYAN}or a valid octet range.${ENDCOLOUR} \n${GREEN}Examples >>${ENDCOLOUR} ${LIGHTGRAY}[${ENDCOLOUR}${BLUE}192.168.${ENDCOLOUR}${YELLOW}1-255${ENDCOLOUR}${BLUE}.1${ENDCOLOUR}$LIGHTGRAY]${ENDCOLOUR} ${GREEN}/${ENDCOLOUR} ${LIGHTGRAY}[${ENDCOLOUR}${BLUE}192.168.1.${ENDCOLOUR}${YELLOW}1-255${ENDCOLOUR}$LIGHTGRAY]${ENDCOLOUR} ${GREEN}/${ENDCOLOUR} ${LIGHTGRAY}[${ENDCOLOUR}${BLUE}192.168.${ENDCOLOUR}${YELLOW}1-255${ENDCOLOUR}${BLUE}.${ENDCOLOUR}${YELLOW}1-255${ENDCOLOUR}$LIGHTGRAY]${ENDCOLOUR}\n"
    sleep 1
    tput cnorm
    exit 1

echo

fi