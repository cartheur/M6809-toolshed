;
; SuperDos E6, Copyright (C) 1986 ???, Grosvenor.
;
; Disassembled 2004-11-05, P.Harvey-Smith.
;
; Fixed for assembly with "mamou" cross-assembler,
; from NitrOS9 cocotools.
;
; Ported to the Dragon Alpha/Professional hardware,
; 2004-11-21 P.Harvey-Smith.
;
; Ported to RS-DOS cartrage (FD-500), using WD1773,
; 2006-01-16 P.Harvey-Smith.
;
; Began porting to run natively on Tandy CoCo 1/2 
; 2006-01-26 P.Harvey-Smith.
;
; Completed port to CoCo.
; 2006-01-30 P.Harvey-Smith.
;
; The CoCo port has the following differences from the Dragon version,
; these are largely due to the fact that on the CoCo, Color basic, and 
; Extended color basic are in 2 roms that are linked, whereas the Dragon
; has the equivelent of Extended basic but all in one ROM.
; Also some of the meanings of the Low ram vectors are slightly different.
;
; 1) The RUN vector at $829C, is not called before a program is run, as DOS 
; 	takes over this vector, the upshot of this is that the parameters for
;	the PLAY command are not reset on each run. However this is easily
;	enough remedied by EXEC &H829C as the first line of your program.
;
; 2) The error hook at $88F0 is not called however, the SuperDos error handler
;	calls the Basic error handler if needed (if errors are not trapped with 
;	on error)
;
; 3) The close single file hook gets re-directed to the DOS handler, scanning the
; 	code this should only be a problem if writing a file to cassete.
;
; 4) The Console output hook is overwritten by DOS, this does not appear to have 
;	any effect.

;
; These are defined by the makefile, and are the DOS controlers supported.
;
;DragonDos	EQU		1	; Define this if compiling for Standard DragonDos Cart.
;DragonAlpha	EQU		1	; Define this if compiling for Dragon Alpha.
;RSDos		EQU		1	; Define this if compiling for the RS-DOS cart.
;
;These are also defined in the makefile and are the Machines supported.
;
;Dragon		EQU		1	; Build for Dragon 32/64/Alpha/Tano/200.
;Tandy		EQU		1	; Build for Tandy CoCo 1/2/3.
;

;
; The file RomDefs.asm contains a set of definitions for calling the ROM routines
; of either the Dragon or CoCo machines, these will be assembled conditionally
; depending on weather Dragon or Tandy is defined.
;
		ifp1
		use		dgndefs.asm
		use		romdefs.asm
		use		dosdefs.asm
		endc

		IFNE DragonDos
		
DPPIADA		EQU		DPPIA1DA
DPPIACRA	EQU		DPPIA1CRA		
DPPIADB		EQU		DPPIA1DB		
DPPIACRB	EQU		DPPIA1CRB

PIADA		EQU		DPPIADA+IO	; Side A Data/DDR
PIACRA		EQU		DPPIACRA+IO	; Side A Control.
PIADB		EQU		DPPIADB+IO	; Side A Data/DDR
PIACRB		EQU		DPPIACRB+IO	; Side A Control.

;WD2797 Floppy disk controler, used in DragonDos.
DPCMDREG	EQU		DPCmdRegD	; command/status			
DPTRKREG	EQU		DPTrkRegD	; Track register
DPSECREG	EQU		DPSecRegD	; Sector register
DPDATAREG	EQU		DPDataRegD	; Data register

CMDREG		EQU		DPCMDREG+IO	; command/status			
TRKREG		EQU		DPTRKREG+IO	; Track register
SECREG		EQU		DPSECREG+IO	; Sector register
DATAREG		EQU		DPDATAREG+IO	; Data register

; Disk IO bitmasks

NMIEn    	EQU		NMIEnD		; Enable/disable NMI
WPCEn    	EQU   		WPCEnD		; Write precomp enable
SDensEn  	EQU   		SDensEnD	; Write precomp enable
MotorOn  	EQU   		MotorOnD 	; Motor on enable

DskCtl		EQU		DskCtlD		; Disk control reg
DPDskCtl	EQU		DPDskCtlD	; Disk control reg
DriveMask	EQU		DriveMaskD	; Mask to extract drives form DskCtl
		ENDC

		IFNE	DragonAlpha

* Dragon Alpha has a third PIA at FF24, this is used for
* Drive select / motor control, and provides FIRQ from the
* disk controler.

DPPIADA		EQU		DPPIA2DA
DPPIACRA	EQU		DPPIA2CRA		
DPPIADB		EQU		DPPIA2DB		
DPPIACRB	EQU		DPPIA2CRB

PIADA		EQU		DPPIADA+IO	; Side A Data/DDR
PIACRA		EQU		DPPIACRA+IO	; Side A Control.
PIADB		EQU		DPPIADB+IO	; Side A Data/DDR
PIACRB		EQU		DPPIACRB+IO	; Side A Control.

;WD2797 Floppy disk controler, used in Alpha Note registers in reverse order !
DPCMDREG	EQU		DPCmdRegA	; command/status			
DPTRKREG	EQU		DPTrkRegA	; Track register
DPSECREG	EQU		DPSecRegA	; Sector register
DPDATAREG	EQU		DPDataRegA	; Data register

CMDREG		EQU		DPCMDREG+IO	; command/status			
TRKREG		EQU		DPTRKREG+IO	; Track register
SECREG		EQU		DPSECREG+IO	; Sector register
DATAREG		EQU		DPDATAREG+IO	; Data register

; Disk IO bitmasks

NMIEn    	EQU		NMIEnA		; Enable/disable NMI
WPCEn    	EQU   		WPCEnA		; Write precomp enable
SDensEn  	EQU   		SDensEnA	; Write precomp enable
MotorOn  	EQU   		MotorOnA 	; Motor on enable

Drive0		EQU		Drive0A
Drive1		EQU		Drive1A
Drive2		EQU		Drive2A
Drive3		EQU		Drive3A

KnownBits	EQU		Drive0+Drive1+Drive2+Drive3+MotorOn+WPCEn
DriveMask	EQU		DriveMaskD	; Mask to extract drives form DskCtl
;**** Important, about should be the DragonDos one NOT Alpha one *****

		ENDC
		
		IFNE RSDos

; This is to use the Tandy FD-500 on a Dragon running superdos.

DPPIADA		EQU		DPPIA1DA
DPPIACRA	EQU		DPPIA1CRA		
DPPIADB		EQU		DPPIA1DB		
DPPIACRB	EQU		DPPIA1CRB

PIADA		EQU		DPPIADA+IO	; Side A Data/DDR
PIACRA		EQU		DPPIACRA+IO	; Side A Control.
PIADB		EQU		DPPIADB+IO	; Side A Data/DDR
PIACRB		EQU		DPPIACRB+IO	; Side A Control.

;WD2797 Floppy disk controler, used in DragonDos.
DPCMDREG	EQU		DPCmdRegT	; command/status			
DPTRKREG	EQU		DPTrkRegT	; Track register
DPSECREG	EQU		DPSecRegT	; Sector register
DPDATAREG	EQU		DPDataRegT	; Data register

CMDREG		EQU		DPCMDREG+IO	; command/status			
TRKREG		EQU		DPTRKREG+IO	; Track register
SECREG		EQU		DPSECREG+IO	; Sector register
DATAREG		EQU		DPDATAREG+IO	; Data register

; Disk IO bitmasks

NMIEn    	EQU		NMIEnT		; Enable/disable NMI
WPCEn    	EQU   		WPCEnT		; Write precomp enable
SDensEn  	EQU   		SDensEnT	; Write precomp enable
MotorOn  	EQU   		MotorOnT 	; Motor on enable

DskCtl		EQU		DskCtlT		; Disk control reg
DPDskCtl	EQU		DPDskCtlT	; Disk control reg

Drive0		EQU		Drive0T
Drive1		EQU		Drive1T
Drive2		EQU		Drive2T
Drive3		EQU		Drive3T
DriveMask	EQU		DriveMaskT	; Mask to extract drives form DskCtl
		ENDC


		IFNE	Tandy
; Compiling to run on Tandy CoCo

NextResJump	EQU	BasStub3+StubResJumpOfs		; Jump to reserved word handler of user table
NextFuncsJump	EQU	BasStub3+StubFuncsJumpOfs	; Jump to functions handler of user table

		ELSE
; Compiling to run on Dragon 32/64/Alpha

NextResJump	EQU	BasStub2+StubResJumpOfs		; Jump to reserved word handler of user table
NextFuncsJump	EQU	BasStub2+StubFuncsJumpOfs	; Jump to functions handler of user table

		ENDC

		ORG     $C000

; Disk controler ID, if a cartrage starts with the chars 'DK', then the basic rom routines
; will do a JMP to $C002 to init the cartrage.

DC000   FCC     /DK/				

LC002   BRA     DosInit

;
; Jump table containing the addresses of the various dos routines, these should be called by :
; JSR [JumpAddr] rather than jumping directly to the routine.
; JSR [JumpAddr] rather than jumping directly to the routine.
;
        FDB     SuperDosLowLevel		; Low Level disk IO routine
        FDB     DosHWByte			; Address of data table for low level command
        FDB     SuperDosValidFilename		; Validate filename & copy to disk block.
        FDB     SuperDosOpenFile		; Open A file.
        FDB     SuperDosCreateFile		; Create file (make backup)
        FDB     SuperDosGetFLen			; Get file length
        FDB     SuperDosCloseAll		; Close all open files
        FDB     SuperDosCloseFile		; Close file
        FDB     SuperDosFRead			; Read data from file
        FDB     SuperDosFWrite			; Write data to file
        FDB     SuperDosGetFree			; Get free space on a disk
        FDB     SuperDosDeleteFile		; Delete a file
        FDB     SuperDosProtect			; Protect/unprotect file
        FDB     SuperDosRename			; Rename a file 
        FDB     SuperDosGetDirEntry		; Get a directory entry
        FDB     SuperDosFindAndRead		; Find free buffer and read sector
        FDB     SuperDosSyncDir			; Copy updated sectors from track 20 to 16 (sync direcories)
        FDB     SuperDosReadAbsSector		; Read absolute sector
        FDB     SuperDosWriteAbsSector		; Write absolute sector (no verify)

;
; Init Dos
; 
				
DosInit LDX     #DosAreaStart	; Point to bottom of dos vars area	
        TFR     X,Y		
LC02F   CLR     ,X+		; Clear a byte, increment X
        LEAY    -1,Y		; decrement counter
        BNE     LC02F		; loop again if more to do
	
; X now points to the top of the dos variable area

        TFR     X,D
        TFR     A,B
        ADDB    #$18
        STB     <BasStartProg	; Setup new begining of basic
        JSR     >BasLocateScreen
        LDA     <GrDisplayStartAddr	; Adjust graphics ram pages
        ADDA    #$06
        STA     <GrLastDisplayAddr
	
;
; Init various low ram stuff, inturrupt vectors, basic stub etc
; 
	
        LDX     #DDE24		; Point to rom copy of data to copy
LC049   LDB     ,X+		; Get byte count byte
        BEQ     LC054		; zero= end of table, exit copy
        LDU     ,X++		; Get destination address
        JSR     >UtilCopyBXtoU	; do copy
        BRA     LC049		; do next

LC054   CLR     DosHWMaskFF48	; clear hardware mask		
        COM     DosVerifyFlag		; function unknown 
        LDX     #DosNewUSRTable	; Adjust usr vector base
        STX     <BasUSRTableAddr	
        LDU     #BasFCError	; Setup the 10 usr vectors to point to BasFCError
        LDB     #$0A		; do 10
LC064   STU     ,X++		; setup vector
        DECB			; decrement count
        BNE     LC064		; loop again if more to do
	
        INC     DosDefDriveNo	
        BSR     LC09D
	
        LDX     #VectBase	; Point to ram hooks
        LDY     #RamHookTable	; Point to ram hook table in rom
        LDD     #$137E		; load A with number of vectors B with opcode for JMP
LC078   STB     ,X+		; setup jump
        LDU     ,Y++		; setup vector
        STU     ,X++
        DECA			; decrement counter
        BNE     LC078		; Loop again if more to do
	
        LDX     #ResetVector	; Setup new reset vector
        STX     <IndVecReset
        ANDCC   #$AF		; reenable inturrupts
	
        LDX     #BasSignonMess	; Print staandard Basic signon message
        JSR     >TextOutString
        JSR     >DosDoRestore
	
        LDX     #DosSignonMess
        JSR     >TextOutString
        JSR     >LDC08
        JMP     >BasCmdMode	; Jump to normal basic command mode
	

LC09D   LDA     #WDCmdForceInt	; Force WD2797 to inturrupt & reset
        STA     cmdreg
        LDX     #DosD0Online	; Clear drive online flags
        LDD     <Misc16BitScratch	; load D with 16 bit zero !!!!
        STD     ,X
        STD     2,X
	
        LDX     #Drv0Details+5	; last byte of drive details for each drive
        CLR     ,X
        CLR     6,X
        CLR     12,X
        CLR     $12,X
        
	CLR     <DosIOInProgress ; Flag to check for timeout
        
	LDX     #DosDirSecStatus ; Clear Dirctory status, FCBs etc
LC0BC   CLR     ,X+
        CMPX    #DosFCBEnd
        BNE     LC0BC


        LDB     #$04		; Count of buffers to process
        LDX     #Buff1Details	; Setup disk buffer initial values
        LDU     #$0800		; addr of buffer
LC0CB   CLR     2,X
        STB     4,X
        STU     5,X
        LEAU    $0100,U		; Increment addr for next buffer
        LEAX    7,X		; do next buffer
        DECB			; done all ?
        BNE     LC0CB		; no : do next
        RTS				

        FCB     $2A
        FCB     $20

LC0DD   LDB     DosTimeout	; Get timeout	
        STA     DosTimeout
        TSTB			; Timeout ?
        BNE     LC0ED		; no : return
        LDX     #SpinUpDelay	; wait some time for drive to spin up	
LC0E9   LEAX    -1,X
        BNE     LC0E9
LC0ED   RTS

; These bytes are here to ensure that the entry points below are at the same
; address as they are in DragonDos, so that badly behaved programs that make 
; direct calls (rather than going through jump table) will still work !
        FCC     /          /	
;
; The following code is quite clever, there are actually multiple code paths.
; This involves having a 2 byte instruction encoded as the oprand to a 3
; byte instruction eg :-
;
; L00FA	CMPX	#$C605
;
; CMPX is one byte long, so a jump to L00DB, will execute the oprand to the
; CMPX, which decodes as LDB #$05 this saves a few bytes by not having LDB #xx,
; BRA label.
;
; There are several examples of this in the Dos ROM !
;

LC0F8	LDB	#DosFnReadAddr

	FCB	Skip2		; CMPX
DosDoWriteTrack	
	LDB	#DosFnWriteTrack

	FCB	Skip2		; CMPX
DosDoWriteSec2	
	LDB	#DosFnWriteSec2  

	FCB	Skip2		; CMPX
DosDoWriteSec   
	LDB	#DosFnWriteSec

	FCB	Skip2		; CMPX
DosDoReadSec	
	LDB	#DosFnReadSec

DosDoFuncinB   
	PSHS    A
        LEAS    -2,S		; Make room on stack
        CLR     $0600		
LC10D   LDA     #$03  		; retry count ?
        STD     ,S		; save on stack
	
LC111   BSR     DosDoSeek	; Try to seek to track
        BCS     LC11D		; Error ?
        LDB     1,S		; No error, get dos op code
        STB     <DosHWByte	; Save operation to perform
        BSR     SuperDosLowLevel
        BCC     LC159		; No error 

LC11D   CMPB    #$84
        BEQ     LC148
	
        DEC     ,S		; Dec retry count
        BEQ     LC13A   	; Any retries left ?
        LDB     ,S		; get retry count
        LSRB			; gety lsbit
        BCC     LC132 		; on even numbered retry, do recal
	
        INC     <DskTrackNo	; step out a track
        BSR     DosDoSeek
        DEC     <DskTrackNo	; step back in when retrying 
        BRA     LC111

LC132   LDA     <DskTrackNo	; Save Track no whilst doing restore
        BSR     DosDoRestore	; Restore & Recalibrate
        STA     <DskTrackNo	; Put track no back
        BRA     LC111		; Try again

; We come here when all reties exhausted
LC13A   CMPB    #$80		
        BNE     LC156
        TST     $0600
        BNE     LC156
        COM     $0600
        BRA     LC152

; Something to do with dir track ? Make sure same op done to both copies of Dir
LC148   LDA     <DskTrackNo	; Get track number
        CMPA    #$14		; Track 20 ?
        BNE     LC156		; no : error
        LDA     #$10		; set track to 16
        STA     <DskTrackNo
LC152   LDB     1,S		; Get Dos op code
        BRA     LC10D		; So same to track 16

LC156   ORCC    #$01		; Flag error
        FCB	Skip1		; opcocode for BRN		
LC159	CLRB			; Flag no error
        LEAS    2,S		; Drop bytes from stack
        PULS    A,PC		; restore & return

;
; Another LDB, enbeded in CMPX sequence....
; 

DosDoReadSec2   
	LDB     #DosFnReadSec2

	FCB	Skip2		; CMPX
DosDoSeek	
	LDB	#DosFnSeek

	FCB	Skip2		; CMPX
DosDoRestore   
	LDB	#DosFnRestore
        STB     <DosHWByte	; save in hardware byte

;
; Low level hardware command, operation is in $00E8
;

SuperDosLowLevel   
	PSHS    CC,A,DP,X,Y,U
        ORCC    #$50		; Disable inturrupts
        ROR     ,S
        CLR     <DosDiskError	; Flag no disk error
        LDA     <DosHWByte	; get HW byte
        CMPA    #$07		; Valid op
        BLS     LC178		; yes : do it !
        BRA     LC180		; No: error

LC178   JSR     >ResetAndStartDrive
        BCC     LC18B		; Error ?
        LDB     #$FD		; yes flag error

        FCB     Skip2		; Andothe CMPX saving.....

LC180   LDB     #$FC		; Set error code
        ORCC    #$01		; and carry bit
        ROL     ,S
        STB     <DosDiskError	; Flag disk error
        JMP     >LC24D

; Disable IRQ

LC18B   LDX     #PIA0CRA	; Point to PIA CR A
LC18E   LDA     ,X		; Get old value
        PSHS    A		; save on stack
        ANDA    #$FC		; Turn off inturrupt
        STA     ,X++		; Save it and point to CR B
        LDA     ,X		; Get old CRB value
        PSHS    A		; save it on stack
        ANDA    #$FC		; Disable Inturrupt
        STA     ,X
        LEAX    $1E,X		; Point to next PIA
        CMPX    #PIA1CRB	; PIA1 ?	
        BCS     LC18E		; No : do disable
	
	IFEQ	RSDos
        LDA     PIACRB		; Enable FIRQ from FDC (Not on RSDos).
        ORA     #$37
        STA     PIACRB
	ENDC
	
        LDA     #$03
        PSHS    A

        LDA     <DskSectorNo	; Get disk sector no

	IFNE	RSDos
; Set side select correctly on RSDos controler.

RSDosSetSide
        CMPA    #$12		; >$12, therefore on second side
	BLS	RSDosSide0	; Yes, on side 0

	LDB	#SS0		; turn on SSO bit in FDCREG
	ORB	DosHWMaskFF48
	bra	RSDosSetSide01	; Set it

RSDosSide0
	LDB	DosHWMaskFF48	; Turn off SSO
	ANDB	#~SS0

RSDosSetSide01
	STB	DosHWMaskFF48	; Resave
	STB	DskCtl		; Write to hardware
	ENDC

        CMPA    #$12		; >$12, therefore on second side
        BLS     LC1C2		; no: don't adjust
	
        SUBA    #$12		; Calculate sector number on second side
	
	IFEQ	RSDos
        LDB     #$02		; Flag as side 2 (Dragon WD2797 only)
        ORB     DosHWMaskFF40	
        STB     DosHWMaskFF40
	ENDC
	
LC1C2   STA     secreg		; Save in sector register
        STA     <DosSectorSeek	; Save sector we are looking for
LC1C7   LDY     <Misc16BitScratch
        LDX     <DiskBuffPtr	; Point to buffer
        LDB     <DosHWByte	; Get hardware byte (function code)
        ASLB			; Calculate offset in table
        LDU     #DosFunctionTable	; Point to function dispatch table
        LDA     <DosSectorSeek	; Get sector we are seeking to
        CMPA    secreg		; Found it yet ?
        BNE     LC1C2
	
        LDA     #$FF		; Set DP=$FF, to make IO quicker
        TFR     A,DP
