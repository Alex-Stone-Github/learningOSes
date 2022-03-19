/*
The data segment does not work look watch.
*/

#define WIDTH 80
#define HEIGHT 25

unsigned char * const FRAMEBUFFER1 = (unsigned char*)0xb8000;

enum vga_color {
	VGA_COLOR_BLACK = 0,
	VGA_COLOR_BLUE = 1,
	VGA_COLOR_GREEN = 2,
	VGA_COLOR_CYAN = 3,
	VGA_COLOR_RED = 4,
	VGA_COLOR_MAGENTA = 5,
	VGA_COLOR_BROWN = 6,
	VGA_COLOR_LIGHT_GREY = 7,
	VGA_COLOR_DARK_GREY = 8,
	VGA_COLOR_LIGHT_BLUE = 9,
	VGA_COLOR_LIGHT_GREEN = 10,
	VGA_COLOR_LIGHT_CYAN = 11,
	VGA_COLOR_LIGHT_RED = 12,
	VGA_COLOR_LIGHT_MAGENTA = 13,
	VGA_COLOR_LIGHT_BROWN = 14,
	VGA_COLOR_WHITE = 15,
};

int tobgcolor(int);

const int a = 3;

void entry() {
    unsigned int counter = 0;
    for (unsigned int i = 0; i < WIDTH * HEIGHT * 2; i++) {
        counter ++;
        if (i % 2 == 1) {
            if (counter % a == 0) {
                FRAMEBUFFER1[i] = tobgcolor(VGA_COLOR_MAGENTA)|VGA_COLOR_WHITE;
            }
            else {
                FRAMEBUFFER1[i] = tobgcolor(VGA_COLOR_LIGHT_GREEN);
            }
        }
        else {
            FRAMEBUFFER1[i] = ' ';
        }
    }
}
int tobgcolor(int color) {
    return color << 4;
}
