module scene
!==============================================================================#
! SCENE
!------------------------------------------------------------------------------#
! Author:  Ed Higgins <ed.higgins@york.ac.uk>
!------------------------------------------------------------------------------#
! Version: 0.1.1, 2023-04-01
!------------------------------------------------------------------------------#
! This code is distributed under the MIT license.
!==============================================================================#
  use rays
  use omp_lib
  implicit none

  private

  public :: scene_render

  double precision, save :: t_start = -1
  double precision, save :: time_since_last_call

contains

  subroutine scene_render(buffer)
    real, intent(inout) :: buffer(:,:,:)

    double precision :: tmp_time

    integer :: image_width, image_height
    real :: aspect_ratio

    real :: time

    real :: viewport_width
    real :: viewport_height
    real :: focal_length

    real :: origin(3)
    real :: horizontal(3)
    real :: vertical(3)
    real :: lower_left_corner(3)

    type(ray_class), pointer :: ray
    real :: u, v
    integer :: i, j

    tmp_time = omp_get_wtime()
    print *, nint(1 / (tmp_time-time_since_last_call)), "FPS, ", (tmp_time - time_since_last_call)*1000, "ms/frame"
    time_since_last_call = tmp_time 

    if (t_start < 0) t_start = tmp_time
    time = real(tmp_time - t_start)

    image_width = size(buffer,2)
    image_height = size(buffer,3)
    aspect_ratio = real(image_width) / image_height

    viewport_height = (1+sin(time)**2)  * 2.0
    viewport_width = viewport_height * aspect_ratio
    focal_length = 1.0

    origin = [0.0,0.0,0.0]
    horizontal = [0.0, 0.0, viewport_width]
    vertical = [0.0, viewport_height, 0.0]
    lower_left_corner = origin - horizontal/2 - vertical/2 - [focal_length, 0.0, 0.0]

    !$omp parallel default(none) shared(buffer, image_height, image_width, horizontal, vertical, origin, lower_left_corner) &
    !$omp &  private(u, v, ray, j)

      allocate(ray)
      ray = ray_class(origin = origin, direction = lower_left_corner + u*vertical + v*horizontal - origin)
      !$omp do collapse(2)
      do i=1, image_height
        do j = 1, image_width
          u = real(i) / image_height
          v = real(j) / image_width
          ray%direction = lower_left_corner + u*vertical + v*horizontal - origin
          buffer(:,j,i) = ray_color(ray)
        end do
      end do
      !$omp end do
      deallocate(ray)
    !$omp end parallel

  end subroutine scene_render

  function ray_color(ray)
    class(ray_class), intent(in) :: ray
    real :: ray_color(3)

    real :: unit_direction(3)
    real :: normal(3)
    real :: t, tmp

    unit_direction = ray%direction / norm2(ray%direction)
    t = hit_sphere([-1.0,0.0,0.0], 0.5, ray)
    if (t < 0.0) then
      tmp = 0.5 * unit_direction(2) + 1
      ray_color = (1-tmp)*[1.0, 1.0, 1.0] + tmp*[0.5, 0.7, 1.0]
    else
      normal = ray%at(t) / norm2(ray%at(t)) - [-1.0, 0.0, 0.0]
      ray_color = 0.5  * (normal+1)
    end if

  end function ray_color

  function hit_sphere(center, radius, ray)
    real :: hit_sphere
    real, intent(in) :: center(3)
    real, intent(in) :: radius
    class(ray_class), intent(in) :: ray

    real :: oc(3)
    real :: a, half_b, c
    real :: discriminant

    oc = ray%origin - center
    a = ray%direction(1)**2 + ray%direction(2)**2 + ray%direction(3)**2
    half_b = oc(1)*ray%direction(1) + oc(2) * ray%direction(2) + oc(3) * ray%direction(3)
    c = oc(1)**2 + oc(2)**2 + oc(3)**2 - radius**2

    discriminant = half_b**2 - a*c

    if (discriminant < 0.0) then
      hit_sphere = -1.0
    else
      hit_sphere = (-half_b - sqrt(discriminant)) / a
    end if

  end function hit_sphere


end module scene
