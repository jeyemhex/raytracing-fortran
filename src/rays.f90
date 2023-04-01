module rays
!==============================================================================#
! RAYS
!------------------------------------------------------------------------------#
! Author:  Ed Higgins <ed.higgins@york.ac.uk>
!------------------------------------------------------------------------------#
! Version: 0.1.1, 2023-04-01
!------------------------------------------------------------------------------#
! This code is distributed under the MIT license.
!==============================================================================#
  implicit none

  private

  type, public :: ray_class
    real :: origin(3)
    real :: direction(3)

  contains
    procedure :: at => ray_at

  end type ray_class

contains

  function ray_at(this, t)
    real :: ray_at(3)

    class(ray_class), intent(in) :: this
    real,             intent(in) :: t

    ray_at = this%origin + t * this%direction
  end function ray_at

end module rays
