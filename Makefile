CC = nvc
FC = nvfortran
CFLAGS = -O2 -Wall -Wextra -g
FFLAGS = -O2 -g -mp -Wall
LDFLAGS = -lGL -lglut -lnvf -mp
SHARED_OBJ = c_entry.so
TARGET = raytracing-fortran
OBJ = scene.o rays.o

vpath %.f90 src/

all: $(TARGET)

$(TARGET): src/main.c $(OBJ) $(SHARED_OBJ) $(OBJ)
	$(CC) -o $@ $^ $(LDFLAGS)

$(SHARED_OBJ): src/c_entry.f90
	$(FC) -c -fpic -shared $< -o $@

$(SHARED_OBJ): scene.o

scene.o: rays.o

%.o: %.f90
	$(FC) $(FFLAGS) -c $< -o $@

clean:
	rm -f *.o *.mod *.so $(TARGET)
