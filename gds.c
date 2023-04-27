/* game development system - tdwsl 2023 */

#include <aster.h>
#include <SDL2/SDL.h>
#include <SDL2/SDL_image.h>
#include <assert.h>
#include <string.h>
#include <stdlib.h>

/* set main file here */
#define GDS_MAIN_FILE "f/main.f"

SDL_Window *window;
SDL_Renderer *renderer;
SDL_Texture *textures[20];
int ntextures = 0;
int updatems = 10;
int scale = 1;
char redraw = 1;

int wquit=0, wdraw=0, wkeydown=0, wkeyup=0, wclick=0, wupdate=0;

void initSDL()
{
    assert(SDL_Init(SDL_INIT_EVERYTHING) >= 0);
    window = SDL_CreateWindow("GDS SDL",
        SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED,
        800, 600, SDL_WINDOW_RESIZABLE);
    assert(window);
    renderer = SDL_CreateRenderer(window, -1, SDL_RENDERER_SOFTWARE);
    assert(renderer);
    IMG_Init(IMG_INIT_PNG);
}

void endSDL()
{
    int i;
    for(i = 0; i < ntextures; i++) SDL_DestroyTexture(textures[i]);
    SDL_DestroyRenderer(renderer);
    SDL_DestroyWindow(window);
    SDL_Quit();
}

void f_loadimg()
{
    char buf[80];
    SDL_Surface *surf;
    SDL_Texture *tex;

    aster_sassert(2);
    strncpy(buf, aster_dict+aster_stack[aster_sp-2],
        aster_stack[aster_sp-1]);
    buf[aster_stack[aster_sp-1]] = 0;
    aster_sp -= 2;

    surf = IMG_Load(buf);
    assert(surf);
    tex = SDL_CreateTextureFromSurface(renderer, surf);
    assert(tex);
    SDL_FreeSurface(surf);
    textures[ntextures] = tex;
    aster_stack[aster_sp++] = ntextures++;
}

void f_blit()
{
    SDL_Rect src, dst;
    aster_sassert(7);
    src = (SDL_Rect) {
        aster_stack[aster_sp-6], aster_stack[aster_sp-5],
        aster_stack[aster_sp-4], aster_stack[aster_sp-3],
    };
    dst = (SDL_Rect) {
        aster_stack[aster_sp-2]*scale, aster_stack[aster_sp-1]*scale,
        src.w*scale, src.h*scale,
    };
    SDL_RenderCopy(renderer, textures[aster_stack[aster_sp-7]],
        &src, &dst);
    aster_sp -= 7;
}

void f_mouse()
{
    int x, y;
    SDL_GetMouseState(&x, &y);
    aster_stack[aster_sp++] = x/scale;
    aster_stack[aster_sp++] = y/scale;
}

void f_window()
{
    int w, h;
    SDL_GetWindowSize(window, &w, &h);
    aster_stack[aster_sp++] = w/scale;
    aster_stack[aster_sp++] = h/scale;
}

void f_bye()
{
    endSDL();
    exit(0);
}

void f_quitSet() { aster_sassert(1);
    wquit = aster_stack[--aster_sp]; }
void f_drawSet() { aster_sassert(1);
    wdraw = aster_stack[--aster_sp]; }
void f_keydownSet() { aster_sassert(1);
    wkeydown = aster_stack[--aster_sp]; }
void f_keyupSet() { aster_sassert(1);
    wkeyup = aster_stack[--aster_sp]; }
void f_clickSet() { aster_sassert(1);
    wclick = aster_stack[--aster_sp]; }
void f_updateSet() { aster_sassert(1);
    wupdate = aster_stack[--aster_sp]; }

void f_updatemsSet() { aster_sassert(1);
    updatems = aster_stack[--aster_sp]; }
void f_scaleSet() { aster_sassert(1);
    scale = aster_stack[--aster_sp]; }
void f_redraw() { redraw = 1; }

void mainLoop()
{
    int lastUpdate, currentTime;
    SDL_Event ev;
    lastUpdate = SDL_GetTicks();
    for(;;) {
        while(SDL_PollEvent(&ev)) {
            switch(ev.type) {
            case SDL_MOUSEMOTION:
            case SDL_MOUSEWHEEL:
            case SDL_MOUSEBUTTONUP:
                break;
            default:
                redraw = 1;
                break;
            }
            switch(ev.type) {
            case SDL_QUIT:
                if(wquit) aster_execute(wquit);
                return;
            case SDL_KEYDOWN:
                if(wkeydown) {
                    aster_stack[aster_sp++] = ev.key.keysym.sym;
                    aster_execute(wkeydown);
                }
                break;
            case SDL_KEYUP:
                if(wkeyup) {
                    aster_stack[aster_sp++] = ev.key.keysym.sym;
                    aster_execute(wkeyup);
                }
                break;
            case SDL_MOUSEBUTTONDOWN:
                if(wclick) aster_execute(wclick);
                break;
            }
        }
        currentTime = SDL_GetTicks();
        while(currentTime-lastUpdate >= updatems
                || currentTime < lastUpdate) {
            if(wupdate) aster_execute(wupdate);
            lastUpdate += updatems;
        }
        if(redraw) {
            SDL_RenderClear(renderer);
            if(wdraw) aster_execute(wdraw);
            SDL_RenderPresent(renderer);
            redraw = 0;
        }
    }
}

int main(int argc, char **args)
{
    initSDL();
    aster_init();

    aster_bye = f_bye;
    aster_addC(f_quitSet, "GDS-QUIT!", 0);
    aster_addC(f_drawSet, "GDS-DRAW!", 0);
    aster_addC(f_keydownSet, "GDS-KEYDOWN!", 0);
    aster_addC(f_keyupSet, "GDS-KEYUP!", 0);
    aster_addC(f_clickSet, "GDS-CLICK!", 0);
    aster_addC(f_updateSet, "GDS-UPDATE!", 0);
    aster_addC(f_updatemsSet, "GDS-UPDATEMS!", 0);
    aster_addC(f_scaleSet, "GDS-SCALE!", 0);
    aster_addC(f_loadimg, "GDS-LOADIMG", 0);
    aster_addC(f_blit, "GDS-BLIT", 0);
    aster_addC(f_mouse, "GDS-MOUSE", 0);
    aster_addC(f_window, "GDS-WINDOW", 0);
    aster_addC(f_redraw, "GDS-REDRAW", 0);

    aster_runFile(GDS_MAIN_FILE);

    mainLoop();

    endSDL();
    return 0;
}
