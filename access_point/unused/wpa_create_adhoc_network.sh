#!/bin/bash


ifconfig $1 down
iwconfig $1 mode ad-hoc
ifconfig $1 up
iwconfig $1 essid "$2"
ifconfig $1 inet 10.0.0.1

