CC = gcc
FC = gfortran
CFLAGS = -Wall -Wextra -std=c99 -g
FFLAGS = -g -fno-underscoring
LDFLAGS = -lGL -lglut -lgfortran
OBJ = src/main.o
F90_OBJ = src/c_entry.o
TARGET = raytracing-fortran

all: $(TARGET)

$(TARGET): $(OBJ) $(F90_OBJ)
	$(CC) -o $@ $^ $(LDFLAGS)

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

%.o: %.f90
	$(FC) $(FFLAGS) -c $< -o $@

clean:
	rm -f $(OBJ) $(F90_OBJ) $(TARGET)
