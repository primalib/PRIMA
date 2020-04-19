! The gateway for NEWUOA
!
! Authors:
!     Tom M. RAGONNEAU (tom.ragonneau@connect.polyu.hk)
!     and Zaikun ZHANG (zaikun.zhang@polyu.edu.hk)
!     Department of Applied Mathematics,
!     The Hong Kong Polytechnic University.
!
! Dedicated to late Professor M. J. D. Powell FRS (1936--2015).

module fnewuoa
use pdfoconst ! See pdfoconst.F, which defines HUGENUM
implicit none
integer :: nf
double precision, allocatable :: fhist(:)
end module fnewuoa

subroutine mnewuoa (n,npt,x,rhobeg,rhoend,iprint,maxfun,w,f,info,funhist,ftarget)
use fnewuoa
implicit none
integer :: n,npt,iprint,maxfun,info
double precision :: x(n),rhobeg,rhoend,w((npt+13)*(npt+n)+3*n*(n+3)/2+1),f,funhist(maxfun),ftarget

nf=0
if (allocated(fhist)) deallocate (fhist)
allocate(fhist(maxfun))
fhist(:)=hugenum

call newuoa (n,npt,x,rhobeg,rhoend,iprint,maxfun,w,f,info,ftarget)

funhist=fhist

deallocate(fhist)
return
end subroutine mnewuoa

subroutine calfun (n,x,f)
use fnewuoa
implicit none
integer :: n
double precision :: x(n),f,fun
external :: fun
f=fun(n,x)

! use extreme barrier to cope with 'hidden constraints'
if (f .gt. HUGEFUN .or. f .ne. f) then
    f = HUGEFUN ! HUGEFUN is defined in pdfoconst
endif

nf=nf+1
fhist(nf)=f
return
end subroutine calfun
