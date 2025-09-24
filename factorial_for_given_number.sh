#!/bin/bash
for i in 2 4 5 7 9 6
do
    num=$i
    fact=1

    while [ $num -gt 1 ]
    do
        fact=$((fact * num))
        num=$((num - 1))
    done

    echo "The Factorial of $i is $fact"
done
