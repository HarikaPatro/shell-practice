#!/bin/bash

echo "please enter a number:"
read NUMBER

if [ $(($NUMBER % 2)) -eq 0 ]; then
    echo "given number is even"
else
    echo "given number is odd"
fi