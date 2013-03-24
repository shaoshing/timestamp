path="./Timestamp/Timestamp.iconset"

convert $path/icon.png -resize 16  $path/icon_16x16.png
convert $path/icon.png -resize 32  $path/icon_32x32.png
convert $path/icon.png -resize 128 $path/icon_128x128.png
convert $path/icon.png -resize 256 $path/icon_256x256.png
convert $path/icon.png -resize 512 $path/icon_512x512.png

cp $path/icon_32x32.png             $path/icon_16x16@2x.png
convert $path/icon.png -resize 64   $path/icon_32x32@2x.png
cp $path/icon_256x256.png           $path/icon_128x128@2x.png
cp $path/icon_512x512.png           $path/icon_256x256@2x.png
convert $path/icon.png -resize 1025 $path/icon_512x512@2x.png
