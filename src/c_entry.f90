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
subroutine update_buffer_fortran(c_buffer, width, height)
  use iso_c_binding
  use omp_lib
  use scene
  implicit none

  real, intent(inout) :: c_buffer(3, width, height)
  integer(c_int), intent(in) :: width, height

  call scene_render(c_buffer)

end subroutine update_buffer_fortran