LC1DD   JSR     [B,U]		; Jump to function handler
        STA     <DosDiskError	; Save error code
        BCC     LC1E5		; No error : check verify
        BRA     LC213

LC1E5   ANDA    DosErrorMask	; Mask out error bits we are not interested in
        STA     <DosDiskError	; save errors for later use
        BEQ     LC1FA		; No error : jump ahead
	
        LDA     <DosHWByte	; Get operation code
        CMPA    #DosFnReadSec2	; ReadSec2 command ?		
        BEQ     LC1F6
        DEC     ,S		; Dec retry count
        BNE     LC1C7		; retry
	
LC1F6   ORCC    #$01		; Flag error
        BRA     LC213

LC1FA   TST     DosErrorMask	; is this write sector ?
        BPL     LC213		; no : jump ahead
	
        LDA     <DskTrackNo	; Get track number
        CMPA    #$14		; Primary Dir track ?
        BEQ     LC210
	
        CMPA    #$10		; Secondary dir track ?
        BEQ     LC210
	
        TST     DosVerifyFlag
        ANDCC   #$FE		; re-enable inturrupts
        BPL     LC213
	
LC210   LBSR    DosDoReadSec2	
LC213   LEAS    1,S
        ROL     4,S
        LDX     #DosD0Track-1	; Point to drive track table
        LDB     <LastActiveDrv	; Get last used drive
        ABX			; get pointer to track for current drive
        LDA     trkreg		; Get current track number from WD
        CMPA    <DskTrackNo	; Same as current track no ?
        BEQ     LC235		; yes : update table
	
        LDB     DosErrorMask	; is this a seek ?
        CMPB    #$19
        BNE     LC235
	
        LDB     #$FF
        STB     <DosDiskError
        ROR     4,S
        ORCC    #$01		; flag error
        ROL     4,S
	
LC235   STA     ,X		; Update current track for current drive
        LDX     #PIA1CRB	; Restore state of PIA from stack
LC23A   PULS    A
        STA     ,X
        PULS    A
        STA     ,--X
	
        LEAX    -$1E,X		; Do PIA0
        CMPX    #PIA0CRA
        BHI     LC23A
	
        CLR     DosHWMaskFF40	; Clear hardware mask
LC24D   CLRB			; Flag no error
        PULS    CC,A,DP,X,Y,U	; Restore regs
	
        BCC     LC289
        LDB     <DosDiskError	; get last error code
        BEQ     LC289		; no error : exit
	
        BPL     LC278

;
; Work out the dragon error code that coresponds to the hardware
; error reported by WD.
;

        CMPB    #$FC		
        BNE     LC260

        LDB     #$A4
        BRA     LC287

LC260   CMPB    #$FD
        BNE     LC268

        LDB     #$28
        BRA     LC287

LC268   CMPB    #$FE
        BNE     LC270

        LDB     #$80
        BRA     LC287

LC270   CMPB    #$FF
        BNE     LC285

        LDB     #$82
        BRA     LC287

LC278   TFR     B,A
        LDB     #$82
        ROLA
LC27D   ADDB    #$02
        ROLA
        TSTA
        BCS     LC287
        BNE     LC27D
LC285   LDB     #$A6
LC287   ORCC    #$01
LC289   RTS

;
; Reset controler chip, and spin up drive.
;

ResetAndStartDrive   
	LDA     #WDCmdForceInt		; Force inturrupt
        STA     cmdreg
        LDA     <DosLastDrive		; Get last active drive no
        BMI     LC29A			; invalid, flag error & exit
        BEQ     StartDrive		; Zero ? : yes branch on
        DECA				; Make drive number 0..3 from 1..4
        CMPA    #$03			; Drive valid ?
        BLS     StartDrive2		; yes : continue
	
LC29A   ORCC    #$01			; flag error
DosHookRetDevParam   
	RTS				; return

;
; Select drive, and start motor & load track reg.
;
; A=Drive no 0..3
;

StartDrive   
	INC     <DosLastDrive		; Flag drive 1
StartDrive2   

	IFNE		RSDos
;
; Translate Dragon Drive number to RSDos hardware number
;	Dragon		RSDos
;	00000000	00000001
;	00000001	00000010
;	00000010	00000100
;	00000011	00000100
; A=Dragon Mask
;

	leax	TDriveTab,pcr		; Point at drive table
	lda	a,x			; get drive
	ENDC
	
	ORA     #NMIEn+MotorOn		; Mask in nmi enable & Motor on bits
        PSHS    A
        LDA     DosHWMaskFF48		; Get HW byte mask

        ANDA    #~DriveMask		; Mask out drive bits	
	ORA     ,S+			; Mask in drive bits 
 	
	ifne	DragonAlpha
	LBSR	AlphaDskCtl		; Write to control reg
	else
	STA     DskCtl			; Write to control reg
	endc
		
        STA     DosHWMaskFF48		; Resave hardware mask
        LDX     #DosD0Track-1		; Point to current track table
        LDA     <LastActiveDrv		; Get active drive
        LDA     A,X			; Get drive current track
        STA     trkreg			; Write to controler
        LDA     #$D2			
        JSR     >LC0DD
        CLRB				; no error ?
        RTS
;
; Dos function 0 comes here
;

DosFunctionRestore   
	CLRA
        STA     >DskTrackNo		; Save Track number
        BRA     LC2D9

;
; Dos function 1
;

DosFunctionSeek   
	LDA     >DskTrackNo		; Get current track no
        CMPA    dptrkreg		; Are we over it ?
        BNE     SeekTrackinA		; no : seek to it
        CLRA
        STA     DosErrorMask		; Turn off verify
        TFR     A,DP			; Reset DP
        RTS

;
; Seek to a track, routine will exit either with an error, or via NMI.
; On entry A contains track to seek to.
;

SeekTrackinA   
	STA     dpdatareg
        LDA     #WDCmdSeek		; Seek command
	
LC2D9   LDB     #$19
        STB     DosErrorMask
        LDX     #DosD0StepRate-1	; Point to step rate table
        LDB     >LastActiveDrv		; Get active drive
        ORA     B,X			; Mask in that drive's step rate
        STA     dpcmdreg		; save in command reg
LC2E8   MUL				; burn up CPU time waiting....
        MUL				; NMI will exit this loop
        LEAY    -1,Y			; decrement timeout counter
        BNE     LC2E8			; count exhausted ? : no keep going
        BRA     LC337			; yes : error 



   

	ifne	RSDos
;
; Dos function 6 : Read address mark (RS-Dos)
; 
DosFunctionReadAddr   
	LDB     #WDCmdReadAddr		; Read address mark
        FCB     Skip2			; CMPX again :)

;
; Dos function 2 : Read sector (RS-Dos)
; 
DosFunctionReadSec
	LDB     #WDCmdReadSec		; Read a sector
        ORB     DosHWMaskFF40		; Mask in side etc

        LDA     #$3F
        STA     DosErrorMask

	BSR	TSetHalt		; Get IO byte with halt enabled in A

        STB     dpcmdreg		; Send command to controler.

	ldb	#02			; Busy bit
LC301	bitb	<DPCMDREG		; still busy ?
	BNE	TReadSec		; no : read sector
        LEAY    -1,Y			; decrement timeout count
        BNE     LC301			; check for int again, if no timeout
	
TReadSec
	
RNext	LDB	dpDataReg		; Get byte
	STB	,X+			; save in mem
	STA	dpDSKCTL		; Update reg
	BRA	RNext	

	ELSE

;
; Dos function 6 : Read address mark (Dragon)
; 

DosFunctionReadAddr   
	LDA     #WDCmdReadAddr		; Read address mark
        FCB     Skip2			; CMPX again :)
;
; Dos function 2 : Read sector (Dragon/Cumana)
; 
DosFunctionReadSec
	LDA     #WDCmdReadSec		; Read a sector
        LDB     #$3F
        STB     DosErrorMask

        LDB     #$05			; try 5x$FFFF for timeout
        ORA     DosHWMaskFF40		; Mask in side etc
        STA     dpcmdreg

LC301   LDA     dppiacrb		; Check for INT from WD
        BMI     LC311			; yes : start reading bytes 
        LEAY    -1,Y			; decrement timeout count
        BNE     LC301			; check for int again, if no timeout
        LDA     dppiadb
        DECB				; decrement retry wait count
        BNE     LC301			; count=0 ?, no continue waiting
        BRA     LC337			; yes : error and exit

;
; Read sector/address mark loop, exits with NMI.
;

LC310   
	SYNC				; Syncronise to FIRQ (INT from WD)
	
LC311   LDB     dppiadb			; clear iunturrupt
        LDA     dpdatareg		; read byte from WD
        STA     ,X+			; save in buffer
        BRA     LC310			; do next byte
	ENDC

;
; Dos function 7 read first two bytes of a sector, used by BOOT command.
;

DosFunctionReadSec2   
	LDX     #$004F			
        LDA     #$3F
        STA     DosErrorMask

	IFNE	RSDos
;
; Code to wait for DRQ when using RS-DOS controler.
;
	BSR	TSetHalt		; Get IO byte with halt enabled in A

        LDB     #WDCmdReadSec		; Read sector command
        ORB     DosHWMaskFF40		; mask in heads etc
        STB     dpcmdreg		; write it to WD

LC32A	LDB	#$02			; Bitmask for DRQ
	BITB	<DPCMDREG		; DRQ asserted ?
	BNE	LC343			; Yes, read data
	LEAY    -1,Y			; decrement timeout
        BNE     LC32A			; check again
        
	ELSE
;
; Code to wait for DRQ when using Dragon/Cumana controlers.
;
        LDB     #$05			; Wait 5x$FFFF 
        LDA     #WDCmdReadSec		; Read sector command
        ORA     DosHWMaskFF40		; mask in heads etc
        STA     dpcmdreg		; write it to WD

LC32A   LDA     dppiacrb		; Check for Int from WD
        BMI     LC343			; yes : start reading
        LEAY    -1,Y			; decrement timeout
        BNE     LC32A			; check again
        LDA     dppiadb			; try clearing int
        DECB				; decrement outer count
        BNE     LC32A			; keep going ?
	ENDC
	
LC337   LDA     #WDCmdForceInt		; Force the WD to abort
        STA     dpcmdreg
        CLRA				; Reset DP to page 0
        TFR     A,DP
        LDA     #$FE			; return error
        ORCC    #$01
        RTS

; Read data from WD, as normal exited with NMI

	IFNE	RSDos
;
; Read bytes code when using RS-DOS controler.
;
LC343
;	LDA	DosHWMaskFF48		; Get Drive control reg
;	ORA	#HaltEn			; enable halt
	
	LDB	dpDataReg		; Get byte
	STB	,X+			; save in mem
	STA	dpDSKCTL		; Update reg

	LDB	dpDataReg		; Get byte
	STB	,X			; save in mem
	STA	dpDSKCTL		; Update reg
	
LC350	LDB	dpDataReg		; clear DRQ
	STA	dpDSKCTL		; Update reg
	
	BRA	LC350	
	ELSE
;
; Read bytes code when using Dragon/Cumana controlers.
;
LC343   LDA     dpdatareg		; read byte from WD
        TST     dppiadb			; clear inturrupt
        STA     ,X+			; save in memory
        
	SYNC				; wait for next
	
	LDA     dpdatareg		; get next byte
        TST     dppiadb			; clear inturrupt
        STA     ,X			; save byte
LC350   
	SYNC				; wait for next
	
	TST     dppiadb			; clear inturrupt
        LDA     dpdatareg		; read byte
        BRA     LC350			; do next
	ENDC

	IFNE	RSDos
;
; Load Reg A with CmdReg mask & enable halt, making this a sub, saves a few bytes !
;
TSetHalt	
	LDA	DosHWMaskFF48		; Get Drive control reg
	ORA	#HaltEn			; enable halt
	RTS
	ENDC
;
; Dos function 4
;

DosFunctionWriteSec2   
	LDA     #$5F

        FCB     Skip2

;
; Dos function 3
;

DosFunctionWriteSec   
	LDA     #$DF
        STA     DosErrorMask
        BSR     DosSetPrecomp	; Setup write precomp
	
	IFNE	RSDos
;
; Write sector for RS-DOS controlers.
;
;	LDA	DosHWMaskFF48	; Get Drive control reg
;	ORA	#HaltEn		; enable halt

	BSR	TSetHalt	; Get IO byte with halt enabled in A

        LDB     #WDCmdWriteSec	; Write sector
        ORB     DosHWMaskFF40	; Mask in side etc
        STB     dpcmdreg	; write to WD
	
	LDB	#2		; DRQ MASK
LC36A	BITB	<DPCMDREG	; DRQ asserted ?
	BNE	LC374		; Yes, go write data
	LEAY	-1,Y		; Decrement count
        BNE     LC36A		; if not timed out continue waiting
        BRA     LC337		; timout, abort, and return error

LC374	LDB	,X+		; Fetch byte to write
	STB	DPDataReg	; Write it
	STA	DPDskCtl	; Halt controler
	BRA	LC374
	
	ELSE
;
; Write sector for Dragon/Cumana controlers.
;
	LDA     #WDCmdWriteSec	; Write sector
        ORA     DosHWMaskFF40	; Mask in side etc
        STA     dpcmdreg	; write to WD

        LDA     ,X+		; fetch first byte to write

LC36A   LDB     dppiacrb	; Int from WD ?
        BMI     LC377		; yes : start writing
        LEAY    -1,Y		; decrement timeout
        BNE     LC36A		; if not timed out continue waiting
        BRA     LC337		; timout, abort, and return error

; Write sector loop, NMI breaks out of here

LC374   LDA     ,X+		; get byte to write
        
	SYNC			; wait for WD
	
LC377   STA     dpdatareg	; write byte to WD
        LDA     dppiadb		; clear inturrupt
        BRA     LC374		; Do next byte

	ENDC
;
; Dos function 5 : Write (format) track
;

DosFunctionWriteTrack   
	LDA     #$47
        STA     DosErrorMask
        BSR     DosSetPrecomp	; Set write precomp
	

	IFNE	RSDos
	BSR	TSetHalt	; Get IO byte with halt enabled in A
	
        LDB     #WDCmdWriteTrack	; Write (format) track			
        ORB     DosHWMaskFF40	; Mask in head etc
        STB     dpcmdreg
	
	STA	dpDskCtl	; Set halt etc
	
LC38B   LDD     ,X++		; Get bytes to write A=count, B=byte
LC38D   
	STB     dpdatareg	; Write a byte on track
        DECA			; decrement byte count
        BNE     LC38D		; continue until count=0
	
        LDB     ,X+		; get next 
        
	STB     dpdatareg	; write to wd
        BRA     LC38B		; do next block
	
	ELSE

        LDA     #WDCmdWriteTrack	; Write (format) track			
        ORA     DosHWMaskFF40	; Mask in head etc
        STA     dpcmdreg

LC38B   LDD     ,X++		; Get bytes to write A=count, B=byte
LC38D   
	SYNC			; Wait for WD
	
	CMPA    dppiadb		; Clear inturrupt
	STB     dpdatareg	; Write a byte on track
        DECA			; decrement byte count
        BNE     LC38D		; continue until count=0
	
        LDA     ,X+		; get next 
        
	SYNC
	CMPA    dppiadb		; Clear int
	
        STA     dpdatareg	; write to wd
        BRA     LC38B		; do next block
	ENDC
;
; Set write precompensation based on track
;

DosSetPrecomp   
	LDA     dptrkreg	; Get track 
        CMPA    #TrackPrecomp	; track < 16
        BLS     LC3AB		; no : no write precomp
        
	LDA     DosHWMaskFF48	; Enable precomp
        ORA     #WPCEn
        BRA     LC3B0		; Write to controler

LC3AB   LDA     DosHWMaskFF48	; Turn off precomp
        ANDA    #~WPCEn	;#$EF
LC3B0   
	ifne	DragonAlpha
	LBSR	AlphaDskCtl	; Write control reg
	else
	STA     DskCtl		; Write control reg
	endc
		
        RTS

;
; Dskinit dispatch routine
;
; Syntax :
;	DSKINIT				(default drive,sides,tracks)
;	DSKINIT drive			(specified drive, default sides,tracks) 
;	DSKINIT drive,sides		(specified drive,sides default tracks) 
;	DSKINIT drive,sides,tracks	(specified drive,sides,tracks)
;

CmdDskInit   
	BEQ     LC3D9		; No parameters : use defaults
        JSR     >GetDriveNoInB	; Get drive no
        STB     <DosLastDrive	; save it
        JSR     >GetCommaThen8Bit	; Get comma, and then no of sides
        BEQ     LC3DE		; Error, use default sides & tracks
	
        DECB			; Convert sides to zero base
        CMPB    #$01		; > 1 sides specified : error & exit
        BHI     LC3D6
        
	STB     <DosRecLenFlag		; Save sides
        JSR     >GetCommaThen8Bit	; Get comman, then tracks
        BEQ     LC3E0		; Error : use default tracks
        
	CMPB    #$28		; 40 tracks ?
        BEQ     LC3E2		; Yes skip on
	
        NEG     <DosRecLenFlag
        CMPB    #$50		; 80 tracks ?
        BEQ     LC3E2		; yes, skip on
LC3D6   JMP     >DosPRError

;
; Set defaults for format : disk=1,sides=1,tracks=40
;
LC3D9   LDB     DosDefDriveNo		; Get default drive
        STB     <DosLastDrive	; Save as last used drive
LC3DE   CLR     <DosRecLenFlag		; 1 side only 
LC3E0   LDB     #$28		; 40 tracks
LC3E2   STB     <DosBytesInDTA

        JSR     >DosHookCloseSingle	; Close single file ????
        LBNE    CmdDskInitErrorExit
	
        LDX     #$0800		; Pointer to param area for format
        STX     <DiskBuffPtr
        JSR     DosDoRestore	; Restore to track 0
        BNE     CmdDskInitErrorExit		; Error : exit
        LDA     #$01
        STA     <DskSectorNo
        JSR     >DosDoReadSec2	; Read sector from disk to be formatted ?
        CMPB    #$80
        BEQ     CmdDskInitErrorExit
	
LC400   CLR     <DosNoBytesMove
        CLR     <DskSectorNo
        JSR     >SetupTrackImage
        JSR     >DosDoWriteTrack
        BCS     CmdDskInitErrorExit
        TST     <DosRecLenFlag
        BEQ     LC41F
        LDA     #$01
        STA     <DosNoBytesMove
        NEGA
        STA     <DskSectorNo
        JSR     >SetupTrackImage
        JSR     >DosDoWriteTrack
        BCS     CmdDskInitErrorExit
LC41F   INC     <DskTrackNo
        LDA     <DskTrackNo
        CMPA    <DosBytesInDTA
        BCS     LC400
        JSR     >DosDoRestore
        BCS     CmdDskInitErrorExit
LC42C   JSR     >DosDoSeek
        BCS     CmdDskInitErrorExit
        CLRA
        JSR     >LC4F2
        INC     <DskTrackNo
        LDA     <DskTrackNo
        CMPA    <DosBytesInDTA
        BCS     LC42C
        LDX     <DiskBuffPtr
        LDD     <Misc16BitScratch
LC441   STD     ,X++
        CMPX    #$0B00
        BNE     LC441
        LDA     #$01
        STA     <DskSectorNo
        LDA     #$14
        BSR     LC45A
        DEC     <DskSectorNo
        DEC     <DiskBuffPtr
        LDA     #$10
        BSR     LC460
        BRA     LC474

LC45A   PSHS    A
        BSR     LC49B
        PULS    A
LC460   STA     <DskTrackNo
        JSR     >DosDoWriteSec
        BCS     CmdDskInitErrorExit
        INC     <DskSectorNo
        INC     <DiskBuffPtr
        JSR     >DosDoWriteSec
        BCS     CmdDskInitErrorExit
        RTS

;
; Exit with error, allow basic to handle it.
;

CmdDskInitErrorExit   
	JMP     >DosHookSysError

LC474   INC     <DiskBuffPtr
        LDX     <DiskBuffPtr
        LDD     #$890A
LC47B   STA     ,X
        LEAX    $19,X
        DECB
        BNE     LC47B
        BSR     LC489
        LDA     #$14
        STA     <DskTrackNo
LC489   LDD     #$1003
        STB     <DskSectorNo
LC48E   JSR     >DosDoWriteSec
        BCS     CmdDskInitErrorExit
        INC     <DskSectorNo
        DECA
        BNE     LC48E
        JMP     >LC09D

LC49B   STA     <DskTrackNo
        LDA     #$12
        LDB     #$5A
        TST     <DosRecLenFlag
        BEQ     LC4A7
        ASLB
        ASLA
