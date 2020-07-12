!=================================================
!	2 dimensional data fitting
!=================================================

!<INPUT>
!	.ctp : control parameter file
!	FLF = *.flt :  �f�w�ʋL�q�f�[�^�t�@�C��

!<OUTPUT>
!	fcof = *.cof : 
!

program INV2D

use prm_var
use mod_ctpin
use mod_starea
use mod_sttrans
use mod_inv2d

implicit none

integer :: i, ls, iu, ipl, nsource
character(LEN=24) :: flf, fcof, fctp="                        "

open(77,file="./inv2d.out")
call getarg(1,fctp)

open(9,file=fctp)

CALL SETA2D(nsource)	! ctpin.f
!���_�ƒf�w�����p�����[�^�t�@�C������ǂݍ���

do i = 1, nsource
	ls = i
	iu = 50 + i

	CALL SETFC2D(ls,flf,fcof,ipl)	! ctpin.f
		! (ipl=1) ==> MODEL FAULT IS FLAT 
		!�e�f�w�̈ʒu�E�O���b�h�T�C�Y�ȂǏ����擾

	if(ipl == 0) then

		CALL STTRANS	! blms.f
			!�f�w���W�ւ̕ϊ��W�����o�iu11, u12, t11, t12�j
		CALL STAREA		! blms.f
			!�f�w���W�ł̋�`�f�w�̈�ʒu�̓��o�ixa-xb, ya-yb�j

		open(11,file=flf,status="old")
			CALL INSURD(11)		! this file
		close(11)
			!gx,gy,gz�ɁA�f�w���W�n�ł̒f�w�ʒu�i�[���j������

		CALL SETKN		! this file
		CALL SETBM2D	! this file
		CALL SABIC2D	! this file
			!�f�w�ʂ�b-spline�ŕ\���ۂ̃p�����[�^������

		open(iu,file=fcof)
			CALL OUT2DP(flf,iu)	! this file
		close(iu)
			! �H�Hjmt �̃Z�O�����g�̒l���o�́H�H

	end if

end do

close(9)
close(77)

end program
