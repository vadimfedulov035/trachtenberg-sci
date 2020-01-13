#!/bin/sh

xdf=1
ydf=1

read -p 'Do you want a division test or multiplication? (mul/div): ' answ
read -p 'Do you want to be in endless mathematical loop? (yes/no): ' endl
read -p 'How many iterations do you want before increasing difficulty? (num): ' rpass

whileml()
{
i=1
while true; do
    if [ `echo "$i % ($rpass * 2)" | bc` = 1 ] && [ $i != 1 ]; then
        ydf=`echo "$ydf + 1" | bc`
    elif [ `echo "$i % $rpass" | bc` = 1 ] && [ $i != 1 ]; then
        xdf=`echo "$xdf + 1" | bc`
    fi
    
    x0=`tr -cd 1-9 < /dev/urandom | head -c 1 | cut -d'%' -f 1`
    x1=`tr -cd 0-9 < /dev/urandom | head -c $xdf | cut -d'%' -f 1`
    y0=`tr -cd 1-9 < /dev/urandom | head -c 1 | cut -d'%' -f 1`
    y1=`tr -cd 0-9 < /dev/urandom | head -c $ydf | cut -d'%' -f 1`
    x="$x0$x1"
    y="$y0$y1"
    
    rmul=`echo "$x * $y" | bc`
    read -p "$x * $y = " vmul

    if [ ! -z $vmul ]; then
        if [ $vmul = $rmul ]; then
            echo "You are God Damn Right!"
        else
            echo "No, the answer is $rmul"
        fi
    else
        echo "You typed nothing!"
    fi
    i=$(( $i + 1 ))
done
}

whiledl()
{
i=1
while true; do
    if [ `echo "$i % ($rpass * 2)" | bc` = 1 ] && [ $i != 1 ]; then
        ydf=`echo "$ydf + 1" | bc`
    elif [ `echo "$i % $rpass" | bc` = 1 ] && [ $i != 1 ]; then
        xdf=`echo "$xdf + 1" | bc`
    fi

    x0=`tr -cd 1-9 < /dev/urandom | head -c 1 | cut -d'%' -f 1`
    x1=`tr -cd 0-9 < /dev/urandom | head -c $(($xdf + 2)) | cut -d'%' -f 1`
    y0=`tr -cd 1-9 < /dev/urandom | head -c 1 | cut -d'%' -f 1`
    y1=`tr -cd 0-9 < /dev/urandom | head -c $ydf | cut -d'%' -f 1`
    x="$x0$x1"
    y="$y0$y1"

    rdiv=`echo "$x / $y" | bc`
    rout=`echo "$x % $y" | bc`
    read -p "$x / $y = " vdiv
    read -p "$x % $y = " vout

    if [ ! -z $vdiv ]; then
        if [ $vdiv = $rdiv ] && [ $vout = $rout ]; then
            echo "You're God Damn Right!"
        else
            echo "No, the answer is $rdiv and residue is $rout"
        fi
    else
        echo "You typed nothing!"
    fi
    i=$(( $i + 1 ))
done
}

forml()
{
read -p 'How many iterations do you want to pass?: ' nitera
for i in `seq $(echo "$nitera")`; do
    if [ `echo "$i % ($rpass * 2)" | bc` = 1 ] && [ $i != 1 ]; then
        ydf=`echo "$ydf + 1" | bc`
    elif [ `echo "$i % $rpass" | bc` = 1 ] && [ $i != 1 ]; then
        xdf=`echo "$xdf + 1" | bc`
    fi
    
    x0=`tr -cd 1-9 < /dev/urandom | head -c 1 | cut -d'%' -f 1`
    x1=`tr -cd 0-9 < /dev/urandom | head -c $xdf | cut -d'%' -f 1`
    y0=`tr -cd 1-9 < /dev/urandom | head -c 1 | cut -d'%' -f 1`
    y1=`tr -cd 0-9 < /dev/urandom | head -c $ydf | cut -d'%' -f 1`
    x="$x0$x1"
    y="$y0$y1"

    rmul=`echo "$x * $y" | bc`
    read -p "$x * $y = " vmul

    if [ ! -z $vmul ]; then
        if [ $vmul = $rmul ]; then
            echo "You are God Damn Right!"
        else
            echo "No, the answer is $rmul"
        fi
    else
        echo "You typed nothing!"
    fi
done
}

fordl()
{
read -p 'How many iterations do you want to pass?: ' nitera
for i in `seq $(echo "$nitera")`; do
    if [ `echo "$i % ($rpass * 2)" | bc` = 1 ] && [ $i != 1 ]; then
        ydf=`echo "$ydf + 1" | bc`
    elif [ `echo "$i % $rpass" | bc` = 1 ] && [ $i != 1 ]; then
        xdf=`echo "$xdf + 1" | bc`
    fi
    
    x0=`tr -cd 1-9 < /dev/urandom | head -c 1 | cut -d'%' -f 1`
    x1=`tr -cd 0-9 < /dev/urandom | head -c $(($xdf + 2)) | cut -d'%' -f 1`
    y0=`tr -cd 1-9 < /dev/urandom | head -c 1 | cut -d'%' -f 1`
    y1=`tr -cd 0-9 < /dev/urandom | head -c $ydf | cut -d'%' -f 1`
    x="$x0$x1"
    y="$y0$y1"

    rdiv=`echo "$x / $y" | bc`
    rout=`echo "$x % $y" | bc`
    read -p "$x / $y = " vdiv
    read -p "$x % $y = " vout

    if [ ! -z $vdiv ]; then
        if [ $vdiv = $rdiv ] && [ $vout = $rout ]; then
            echo "You're God Damn Right!"
        else
            echo "No, the answer is $rdiv and residue is $rout"
        fi
    else
        echo "You typed nothing!"
    fi
done
}

if [ "$answ" = "div" ]; then
    if [ "$endl" = "yes" ]; then
        whiledl
    elif [ "$endl" = "no" ]; then
        fordl
    else
        echo "You typed neither yes, neither no"
    fi
elif [ "$answ" = "mul" ]; then
    if [ "$endl" = "yes" ]; then
        whileml
    elif [ "$endl" = "no" ]; then
        forml
    else
        echo "You typed neither yes, neither no"
    fi
else
    echo "You chose nothing"
fi