LC4A7   STA     $08FD
        COMA
        STA     $08FF
        LDA     <DosBytesInDTA
        STA     $08FC
        TST     <DosRecLenFlag
        BNE     LC4BC
        CMPA    #$50
        BNE     LC4BC
        ASLB
LC4BC   COMA
        STA     $08FE
        LDX     <DiskBuffPtr
        LDU     #$0900
        LDA     #$FF
LC4C7   STA     ,X+
        DECB
        BNE     LC4C7
        LDD     #$242D
        TST     <DosRecLenFlag
        BEQ     LC4E0
        BPL     LC4DD
        LDD     #$B4FF
LC4D8   STB     ,U+
        DECA
        BNE     LC4D8
LC4DD   LDD     #$485A
LC4E0   LDU     <Misc16BitScratch
        PSHS    A
        BSR     LC4E8
        PULS    B
LC4E8   LDX     <DiskBuffPtr
        ABX
        LDA     #$FC
        STU     ,X++
        STA     ,X
        RTS

LC4F2   CLR     <DskSectorNo
        TST     <DosRecLenFlag
        BEQ     LC4FA
        BSR     LC4FA
LC4FA   LDA     #$12
LC4FC   INC     <DskSectorNo
        JSR     >DosDoReadSec2
        LBCS    CmdDskInitErrorExit
        DECA
        BNE     LC4FC
LC508   RTS

;
; Setup format block for write track
;

;LC509
SetupTrackImage   
	LDU     <DiskBuffPtr
        LDX     #DDDFD
        LDY     #DDDEA
        LDB     #$0C
        BSR     LC537
LC516   LDX     #DDE09
        LDB     #$06
        BSR     LC537
        LDA     #$01
        LDB     <DskTrackNo
        STD     ,U++
        LDB     <DosNoBytesMove
        STB     ,U+
        LDB     ,Y+
        STD     ,U++
        STA     ,U+
        LDB     #$12
        BSR     LC537
        TST     ,Y
        BNE     LC516
        LDB     #$03
LC537   JMP     >UtilCopyBXtoU

;
; GetCommaThen8Bit, scan for comma, error if not found, then fetch 8 bit that follows (or error). 
;

GetCommaThen8Bit   
	JSR     <BasChrGetCurr		; Get current basic char
        BEQ     LC508			; Any left no: return 
        JSR     >VarCKComma		; check for comma
        JMP     >Get8BitorError		; go get it

;
; Backup command dispatch routine
;
; Syntax :-
;	BACKUP SrcDrive TO Destdrive,heads,tracks
;
; Stack frame as follows :
;	16 bytes cleared on stack, U points to base of this area as with OS-9.
;
;	0,U	Drive number of source ?
;	1,U	$00 Source track
;	2,U	$01 Source sector
;	3,U	$DF5A ???
;	5,U	Source buffer addr
;	7,U	Drive number of dest ?
;	8,U	$00 Dest track
;	9,U	$01 Dest sector ????
;	10,U	$DF6D ???
;	12,U	dest buff addr
;	14,U	$12 Sector count per track to copy ?
;	15,U	Page number of top of usable RAM


CmdBackup   
	LEAS    -16,S		; Make tempory space on stack
        TFR     S,U		; Point U at base of tempory space (Like OS-9 !)
        TFR     U,D		
        SUBD    #$0040		; reserve room for working stack
        SUBD    <BasVarEnd	; Check that we have suficient memory available
        LBMI    BasOMError	; NO: report ?OM error
	
        CMPA    #$01		; At least 1 sector's worth of ram (256 bytes) available
        LBLT    BasOMError	; NO: report ?OM error
        STA     BupAvailPages,U	; Store memory page count of avaiable RAM
        LDA     #$12		; Sectors per track, initially 18 for SS disk
        STA     BupSecTrk,U
        LDD     <BasVarEnd	; Get end of RAM in use by basic
        STD     BupSrcBuff,U	; save in buffer pointers for source and dest
        STD     BupDestBuff,U

        LDD     #$DF5A		; Error masks ?
        STD     3,U
        LDD     #$DF6D
        STD     10,U

        LDD     #$0001		; Set source and dest track and sector to 0 & 1
        STD     BupSrcTrk,U
        STD     BupDestTrk,U
        LDA     DosDefDriveNo	; Get default drive no
        STA     BupSrcDrive,U	; save in source drive
        STA     BupDestDrive,U	; and dest
        LDY     #$02D0		; sector count 720 sectors=ss40 disk
        
	JSR     <BasChrGetCurr
        BEQ     DoCmdBackup	; No params backup from default drive to default 
        JSR     >Get8BitorError
        CMPB    #$04		; greater than Max drive (4)?
        LBHI    DosDNError
	
        STB     BupSrcDrive,U	; Save source drive
        STB     BupDestDrive,U	; and default dest to same drive
        
	JSR     <BasChrGetCurr	; Get current character from basic
        BEQ     DoCmdBackup	; end of line : yes do backup
        
	CMPA    #$BC		; is this the "TO" token ?
        BNE     CmdBackupErrorExit	; no : error, exit
        
	JSR     <BasChrGet	; Get next char, skip over "TO"
        JSR     >Get8BitorError	; Get dest drive in B
        CMPB    #$04		; Invalid drive no ?
        LBHI    DosDNError	; yes : error, exit
        STB     BupDestDrive,U	; Save in Dest driveno
        
	BSR     GetCommaThen8Bit	; Skip comma, and get next param
        BEQ     DoCmdBackup	; nothing : do backup
        CMPB    #$02		; 2 sided disk specified ?
        BEQ     BackupDS	; yes backup double sided
        CMPB    #$01		; 1 sided disk specified ?
        BEQ     BackupSS	; yes backup single sided
	
CmdBackupErrorExit   		
	JMP     >BasSNError	; error : exit

BackupDS   
	TFR     Y,D		; Double sector count if double sided
        LEAY    D,Y
        ASL     BupSecTrk,U	; Set sectors per track for DS disk

BackupSS   	
	JSR     >GetCommaThen8Bit	; Get next param (if any)
        BEQ     DoCmdBackup	; none: continue
        CMPB    #$50		; Is this an 80 track backup ?
        BEQ     Backup80
        CMPB    #$28		; Or a 40 track backup ?
        BEQ     DoCmdBackup	
        BRA     CmdBackupErrorExit	; neither error and exit 

Backup80   
	TFR     Y,D		; Double sector count if 80 track
        LEAY    D,Y
	
DoCmdBackup   
	CLRA

BupReadFromSrc   
	LEAY    1,Y		; Get sector count
        LEAX    BupSrcDrive,U	; point to source drive on stack frame
        BSR     LC643		; read 1 sector
LC5D6   LEAY    -1,Y		; decrement sector count
        BNE     LC5E0		; if more sectors, do next
        BSR     BupWriteToDest	; no : write final sectors to destination
        LEAS    $10,U		; Clear stack frame
LC5DF   RTS			; return to caller

LC5E0   CMPA    BupAvailPages,U	; Filled all available RAM pages ?	
        BNE     LC5F2		; no : do next sector
        BSR     BupWriteToDest	; Yes : write to destination
        PSHS    D
        LDD     <BasVarEnd	; Get end of basic storage
        STD     BupDestBuff,U	; Save in source and dest buffer pointers
        STD     BupSrcBuff,U
        PULS    D
        BRA     BupReadFromSrc	; Do next sector

LC5F2   LDB     #$02		
        BSR     LC608
        INCA
        BRA     LC5D6

BupWriteToDest   
	TSTA
        BEQ     LC5DF
        LEAX    BupDestDrive,U	; Point to dest drive vars
        BSR     LC643	
DC600   LDB     #$03
LC602   BSR     LC608
DC604   DECA
        BNE     LC602
LC607   RTS

LC608   PSHS    D
        LDA     BupDrive,X	; Get  drive
        STA     <LastActiveDrv	; Set last active drive
        
	LDD     BupBuff,X
        STD     <DiskBuffPtr	; Setup disk buffer pointer
        LDD     BupTrk,X
        STD     <DskTrackNo	; and disk track no
        LDB     1,S		; Get function, read or write
        JSR     >DosDoFuncinB
        BCC     LC631		; no error continue
        STB     DosErrorCode		; Temp storage (error code from dos)
	
        LDA     1,S		; Get function, read or write
        CMPA    #DosFnReadSec	; Read ?
        BRA     LC62B

	PULS	D,X
;        FCB     $35
;        FCB     $16

	JSR	BupWriteToDest

;        FCB     $BD
;        FCB     $C5
;        FCB     $F9

LC62B   LDB     DosErrorCode		; Retrieve error code
        JMP     >DosHookSysError

LC631   INC     2,X		; Increment sector number
        LDA     2,X		; check sector number
        CMPA    14,U		; Done all sectors on track ?
        BLS     LC63F		; No: do next sector
        
	LDA     #$01		; Reset sector count to 1
        STA     2,X
        INC     1,X		; Increment track count
LC63F   INC     5,X		; Move to next page of buffer
        PULS    D,PC		; restore and return

LC643   LDB     ,U		; get source drive
        CMPB    7,U		; same as dest drive ?
        BNE     LC607		; no : continue
	
        PSHS    A,X,Y,U
        JSR     >TextCls	; clear screen
        LDX     1,S		; get message pointer
        LDX     3,X
        JSR     >TextOutString	; Print message (insert source/insert dest)
        LDX     #MessPressAnyKey
        JSR     >TextOutString	; Print press any key
        JSR     >TextWaitKeyCurs2	; Wait for a kepress
        JSR     >TextCls
        PULS    A,X,Y,U,PC
;
; Get8BitorError, get non zero 8 bit value in B, or generate error
;
Get8BitorError   
	PSHS    Y,U
        JSR     >VarGet8Bit	; Get 8 bit value into B
        TSTB			; B non zero ?
        BNE     LC66E
        JMP     >BasFCError	; No : error

LC66E   PULS    Y,U,PC		; Restore and return

LC670   CMPA    #$FF
        LBEQ    BasSNError
        SUBA    #$CE
        BPL     LC67D
LC67A   JMP     >BasSNError

LC67D   CMPA    #$1A
        BCC     LC687
        LDX     #CommandDispatchTable
        JMP     >BasDoDipatch

LC687   JMP     [>NextResJump]	; Jump to user reserved word handler >$0137

LC68B   SUBB    #$44
        BPL     LC691
        BRA     LC67A

LC691   CMPB    #$0E
        BCC     LC69D
        LDX     #FunctionDipatchTable
        JSR     [B,X]
        JMP     >VarGetExprCC

LC69D   JMP     [>NextFuncsJump]	; Jump to user function handler >$013C

LC6A1   LDX     #Buff1Details
LC6A4   JSR     >LD2E2
        BNE     DosHookSysError
        CLR     2,X
        LEAX    7,X
        CMPX    #DosCurDriveInfo	; $0650
        BCS     LC6A4
LC6B2   RTS

;
; Get drive no in B, returns drive no (from command) in B,
; or causes error if (drive < 0 ) or (drive > 4)
;

GetDriveNoInB   
	JSR     >VarGet8Bit	; Get 8 bit var
        TSTB
        BMI     DosDNError	; Minus, invalid drive
        BNE     LC6BC		; greater than 0, check < 4
        INCB			; =0 increment so drive 0 = drive 1
LC6BC   CMPB    #$04		; Drive in range 
        BLS     LC6B2		; Yes : return it in B

DosDNError   
	LDB     #$28
   
	FCB	Skip2		; CMPX
DosPRError
	LDB 	#$A4

DosHookSysError   
	STB     DosErrLast		; save last error code
        LDX     <BasCurrentLine		; Get current line no
        STX     DosErrLineNo		; save for ERR routine
        JSR     >BasResetStack		; reset basic stack
        CLR     <DosIOInProgress	; Flag no IO in progress
        CLR     <TextDevN		; Set device no back to console
        TST     DosErrGotoFlag		; Do we have an error handler ?
        BPL     LC6DF			; Yes, handle errors
        LDX     <BasCurrentLine		; Get current line no
        LEAX    1,X
        BNE     LC6F9
	
LC6DF   JSR     >TextOutCRLF		; Output a return
        JSR     >CasMotorOff		; turn off cassette motor
        JSR     >SndDisable		; disable cassette sound
        JSR     >TextOutQuestion 	; output '?'
        LDX     #BasErrorCodeTable	; Point to error code table $82A9
        LDB     DosErrLast		; Get last error code
        BPL     LC6F6
	LDX	#DosErrorCodeTable-$80 	; Get pointer to error table !
LC6F6   JMP     >SysErr2		; Jump to basic Error handler

LC6F9   LDX     #BasBRARun		; Go back to main interpreter loop $84DA
DC6FC   PSHS    X
        LDD     DosErrDestLine
        STD     <BasTempLine
        JMP     >BasSkipLineNo

;
; New reset vector
;

ResetVector   
	NOP			; Main ROM checks for reset->NOP
        CLRA			; Reset DP=0
        TFR     A,DP		
        JSR     >LC09D		; Reset WD, and various Dos vars.
        CLR     DosErrorMask	; reset various flags
        CLR     DosTimeout
        CLR     DosAutoFlag
        LDA     #$35		; Re-enable NMI
        STA     PIA0CRB
        JMP     >WarmStart	; Jump back to Main ROM reset routine

;
; NMI vector, called to break out of read & write loops between 6809 & WD
; This allows the IO routines to handle sectors of all lengths.
;

NMISrv   
	LDA     dpcmdreg	; Read status register.
        CLRB			; Reset DP=0
        TFR     B,DP
        LEAS    12,S		; Drop registers from stack
        TSTA			; Setup CC
LC726   RTS			; Return to caller

;
; New IRQ vector, used to count down and shut off drives.
;

IRQSrv  CLRA			; Reset DP=0
        TFR     A,DP
        TST     <DosIOInProgress ; Doing IO ?
        BNE     LC748		; Yes: don't time out
        LDA     DosTimeout	; Get timeout byte 
        BEQ     LC748		; Already timed out : exit
        DECA			; Decrement timeout count
        STA     DosTimeout	
        BNE     LC748		; not zero, don't timeout yet
        BSR     SuperDosSyncDir	; syncronsise directory 
        BNE     LC74B		; Error : report it
        LDA     DosHWMaskFF48	; turn off motor in hw byte

	IFNE	RSDos
	ANDA	#~DriveOffMaskT	; On RSDos turn off motor & deslect drives 
	ELSE
        ANDA    #~MotorOn	
	ENDC
	STA     DosHWMaskFF48	; Just turn off drives on Dragon
		
	ifne	DragonAlpha
	LBSR	AlphaDskCtl	; Actually turn off motor
	else
        STA     DskCtl		; Actually turn off motor
	endc
		
LC748   JMP     >BasIRQVec	; Jump to BASIC IRQ

LC74B   JMP     >DosHookSysError		; Jump to system error trap

LC74E   TFR     S,D
        SUBD    #$0100
        SUBD    <BasVarEnd
        BMI     LC75B
        CLRB
        TSTA
        BNE     LC726
LC75B   JMP     >BasOMError

;
; Copy directory from track 20 to track 16.
;

SuperDosSyncDir   
	JSR     >LC6A1
        LEAS    -8,S			; Make room on stack
        LEAU    ,S			; Point U at stack frame
        LEAY    4,U
        LDX     #DosDiskBuffBase	; Point at tempory buffer area
        STX     <DiskBuffPtr
        CLR     2,U
        LDB     <DosLastDrive		; Get last accessed drive
        STB     1,U			; Save it
        LDB     #$01
        STB     ,U
        CLR     <DosLastDrive
        LDX     #DosDirSecStatus-1	; $06AA
	
LC77B   LDB     #SectorsPerTrack	; Sector count
        STB     3,U
        INC     <DosLastDrive

LC781   LDB     3,U
        LDA     B,X
        BITA    ,U
        BEQ     LC7A7

        COMA
        ANDA    B,X
        STA     B,X
        INC     2,U
        STB     <DskSectorNo
        STB     ,Y+
        LDB     #DirPrimary		; Track 20
        STB     <DskTrackNo		
        JSR     >DosDoReadSec		; Go read sector
        BNE     LC7BE			; Error !
	
        INC     <DiskBuffPtr		; use next disk buffer
        LDB     2,U			; Check to see if we have filled all buffers
        CMPB    #$04
        BCS     LC7A7
        BSR     LC7C1

LC7A7   DEC     3,U
        BNE     LC781
        TST     2,U
        BEQ     LC7B1
        BSR     LC7C1
	
LC7B1   ASL     ,U
        LDA     ,U
        CMPA    #$08
        BLS     LC77B
	
        LDA     SyncDrive,U		; Restore last used drive
        STA     <DosLastDrive
        CLRB				; Flag no error
LC7BE   LEAS    8,U			; Drop stack frame
        RTS

LC7C1   LDA     #DirBackup		; Backup track no
        STA     <DskTrackNo
LC7C5   DEC     <DiskBuffPtr
        LEAY    -1,Y
        LDA     ,Y
        STA     <DskSectorNo		; Pickup sector no
        JSR     >DosDoWriteSec		; Go write it
        BEQ     LC7D5
        LEAS    8,U
        RTS

LC7D5   DEC     2,U
        BNE     LC7C5
        RTS

FIRQSrv   
	TST     PIACRA		; Clear Inturrupt conditions 
        TST     PIACRB
        RTI			; and return
	
DosValidateAndOpen   
	BSR     SuperDosValidFilename	; Validate filename
        BNE     LC857			; Error : exit
        JMP     >SuperDosOpenFile	; Open file if valid

;
; Validate filename and copy to current drive block
;
;	  On entry:
;	    X points to filename e.g. '3:FILENAME.EXT'
;	    B length of filename e.g. 0x0e
;	    Y points to default extension to use if none is given e.g. 'DAT'.
;             Use '   ' for no default extension
;	  On Return:
;	    Filename appears at $0650-$065a
;	    CC.Z clear on error
;	    B contains error code
;	    U $065b always (SuperDosE6)
;


SuperDosValidFilename   
	LDA     DosDefDriveNo
        STA     DosCurDriveNo		; Set current drive number, default if non specified
        CLR     DosCurCount
        LDU     #DosCurDriveInfo	; Point at current drive info

        LDA     #$07			; Zero out first 8 bytes (filename)	
LC7F6   CLR     A,U
        DECA
        BPL     LC7F6
        
	LDA     2,Y			; Transfer extension into current details
        STA     DosCurExtension+2	; $065A
        LDA     1,Y
        STA     DosCurExtension+1	; $0659
        LDA     ,Y
        STA     DosCurExtension		; $0658
	
        CMPB    #MaxFilenameLen		; Filename too long ?
        BHI     LC855			; Yep : error
	
        TSTB				; Too short ?
        BEQ     LC855			; Yep : error
	
        CMPB    #$03			; Long enough to contain drive no ?
        BCS     LC83D			; nope : skip on
	
; Because of the order of compare a drive letter at the END of the filename always
; takes presedence, this would only be siginificant if the filename where something like
; '1:2' which would access a file called '1' on drive 2, and NOT 2 on drive 1
	
        SUBB    #$02			; Look for drive no at end of filename
        LDA     B,X
        CMPA    #':			; Seperator present ? $3A
        BNE     LC823			; No skip on
        INCB
        LDA     B,X			; Get drive no
        INCB
        BRA     LC82D			; Go process it

LC823   ADDB    #$02			; Check for drive at begining of path
        LDA     1,X
        CMPA    #':			; Seperator present ? $3A
        BNE     LC83D			; nope, use default drive
	
        LDA     ,X++			; Get ascii drive no
LC82D   SUBA    #$30			; Work out drive number
        BLS     LC835
        
	CMPA    #MaxDriveNo		; Drive valid ?
        BLS     LC838
	
LC835   LDB     #$1C			; Error !
        RTS

LC838   STA     DosCurDriveNo		; Set current drive if specified
        SUBB    #$02
	
; Parse filename looking for extension seperator
	
LC83D   LDA     ,X+			; Get next char
        DECB				; Decrement path count
        BMI     LC8A6			; Reached end : yes skip
	
        CMPA    #'/			; Check for slash $2F
        BEQ     LC84A
	
        CMPA    #'.			; Check for period $2E
        BNE     LC866
	
LC84A   CMPU    #DosCurDriveInfo	; $0650
        BEQ     LC855
	
        TST     DosCurCount		; First pass ?
        BEQ     LC858			; yes : skip on

LC855   LDB     #$96			; Error ?
LC857   RTS

LC858   INC     DosCurCount		; Mark second pass
        LDU     #DosCurExtension	; $0658
        CLR     ,U			; Zero out extension
        CLR     1,U
        CLR     2,U
        BRA     LC83D


; Validate filename chars

