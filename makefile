#!/bin/sh

sys:
	nasm more.asm -o ./bin/MORE.COM -f bin -l ./lst/more.lst -O0v
