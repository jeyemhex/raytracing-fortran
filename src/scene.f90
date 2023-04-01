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

    type(ray_class) :: r
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
        r = ray_class(origin = origin, direction = lower_left_corner + v*vertical + u*horizontal - origin)
        buffer(:,i,j) = ray_color(r)
      end do
    end do


  end subroutine scene_render

  function ray_color(r)
    class(ray_class), intent(in) :: r
    real :: ray_color(3)

    real :: unit_direction(3)
    real :: t

    unit_direction = r%direction / norm2(r%direction)
    t = 0.5 * unit_direction(2) + 1
    ray_color = (1-t)*[1.0, 1.0, 1.0] + t*[0.5, 0.7, 1.0]

  end function ray_color

end module scene