LC866   CMPA    #'A			; $41
        BCS     LC87A			; Below, check if still valid
	
        CMPA    #'Z			; $5A
        BLS     LC886			; valid, skip on
	
        SUBA    #$20			; Convert to lower case if upper
        CMPA    #'A			; $41
        BCS     LC855			; Invalid, return error
	
        CMPA    #'Z			; $5A
        BLS     LC886			; Valid: skip on
        BRA     LC855

LC87A   CMPA    #'-			; $2D
        BEQ     LC886			; Valid skip on
	
        CMPA    #'0			; $30
        BCS     LC855			; Invalid : error
        CMPA    #'9			; $39
        BHI     LC855			; Invalid : error
	
LC886   STA     ,U+			; Save char in path
        CMPU    #DosCurDriveNo		; Path full ?
        BNE     LC893			; nope : skip
        
	TSTB				; Done all path chars ?
        BNE     LC855			; nope : error !
        BRA     LC8A6

LC893   CMPU    #DosCurExtension	; Reached extension ? $0658
        BNE     LC83D
	
        LDA     ,X+			; Get next 
        DECB				; Dec count
        BMI     LC8A6			; Done, return
	
        CMPA    #'.			; Check for seperator $2E
        BEQ     LC84A			; yep loop back
        CMPA    #'/			; Check for seperator $2F
        BEQ     LC84A			; Yep loop back
	
LC8A6   CLRB
        RTS

;
; Open a file and copy dir entry into FCB.
;
;  On entry:
;	    Filename at $0650 ??
;	  Returns:
;	    CC.Z clear on error
;	    A FCB number (0-9)
;	    B contains error code
;


SuperDosOpenFile   
	LDX     #DosFCB0Addr		; Point to first FCB
        CLR     <DosCurrCtrlBlk
        LDD     DosCurDriveInfo		; Get first 2 bytes of current drive info
LC8B0   CMPD    ,X			; Does this FCB point to it ?
        BNE     LC8CB			; Nope : check next
	
; Found matching first 2 bytes of name in an FCB
	
        LDU     #DosCurDriveInfo+2	; Check bytes 2..end of filename
        LEAY    2,X			; Compare from byte 2 of FCB
        LDB     #$0A			; Do 10 bytes, rest of filename + ext
LC8BC   LDA     ,U+			; Get a byte from current
        CMPA    ,Y+			; compare to FCB
        BNE     LC8C8			; Don't match : exit check
        DECB				; Decrement counter
        BNE     LC8BC			; Not at end : do next
        JMP     >LC973			; Found it, already have an FCB for it

; Move to check next FCB

LC8C8   LDD     DosCurDriveInfo		; Re-get first 2 chars of current filaname
LC8CB   LEAX    DosFCBLength,X		; Skip to next FCB
        INC     <DosCurrCtrlBlk		; Set current control block
        CMPX    #DosFCBEnd		; End of blocks ?
        BCS     LC8B0			; No, loop back and check this block
	
        CLR     <DosCurrCtrlBlk		; Set current block to zero
        LDX     #DosFCB0Addr		; Point at first FCB
	
LC8DA   TST     ,X			; FCB in use ?
        BEQ     LC8EB			; No : skip on
	
        LEAX    DosFCBLength,X		; Check next FCB
        INC     <DosCurrCtrlBlk		
        CMPX    #DosFCBEnd		; Done all FCBs
        BCS     LC8DA			; No : check next, yes error, can't open file, no free FCBS
        LDB     #$A2
LC8EA   RTS

LC8EB   LDB     #$0C			; Copy 12 characters of filename
        TFR     X,Y			; Point Y at selected FCB
        LDU     #DosCurDriveInfo	; Point at current info
LC8F2   LDA     ,U+			; Copy filename
        STA     ,Y+
        DECB				; Dec count
        BNE     LC8F2			; if not all done : do next
	
        STA     <DosLastDrive		; Save current drive

; Note in disassembled source, the following was LDU #$0616, which is part of the error line !
; This makes no sense, and is Drv0Details, in DragonDos source,	I think I just fixed a 20 year old
; bug !!!!!!

        LDU     #Drv0Details		; Get drive details	 
        LDB     #$06			; 6 bytes/drive
        MUL
        LEAU    D,U			; Point at drive detail block
        INC     5,U			; Increment usage/open file count
	
        LDB     #$13			; Clear rest of FCB
LC907   CLR     ,Y+
        DECB				; Dec counter
        BNE     LC907			; Loop if more
	
        LDA     #$80
        STA     15,X
        CLR     $0681
        JSR     >DosGetDiskGeometry
        BNE     LC8EA
        LDY     ,X
        LEAY    2,Y
        LDA     #$10
        STA     DosCurCount

LC922   STY     $065C
        JSR     >SuperDosFindAndRead
        BNE     LC8EA
        LDX     5,X
        LEAU    $00FA,X
        STU     $065E
LC934   LDA     ,X
        BITA    #$81
        BNE     LC954
        LDD     DosCurDriveInfo
        CMPD    1,X
        BNE     LC954
        LDU     #$0652
        LEAY    3,X
        LDB     #$09
LC949   LDA     ,U+
        CMPA    ,Y+
        BNE     LC954
        DECB
        BNE     LC949
        BRA     LC980

LC954   LDA     ,X
        BITA    #$08
        BNE     LC970
        INC     $0681
        LEAX    $19,X
        CMPX    $065E
        BCS     LC934
        LDY     $065C
        LEAY    1,Y
        DEC     DosCurCount
        BNE     LC922
LC970   JSR     >DosFCBNoToAddr
LC973   CLRB
        TST     15,X
        BPL     LC97A
        LDB     #$A0
LC97A   LEAX    12,X
        LDA     <DosCurrCtrlBlk
        TSTB
        RTS

LC980   PSHS    X
        JSR     >DosFCBNoToAddr
        PULS    Y
        LDA     $0681
        STA     $1D,X
        LDA     ,Y
        STA     15,X
        LDD     12,Y
        STD     $15,X
        LDA     14,Y
        STA     $17,X
        STA     $19,X
        CLR     $18,X
        CLR     $13,X
        CLR     $14,X
        LDD     15,Y
        STD     $1A,X
        LDA     $11,Y
        STA     $1C,X
        LDD     #$FFFF
        STD     $10,X
        STA     $12,X
        BRA     LC973

;
; Read some data from a file into memory
;

SuperDosFRead   
	CLR     <DosIRQTimeFlag
        STA     <DosCurrCtrlBlk
        BRA     LC9CA

LC9C3   LDA     #$01

        FCB     Skip2

LC9C6   LDA     #$FF
        STA     <DosIRQTimeFlag
LC9CA   STY     $0661
        LBEQ    LCAB0
        STU     $0669
        STB     $0663
        PSHS    X
        JSR     >DosFCBNoToAddr
        LDA     11,X
        STA     <DosLastDrive
        TST     <DosIRQTimeFlag
        BNE     LC9F0
        LDD     $0661
        ADDD    13,X
        BCC     LC9EE
        INC     12,X
LC9EE   STD     13,X
LC9F0   PULS    X
        LDB     $0663
LC9F5   CLRA
        NEGB
        BNE     LC9FA
        INCA
LC9FA   CMPD    $0661
        BLS     LCA03
        LDD     $0661
LCA03   PSHS    D,X
        LDU     $0669
        JSR     >LCAB2
        BNE     LCA1B
        TFR     D,Y
        LDA     15,X
        BITA    #$02
        BEQ     LCA1E
        TST     <DosIRQTimeFlag
        BEQ     LCA1E
        LDB     #$98
LCA1B   LEAS    4,S
        RTS

LCA1E   LDX     2,S
        TST     1,S
        BNE     LCA4E
        TST     <DosIRQTimeFlag
        BEQ     LCA2F
        BPL     LCA34
        JSR     >LD330
        BRA     LCA37

LCA2F   JSR     >SuperDosReadAbsSector
        BRA     LCA37

LCA34   JSR     >SuperDosWriteAbsSector
LCA37   BNE     LCA1B
        INC     2,S
        LDX     $0669
        LEAX    1,X
        STX     $0669
        DEC     $0661
        LDD     $0661
        PULS    D,X
        BNE     LC9F5
        RTS

LCA4E   TST     <DosIRQTimeFlag
        BMI     LCA93
        JSR     >SuperDosFindAndRead
        BNE     LCA1B
        STX     $0667
        LDY     2,S
        LDB     $0663
        TST     <DosIRQTimeFlag
        BEQ     LCA87
        LDA     #$FF
        STA     2,X
        LDX     5,X
        ABX
        LDB     1,S
LCA6D   LDA     ,Y+
        STA     ,X+
        DECB
        BNE     LCA6D
        TFR     X,D
        TSTB
        BNE     LCA93
        LDX     $0667
        PSHS    Y
        JSR     >LD2E2
        PULS    Y
        BNE     LCA1B
        BRA     LCA93

LCA87   LDX     5,X
        ABX
        LDB     1,S
LCA8C   LDA     ,X+
        STA     ,Y+
        DECB
        BNE     LCA8C
LCA93   LDX     $0669
        LEAX    1,X
        STX     $0669
        TFR     Y,X
        LDD     $0661
        SUBD    ,S++
        STD     $0661
        LEAS    2,S
        BEQ     LCAB0
        CLR     $0663
        CLRB
        JMP     >LC9F5

LCAB0   CLRB
        RTS

LCAB2   JSR     >DosFCBNoToAddr
LCAB5   TFR     U,D
        SUBD    $13,X
        BCS     LCAC9
        TSTA
        BNE     LCAC9
        CMPB    $17,X
        BCC     LCAC9
        ADDD    $15,X
        BRA     LCADB

LCAC9   TFR     U,D
        SUBD    $18,X
        BCS     LCADE
        TSTA
        BNE     LCADE
        CMPB    $1C,X
        BCC     LCADE
        ADDD    $1A,X
LCADB   ORCC    #$04
        RTS

LCADE   PSHS    U
        BSR     LCB20
        BNE     LCAEF
        LDD     $066B
        CMPD    $066D
        BHI     LCAF1
        LDB     #$9A
LCAEF   PULS    U,PC

LCAF1   SUBB    2,Y
        SBCA    #$00
        STD     $13,X
        LDA     2,Y
        STA     $17,X
        LDD     ,Y
        STD     $15,X
        TFR     Y,D
        PSHS    U
        SUBD    ,S++
        PULS    U
        CMPB    #$13
        BCC     LCB1E
        LDA     5,Y
        STA     $1C,X
        LDD     3,Y
        STD     $1A,X
        LDD     $066B
        STD     $18,X
LCB1E   BRA     LCAB5

;
; Entry : X=Address of a FCB
;	  B=File number (on disk), also in $1d,X
;

LCB20   PSHS    X
        CLR     $066C
        CLR     $066B
        STU     $066D
        LDB     FCBDiskFileNo,X
        STB     DosCurFileNo
        JSR     >SuperDosGetDirEntry		; Go get directory entry
        BNE     LCB7C				; Error : exit
        TFR     X,U
        PULS    X
        LEAY    12,U
        LDB     #$04
LCB3E   LDA     ,U
        ANDA    #$20
        BEQ     LCB47
        LDA     $18,U
LCB47   PSHS    D
LCB49   LDD     $066B
        ADDB    2,Y
        ADCA    #$00
        STD     $066B
        CMPD    $066D
        BHI     LCB7B
        LEAY    3,Y
        DEC     1,S
        BNE     LCB49
        LDB     ,S
        BEQ     LCB79
        LEAS    2,S
        STB     DosCurFileNo
        PSHS    X
        JSR     >SuperDosGetDirEntry
        TFR     X,U
        PULS    X
        BNE     LCB7E
        LEAY    1,U
        LDB     #$07
        BRA     LCB3E

LCB79   LEAY    -3,Y
LCB7B   CLRB
LCB7C   LEAS    2,S				; Drop stack frame
LCB7E   RTS					; Return

;
; Write data from memory to file, verify if verify on.
;

SuperDosFWrite   
	STA     <DosCurrCtrlBlk
        STX     $0671
        STU     $0673
        STY     $0675
        STB     $0677
        JSR     >DosFCBNoToAddr
        LDB     11,X
        STB     <DosLastDrive
LCB95   JSR     >SuperDosGetFLen
        BEQ     LCBA8
        CMPB    #$9C
        BEQ     LCB9F
        RTS

LCB9F   LDA     <DosCurrCtrlBlk
        JSR     >SuperDosCreateFile
        BNE     LCB7E
        BRA     LCB95

LCBA8   CMPU    $0675
        BHI     LCBB8
        BCS     LCBB5
        CMPA    $0677
        BCC     LCBB8
LCBB5   LDB     #$9A
LCBB7   RTS

LCBB8   PSHS    A
        LDD     $0673
        ADDB    $0677
        ADCA    $0676
        PSHS    B
        TFR     A,B
        LDA     $0675
        ADCA    #$00
        PSHS    U
        SUBD    ,S++
        TFR     B,A
        PULS    B
        BHI     LCBDE
        BCS     LCBE6
        SUBB    ,S
        BCC     LCBE2
        BRA     LCBE6

LCBDE   SUBB    ,S
        SBCA    #$00
LCBE2   BSR     LCC12
        BNE     LCC0F
LCBE6   LEAS    1,S
        LDB     $0677
        LDX     $0671
        LDY     $0673
        LDU     $0675
        JSR     >LC9C3
        BNE     LCBB7
        TST     DosVerifyFlag
        BEQ     LCBB7
        LDB     $0677
        LDX     $0671
        LDY     $0673
        LDU     $0675
        JMP     >LC9C6

LCC0F   LEAS    1,S
        RTS

LCC12   LEAS    -12,S
        STD     ,S
        STD     10,S
        LDA     #$01
        STA     <DosIOInProgress
        JSR     >DosGetDiskGeometry
        LBNE    LCD08
        STX     8,S
        JSR     >DosFCBNoToAddr
        LDB     $1E,X
        JSR     >SuperDosGetDirEntry
        LBNE    LCD08
        STX     4,S
        LDU     DosCurDirBuff
        LDA     #$FF
        STA     2,U
        CLRA
        LDB     $18,X
        BNE     LCC42
        INCA
LCC42   ADDD    ,S
        TSTB
        BNE     LCC48
        DECA
LCC48   STD     ,S
        TSTA
        LBEQ    LCCF0
        LDB     #$04
        LEAY    12,X
        LDA     ,X
        BITA    #$01
        BEQ     LCC5D
        LEAY    1,X
        LDB     #$07
LCC5D   TST     2,Y
        BNE     LCC75
        LDD     #$FFFF
        STD     6,S
        LEAY    -3,Y
        STY     2,S
        LDX     8,S
        TST     2,X
        LBNE    LCD0E
        BRA     LCCB3

LCC75   TST     2,Y
        BEQ     LCC7E
        LEAY    3,Y
        DECB
        BNE     LCC75
LCC7E   LEAY    -3,Y
        LDD     ,Y
        ADDB    2,Y
        ADCA    #$00
        STD     6,S
        STY     2,S
        LDX     8,S
        TST     2,X
        BEQ     LCCB3
        LDD     6,S
        SUBD    3,X
        BEQ     LCCC3
        JSR     >LCD57
        BEQ     LCCA2
        CMPB    #$94
        BNE     LCD08
        BRA     LCD0E

LCCA2   LDX     8,S
        PSHS    A,U
        LDB     2,X
        LDX     3,X
        JSR     >LD03B
        PULS    A,U
        BNE     LCD08
        BRA     LCCB8

LCCB3   JSR     >LCD57
        BNE     LCD08
LCCB8   LDX     8,S
        STU     3,X
        STA     2,X
        CMPU    6,S
        BNE     LCD0E
LCCC3   LDA     ,S
        CMPA    2,X
        BCS     LCCCB
        LDA     2,X
LCCCB   LDY     2,S
        PSHS    A
        ADDA    2,Y
        BCC     LCCD8
        PULS    A
        BRA     LCD0E

LCCD8   STA     2,Y
        LDA     2,X
        SUBA    ,S
        STA     2,X
        LDD     3,X
        ADDB    ,S
        ADCA    #$00
        STD     3,X
        LDA     1,S
        SUBA    ,S+
        STA     ,S
        BNE     LCCB3
LCCF0   LDX     4,S
        TFR     X,U
        JSR     >DosFCBNoToAddr
        LDD     10,S
        ADDD    $11,X
        BCC     LCD01
        INC     $10,X
LCD01   STD     $11,X
        STB     $18,U
        CLRB
LCD08   LEAS    12,S
        CLR     <DosIOInProgress
        TSTB
        RTS

LCD0E   LDD     2,S
        TFR     D,Y
        SUBD    4,S
        CMPB    #$13
        BCC     LCD23
        LEAY    3,Y
        STY     2,S
LCD1D   LDD     3,X
        STD     ,Y
        BRA     LCCC3

LCD23   LDA     #$01
        JSR     >LD123
        BNE     LCD08
        LDY     4,S
        STA     $18,Y
        LDB     ,Y
        ORB     #$20
        STB     ,Y
        LDB     #$FF
        STB     2,X
        LDB     #$01
        STB     ,U
        STU     4,S
        JSR     >DosFCBNoToAddr
        STA     $1E,X
        LEAY    $19,U
        LDB     #$18
LCD4B   CLR     ,-Y
        DECB
        BNE     LCD4B
        STY     2,S
        LDX     8,S
        BRA     LCD1D

LCD57   STS     $0601
        LEAS    -9,S
        CLR     4,S
        JSR     >DosGetDiskGeometry
        LBNE    LCE5A
        LDY     ,X
        LDU     $11,S
        STU     5,S
        LEAX    1,U
        BEQ     LCD81
        BSR     LCDB2
        BNE     LCDAF
        CMPU    #$05A0
        BCS     LCD81
        LDU     #$058E
        BRA     LCDA2

LCD81   LEAU    ,Y
LCD83   LDA     #$FF
        STA     ,S
LCD87   LEAU    -$12,U
        STU     -2,S
        BMI     LCD9A
        BSR     LCDB2
        BEQ     LCD83
        TST     ,S
        BPL     LCDAF
        STU     ,S
        BRA     LCD87

LCD9A   LDU     ,S
        STU     -2,S
        BPL     LCDAF
        LEAU    ,Y
LCDA2   LEAU    $12,U
        CMPU    #$0B40
        BHI     LCDB5
        BSR     LCDB2
        BEQ     LCDA2
LCDAF   JMP     >LCE34

LCDB2   JMP     >LCE60

LCDB5   LDA     #$FF
        STA     7,S
        LDA     4,S
LCDBB   LDU     <Misc16BitScratch
        LSRA
        BCS     LCDC3
        LDU     #$05A0
LCDC3   BSR     LCDB2
        LDB     #$B4
LCDC7   LDA     ,X+
        BNE     LCDD2
        LEAU    8,U
        DECB
        BNE     LCDC7
        BRA     LCE13

LCDD2   CLRB
        STB     8,S
        PSHS    U
LCDD7   INCB
        LDA     ,X+
        INCA
        BEQ     LCDD7
        CMPB    10,S
        BLS     LCDE5
        STB     10,S
        STU     ,S
LCDE5   LEAX    -1,X
        LDA     #$08
        MUL
        LEAU    D,U
LCDEC   CLRB
        LDA     ,X+
        BNE     LCDD7
        LEAU    8,U
        TFR     X,D
        CMPB    #$B4
        BCS     LCDEC
        PULS    U
        BSR     LCE60
        LEAU    8,U
        LDA     ,X
        LDB     8,S
        CMPB    #$01
        BHI     LCE0C
LCE07   LEAU    -1,U
        ASLA
        BCC     LCE07
LCE0C   ASLA
        BCC     LCE13
        LEAU    -1,U
        BRA     LCE0C

LCE13   CMPB    #$02
        BCC     LCE34
        CMPB    7,S
        BHI     LCE34
        LDA     7,S
        INCA
        BNE     LCE2A
        STB     7,S
        STU     5,S
        LDA     4,S
        EORA    #$03
        BRA     LCDBB

LCE2A   LDU     5,S
        BSR     LCE60
        BNE     LCE34
        LDB     #$94
        BRA     LCE5A

LCE34   BSR     LCE60
        CLRB
LCE37   INCB
        BEQ     LCE51
        PSHS    A
        COMA
        ANDA    ,X
        STA     ,X
        PULS    A
        ASLA
        BCC     LCE4A
        LDA     #$01
        LEAX    1,X
LCE4A   BITA    ,X
        BNE     LCE37
        TFR     B,A

;LCE51   EQU     *+1
;        CMPX    #$86FF
	
	FCB	Skip2
LCE51	LDA	#$FF
	
        LDX     2,S
        LDB     #$FF
        STB     2,X
        CLRB
