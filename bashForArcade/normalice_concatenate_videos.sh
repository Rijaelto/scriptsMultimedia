#!/bin/bash

#Pon los archivos en las carpetas tal y como se indica.

pathvideosoriginales="originales"
pathnuevosvideos="normalicedAudio"
pathvideosresiced="resizedVideo"
pathvideosfinal="final"
open="pan/open4Final.mp4"
end="pan/end1Final.mp4"


echo "listar"


list=$(find $pathvideosoriginales -name '*.mp4')


for line in ${list}
do
result1=$(echo "$line" | sed "s#$pathvideosoriginales#$pathnuevosvideos#")
echo $result1  
ffmpeg-normalize $line -o $result1 -c:a aac -b:a 192k

result2=$(echo "$result1" | sed "s#$pathnuevosvideos#$pathvideosresiced#")
echo $result2  
ffmpeg -i $result1 -c:a copy -s 360x240 -vf "setsar=sar=1/1,setdar=dar=3/2" -c:v vp9 -r 30 $result2


result3=$(echo "$result2" | sed "s#$pathvideosresiced#$pathvideosfinal#")
ffmpeg -i $open -i $result2 -i $end \
-filter_complex "[0:v:0][0:a:0][1:v:0][1:a:0][2:v:0][2:a:0]concat=n=3:v=1:a=1[outv][outa]" \
-map "[outv]" -map "[outa]" $result3

done



