CC = nvc
FC = nvfortran
CFLAGS = -Wall -Wextra -g
FFLAGS = -g
LDFLAGS = -lGL -lglut -lnvf
OBJ = src/main.o
SHARED_OBJ = src/c_entry.so
TARGET = raytracing-fortran

all: $(TARGET)

$(TARGET): $(OBJ) $(SHARED_OBJ)
	$(CC) -o $@ $^ $(LDFLAGS)

$(SHARED_OBJ): src/c_entry.f90
	$(FC) -c -fpic -shared $< -o $@

%.o: %.c
	$(CC) $(CFLAGS) -c $< -o $@

clean:
	rm -f $(OBJ) $(SHARED_OBJ) $(TARGET)