LCE5A   LDS     $0601
        TSTB
        RTS

LCE60   PSHS    Y,U
        LDA     #$01
        CMPU    #$05A0
        BCS     LCE71
        LEAY    1,Y
        LEAU    $FA60,U
        ASLA
LCE71   PSHS    U
        BITA    12,S
        BNE     LCE84
        STA     12,S
        JSR     >SuperDosFindAndRead
        BNE     LCE5A
        STX     10,S
        LDA     #$FF
        STA     2,X
LCE84   LDX     10,S
        LDX     5,X
        PULS    D
        LSRA
        RORB
        LSRA
        RORB
        LSRA
        RORB
        LDA     3,S
        ANDA    #$07
        LDU     #$A672
        NEGA
        LDA     A,U
        ABX
        BITA    ,X
        PULS    Y,U,PC

;
; Get length of a file
;

SuperDosGetFLen   
	STA     <DosCurrCtrlBlk
        BSR     DosFCBNoToAddr
        TST     15,X
        BPL     LCEAA
        LDB     #$9C
LCEA9   RTS

LCEAA   LDA     $12,X
        LDU     $10,X
        LEAY    1,U
        BNE     LCED0
        JSR     >LCB20
        BNE     LCEA9
        LDB     DosCurFileNo
        STB     $1E,X
LCEBF   LDA     $18,U
        STA     $12,X
        LDU     $066B
        TSTA
        BEQ     LCECD
        LEAU    -1,U
LCECD   STU     $10,X
LCED0   CLRB
        RTS

;
; Converts current FCB number in DosCurrCtrlBlk to the FCB's address
; Exits with :
;	X=FCB address
; 

DosFCBNoToAddr   
	PSHS    D
        LDA     <DosCurrCtrlBlk	; Get current FCB no
        LDB     #DosFCBLength	; FCB len ?
        MUL			; Work out offset to FCB
        TFR     D,X		
        LEAX    DosFCB0Addr,X	; Get offset of FCB
        PULS    D,PC

;
; Close all open files.
;

SuperDosCloseAll   
	LDA     #$09
        STA     <DosCurrCtrlBlk
LCEE5   BSR     DosFCBNoToAddr
        LDA     11,X
        CMPA    <DosLastDrive
        BNE     LCEF1
        BSR     LCEF9
        BNE     LCEA9
LCEF1   DEC     <DosCurrCtrlBlk
        BPL     LCEE5
LCEF5   CLRB
        RTS

;
; Close a single file
;

SuperDosCloseFile   
		STA     <DosCurrCtrlBlk
LCEF9   BSR     DosFCBNoToAddr
        TST     ,X
        BEQ     LCEF5
        LDA     <DosLastDrive
        PSHS    A
        LDA     11,X
        STA     <DosLastDrive
        CLR     ,X
        JSR     >DosGetDiskGeometry
        BNE     LCF34
        TST     5,X
        BEQ     LCF19
        DEC     5,X
        BEQ     LCF19
        CLRB
        BRA     LCF34

LCF19   LDB     2,X
        BEQ     LCF2A
        PSHS    X
        LDX     3,X
        JSR     >LD03B
        PULS    X
        BNE     LCF34
        CLR     2,X
LCF2A   JSR     >SuperDosSyncDir
        LDU     #DosD0Online-1
        LDA     <DosLastDrive
        CLR     A,U
LCF34   PULS    A
        STA     <DosLastDrive
        TSTB
LCF39   RTS

;
; Create a file, with backup.
;

SuperDosCreateFile   
	STA     $067D
        JSR     >DosFCBNoToAddr
        STX     $0678
        LDB     #$0C
        LDU     #DosCurDriveInfo
LCF48   LDA     ,X+
        STA     ,U+
        DECB
        BNE     LCF48
        LDD     -4,U
        STD     $067A
        LDA     -2,U
        STA     $067C
        LDD     #$4241
        STD     -4,U
        LDA     #$4B
        STA     -2,U
        TST     3,X
        BMI     LCF92
        JSR     >SuperDosOpenFile
        CMPB    #$A0
        BEQ     LCF74
        TSTB
        BNE     LCF39
        BSR     SuperDosDeleteFile
        BNE     LCF39
LCF74   JSR     >LCEF9
        NOP
        LDA     $067D
        TST     [$0678]
        BEQ     LCF92
        JSR     >SuperDosRename
        BEQ     LCF8A
        CMPB    #$9C
        BNE     LCF39
LCF8A   LDA     $067D
        JSR     >SuperDosCloseFile
        BNE     LCF39
LCF92   LDD     $067A
        STD     $0658
        LDA     $067C
        STA     $065A
        JSR     >SuperDosOpenFile
        BEQ     LCFA7
        CMPB    #$A0
        BNE     LCF39
LCFA7   STA     <DosCurrCtrlBlk
        JSR     >DosFCBNoToAddr
        TST     15,X
        BMI     LCFB3
        LDB     #$9E
LCFB2   RTS

LCFB3   CLRA
        JSR     >LD123
        BNE     LCFB2
        JSR     >DosFCBNoToAddr
        STA     FCBDiskFileNo,X
        STA     $1E,X
        LDB     #$1C
LCFC4   CLR     B,X
        DECB
        CMPB    #$0C
        BCC     LCFC4
        LDB     #$18
LCFCD   CLR     B,U
        DECB
        BPL     LCFCD
        LEAU    1,U
        LDB     #$0B
LCFD6   LDA     ,X+
        STA     ,U+
        DECB
        BNE     LCFD6
        CLRB
        RTS

;
; Delete a file from disk.
;

SuperDosDeleteFile   
	JSR     >LD0E4
        BNE     LCFB2
        PSHS    X
        LDB     FCBDiskFileNo,X
        JSR     >LD237
        BNE     LD035
        TFR     X,U
        PULS    X
        LEAY    12,U
        LDB     #$04
LCFF6   LDA     ,U
        ANDA    #$20
        BEQ     LCFFF
        LDA     $18,U
LCFFF   PSHS    D
        LDB     #$81
        STB     ,U
        PSHS    X
LD007   LDX     ,Y++
        LDB     ,Y+
        BEQ     LD017
        PSHS    Y
        BSR     LD03B
        PULS    Y
        LBNE    LCA1B
LD017   DEC     3,S
        BNE     LD007
        PULS    X
        LDB     ,S
        BEQ     LD034
        LEAS    2,S
        PSHS    X
        JSR     >LD237
        TFR     X,U
        PULS    X
        BNE     LCFB2
        LEAY    1,U
        LDB     #$07
        BRA     LCFF6

LD034   CLRB
LD035   CLR     <DosIOInProgress
        LEAS    2,S
        TSTB
        RTS

LD03B   CLRA
        PSHS    A
        PSHS    D,X
        JSR     >DosGetDiskGeometry
        BNE     LD0C2
        LDY     ,X
        LDD     2,S
        SUBD    #$05A0
        BCS     LD05A
        LEAY    1,Y
        STD     2,S
        ADDD    ,S
        SUBD    #$05A0
        BCC     LD0C0
LD05A   LDD     2,S
        ADDD    ,S
        SUBD    #$05A0
        BCS     LD06A
        STB     4,S
        NEGB
        ADDB    1,S
        STB     1,S
LD06A   JSR     >SuperDosFindAndRead
        BNE     LD0C2
        LDA     #$FF
        STA     2,X
        LDD     2,S
        LSRA
        RORB
        ROR     ,S
        LSRA
        RORB
        ROR     ,S
        LSRA
        RORB
        ROR     ,S
        LDX     5,X
        ABX
        LDB     #$01
        LDA     ,S
        BEQ     LD08F
LD08A   ASLB
        SUBA    #$20
        BNE     LD08A
LD08F   STB     ,S
        LDB     1,S
LD093   LDA     ,S
        ORA     ,X
        STA     ,X
        DECB
        BEQ     LD0B4
        ASL     ,S
        BCC     LD093
        LDA     #$01
        STA     ,S
        LEAX    1,X
LD0A6   CMPB    #$10
        BCS     LD093
        LDA     #$FF
        STA     ,X+
        STA     ,X+
        SUBB    #$10
        BNE     LD0A6
LD0B4   LDX     #$05A0
        LEAS    4,S
        LDB     ,S+
        BEQ     LD0C4
        JMP     >LD03B

LD0C0   LDB     #$90
LD0C2   LEAS    5,S
LD0C4   RTS

;
; Protect/unprotect a file.
;

SuperDosProtect   
	STA     <DosCurrCtrlBlk
        JSR     >DosFCBNoToAddr
        LDA     15,X
        BMI     LD0F4
        TSTB
        BEQ     LD0D4
        ORA     #$02

;LD0D4   EQU     *+1
;        CMPX    #$84FD

	FCB	Skip2
LD0D4	ANDA	#$FD	

        STA     15,X
        LDB     FCBDiskFileNo,X
        JSR     >LD237
        BNE     LD0C4
        STA     ,X
        CLRB
        RTS

LD0E4   STA     <DosCurrCtrlBlk
        JSR     >DosFCBNoToAddr
        LDA     15,X
        BMI     LD0F4
        BITA    #$02
        BEQ     LD122
        LDB     #$98
        RTS

LD0F4   LDB     #$9C
        RTS

;
; Rename a file.
;

SuperDosRename   
	BSR     LD0E4
        BNE     LD122
        LDB     #$0B
        LDU     #DosCurDriveInfo
LD100   LDA     ,U+
        STA     ,X+
        DECB
        BNE     LD100
        LEAX    -11,X
        LDB     FCBDiskFileNo,X
        JSR     >LD237
        BNE     LD122
        LDU     #DosCurDriveInfo
        LDB     #$0B
        LEAX    1,X
LD118   LDA     ,U+
        STA     ,X+
        DECB
        BNE     LD118
        CLR     <DosIOInProgress
        CLRB
LD122   RTS

LD123   CLRB
        STD     $067D
        BSR     DosGetDiskGeometry
        BNE     LD122
        LDX     ,X
        PSHS    X
        LEAX    2,X
LD131   STX     DosCurLSN
        TFR     X,Y
        JSR     >SuperDosFindAndRead
        BNE     LD170
        LDU     5,X
        LDB     #$0A
        TST     $067D
        BEQ     LD149
        CLR     $067D
        BRA     LD14D

LD149   LDA     ,U
        BMI     LD168
LD14D   INC     $067E
        LEAU    $19,U
        DECB
        BNE     LD149
        JSR     >LDFF3
        LEAX    1,X
        TFR     X,D
        SUBD    ,S
        CMPB    #$12
        BCS     LD131
        LEAS    2,S
        LDB     #$92
        RTS

LD168   LDA     #$FF
        STA     2,X
        LDA     $067E
        CLRB
LD170   LEAS    2,S
        RTS

;
; Get free space on disk
;

SuperDosGetFree   
	BSR     DosGetDiskGeometry
        BNE     LD187
        LDY     ,X
        LDX     <Misc16BitScratch
        BSR     LD188
        BNE     LD187
        LEAY    1,Y
        BSR     LD188
        BNE     LD187
        CLRB
LD187   RTS

LD188   PSHS    X
        JSR     >SuperDosFindAndRead
        BNE     LD170
        LDU     5,X
        PULS    X
        LDB     #$B4
LD195   LDA     ,U+
LD197   LSRA
        BCC     LD19C
        LEAX    1,X
LD19C   TSTA
        BNE     LD197
        DECB
        BNE     LD195
        RTS

;
; Get geometry for a disk and set the apropreate low memory vars.
;
; Entry : DosLastDrive, set to last drive
;
; Exit  : Drive vars setup in low ram, to be same as disk in drive.
;	  X=Address of buffer detail entry for buffer to use

DosGetDiskGeometry   
	LDX     #Drv0Details		; Point at drive details
        LDU     #DosD0Online-1		; Point at drive online table
        LDB     #DrvDeatailLen		; Get drive table entry len
        LDA     <DosLastDrive		; Get last used drive
        LEAU    A,U			; Point U at drive online flag
        DECA				; Make zero based
        MUL				; Calculate offset of drive we need
        LEAX    D,X
        TST     ,U			; Is drive online ?
        BNE     LD1FF			; Yes : exit
	
        LDY     #SectorsPerTrack*DirPrimary 	; First sector of DIR track ($0168)
        LDA     #SectorsPerTrack	; Set sectors per track for this drive
        STA     $10,U			; Set it
        TST     $0C,U			; Do we know how many tracks this disk has ?
        BNE     LD1CA			; Yes : skip on
	
        JSR     >DosDoRestore		; No, do restore
        BCC     LD1CA			; no error : skip
        RTS

LD1CA   PSHS    X			; Save drive detail pointer		
        JSR     >SuperDosFindAndRead	; Find free buffer and read sector
        BNE     LD170			; Error : exit
	
; At this point X points to buffer details ???
	
        CLR     BuffFlag,X		; Reset buffer flag
        LDX     BuffAddr,X		; Get address of buffer data
        LDD     DirTracks1s,X		; Get complements of tracks/secs per track
        COMA				; Complemetn them for compare
        COMB
        CMPD    DirTracks,X		; compare them to validate the disk
        PULS    X			; restore drive detail pointer
        BNE     LD201			; Not the same, may be ds disk
	
        STB     $10,U			; Set Sectors/Track for this disk
        STA     $0C,U			; Set tracks for this disk
        DEC     ,U			; Mark drive online
        CMPB    #$12			; Disk single sided ?
        BEQ     LD1F0			; yes : skip on
	
        CLRB				; zero it
LD1F0   PSHS    B			; save it
        CLR     BuffFlag,X		; Clear buffer flag
        LDD     #SectorsPerTrack*DirPrimary 	; First sector of DIR track ($0168)
        TST     ,S+			; Do we need to double ? 
        BNE     LD1FD			; yes : skip
        ASLB				; Multiply D by 2, as we have 2 sides
        ROLA
LD1FD   STD     ,X			; save it
LD1FF   CLRB				; No error
        RTS				; Return

LD201   LDB     #$90			; Flag error
        RTS

;
; Get directory entry.
;
; Entry : B= File number(on disk) to get entry for???
;
; Exit  : X=Pointer to required Dir entry.
;

SuperDosGetDirEntry   
	LDA     #$FF			; Init sector counter
LD206   INCA				; increment sector counter
        SUBB    #DirEntPerSec		; Decrement file no, by a sectors worth of files
        BCC     LD206			; Done all ? no : continue looping
	
        ADDB    #DirEntPerSec		; Compensate for over loop
	
; At this point A contains the sector number within the directory that we are intereted in.
; and B contains the entry within that sector of the file's details.
	
        PSHS    D			; Save them
        BSR     DosGetDiskGeometry	; Setup disk geometry from disk in drive
        LBNE    LCB7C			; Error : exit
	
        LDD     ,X			; Get LSN number from buffer
        ADDD    #$0002			; Advance past bitmap sectors
        ADDB    ,S+			; Add sector offset calculated above
        ADCA    #$00			; Deal with carry
        STD     DosCurLSN		; Save LSN
        TFR     D,Y			; Get LSN into Y
        BSR     SuperDosFindAndRead	; Find free buffer and read sector
        PULS    A			; Retrieve entry number witin sector

        BNE     LD236			; Error: exit
        TFR     X,U			
        LDB     #$19			; Length of dir entry
        MUL				; Calculate offset
        STX     DosCurDirBuff		; Saave block def pointer
        LDX     BuffAddr,X		; Get pointer to block data
        LEAX    D,X			; Get offset of DIR entry into X
        CLRB				; Flag no error
LD236   RTS

LD237   PSHS    D
        BSR     SuperDosGetDirEntry	; Get directory entry we are interested in
        LBNE    LCB7C			; Error :
        LDY     DosCurDirBuff		; Get Buffer def block for this entry
        LDA     #$FE			; Set flag
        STA     BuffFlag,Y
        CLRB				; Flag no error
        PULS    D,PC			; Restore and return

;
; Find a free disk buffer.
;
; Entry	: Y=??
;
; Exits : U=pointer to detail entry for free buffer.
;	  B=Error code
;

FindFreeBuffer
        LDX     #Buff1Details		; Point at disk buffer detail table
        LDU     <Misc16BitScratch	; Load U with 0 ?
        LDB     #BuffCount		; 4 Disk buffers
LD251   LDA     BuffFlag,X		; Get buffer flag in A
        BEQ     LD26C			; Zero ?
	
        CMPA    #BuffInUse		; Is buffer in use ?
        BEQ     LD26E			; Yes, try next buffer
        CMPY    ,X
        BNE     LD268
	
        LDA     <DosLastDrive		; Get last drive
        CMPA    BuffDrive,X		; Is this buffer using the same drive ?
        BNE     LD268			; nope, skip on
        BSR     MakeBuffYoungest	; Make this the youngest buffer
        CLRB				; Flag no error
        RTS

LD268   TST     BuffFlag,X		; Is buffer free ?
        BNE     LD26E			; nope, look at next
LD26C   TFR     X,U			; Select this buffer
LD26E   LEAX    BuffDetailSize,X	; move on to next buffer detail entry
        DECB				; Decrement counter
        BNE     LD251			; Any more to check ? : yes loop again
        LDB     #$FF			; Flag error
        RTS					

;
; Find a free buffer and read sector.
;
; Entry : 
;	  Y= ???
;	  U= ???
;

SuperDosFindAndRead   
	PSHS    U
        BSR     FindFreeBuffer		; Find free buffer, pointer to details returned in U
        LBEQ    LCB7C
        LEAX    ,U			; Make X point to details
        PULS    U
        BNE     LD288
        BSR     FindFreeDiskBuffer	; Find buffer to read data into
        BNE     LD2A1			; Error : exit
	
LD288   CLR     BuffFlag,X		; Make buffer free
        STY     ,X
        LDA     <DosLastDrive		; Get last drive
        STA     BuffDrive,X		; Set this drive's buffer
        PSHS    X			; Save buffer detail pointer
        LDX     BuffAddr,X		; Get address of buffer
        JSR     >SuperDosReadAbsSector	; Read the sector
        PULS    X			; Restore buff detail pointer
        BNE     LD2A1			; Error : exit
	
        LDA     #$01			; Set flag to 1
        STA     BuffFlag,X
        CLRB				; No error
LD2A1   RTS

;
; Find least recently used disk buffer, if none, and there is 
; a dirty buffer, then flush it and use that one.
;
; Exit : X=pointer to buffer info block.
;

FindFreeDiskBuffer   
	PSHS    D,Y,U
LD2A4   LDX     #Buff1Details		; Point to disk buffer table
        LDB     #$04			; Check 4 buffers
LD2A9   LDA     BuffAge,X		; Get buffer age
        CMPA    #$01			; Oldest ?
        BEQ     LD2B4			; Yes go process it
        LEAX    7,X			; Do next bufffer
        DECB				; Decrement buffer count
        BNE     LD2A9			; More : do next
	
LD2B4   BSR     MakeBuffYoungest	; Adjust ages of all other buffers
        LDA     BuffFlag,X		; Get buffer flag byte 
        CMPA    #$55			; In use ???
        BEQ     LD2A4			; yes, select another buffer
        INCA				; Check for Flag=$FF
        BNE     LD2C3			; no : skip on
        DEC     BuffFlag,X		; yes, select another buffer
        BRA     LD2A4	

LD2C3   BSR     LD2E2			; Check for buffer flush needed ?
        BEQ     LD2C9			; No error: skip
        STB     1,S			; Flag error to caller
LD2C9   PULS    D,Y,U,PC		; restore and return

MakeBuffYoungest
	LDB     #BuffCount		; Process 4 buffers
        LDA     BuffAge,X		; Get current buffer Age
        LDU     #Buff1Details		; Point to disk buffer table
LD2D2   CMPA    BuffAge,U		; Compare to current buffer age
        BHI     LD2D8			; higher ? skip
        DEC     BuffAge,U		; Decrement Age byte (make older)
	
LD2D8   LEAU    BuffDetailSize,U	; Do next buffer
        DECB				; Decrement count
        BNE     LD2D2			; More : do next
        LDA     #$04			; Mark this as youngest buffer
        STA     BuffAge,X
        RTS

LD2E2   TST     BuffFlag,X		; Buffer dirty ? 
        BMI     FlushBuffer		; Yes, flush it !
        CLRB				; No error ?
        RTS

FlushBuffer   
	LDA     <DosLastDrive		; Get last drive accessed
        PSHS    A			; save it on stack
        PSHS    X			; Save buffer pointer
        LDA     #$FF			; Flag Dos IO in progress
        STA     <DosIOInProgress
        CLR     2,X			; Flag buffer no longer dirty
        LDA     3,X			; Get drive this buffer refers to
        STA     <DosLastDrive		; Save in last accessed drive
        LDY     ,X			; get LSN ?
        LDX     5,X			; Get buffer pointer
        BSR     SuperDosWriteAbsSector	; Write it
        PULS    X			; Retrieve buffer pointer
        BNE     LD31F			; no error : skip ahead
        LDA     <DskTrackNo		; Get current track no
        CMPA    #$14			; track 20 (directory) ?
        BNE     LD31A			; no : skip ahead
        
