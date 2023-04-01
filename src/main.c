/*==============================================================================*
 * MAIN
 *------------------------------------------------------------------------------*
 * Author:  Ed Higgins <ed.higgins@york.ac.uk>
 *    with the help of ChatGPT-3
 *------------------------------------------------------------------------------*
 * Version: 0.1.1, 2023-04-01
 *------------------------------------------------------------------------------*
 * This code is distributed under the MIT license.
 *==============================================================================*/

#include <stdio.h>
#include <stdlib.h>
#include <GL/glut.h>

extern void update_buffer_fortran_(float*, int*, int*);

#include <GL/glut.h>
#include <stdlib.h>

float FPS = 60;
int WIDTH = 1920;
int HEIGHT = 1080;

// Define the color array
int NUM_PIXELS;
GLfloat* buffer;

// Initialize the color array with random buffer
void initBuffer() {
    buffer = (GLfloat*)malloc(NUM_PIXELS * 3 * sizeof(GLfloat));
    for (int i = 0; i < NUM_PIXELS * 3; i++) {
        buffer[i] = 0;
    }
}

// Update the color array and redisplay the window
void updateBuffer(void) {
    update_buffer_fortran_(buffer, &WIDTH, &HEIGHT);
    glutPostRedisplay();
}

void display() {
    glClear(GL_COLOR_BUFFER_BIT);

    // Set the raster position to the bottom-left corner of the window
    glRasterPos2f(-1, -1);

    // Draw the pixels using the color array
    glDrawPixels(WIDTH, HEIGHT, GL_RGB, GL_FLOAT, buffer);

    glutSwapBuffers();

    glFlush();
}

void timer(void) {

}

int main(int argc, char** argv) {
    glutInit(&argc, argv);
    glutInitDisplayMode(GLUT_DOUBLE | GLUT_RGB);
    glutInitWindowSize(WIDTH, HEIGHT);
    glutCreateWindow("OpenGL Colored Pixels");

    NUM_PIXELS = WIDTH * HEIGHT;
    initBuffer();

    glutDisplayFunc(display);
    glutIdleFunc(updateBuffer); // Start the timer

    glutMainLoop();

    // Free the dynamically allocated color array
    free(buffer);

    return 0;
}
