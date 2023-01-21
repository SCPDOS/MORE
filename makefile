#!/bin/sh

sys:
	nasm more.asm -o ./Binaries/MORE.COM -f bin -l ./Listings/more.lst -O0v