;
; I do not have a clue why this code does this, it seems to take a byte from
; the basic rom do some stuff to it and update the Directory sector status table 
; with it !
; 
; Looking at $A673, the 8 bytes before it are $80,$40,$20,$10,$08,$04,$02,$01
; This is the 2 colour pixel mask table, but is a convenient table for mapping a bit
; number to the bit it represents.
;
	
	LDU     #PixMaskTable4Col	; This for some strange reason points U at basic rom !!!	
        LDA     <DosLastDrive		; get last drive
        NEGA
        LDA     A,U
	
        LDU     #DosDirSecStatus-1	; Point to directory status table
        LDB     <DskSectorNo		; get sector number
        ORA     B,U			; Put a byte in table
        STA     B,U
	
LD31A   LDA     #$01			; Mark bufer as youngest
        STA     BuffFlag,X
        CLRB
LD31F   PULS    A
        STA     <DosLastDrive		; Restore last drive
        CLR     <DosIOInProgress	; Mark no io in progress
        TSTB
        RTS

;
; Write absolute sector.
;
; Entry	:    X=Address to store data
;	     Y=LSN to read
;	 $00EA=Drive number
;

SuperDosWriteAbsSector   
	BSR     CalcTrackFromLSN		; Setup disk vars in low ram with trackno
        JSR     >DosDoWriteSec2
LD32C   LDX     <DiskBuffPtr			; Restore buffer pointer 
        TSTB					; Test for Error
        RTS					; return to caller

LD330   BSR     CalcTrackFromLSN		; Setup disk vars in low ram with trackno
        JSR     >DosDoReadSec2
        BRA     LD32C

;
; Read absolute sector.
;
; Entry	:    X=Address to store data
;	     Y=LSN to read
;	 $00EA=Drive number
;

SuperDosReadAbsSector   
	BSR     CalcTrackFromLSN		; Setup disk vars in low ram with trackno
        JSR     >DosDoReadSec			; Go read data
        BRA     LD32C				; Return to caller

;
; Calculate track from Logical sector number.
;
; Entry : X=Buffer pointer
;	  Y=LSN to read/write
;
; Exit  : D=Disk track no, Low ram vars also set.
;

CalcTrackFromLSN   
	STX     <DiskBuffPtr			; Save in buffer pointer
        LDX     #DosD0SecTrack-1		; Point to Sec/Track table
        LDB     <DosLastDrive			; Get last drive
        LDB     B,X				; Get Sec/Track for that drive
        CLRA
        PSHS    D				; Save it
        CLR     ,-S				; Make room on stack
        TFR     Y,D				; Get LSN into D
	
; Calculate which track we need
	
LD34E   INC     ,S				; Inc track counter
        SUBD    1,S				; Decrement sec/track from LSN
        BPL     LD34E				; keep looping till it goes -ve
	
        ADDB    2,S				; Compensate for over-loop
        LDA     ,S				; Get track needed
        DECA					; Compensate track for over loop
        INCB
        LEAS    3,S				; Drop stack temps
        STD     <DskTrackNo			; Save track no
        RTS

;
; Copy command dispatch routine
;
; Syntax :
;	COPY filespec TO filespec	
;
; Stack setup as follows 
;
; offset	size 	purpose
; 0		1	Source FCB number
; 1		1	Destination FCB number
; 2		2	Buffer pointer ?
; 4		3	File pointer pos
;

CmdCopy   
	JSR     >SuperDosCloseAll	; Close all files & devices
        BNE     LD39F			; Error : exit
        LEAS    -7,S			; Make room on stack
	
;
; Make a buffer for copying the file.
;
	
        TFR     S,D			; move to D
        SUBD    #$0100			; Make room for 1 sector
        SUBD    <BasVarEnd		; Will we overwrite basic ?		
        LBMI    BasOMError		; yes : error, exit
	
        CLRB
        TSTA				; overwrite zero page ?
        LBEQ    BasOMError		; yes : error, exit
        STD     2,S			; IO buffer pointer
        JSR     >DosGetFilenameAndOpen	; Get source filename FCB number in A
        BNE     LD39F			; Error : exit
        STA     ,S			; save FCB no of source
        
	JSR     >SuperDosGetFLen	; Get file length
        BNE     LD39F			; Error : exit
        JSR     <BasChrGetCurr		; scan current char from params
        CMPA    #$BC			; "TO" token
        LBNE    BasSNError		; no : Error
	
        JSR     <BasChrGet		; Get next character
        JSR     >DosGetFilenameAndOpen	; Get dest filename FCB number in A		
        BEQ     LD398			; No error : continue
        CMPB    #$A0
        BNE     LD39F			; Error : exit
LD398   STA     1,S			; Save destination FCB number
        JSR     >SuperDosCreateFile	; re-write destination file
        BEQ     LD3A2			; no error : continue
LD39F   JMP     >DosHookSysError	; Error : exit

LD3A2   LDA     ,S			; Get source FCB no
        STA     <DosCurrCtrlBlk		; Save current FCB
        JSR     >DosFCBNoToAddr		; Get FCB address
	
; Compare file pointer position with file length for source file
	
        LDD     12,X
        CMPD    $10,X
        BCS     LD3B8
        LDA     14,X
        CMPA    $12,X
        BEQ     LD408
	
LD3B8   LDU     12,X
        LDA     14,X
        STA     6,S
        STU     4,S
        LDD     2,S
        ADDD    5,S
        STD     5,S
        BCC     LD3CA
        INC     4,S
LD3CA   LDA     4,S
        SUBA    $10,X
        BCS     LD3DF
        LDD     5,S
        SUBD    $11,X
        BLS     LD3DF
        LDD     $11,X
        SUBD    13,X
        STD     2,S
	
LD3DF   LDA     ,S			; Get source FCB no
        LDU     12,X			; Get number of bytes to read
        LDB     14,X			; Y:B=position to read from
        LDY     2,S			
        LDX     <BasVarEnd		; Point to end of basic memory
        JSR     >SuperDosFRead		; Read from source file
        BNE     LD39F			; error : exit
        
	LDA     1,S			; Get destination FCB No
        STA     <DosCurrCtrlBlk		; Save in current ctrl block no
        JSR     >DosFCBNoToAddr		; Get addres of Dest FCB
	
        LDY     $10,X
        LDB     $12,X
        LDU     2,S
        LDX     <BasVarEnd		; Point to end of basic memory
        JSR     >SuperDosFWrite		; Write to destination
        BNE     LD39F			; Error : exit
        BRA     LD3A2			; continue copying

LD408   JSR     >SuperDosCloseAll	; Close all files, finished copy
        BNE     LD39F		; Error !	
        LEAS    7,S		; drop stack frame
        RTS
;
; Merge command dispatch routine.
;
; Syntax :
;	MERGE filespec
;

CmdMerge   
	JSR     >DosValidateAndOpenBas
        BNE     LD39F
        BSR     LD494
        BNE     LD39F
        CMPA    #$01
        BNE     LD45B
        LDU     <BasVarSimpleAddr
        LDY     <BasStartProg
        PSHS    Y,U
        LEAU    1,U
        STU     <BasStartProg
        JSR     >LD507
        PULS    X,U
        STU     <BasVarSimpleAddr
        STX     <BasStartProg
        LEAU    1,U
LD433   LDD     ,U++
        BEQ     LD455
        LDD     ,U++
        STD     BasLinInpHead
        STD     <BasTempLine
        CLRB
        LDX     #$02DC
LD442   INCB
        LDA     ,U+
        STA     ,X+
        BNE     LD442
        ADDB    #$04
        STB     <BasGenCount
        PSHS    U
        BSR     LD45E
        PULS    U
        BRA     LD433

LD455   CLR     DosRunLoadFlag
        JMP     >LD4E4

LD45B   JMP     >BasFMError

LD45E   JSR     >BasFindLineNo
        BCS     LD475
        LDD     <BasVarFPAcc4+2
        SUBD    ,X
        ADDD    <BasVarSimpleAddr
        STD     <BasVarSimpleAddr
        LDU     ,X
LD46D   LDA     ,U+
        STA     ,X+
        CMPX    <BasVarSimpleAddr
        BNE     LD46D
LD475   LDD     <BasVarSimpleAddr
        STD     <BasVarFPAcc3+3
        ADDB    <BasGenCount
        ADCA    #$00
        STD     <BasVarFPAcc3+1
        JSR     >BasChkArrSpaceMv	
        LDU     #$02D8
LD485   LDA     ,U+
        STA     ,X+
        CMPX    <BasVarFPAcc4
        BNE     LD485
        LDX     <BasVarFPAcc3+1
        STX     <BasVarSimpleAddr
        JMP     >BasVect2


LD494   LDX     #DosCurDriveInfo		; Get current drive info
        LDY     #$0009
        LDU     <Misc16BitScratch		; U=0 ?
        CLRB
        LDA     <DosCurrCtrlBlk			; Get current FCB address
        JSR     >SuperDosFRead			; Go read the file
        BNE     LD4B6				; Error : exit
	
        LDA     #$55
        LDX     #DosCurDriveInfo		; Get current drive info
        CMPA    ,X
        BNE     LD45B
	
        COMA
        CMPA    8,X
        BNE     LD45B
        LDA     1,X
        CLRB
LD4B6   RTS

DosHookRun   
	CLR     $0614
        CLR     $0619
        CLR     $0617
        CLR     $0618
        CMPA    #$22
        BEQ     LD4C9
        TSTA
        RTS					; Dragon, just return

LD4C9   LEAS    2,S
        LDB     #$01

        FCB     $21

;
; Load command dispatch routine
;
; Syntax :
;	LOAD filespec
;	LOAD filespec,offset
;

CmdLoad   
	CLRB					; Set run/load flag to load
        STB     DosRunLoadFlag
	
        JSR     >DosValidateAndOpenBas		; Open supplied filename
        BNE     LD4DB				; Error : exit
	
        BSR     LD494
        BEQ     LD4DE				; No error : skip
	
LD4DB   JMP     >DosHookSysError

LD4DE   CMPA    #$01
        BNE     LD529
        BSR     LD507
	
LD4E4   CLR     <DosIOInProgress		; Flag no DOS IO in progress
        LDX     <BasStartProg			; Get start of program
        JSR     >BasSetProgPtrX			; Set program pointer to X
        LDX     <AddrFWareRamTop		; Set Top of string space
        STX     <BasVarStrTop		
        LDX     <BasVarSimpleAddr		; Set Array base=simple var base	
        STX     <BasVarArrayAddr
        STX     <BasVarEnd			; Set Basic var end at seme place
	
LD4F5   JSR     >CmdRestore			; So the equivelent of a basic 'RESTORE' command
        JSR     >BasResetStack			; Reset basic stack
        TST     DosRunLoadFlag			; Is this a load only or load & then run ?
        BEQ     LD503				; Just a load, return to basic
        JMP     >BasRun				; Run basic program

LD503   CLRA					; Clear error
        JMP     >BasCmdMode			; Go to command mode

LD507   LDD     4,X
        TFR     D,Y
        ADDD    <BasStartProg
        STD     <BasVarEnd
        LDB     #$40
        JSR     >BasChkB2Free
LD514   LDA     <DosCurrCtrlBlk
        LDB     #$09
        LDX     <BasStartProg
        LDU     <Misc16BitScratch
        JSR     >SuperDosFRead
        BNE     LD4DB
        JSR     >BasVect2
        LEAX    2,X
        STX     <BasVarSimpleAddr
        RTS

LD529   CMPA    #$02
        LBNE    LD45B
        LDU     6,X
        STU     <BasExecAddr
        JSR     <BasChrGetCurr
        BEQ     LD549
        PSHS    X
        BSR     LD5AA
        TFR     X,U
        PULS    X
        LDD     6,X
        SUBD    2,X
        STU     2,X
        ADDD    2,X
        STD     <BasExecAddr
LD549   LDY     4,X
        LDA     <DosCurrCtrlBlk
        LDB     #$09
        LDU     <Misc16BitScratch
        LDX     2,X
        JSR     >SuperDosFRead
        BNE     LD5A1
        TST     DosRunLoadFlag
        BEQ     LD5A9
        JMP     [>BasExecAddr]

;
; Save command dispatch routine.
;
; Syntax :
;	SAVE filespec
;	SAVE filespec,start_addr,end_addr,entry_addr
;

CmdSave   
	JSR     >VarGetStr
        JSR     >VarGetExpr
        JSR     <BasChrGetCurr
        BEQ     LD5B0
        LDY     #DosExtBin
        BSR     LD598
        BSR     LD5AA
        STX     $0652
        BSR     LD5AA
        TFR     X,D
        CMPX    $0652
        LBCS    DosPRError
        SUBD    $0652
        LBMI    BasFCError
        ADDD    #$0001
        STD     $0654
        BSR     LD5AA
        STX     $0656
        LDB     #$02
        BRA     LD5CA

LD598   JSR     >LD6DF
        BEQ     LD5A4
        CMPB    #$A0
        BEQ     LD5A4
LD5A1   JMP     >DosHookSysError

LD5A4   JSR     >SuperDosCreateFile
        BNE     LD5A1
LD5A9   RTS

LD5AA   JSR     >VarCKComma
        JMP     >VarGet16Bit

LD5B0   LDY     #DosExtBas
        BSR     LD598
        LDX     <BasStartProg
        STX     $0652
        LDD     <BasVarSimpleAddr
        SUBD    <BasStartProg
        STD     $0654
        LDX     #BasFCError
        STX     $0656
        LDB     #$01
LD5CA   LDX     #DosCurDriveInfo
        LDA     #$55
        STA     ,X
        COMA
        STA     8,X
        STB     1,X
        LDA     <DosCurrCtrlBlk
        CLRB
        LDY     <Misc16BitScratch
        LDU     #$0009
        JSR     >SuperDosFWrite
        BNE     LD5A1
        LDA     <DosCurrCtrlBlk
        LDB     #$09
        LDX     $0652
        LDU     $0654
        LDY     <Misc16BitScratch
        JSR     >SuperDosFWrite
        BNE     LD5A1
        CLR     <DosIOInProgress
        RTS

;
; Chain command dispatch routine.
;
; Syntax :
;	CHAIN filespec	
;

CmdChain   
	BSR     LD670
        JSR     >DosValidateAndOpenBas
        BNE     LD5A1
        JSR     >LD494
        BNE     LD5A1
        CMPA    #$01
        LBNE    LD45B
        JSR     <BasChrGetCurr
        BEQ     LD61E
        JSR     >VarCKComma
        JSR     >BasGetLineNo
        BSR     LD629
        LDD     <BasTempLine
        JSR     >BasSkipLineNo
        BRA     LD626

LD61E   BSR     LD629
        LDU     <BasStartProg
        LEAU    -1,U
        STU     <BasAddrSigByte
LD626   JMP     >LD4F5

LD629   LDD     $0654
        TFR     D,Y
        ADDD    <BasStartProg
        SUBD    <BasVarSimpleAddr
        PSHS    D
        ADDD    <BasVarEnd
        STD     <BasVarEnd
        LDB     #$40
        STB     DosRunLoadFlag
        JSR     >BasChkB2Free
        LDD     ,S
        BPL     LD653
        LDX     <BasVarSimpleAddr
        LEAU    D,X
LD648   LDA     ,X+
        STA     ,U+
        CMPU    <BasVarEnd
        BLS     LD648
        BRA     LD661

LD653   LDX     <BasVarEnd
        LEAX    1,X
        LEAU    D,X
LD659   LDA     ,-X
        STA     ,-U
        CMPX    <BasVarSimpleAddr
        BCC     LD659
LD661   LDD     ,S
        ADDD    <BasVarSimpleAddr
        STD     <BasVarSimpleAddr
        PULS    D
        ADDD    <BasVarArrayAddr
        STD     <BasVarArrayAddr
        JMP     >LD514

LD670   LDX     <BasVarSimpleAddr	; Get pointer to start of vars
        LEAX    2,X		
LD674   CMPX    <BasVarArrayAddr	; More than 2 bytes of vars ?
        BCC     LD682
	
        TST     -1,X
        BPL     LD67E
        BSR     LD6AA
LD67E   LEAX    7,X
        BRA     LD674

LD682   LDU     <BasVarArrayAddr	; Array pointer
LD684   CMPU    <BasVarEnd		; any arrays in use ?
        BCC     LD6A7
        LDD     2,U
        LEAX    D,U
        PSHS    X
        TST     1,U
        BPL     LD6A3
        LDB     4,U
        CLRA
        ASLB
        LEAX    D,U
        LEAX    5,X
LD69B   BSR     LD6AA
        LEAX    5,X
        CMPX    ,S
        BCS     LD69B
LD6A3   PULS    U
        BRA     LD684

LD6A7   JMP     >VarGarbageCollect

LD6AA   PSHS    X,U
        CMPX    <BasVarStringBase
        BCC     LD6C3
        LDB     ,X
        BEQ     LD6C3
        JSR     >BasResStr2
        TFR     X,U
        LDY     ,S
        LDX     2,Y
        STU     2,Y
        JSR     >UtilCopyBXtoU
LD6C3   PULS    X,U,PC

LD6C5   LDY     #DosExtDat
        BRA     DosGetFilenameAndOpenExt

;
; Validate and open Basic program file supplied on command
;

DosValidateAndOpenBas   
	LDY     #DosExtBas			; Point to 'BAS' file extension
        BRA     DosGetFilenameAndOpenExt	; Validate and open file

;
; Get a filename from Dos and open it
; 	Takes a string supplied on command name, fetches it and
;	tries to open the file of that name.
; 
; If entered at DosGetFilenameAndOpenExt then extension must be pointed to by Y
;
; Exits with :-
;		A=FCB number for opened file
;		B= Error code ?
;		Y=ptr to extension
;


DosGetFilenameAndOpen   
	LDY     #DosExtNone		; Point to Blank extension
	
DosGetFilenameAndOpenExt   
	PSHS    Y
        JSR     >VarGetStr		; get string into temp variable
        JSR     >VarGetExpr		; Get address of string in FAC
        PULS    Y
LD6DF   LDX     <BasVarAssign16		; Get string address
        PSHS    X
        LDB     ,X			; Get string length
        LDX     2,X			; Get pointer to actual string data
        JSR     >DosValidateAndOpen	; Validate & open file (if valid)
        PULS    X
        PSHS    D
        JSR     >VarDelVar		; Delete tempory variable
        PULS    D
        TSTB				; Get error?
        RTS

DosHookCloseSingle   
	LDA     #$09
        STA     <DosCurrCtrlBlk
LD6F9   JSR     >LCEF9
        BNE     LD717
        DEC     <DosCurrCtrlBlk
        BPL     LD6F9
LD702   CLR     <DosIOInProgress		
        CMPX    #$39FD
	
DosFlagDrivesOffline   
	CLRA					; Clears some dos vars
        CLRB
        STD     DosD0Online			; Drives 0 & 1
        STD     DosD2Online			; Drives 2 & 3
        RTS

DosDrivesOffCLS   
	BSR     DosFlagDrivesOffline		; Flag all drives as offline
        JMP     >TextCls			; Clear screen

LD715   BEQ     LD702
LD717   JMP     >DosHookSysError

LD71A   JSR     >LCEF9
        BRA     LD715

;
; Create command dispatch routine.
; 
; Syntax :
;	CREATE filespec,length	
;

CmdCreate   
	BSR     LD6C5
        BEQ     LD72B
        CMPB    #$9E
        BEQ     LD72B
        CMPB    #$A0
        BNE     LD717
LD72B   LDA     <DosCurrCtrlBlk
        JSR     >SuperDosCreateFile
        BNE     LD717
        JSR     <BasChrGetCurr
        BEQ     LD76C
        JSR     >VarCKComma
        JSR     >VarGetStr
        JSR     >LD879
LD73F   TST     <BasVarFPAcc1+2
        BEQ     LD755
        LDD     #$FF00
        BSR     LD767
        LDD     <BasVarAssign16
        SUBD    #$FF00
        STD     <BasVarAssign16
        BCC     LD73F
        DEC     <BasVarFPAcc1+2
        BNE     LD73F
LD755   LDD     <BasVarAssign16
        BEQ     LD76C
        CMPD    #$FF00
        BLS     LD767
        SUBD    #$FF00
        BSR     LD767
        LDD     #$FF00
LD767   JSR     >LCC12
        BNE     LD717
