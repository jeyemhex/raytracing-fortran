!==============================================================================#
! C_ENTRY
!------------------------------------------------------------------------------#
! Author:  Ed Higgins <ed.higgins@york.ac.uk>
!    with the help of ChatGPT-3
!------------------------------------------------------------------------------#
! Version: 0.1.1, 2023-04-01
!------------------------------------------------------------------------------#
! This code is distributed under the MIT license.
!==============================================================================#
subroutine update_buffer_fortran(buffer, width, height)
  use iso_c_binding
  implicit none

  real(c_float), intent(inout) :: buffer(3, width, height)
  integer, intent(in) :: width, height

  call random_number(buffer)

end subroutine update_buffer_fortran
