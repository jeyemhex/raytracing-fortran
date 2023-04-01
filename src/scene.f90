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
  implicit none

  private

  public :: scene_render

contains

  subroutine scene_render(buffer)
    real, allocatable, intent(inout) :: buffer(:,:,:)

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

    viewport_height = 2.0
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
    real :: t

    unit_direction = ray%direction / norm2(ray%direction)
    t = 0.5 * unit_direction(2) + 1
    if (hit_sphere([-1.0,0.0,0.0], 0.5, ray)) then
      ray_color = [1,0,0]
    else
      ray_color = (1-t)*[1.0, 1.0, 1.0] + t*[0.5, 0.7, 1.0]
    end if

  end function ray_color

  function hit_sphere(center, radius, ray)
    logical :: hit_sphere
    real, intent(in) :: center(3)
    real, intent(in) :: radius
    class(ray_class), intent(in) :: ray

    real :: origin(3)
    real :: oc(3)
    real :: a, b, c
    real :: discriminant

    oc = origin - center
    a = norm2(ray%direction)**2
    b = 2*dot_product(oc, ray%direction)
    c = norm2(oc)**2 - radius**2

    discriminant = b**2 - 4*a*c

    hit_sphere = (discriminant > 0)
!EJH!     if (discriminant > 0) then
!EJH!       hit_sphere = .true.
!EJH!     else
!EJH!       hit_sphere = .false.
!EJH!     end if

  end function hit_sphere


end module scene