LD76C   RTS

;
; Kill command dispatch routine
;
; Syntax :
;	KILL filespec
;

CmdKill   
	JSR     >DosGetFilenameAndOpen
        BNE     LD777
        JSR     >SuperDosDeleteFile
LD775   BEQ     LD71A
LD777   JMP     >DosHookSysError

;
; Protect command dispatch routine.
;
; Syntax :
;	PROTECT ON filespec
;	PROTECT OFF filespec
;

CmdProtect   
		TSTA
        BPL     LD787
        CMPA    #$C2
        BEQ     LD798
        CMPA    #$88
        LBNE    BasSNError
LD787   BSR     LD790
        LDB     #$01
LD78B   JSR     >SuperDosProtect
        BRA     LD775

LD790   JSR     <BasChrGet
        JSR     >DosGetFilenameAndOpen
        BNE     LD7BB
        RTS

LD798   BSR     LD790
        CLRB
        BRA     LD78B

;
; Rename command dispatch routine
;
; Syntax :
;	RENAME filespec TO filespec
;

CmdRename   
	JSR     >DosGetFilenameAndOpen
        BNE     LD7BB
        PSHS    A
        LDB     #$BC
        JSR     >VarCKChar
        JSR     >DosGetFilenameAndOpen
        BEQ     LD7B9
        CMPB    #$A0
        BNE     LD7BB
        PULS    A
        JSR     >SuperDosRename
        BRA     LD775

LD7B9   LDB     #$9E
LD7BB   JMP     >DosHookSysError

;
; FLread command dispatch routine
;
; Syntax :
;	FLREAD filespec;string
;	FLREAD filespec, FROM first_byte,FOR count;string
;

CmdFLRead   
	BSR     LD7CD
        LDA     #$FF
        STA     DosFlFreadFlag
        JSR     >LD95D
        BSR     LD7F8
        JMP     >BasLineInputEntry

LD7CD   JSR     >LD6C5
        BNE     LD822
        BSR     LD825
        JSR     >DosFCBNoToAddr
        TST     $067E
        BEQ     LD7E6
        LDU     $0664
        LDB     $0666
        STU     12,X
        STB     14,X
LD7E6   JSR     >LD9CF
        LDX     #$02DC
        CLR     ,X
        JMP     <BasChrGet

;
; Fread command dispatch routine
;
; Syntax :
;	FREAD filespec;variable list
;	FREAD filespec,FROM startpos,FOR numbytes;variable list	
;

CmdFRead   
	BSR     LD7CD
        CLR     DosFlFreadFlag
        JSR     >CmdReadFromX
LD7F8   JSR     >DosFCBNoToAddr
        LDB     $0604
        BEQ     LD80E
	CLR     DosErrorCode
        LDD     FCBFilePointer+1,X	; Get filepointer LSW
        SUBD    $0603
        STD     FCBFilePointer+1,X	; Resave filepointer LSW
        BCC     LD80E
        DEC     FCBFilePointer,X	; Decrement filepointer MSB
LD80E   TST     <DosRecLenFlag
        BEQ     LD81F
        LDB     <DosNoBytesMove
        BEQ     LD81F
        CLRA
        ADDD    FCBFilePointer+1,X
        STD     FCBFilePointer+1,X
        BCC     LD81F
        INC     FCBFilePointer,X
LD81F   CLR     <TextDevN
        RTS

LD822   JMP     >DosHookSysError

LD825   JSR     >BasChkDirect
        LDA     <DosCurrCtrlBlk
        JSR     >SuperDosGetFLen
        BNE     LD822
        STU     $0664
        STA     $0666
        CLR     <DosRecLenFlag
        CLR     $067E
        LDA     #$01
        STA     <TextDevN
LD83E   JSR     <BasChrGetCurr
        CMPA    #$3B
        BEQ     LD896
        JSR     >VarCKComma
        CMPA    #$E5
        BNE     LD85F
        JSR     <BasChrGet
        JSR     >VarGetStr
        BSR     LD879
        STU     $0664
        STA     $0666
        LDA     #$FF
        STA     $067E
        BRA     LD83E

LD85F   CMPA    #$80
        BNE     LD870
        JSR     <BasChrGet
        JSR     >Get8BitorError
        STB     <DosNoBytesMove
        LDB     #$FF
        STB     <DosRecLenFlag
        BRA     LD83E

LD870   JMP     >BasSNError

LD873   JMP     >BasFCError

LD876   JMP     >BasTMError

LD879   TST     <BasVarFPAcc1+5
        BMI     LD873
        TST     <BasVarType
        BNE     LD876
        LDA     #$A0
        SUBA    <BasVarFPAcc1
        BEQ     LD892
LD887   LSR     <BasVarFPAcc1+1
        ROR     <BasVarFPAcc1+2
        ROR     <BasVarAssign16
        ROR     <BasVarFPAcc1+4
        DECA
        BNE     LD887
LD892   LDU     <BasVarFPAcc1+2
        LDA     <BasVarFPAcc1+4
LD896   RTS

;
; FWrite command dispatch routine.
;
; Syntax :
;	FWRITE filespec;variable list
;	FWRITE filespec,FROM startpos,FOR numbytes;variable list	
;

CmdFWrite   
	JSR     >LD6C5
        BEQ     LD8A5
        CMPB    #$A0
        BNE     LD908
        JSR     >SuperDosCreateFile
        BNE     LD908
LD8A5   JSR     >LD825
        JSR     >FindFreeDiskBuffer
        BNE     LD908
        STX     $060B
        LDA     #$55
        STA     2,X
        CLR     <DosBytesInDTA
        JSR     <BasChrGet
        JSR     >CmdPrint
        TST     <DosRecLenFlag
        BEQ     LD8CA
        LDB     <DosNoBytesMove
        BEQ     LD8CA
        LDA     #$20
LD8C5   BSR     LD911
        DECB
        BNE     LD8C5
LD8CA   TST     <DosBytesInDTA
        BEQ     LD8E6
        LDX     $060B
        LDX     5,X
        CLRA
        LDB     <DosBytesInDTA
        TFR     D,U
        LDA     <DosCurrCtrlBlk
        LDY     $0664
        LDB     $0666
        JSR     >SuperDosFWrite
        BNE     LD908
LD8E6   LDX     $060B
        CLR     2,X
LD8EB   RTS

DosHookCheckIONum   
	BLE     LD8EB
        CMPB    #$04
        BHI     LD906
        PULS    X,PC

DosHookOpenDev   
	LEAS    2,S
        JSR     >VarGetStr
        JSR     >BasGetStrFirst
        PSHS    B
        JSR     >BasGetDevNo
        TSTB
        LBLE    CmdOpenEntry
LD906   LDB     #$28
LD908   JMP     >DosHookSysError

DosHookCharOut   
	TST     <TextDevN
        BLE     LD8EB
        LEAS    2,S
LD911   PSHS    D,X,Y,U
        LDB     <DosRecLenFlag
        BEQ     LD91B
        LDB     <DosNoBytesMove
        BEQ     LD952
LD91B   LDX     $060B
        LDX     5,X
        LDB     <DosBytesInDTA
        ABX
        STA     ,X
        DEC     <DosNoBytesMove
        INC     <DosBytesInDTA
        BNE     LD952
        LDA     <DosCurrCtrlBlk
        LDX     $060B
        LDX     5,X
        LDU     #$0100
        LDY     $0664
        LDB     $0666
        JSR     >SuperDosFWrite
        BEQ     LD944
        JMP     >DosHookSysError

LD944   LDD     $0665
        ADDD    #$0100
        BCC     LD94F
        INC     $0664
LD94F   STD     $0665
LD952   PULS    D,X,Y,U,PC

DosHookDiskItem   
	TST     <TextDevN
        BLE     LD9BB
        LDX     #$879A
        STX     ,S
LD95D   LDA     <DosRecLenFlag
        BEQ     LD965
        LDA     <DosNoBytesMove
        BEQ     LD9B2
LD965   LDX     #$02DD
        LDB     <DosBytesInDTA
        STB     $0603
        ABX
        LDB     $0604
        STB     DosRunLoadFlag
        CLRB
        STB     -1,X
        STB     <BasBreakFlag
LD979   DEC     <DosNoBytesMove
        DEC     $0604
        INC     <DosBytesInDTA
        LDA     ,X+
        BEQ     LD9B2
        CMPA    #$0D
        BEQ     LD9B2
        TST     DosFlFreadFlag
        BNE     LD995
        CMPA    #$2C
        BEQ     LD9B2
        CMPA    #$3A
        BEQ     LD9B2
LD995   LDA     <DosRecLenFlag
        BEQ     LD99D
        LDA     <DosNoBytesMove
        BEQ     LD9B2
LD99D   INCB
        CMPB    #$FF
        BEQ     LD9B0
        LDA     $0604
        BNE     LD979
        LDB     <BasBreakFlag
        BNE     LD9B0
        BSR     LD9BC
        CLRB
        BRA     LD979

LD9B0   LEAX    1,X
LD9B2   LDB     $0603
        CLR     -1,X
        LDX     #$02DC
        ABX
LD9BB   RTS

LD9BC   JSR     >DosFCBNoToAddr
        CLRA
        LDB     DosRunLoadFlag
        PSHS    D
        LDD     13,X
        SUBD    ,S++
        STD     13,X
        BCC     LD9CF
        DEC     12,X
LD9CF   PSHS    Y,U
        LDU     #$00FF
        BSR     LD9EF
        LDU     #$02DD
        CLR     D,U
        LDA     <DosCurrCtrlBlk
        LDB     14,X
        LDX     12,X
        EXG     X,U
        JSR     >SuperDosFRead
        BNE     LDA25
        LDX     #$02DD
        CLR     -1,X
        PULS    Y,U,PC

LD9EF   PSHS    U
        LDD     13,X
        ADDD    ,S
        PSHS    D
        LDA     12,X
        ADCA    #$00
        SUBA    $10,X
        PULS    D
        BCS     LDA14
        BHI     LDA23
        SUBD    $11,X
        BLS     LDA14
        LDD     $11,X
        SUBD    13,X
        BEQ     LDA23
        STD     ,S
        COM     <BasBreakFlag
LDA14   LDD     ,S
        STB     $0604
        STB     DosRunLoadFlag
        CLR     $0603
        CLR     <DosBytesInDTA
        PULS    Y,PC

LDA23   LDB     #$9A
LDA25   JMP     >DosHookSysError

;
; Dir command dispatch routine
;
; Syntax :
;	DIR drivenum	
;

CmdDir   
	BEQ     LDA2F				; No drive specified, use default
        JSR     >GetDriveNoInB			; Else get from command 
        BRA     LDA32

LDA2F   LDB     DosDefDriveNo			; Get default drive

LDA32   STB     <DosLastDrive			; Flag as last drive used
        CLR     ,-S				; make temp on stack (file number on disk counter)
        JSR     >DosDrivesOffCLS		; Flag drives offline, and clear screen
	
        CLRB
LDA3A   JSR     >BasPollKeyboard		; Read keyboard, check for break
        JSR     >SuperDosGetDirEntry		; Get next dir entry
        BNE     LDA25				; Error : exit
	
        LDA     ,X				; Get Attribute byte
        BITA    #AttrEndOfDir			; Check for end of directory $08
        BNE     CmdDirDoneAll			; Yes : stop processing
	
        BITA    #AttrDeleted+AttrIsCont 	; Is entry a deleted file, or continuation entry ? $81				; and another thing
        BNE     CmdDirDoNextEntry		; yes : do next
	
        LEAX    1,X				; Point at filename
        LDB     #$08				; Up to 8 chars
        BSR     PrintBCharsFromX		; Print it
        LDB     #$04				; 5 chars
        LDA     #$2E				; '.'
        BSR     LDAB8				; Print extension
        LDA     -12,X				; Point at attributes
        BITA    #AttrWriteProt			; Is this a protected file ?
        BEQ     LDA61				; no skip on
        LDA     #'p				; Flag protected $70
;LDA61   EQU     *+1
;        CMPX    #$8620

	FCB	Skip2				; CMPX trick
LDA61	LDA	#$20 
        JSR     >TextOutChar			; output attribute byte
        JSR     >TextOutSpace			; And a space
        LDU     #$FFFF
        LDX     #DosFCB0Addr			; Point at first FCB
        LDB     ,S				; Get file number
        STB     FCBDiskFileNo,X			; Save in FCB
        JSR     >LCB20
        BNE     LDA25				; Check for error
	
        JSR     >LCEBF
        BSR     LDABF				; Print filesize
        LDD     <TextVDUCursAddr		; Check for near end of screen
        CMPD    #$05A0				
        BLS     LDA97				; not near end, skip on
        PSHS    D,X,Y,U				; save regs
        LDX     #DosMoreMess			; Point to message
        JSR     >TextOutString			; Print more: prompt
        JSR     >TextWaitKey			; wait for a key
	JSR     >TextCls			; clear screen
        PULS    D,X,Y,U				; Restore regs
;LDA97   EQU     *+1
;        LDA     #$BD
;        SUBA    <$A1
	
	IFNE	Tandy
	BRA	CmdDirDoNextEntry
	ELSE
	FCB	Skip1LD				; LDA, like cmpx trick
	ENDC
	
LDA97	JSR	TextOutCRLF			; Output EOL
	
CmdDirDoNextEntry   
	INC     ,S				; do next
        LDB     ,S				; Get disk file number counter
        CMPB    #$A0				; More than max files on disk ?
        BCS     LDA3A				; Less, loop again.

;
; We come here either when we have processed $A0 entries, which is the maximum,
; or we have reached an entry with the AttrEndOfDir bit set which signals the end
; of the directory.
;

CmdDirDoneAll   
	PULS    A
        JSR     >SuperDosGetFree		; Get free bytes on drive
        CLRA
        TFR     X,U
        BSR     LDABF				; Display free bytes
        LDX     #BytesFreeMess-1		; Point to message
        JMP     >TextOutString			; print it, and return


; Print B chars pointed to by X, if char is $00, then output a space.
; Used to print filenames.

PrintBCharsFromX   
	LDA     ,X+				; Fetch a char
        BNE     LDAB8				; Is it zero ? no : skip
        LDA     #$20				; Replace it with a space
LDAB8   JSR     >TextOutChar			; Output it
        DECB					; Decrement count
        BNE     PrintBCharsFromX		; any left yes : loop again
        RTS

LDABF   JSR     >LDD9B
        JMP     >TextOutNumFPA0

DosHookReadInput   
	PSHS    D,X,U
        LDX     #$837D
        CMPX    8,S
        BNE     LDAD3
        JSR     >DosHookCloseSingle
        BRA     LDB2D

LDAD3   PULS    D,X,U,PC

BytesFreeMess
        FCC     / BYTES FREE/
        FCB     $0D
        FCB     $00
        FCB     $00
        FCB     $00
        FCB     $00

;
; Auto command dispatch routine
;
; Syntax :
;
;	AUTO startline,increment
;


CmdAuto   
	LDX     <BasCurrentLine		; Get current line number
        LEAX    1,X			; Increment it
        LBNE    BasFCError		; to big : ?FC error
        LDX     #$000A			; Default line no increment 10
        TFR     X,D
        PSHS    D,X			; make room on stack & setup default start and increment
        JSR     <BasChrGetCurr		; Fetch current char pointed to by basic
        BEQ     CmdAutoDoAuto		; Last char : yes proceed 
        JSR     >VarGet16Bit		; get start line no
        LDD     <BasVarAssign16			; check for error
        STD     2,S
        JSR     <BasChrGetCurr		; Fetch current char pointed to by basic
        BEQ     CmdAutoDoAuto		; Last char : yes proceed
        JSR     >VarCKComma		; check for comma
        JSR     >VarGet16Bit		; Get Line increment
        LDD     <BasVarAssign16
        BEQ     CmdAutoErrorExit
        STD     ,S
        JSR     <BasChrGetCurr		; Fetch current char pointed to by basic
        BEQ     CmdAutoDoAuto		; Last char : yes proceed
CmdAutoErrorExit   
	JMP     >BasSNError		; More chars left, SN? error

CmdAutoDoAuto   
	ORCC    #$50			; Disable inturrupts ???
        LDD     ,S++			; Get Increment off stack		
        STD     DosAutoInc
        LDD     ,S++			; Get start line off stack
        SUBD    $060F			; Subtrack increment
        STD     DosAutoCurrent		; Save in current
        LDA     #AutoFlag		; Flag in AUTO mode
        STA     DosAutoFlag
        RTS

        FCB     $34
        FCB     $56

LDB2D   TST     $0613
        BNE     LDB34
LDB32   PULS    D,X,U,PC

LDB34   LDD     $060D
        ADDD    $060F
        CMPD    #$F9FF
        BHI     LDB32
        STD     ,S
        JSR     >TextOutNum16
        LDA     #$20
        JSR     >TextOutChar
        LDU     #$03DA
        LDD     ,S
        STD     $060D
        LDX     #$02DD
        CLRB
LDB56   LDA     ,U+
        BEQ     LDB5F
        STA     ,X+
        INCB
        BRA     LDB56

LDB5F   LDA     #$20
        STA     ,X+
        INCB
LDB64   JSR     >TextWaitKeyCurs2
        CMPA    #$0D
        BEQ     LDB6F
        CMPA    #$03
        BNE     LDB85
LDB6F   CLR     $0613
        LDA     #$0D
        JSR     >TextOutChar
        LEAS    8,S
        CLR     <CasLastSine
        LDX     #$02DD
        LDA     #$0D
        LDB     #$01
        JMP     >BasInBuffFromX

LDB85   CMPA    #$20
        BCS     LDB64
        CMPA    #$7B
        BCC     LDB64
        LEAS    8,S
        CLR     <CasLastSine
        JMP     >BasInBuffFromX

LDB94   CLRA			; A=0	
        LDX     #$0008		; Repeat 8 times
LDB98   JSR     >CasByteOut	; Output A to cassette
        LEAX    -1,X		; Decrement count
        BNE     LDB98		; Loop again if all not done
        RTS

;
; Beep command dispatch routine
;
; Syntax :
;	BEEP nobeeps
;

CmdBeep   
	BEQ     LDBA6		; if no params, default to 1 beep
        JSR     >Get8BitorError	; get beep count 

;LDBA6   EQU     *+1
;        CMPX    #$C601		; LDB #$01 (default beep count)
	
	FCB	Skip2
LDBA6	LDB	#$01		; Default beep count

        PSHS    B		; save count on stack
        CLRB
        JSR     >SndDTOAOn	; switch dound to D to A
LDBAE   BSR     LDB94
        JSR     >BasPollKeyboard
        DEC     ,S		; decrement beep count
        BEQ     LDBC1		; done all : restore and exit
        LDY     #$6000		; wait a short while
LDBBB   LEAY    -1,Y
        BEQ     LDBAE		; loop back and do next beep
        BRA     LDBBB

LDBC1   PULS    B,PC		; restore and return

;
; Wait command dispatch routine.
;
; Syntax :
;	WAIT miliseconds
;

CmdWait   
	BEQ     LDBD6
        JSR     >VarGet16Bit
        LDX     <BasVarAssign16
LDBCA   JSR     >BasPollKeyboard
        LDB     #$A0
LDBCF   DECB
        BNE     LDBCF
        LEAX    -1,X
        BNE     LDBCA
LDBD6   RTS

;
; Swap command dispatch routine.
;
; Syntax :
;	SWAP var1,var2
;

CmdSwap   
	JSR     >VarGetVar
        LDX     <BasVarPtrLast
        LDA     <BasVarType
        PSHS    A,X
        JSR     >VarCKComma
        JSR     >VarGetVar
        PULS    A,Y
        CMPA    <BasVarType
        LBNE    BasTMError
        LDU     <BasVarPtrLast
        LDX     #$0005
LDBF3   LDA     ,U
        LDB     ,Y
        STB     ,U+
        STA     ,Y+
        LEAX    -1,X
        BNE     LDBF3
        RTS

LDC00   LDB     #$8E
LDC02   TST     <WarmStartFlag
        NOP
        LBRA    DosHookSysError

LDC08   LDA     #$55
        STA     <WarmStartFlag
        RTS

;
; If assembling for the DragonDos cartrage, this is the dispatch for
; the boot command, if assembling for the dragon Alpha, I have used
; the space occupied by the boot command to store the code used to
; activate the Alpha's drive selects and motor on, this is reasonable
; because the Alpha has a graphical boot menu, which allows it to boot
; from disk, so this routine seemed expendable.
;

		ifne	DragonAlpha

; Translate DragonDos Drive select mechinisim to work on Alpha 
; Takes byte that would be output to $FF48, reformats it and 
; outputs to Alpha AY-8912's IO port, which is connected to 
; Drive selects, motor on and enable precomp.
; We do not need to preserve the ROM select bit as this code
; operates in RAM only mode.


