# adjust paths as necessary
SDL2=~/SDL2-2.26.5
SDL2_mixer=~/SDL2_mixer-2.6.3
SDL2_image=~/SDL2_image-2.6.3
mingw=i686-w64-mingw32
aster=./aster-forth

# remember to use  "-Wl,-subsystem,windows" to disable console
$mingw-gcc \
-I$SDL2/$mingw/include -I$SDL2/$mingw/include/SDL2 -L$SDL2/$mingw/lib \
-I$SDL2_image/$mingw/include -L$SDL2_image/$mingw/lib \
-std=gnu99 -I$aster \
gds.c $aster/aster.c $aster/aster_dict.c \
-w \
-lmingw32 -lSDL2main -lSDL2 -lopengl32 -lm -lSDL2_image \
-o gds.exe && \
cp $SDL2/$mingw/bin/SDL2.dll . && \
cp $SDL2_image/$mingw/bin/SDL2_image.dll .
