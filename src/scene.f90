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

contains

  subroutine scene_render(buffer, t)
    real, allocatable, intent(inout) :: buffer(:,:,:)
    integer, intent(in) :: t

    integer :: image_width, image_height
    real :: aspect_ratio

    real :: viewport_width
    real :: viewport_height
    real :: focal_length

    real :: origin(3)
    real :: horizontal(3)
    real :: vertical(3)
    real :: lower_left_corner(3)

    type(ray_class) :: ray
    real :: u, v
    integer :: i, j

    image_width = size(buffer,2)
    image_height = size(buffer,3)
    aspect_ratio = real(image_width) / image_height

    viewport_height = (1+sin(t/30.0)**2)  * 2.0
    viewport_width = viewport_height * aspect_ratio
    focal_length = 1.0

    origin = [0,0,0]
    horizontal = [0.0, 0.0, viewport_width]
    vertical = [0.0, viewport_height, 0.0]
    lower_left_corner = origin - horizontal/2 - vertical/2 - [focal_length, 0.0, 0.0]

    do i=1, image_width
      do j = 1, image_height
        u = real(i) / image_width
        v = real(j) / image_height
        ray = ray_class(origin = origin, direction = lower_left_corner + v*vertical + u*horizontal - origin)
        buffer(:,i,j) = ray_color(ray)
      end do
    end do

  end subroutine scene_render

  function ray_color(ray)
    class(ray_class), intent(in) :: ray
    real :: ray_color(3)

    real :: unit_direction(3)
    real :: normal(3)
    real :: t

    unit_direction = ray%direction / norm2(ray%direction)
    t = hit_sphere([-1.0,0.0,0.0], 0.5, ray)
    if (t > 0) then
      normal = ray%at(t) / norm2(ray%at(t)) - [-1, 0, 0]
      ray_color = 0.5  * (normal+1)
    else
      t = 0.5 * unit_direction(2) + 1
      ray_color = (1-t)*[1.0, 1.0, 1.0] + t*[0.5, 0.7, 1.0]
    end if

  end function ray_color

  function hit_sphere(center, radius, ray)
    real :: hit_sphere
    real, intent(in) :: center(3)
    real, intent(in) :: radius
    class(ray_class), intent(in) :: ray

    real :: origin(3)
    real :: oc(3)
    real :: a, half_b, c
    real :: discriminant

    oc = origin - center
    a = norm2(ray%direction)**2
    half_b = dot_product(oc, ray%direction)
    c = norm2(oc)**2 - radius**2

    discriminant = half_b**2 - a*c

    if (discriminant < 0) then
      hit_sphere = -1.0
    else
      hit_sphere = (-half_b - sqrt(discriminant)) / a
    end if

  end function hit_sphere


end module scene