AlphaDskCtl	
	PSHS	x,A,B,CC,DP

	pshs	a		; Convert drives
	anda	#%00000011	; mask out drive number
	leax	ADriveTab,pcr	; point at table
	lda	a,x		; get bitmap
	ldb	,s
	andb	#%11111100	; mask out drive number
	stb	,s
	ora	,s		; recombine

	bita	#MotorOn	; test motor on ?
	bne	MotorRunning

	clra			; No, turn off other bits.
MotorRunning
	anda	#KnownBits	; Mask out bits we do not know the function of
	sta	,s
		
	lda	#AYIOREG	; AY-8912 IO register
	sta	PIA2DB		; Output to PIA
	ldb	#AYREGLatch	; Latch register to modify
	stb	PIA2DA
		
	clr	PIA2DA		; Idle AY
		
	lda	,s+		; Fetch saved Drive Selects
	sta	PIA2DB		; output to PIA
	ldb	#AYWriteReg	; Write value to latched register
	stb	PIA2DA		; Set register

	clr	PIA2DA		; Idle AY
				
	PULS	dp,x,A,B,CC,pc

	org		$DC46

	else
;		
; Boot command dispatch routine (DragonDos only).
;
; Syntax :
;	BOOT drivenum	
;

CmdBoot   
	BEQ     LDC14		; No drive supplied, use default
        JSR     >GetDriveNoInB	; Get drive number 
        BRA     LDC17

LDC14   LDB     DosDefDriveNo	; use default drive no
LDC17   LDA     #BootFirstSector ; Read boot sector	
        STA     <DskSectorNo
        STB     <LastActiveDrv	; Set drive number
        JSR     >DosDoRestore	; Restore to track 0
        BCS     LDC02		; Error : exit
        
	JSR     >DosDoReadSec2	; Read first 2 chars of boot sec
        BCS     LDC02		; error : exit
	
        LDD     #BootSignature	; Boot signature found ?
        CMPD    <BasVarFPAcc1
        BNE     LDC00		; no : error
	
        LDD     #BootLoadAddr	; start at boot load address
        STD     <DiskBuffPtr	; Set disk buffer to point there
LDC34   JSR     >DosDoReadSec	; Read a sector
        BCS     LDC02		; Error : exit
	
        INC     <DiskBuffPtr	; increment page of buffer pointer	
        INC     <DskSectorNo	; increment sector number
        LDA     <DskSectorNo	; get sector number
        CMPA    #BootLastSector	; Read the whole boot area ?
        BLS     LDC34		; no : read next sector
        
	JMP     >BootEntryAddr	; jump to loaded boot code

	endc

;
;Drive command dispatch routine.
;
; Syntax :
;	DRIVE drivenum	
;

CmdDrive   
	BEQ     LDC4F
        JSR     >GetDriveNoInB
        STB     DosDefDriveNo
        RTS

LDC4F   JMP     >BasSNError

;
; Error command dispatch routine.
;
; Syntax :
;	ERROR GOTO lineno
;

CmdError2   
	CMPA    #$81
        BNE     LDC4F
        JSR     <BasChrGet
        CMPA    #$BC
        BNE     LDC4F
        JSR     <BasChrGet
        JSR     >BasGetLineNo
        LDX     <BasTempLine
        CMPX    #$F9FF
        LBHI    BasFCError
        STX     DosErrDestLine
        BEQ     LDC75
        LDA     #$FF
        STA     $0614
        RTS

LDC75   CLR     $0614
        RTS

LDC79   JSR     >VarCKComma
        JSR     >VarGetVar
        JMP     >VarGetExpr

;
;Sread command dispatch routine.
;
; Syntax :
;	SREAD driveno,trackno,secno,part1$,part2$
;

CmdSread   
	JSR     >GetSreadWriteParams	; Get drive,track,secno
        BSR     LDC79			; Get address of first 128 bytes to read
        PSHS    X			; save on stack
        BSR     LDC79			; Get address of second 128 bytes to read
        
	PSHS    X			; save on stack
        LDB     #$FF
        STB     <DosIOInProgress	; Flag Dos IO in progress
        JSR     >FindFreeDiskBuffer	; Find a buffer to read sector into
        BNE     LDCBA			; Error : exit
	
        CLR     BuffFlag,X		; Clear buffer flag
        LDX     BuffAddr,X		; Get buffer address
        STX     <DiskBuffPtr		; Save as pointer to do read
        JSR     >DosDoReadSec		; Read the sector
	
        STB     $0603			; Save error code in temp storage
        LDU     <DiskBuffPtr		; Get pointer to read data
        LEAU    $0080,U			; Point to second half of sector
        PULS    X			; Get address of second string
        BSR     LDCBD			; Copy bytes to string
        LDU     <DiskBuffPtr		; Point at begining of disk buffer
        PULS    X			; Get address of first string
        BSR     LDCBD			; Copy bytes to string
        CLR     <DosIOInProgress	; Flag Dos IO not in progress
        LDB     $0603			; Retrieve error code from read
        BNE     LDCBA			; Error : go to error handler
        RTS				; return to caller

LDCBA   JMP     >DosHookSysError	; Jump to error hook

LDCBD   PSHS    X,U			
        LDB     #$80
        JSR     >BasResStr
        LEAU    ,X
        PULS    X
        STB     ,X
        STU     2,X
        PULS    X
        JMP     >UtilCopyBXtoU

;
; Swrite command dispatch routine.
;
; Syntax :
;	SWRITE driveno,side,sector,part1$,part2$
;

CmdSwrite   
	BSR     GetSreadWriteParams	; Get drive,track,secno
        BSR     LDD1B
        JSR     >VarGetExpr
        LDX     <BasVarAssign16
        PSHS    X
        BSR     LDD1B
        JSR     >BasGetStrLenAddr
        PSHS    B,X
        LDB     #$FF
        STB     <DosIOInProgress
        JSR     >FindFreeDiskBuffer
        BNE     LDCBA
        CLR     2,X
        LDX     5,X
        STX     <DiskBuffPtr
        CLRB
LDCF3   CLR     ,X+
        DECB
        BNE     LDCF3
        PULS    B,X
        LDU     <DiskBuffPtr
        LEAU    $0080,U
        TSTB
        BEQ     LDD06
        JSR     >UtilCopyBXtoU
LDD06   PULS    X
        JSR     >VarDelVar
        LDU     <DiskBuffPtr
        TSTB
        BEQ     LDD13
        JSR     UtilCopyBXtoU
LDD13   JSR     >DosDoWriteSec
        BCS     LDCBA
        CLR     <DosIOInProgress
        RTS

LDD1B   JSR     VarCKComma
        JMP     >VarGetStr

GetSreadWriteParams   
	BNE     LDD26		; params, read them
        JMP     >BasSNError	; none : SN Error

;
; Get params for Sread/Swrite
;

LDD26   JSR     GetDriveNoInB	; Drive number
        STB     <DosLastDrive
        JSR     >VarGetComma8	; Track number
        CMPB    #$4F		; greater than track 80 ?
        BHI     LDD3A		; Yes : error
        STB     <DskTrackNo	; Save track number
        JSR     >VarGetComma8	; Get sector number
        STB     <DskSectorNo	; save it
LDD39   RTS

LDD3A   JMP     >BasFCError

;
; Verify command dispatch routine.
;
; Syntax :
;	VERIFY ON
;	VERIFY OFF
;

CmdVerify   
	BEQ     LDD4D
        CMPA    #$C2
        BNE     LDD46
        CLRB
        BRA     LDD4F

LDD46   CMPA    #$88
        BEQ     LDD4D
        JMP     >BasSNError

LDD4D   LDB     #$FF
LDD4F   STB     DosVerifyFlag
        JMP     <BasChrGet

DosHookEOF   
	TST     <BasVarType
        BEQ     LDD39
        CLR     <BasVarType
        LEAS    2,S
        LDY     #DosExtDat
        JSR     LD6DF
        BNE     LDD7E
        JSR     SuperDosGetFLen
        BNE     LDD7E
        JSR     DosFCBNoToAddr
        CMPU    12,X
        BHI     LDD76
        CMPA    14,X
        BLS     LDD78
LDD76   CLRA

;LDD78   EQU     *+1
;        CMPX    #$8601

	FCB	Skip2
LDD78	LDA	#$01	

        LDU     <Misc16BitScratch
        BRA     LDD99

LDD7E   JMP     >DosHookSysError

FuncLoc 
	JSR     LD6C5
        BNE     LDD7E
        JSR     DosFCBNoToAddr
        LDU     12,X
        LDA     14,X
        BRA     LDD99

FuncLof 
	JSR     LD6C5
        BNE     LDD7E
        JSR     SuperDosGetFLen
        BNE     LDD7E
LDD99   CLR     <BasVarType

LDD9B   CLRB
        STU     <BasVarFPAcc1+2
        STD     <BasVarFPAcc1+4
        CLR     <BasVarFPAcc2+7
        LDA     #$A0
        STD     <BasVarFPAcc1
        JMP     >VarNormFPA0

FuncFree
	JSR     <BasChrGetCurr
        BEQ     LDDB2
        JSR     GetDriveNoInB
        BRA     LDDB5

LDDB2   LDB     DosDefDriveNo
LDDB5   STB     <DosLastDrive
        JSR     SuperDosGetFree
        BNE     LDD7E
        TFR     X,U
        CLRA
        BRA     LDD99

FuncErl   
	LDD     $0617
LDDC4   JMP     >VarAssign16Bit2

FuncErr   
	CLRA
        LDB     $0619
        BRA     LDDC4

FuncHimem   
	LDD     <AddrFWareRamTop
        BRA     LDDC4

FuncFres   
	JSR     VarGarbageCollect
        LDD     <BasVarStrTop
        SUBD    <BasVarStringBase
        BRA     LDDC4

;
; The actual core disk IO routine, accepts a function code $00..$07
; these are dispatched through this table
;

DosFunctionTable   
	FDB     DosFunctionRestore		; Restore to track 0
        FDB     DosFunctionSeek			; Seek to a track
        FDB     DosFunctionReadSec		; Read a sector
        FDB     DosFunctionWriteSec		; Write a sector
        FDB     DosFunctionWriteSec2
        FDB     DosFunctionWriteTrack		; Write (format) track
        FDB     DosFunctionReadAddr		; Read address mark
        FDB     DosFunctionReadSec2		; Read first two bytes of a sector

;
; Data table for Format ?
;
	
DDDEA   FCB     $01
        FCB     $0A
        FCB     $02
        FCB     $0B
        FCB     $03
        FCB     $0C
        FCB     $04
        FCB     $0D
        FCB     $05
        FCB     $0E
        FCB     $06
        FCB     $0F
        FCB     $07
        FCB     $10
        FCB     $08
        FCB     $11
        FCB     $09
        FCB     $12
        FCB     $00
	
DDDFD   FCC     /5NN/
        FCB     $08
        FCB     $00
        FCB     $00
        FCB     $03
        FCB     $F6
        FCB     $FC
        FCB     $1F
        FCB     $4E
        FCB     $4E
DDE09   FCB     $07
        FCB     $00
        FCB     $00
        FCB     $03
        FCB     $F5
        FCB     $FE
        FCB     $01
        FCB     $F7
        FCB     $4E
        FCB     $14
        FCB     $4E
        FCB     $4E
        FCB     $0B
        FCB     $00
        FCB     $00
        FCB     $03
        FCB     $F5
        FCB     $FB
        FCB     $00
        FCB     $E5
        FCB     $F7
        FCB     $17
        FCB     $4E
        FCB     $4E
        FCB     $00
        FCB     $4E
        FCB     $4E
	
;
; Data copied into low ram at init, inturrupt vectors etc
;
	
DDE24   FCB     $09		; No bytes
        FDB     $0109		; address to copy

; Inturrupt vectors

LDE27   JMP     >NMISrv

LDE2A   JMP     >IRQSrv

LDE2D   JMP     >FIRQSrv

; Dos vars, step rates for drives

        FCB     $04		; No bytes
        FDB     DosD0StepRate	; address to copy
        FCB     SeepRateDefault
        FCB     SeepRateDefault
        FCB     SeepRateDefault
        FCB     SeepRateDefault
	
; New basic dispatch stub
	
        FCB     $1E		; No bytes
	
	IFEQ	Tandy
	FDB	BasStub1	; Copy to stub 1 ($012A) on Dragons
	ELSE	
        FDB     BasStub2	; Copy to stub 1 ($0134) on Tandy 
	ENDC
	
        FCB     $1A
        FDB     DDEDA
        FDB     LC670
        FCB     $07
        FDB     DDEC1
        FDB     LC68B
        FCB     $00
        FDB     $0000
        FDB     BasSNError
        FCB     $00
        FDB     $0000
        FDB     BasSNError
        FCB     $00
        FCB     $00
        FCB     $00
        FCB     $00
        FCB     $00
        FCB     $00
        FCB     $00
        FCB     $00
        FCB     $00
	
        FCB     $00		; No bytes : terminate
        FCB     $00
		
CommandDispatchTable   
	FDB     CmdAuto		; Commented
        FDB     CmdBackup
        FDB     CmdBeep
		
	ifne	DragonAlpha
	FDB	BasSNError	; If assembling for Alpha, just redirect to ?SN error
	else
        FDB     CmdBoot		; Else, if dragondos, boot command 
	endc
		
        FDB     CmdChain
        FDB     CmdCopy
        FDB     CmdCreate
        FDB     CmdDir
        FDB     CmdDrive
        FDB     CmdDskInit
        FDB     CmdFRead
        FDB     CmdFWrite
        FDB     CmdError2
        FDB     CmdKill
        FDB     CmdLoad
        FDB     CmdMerge
        FDB     CmdProtect
        FDB     CmdWait
        FDB     CmdRename
        FDB     CmdSave
        FDB     CmdSread
        FDB     CmdSwrite
        FDB     CmdVerify
        FDB     BasSNError
        FDB     CmdFLRead
        FDB     CmdSwap
		
FunctionDipatchTable   
	FDB     FuncLof
        FDB     FuncFree
        FDB     FuncErl
        FDB     FuncErr
        FDB     FuncHimem
        FDB     FuncLoc
        FDB     FuncFres

;
; New ram hook table copied into low ram
;

	IFEQ	Tandy
; Dragon Table
RamHookTable   
	FDB     DosHookOpenDev		; open dev/file
        FDB     DosHookCheckIONum	; check io num
        FDB     DosHookRetDevParam	; return dev parameters
        FDB     DosHookCharOut		; char output
        FDB     DosHookRetDevParam	; char input
        FDB     DosHookRetDevParam	; check dev open for input
        FDB     DosHookRetDevParam	; check dev open for output
        FDB     DosHookRetDevParam	; close all devs and files
        FDB     DosHookCloseSingle	; close single dev/file
        FDB     DosHookRetDevParam	; first char of new statement
        FDB     DosHookDiskItem		; Disk file item scanner
        FDB     DosHookRetDevParam	; poll for break
        FDB     DosHookReadInput	; read line of input
        FDB     DosHookRetDevParam	; finish loading ASCII program
        FDB     DosHookEOF		; EOF function
        FDB     DosHookRetDevParam	; Eval expression
        FDB     DosHookRetDevParam	; User error trap
        FDB     DosHookSysError		; System error trap
        FDB     DosHookRun		; run statement
	
	ELSE
;CoCo Table.
RamHookTable   
	FDB     DosHookOpenDev		; open dev/file
        FDB     DosHookCheckIONum	; check io num
        FDB     DosHookRetDevParam	; return dev parameters
        FDB     DosHookCharOut		; char output
        FDB     CoCoVect16A		; char input
        FDB     DosHookRetDevParam	; check dev open for input
        FDB     DosHookRetDevParam	; check dev open for output
        FDB     DosHookRetDevParam	; close all devs and files
        FDB     DosHookCloseSingle	; close single dev/file
        FDB     CoCoVect179		; first char of new statement
        FDB     DosHookDiskItem		; Disk file item scanner
        FDB     DosHookRetDevParam	; poll for break
        FDB     DosHookReadInput	; read line of input
        FDB     DosHookRetDevParam	; finish loading ASCII program
        FDB     DosHookEOF		; EOF function
        FDB     CoCoVect18B		; Eval expression
        FDB     DosHookRetDevParam	; User error trap
        FDB     DosHookSysError		; System error trap
        FDB     DosHookRun		; run statement

	ENDC
	
;
; New Function names table
;
	
DDEC1   FCC     /LO/
        FCB     $C6
        FCC     /FRE/
        FCB     $C5
        FCC     /ER/
        FCB     $CC
        FCC     /ER/
        FCB     $D2
        FCC     /HIME/
        FCB     $CD
        FCC     /LO/
        FCB     $C3
        FCC     /FRE/
        FCB     $A4
	
;
; New Command names table
;
	
DDEDA   FCC     /AUT/
        FCB     $CF
        FCC     /BACKU/
        FCB     $D0
        FCC     /BEE/
        FCB     $D0
        FCC     /BOO/
        FCB     $D4
        FCC     /CHAI/
        FCB     $CE
        FCC     /COP/
        FCB     $D9
        FCC     /CREAT/
        FCB     $C5
        FCC     /DI/
        FCB     $D2
        FCC     /DRIV/
        FCB     $C5
        FCC     /DSKINI/
        FCB     $D4
        FCC     /FREA/
        FCB     $C4
        FCC     /FWRIT/
        FCB     $C5
        FCC     /ERRO/
        FCB     $D2
        FCC     /KIL/
        FCB     $CC
        FCC     /LOA/
        FCB     $C4
        FCC     /MERG/
        FCB     $C5
        FCC     /PROTEC/
        FCB     $D4
        FCC     /WAI/
        FCB     $D4
        FCC     /RENAM/
        FCB     $C5
        FCC     /SAV/
        FCB     $C5
        FCC     /SREA/
        FCB     $C4
        FCC     /SWRIT/
        FCB     $C5
        FCC     /VERIF/
        FCB     $D9
        FCC     /FRO/
        FCB     $CD
        FCC     /FLREA/
        FCB     $C4
        FCC     /SWA/
        FCB     $D0
	
;
; Some mesagaes
;

; Dragon versions slightly more verbose, as I had to create space for extra
; code whenporting to RS-DOS cart, by shortening messages, iliminating 
; whitespace etc
; 
	IFEQ	RSDos 
        FCC     /INSERT SOURCE    /
        FCB     $0D
        FCB     $00
        FCC     /INSERT DESTINATION     /
        FCB     $0D
MessPressAnyKey   
	FCB     $00
        FCC     /PRESS ANY KEY        /
        FCB     $0D
        FCB     $00

	ELSE

        FCC     /INSERT SOURCE    /
        FCB     $0D
        FCB     $00
        FCC     /INSERT DEST/
	FCC	/INATION     /
        FCB     $0D
MessPressAnyKey   
	FCB     $00
        FCC     /PRESS ANY KEY     /
        FCB     $0D
        FCB     $00

	ENDC
;
; File extensions
;
	
DosExtBas   
	FCC     /BAS/
DosExtDat	
	FCC	/DAT/
DosExtBin	
	FCC	/BIN/
DosExtNone	
	FCC	/   /
	
DosErrorCodeTable
	FCC	/NRSKWPRTRFCCLDBTIVFDDFFSPTPEFFFENETFPR?/

DosSignonMess		
	ifne	DragonDos	
	FCC	/?SUPERDOS E6 /
	endc

	ifne	DragonAlpha	
	FCC	/?SUPERDOS E7a/
	endc
	
	ifne	RSDos	
	ifne	Tandy
	FCC	/?SUPERDOS E7C/		; RSDos cart/Tandy CoCo
	else
	FCC	/?SUPERDOS E7T/		; RSDos cart/Dragon
	endc
	endc
		
        FCB     $0D
        FCB     $00
DosMoreMess   FCB     $00
	IFEQ	RSDos
	FCC	/  /
	ENDC
        FCC     / MORE:/
        FCB     $00
        FCB     $00

	ifne	DragonDos
	FCC    	/        /
	endc

;
; Drive lookup table used by Dragon Alpha
;
	ifne	DragonAlpha
	FCC	/    /
ADriveTab
	FCB	Drive0,Drive1,Drive2,Drive3
	ENDC

;
; Drive lookup table used on RS-DOS controler
;
	
	IFNE	RSDos
TDriveTab
	FCB	Drive0,Drive1,Drive2,Drive3
	ENDC

LDFF3   LDA     2,X
        DECA
        BNE     LDFFA
        STA     2,X
LDFFA   LDX     DosCurLSN
        RTS

        FCB     $61
        FCB     $34

;DE000   END
