                        .386
                        .MODEL FLAT
                        ExitProcess PROTO NEAR32 stdcall, dwExitCode:DWORD
						include io.h
                        cr      EQU     0dh     ; carriage return character
                        Lf      EQU     0ah     ; line feed
						
                        myoutput EQU -11        ;the output handle is screen
                        myinput EQU -10         ;the input handle is keyboard

                        GENERIC_WRITE EQU 40000000h     ; a definition for desired access
                        GENERIC_READ EQU 80000000h      ;

                        CREATE_NEW EQU 1       ; for writing : only create when file does not exist
                        CREATE_ALWAYS EQU 2    ; for writing : create if does not exist and overwrite if exist
                        OPEN_EXISTING EQU 3
							GetStdHandle PROTO NEAR32 stdcall,nStdHandle:DWORD

                        	ReadFile PROTO NEAR32 stdcall,hFile:DWORD, lpBuffer:NEAR32, nNumberOfCharsToRead:DWORD,lpNumberOfBytesRead:NEAR32, lpOverlapped:NEAR32

                        	WriteFile PROTO NEAR32 stdcall,hFile:DWORD, lpBuffer:NEAR32, nNumberOfCharsToWrite:DWORD,lpNumberOfBytesWritten:NEAR32, lpOverlapped:NEAR32

                        	CreateFileA PROTO NEAR32 stdcall,lpFileName:NEAR32, access:DWORD, shareMode:DWORD,lpSecurity:NEAR32, creation:DWORD, attributes:DWORD, copyHandle:DWORD

                        	CloseHandle PROTO NEAR32 stdcall,fHandle:DWORD
                        ;==========================================================================
                        .DATA
						tmp byte 20 dup (" "),0
						tmp2 byte 6 dup (" "),0
                        fail 	DWORD 	?        	;for last CopyFileA parameter
                        written DWORD ?
                        read DWORD ?
						k byte "kir",0
						helper dword ?
						crlf   byte  cr,Lf,0
                        choice BYTE 3 DUP (?)   ; for choosing desired item in menu
						buffer2 word ?
                        fileName BYTE 60 DUP (?);the name of the file
						line byte "=================================================",0
                        hStdOut DWORD ?          ;for output
                        hStdIn DWORD ?           ;for input
                        hFile DWORD ?
						t byte cr,lf,"test",0 
						io4 byte 6 dup(" "),0
                        buffer BYTE 128 DUP (?)
						io1 byte 10 dup(" "),0
						io2 byte 10 dup(" "),0
						io3 byte 11 dup(?),0
						io byte 10 dup(?),0
                        prompt1 BYTE "File name (Source File)?"
						maxmsg byte "Max Score: ",0
						minmsg byte "Min Score: ",0
						nomsg byte "Number Of Students : ",0
                        menu BYTE cr,lf,"In The Name OF God ",cr,lf,cr,lf
                             BYTE "Choose One Of These Items :  ",cr,lf,cr,lf
                             BYTE "1.Show Whole Class Info [ Bonus ] ",cr,lf,cr,lf
                             BYTE "2.Sort By Grade  ",cr,lf,cr,lf
                             BYTE "3.Sort By Name ",cr,lf,cr,lf
							 Byte "4.Save On A file ",cr,lf,cr,lf
							 Byte "5.Search By FullName",cr,lf,cr,lf
							BYTE "6.Show Total Info ",cr,lf,cr,lf
							 Byte "7.Exit ",cr,lf,cr,lf,0
							 
							 
						EM byte "Here",0 
						max word ?
						wrongInput byte "Wrong Input , Please try Again Later " ,0	 
						
						floatingpoint byte "The Average:",0
						fp1 byte 11 dup(?),0
						fp2 byte ".",0
						fp3 byte 11 dup(?),0
						fp4 byte 11 dup(?),0
						
						numberOfAllCourses word ?
						allStdNames byte 2000 dup(" "),0
						allScores	word 100 dup(?),0
						allLessons byte 100 dup(" "),0
						eachLessonStdNo word 5 dup(?),0
						chertopert byte " $$$$$$$$$$  ",0
						characterlen word 19
						
                        ;===========================================================================
						;===========================================================================
						.CODE
                        _start:
						  INVOKE GetStdHandle,myoutput
                        	mov hStdOut, eax

						  INVOKE GetStdHandle,myinput
                        	mov hStdIn, eax
						;-------------------------------------------------------------
						;&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&& READ N FROM FILE &&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
						readl:
						pushad
							INVOKE WriteFile,hStdOut, NEAR32 PTR prompt1,24,NEAR32 PTR written,0
						popad
						pushad
							INVOKE ReadFile,hStdIn,NEAR32 PTR fileName,60,NEAR32 PTR read,0
						popad
								mov ecx, read
								mov BYTE PTR fileName[ecx-2],0
							INVOKE CreateFileA,NEAR32 PTR fileName,GENERIC_READ,0,0,OPEN_EXISTING,0,0
								mov hFile, eax                 ;handle for file							
							;READ THE NUMBER OF ALL COURSES FROM THE FILE
							readLoop1:
								INVOKE ReadFile,hFile,NEAR32 PTR buffer,3,NEAR32 PTR read,0
								; INVOKE WriteFile,hStdOut,NEAR32 PTR buffer,read,NEAR32 PTR written,0
								cmp read, 4
								   jnl readLoop1
								atoi buffer
								mov numberOfAllCourses, ax					; now the n is the number of courses
						;&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&&
						pushad
						movzx ecx , ax
						lea edi , allLessons
						lea ebx , eachLessonStdNo
						lea ebp , allStdNames
						lea edx , allScores
						_loop1 :
								;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% Lesson = readfile(23) %%%%%%%%%%%%%%%%%%%%%%%%%%
									push edi 
									_loop2 :
										pushad
										INVOKE ReadFile,hFile,NEAR32 PTR buffer,1,NEAR32 PTR read,0
										popad
										lea   esi , buffer
										cmp byte ptr [esi] , 0dh
											je _endofloop2
										push ax
										mov al , byte ptr [esi]
										mov [edi],al
										inc edi
										pop ax
										jmp _loop2
									_endofloop2:
									pop edi
									add edi , 19
									mov byte ptr [edi],0
									inc edi
								;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
								;@@@@@@@@@@@@@@@@@@@@@@
								jmp _endOfLoop1Emergency2
								_Loop1Emergency2 :
									loop _loop1
									jmp _endofloop1
								_endOfLoop1Emergency2 :
								;@@@@@@@@@@@@@@@@@@@@@@
								;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% stdno = readfile(5)	%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
								
								pushad
								INVOKE ReadFile,hFile,NEAR32 PTR buffer,1,NEAR32 PTR read,0
								popad
								push ebx
								lea ebx , io
								mov byte ptr [ebx] , " "
								mov byte ptr [ebx + 1] , " "
								_loop3 :
									pushad
									INVOKE ReadFile,hFile,NEAR32 PTR buffer,1,NEAR32 PTR read,0
									popad
									cmp byte ptr [esi] , 0dh 
										je _endofloop3
									
									mov ax , 0
									mov al , byte ptr [esi]
									mov byte ptr [ebx] , al
									inc ebx
									jmp _loop3
									_endofloop3:
										pushad
										INVOKE ReadFile,hFile,NEAR32 PTR buffer,1,NEAR32 PTR read,0
										popad
										pop ebx
										atoi io
										mov [ebx] , ax
										add ebx , 2
								;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
								;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
								jmp _endOfLoop1Emergency
								_Loop1Emergency :
									jmp _Loop1Emergency2
								_endOfLoop1Emergency :							
								;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
								;#################################### WE GO TO SECOOND LOOP ###########################################################
								push ecx
								movzx ecx , ax
								_loop4 :

								;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% name = readfile(22) %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
									push ebp
									_loop5 :
										pushad
										INVOKE ReadFile,hFile,NEAR32 PTR buffer,1,NEAR32 PTR read,0
										popad
										
										lea esi , buffer
										cmp byte ptr [esi] , 0dh
											je _endofloop5
										push ax
										mov al , byte ptr [esi]
										mov [ebp],al
										inc ebp
										pop ax
										jmp _loop5
									_endofloop5:
										pop ebp
										add ebp , 19
										mov byte ptr [ebp],0
										inc ebp

								;%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
								jmp _endofemergerncyJump
								_emergencyJumpLable :
									loop _loop4
									jmp _endofloop4
								_endofemergerncyJump :
								;^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^ ALL SCORES.ADD (SCORE ) ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
								pushad
								INVOKE ReadFile,hFile,NEAR32 PTR buffer,1,NEAR32 PTR read,0
								popad
								push ebx
								lea ebx , io
								mov byte ptr [ebx] , " "
								mov byte ptr [ebx + 1] , " "
								_loop6 :
									pushad
									INVOKE ReadFile,hFile,NEAR32 PTR buffer,1,NEAR32 PTR read,0
									popad
									cmp byte ptr [esi] , 0dh 
										je _endofloop6
									push ax
									mov al , byte ptr [esi]
									mov byte ptr [ebx] , al
									inc ebx
									pop ax
									jmp _loop6
									
									_endofloop6:
									pushad
										INVOKE ReadFile,hFile,NEAR32 PTR buffer,1,NEAR32 PTR read,0
									popad
										pop ebx
										push ax
										atoi io
										mov [edx] , ax
										add edx , 2
										pop ax
								;^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^	
									jmp _emergencyJumpLable
								_endofloop4 :
									pop ecx
							;######################################### END OF SECOND LOOP ###################################################################################
							jmp _Loop1Emergency
							_endofloop1 :
								popad
						INVOKE CloseHandle,hfile
						;===============================================================================
						jmp exitl
						
						ShowAllInfo proc near32
							push edi
							mov edi , esp
							mov eax , [edi + 8 ]	;No Of All Courses address
							mov dx , word ptr [eax]
							movzx ecx , dx
							mov ebp , [edi + 24]	;all names address
							mov edx , [edi + 20]	;all scores address
							mov ebx , [edi + 16]	;all lessons address
							mov esi , [edi + 12]	;each lesson std no
							_loop7 :
								;NAME OF THE LESSON
								output crlf
								output [ ebx ]
								add ebx , 20
								push ecx
								mov cx ,word ptr [esi]
								movzx ecx , cx
								add esi , 2
								
								_loop8 :
									;NAME OF THE STUDENT
									output crlf
									output [ebp]
									add ebp , 20
									;SCORE OF STUDENT
										itoa io2,[edx]
										add edx , 2
										output io2
								loop _loop8
								_endofloop8:
								output crlf
								pop ecx
								loop _loop7
							_endofloop7:
							pop edi
							ret 0
						ShowAllInfo endp
						;((((((((((((((((((((((((((((((((((((((((((((((((((((
						displayInfo proc near32
							push ebp
							mov eax , [esp + 8 ]	;No Of All Courses address
							mov dx , word ptr [eax]
							movzx ecx , dx
							mov edi , [esp + 20]	;all scores address
							mov ebp , [esp + 16]	;all lessons address
							mov esi , [esp + 12]	;each lesson std no
							_loop9 :
								;NAME OF THE LESSON
									output crlf
									output [ebp]
									output crlf
									output nomsg
									add ebp , 20 
									push ecx
									movsx ecx ,word ptr [esi]
									mov helper , ecx
									dtoa io3,ecx
									output io3 + 9
									add esi , 2
									mov dx , word ptr [edi]
									mov bx , word ptr [edi]
								
								
								jmp _endofloop9emergency
								;??????????????????????????????????????????//
								_loop9emergency :
									loop _loop9
									jmp _here
								_endofloop9emergency:
								;?????????????????????????????????????????//
								;MAX & MIN
								push eax
								mov eax , 0
								_loop10:
									add ax , word ptr [edi]
									cmp dx ,word ptr [edi]
										jge _continue1
									mov dx ,word ptr [edi]
									_continue1:
									cmp bx , word ptr [edi]
										jle _continue2
									mov bx ,word ptr [edi] 
									_continue2:
									add edi , 2
									loop _loop10
								_endofloop10:
								itoa io , dx
								output crlf
								output maxmsg
								output io
								output crlf
								itoa io , bx
								output minmsg
								output io
								output crlf
								;floatingpoint byte "The Average:" , 11 dup(?) , ".",11 dup(?),0 ;12
								
								movsx eax , ax
								cdq
								div helper					; edx : eax 
								dtoa fp1 , eax 
								mov eax , edx
								cdq
								push ebx 
								mov ebx , 10
								
								mul ebx			;edx : eax
								pop ebx
								div helper					; edx : eax 
								dtoa fp3 , eax
								
								mov eax , edx
								cdq
								push ebx 
								mov ebx , 10
								mul ebx			;edx : eax
								pop ebx
								div helper					; edx : eax 
								dtoa fp4, eax
								
								output floatingpoint
								output fp1 + 9
								output fp2
								output fp3 + 10
								output fp4 + 10
								output crlf
								output line
								pop eax
								pop ecx
								jmp _loop9emergency
								_here:
							_endofloop9:
							pop ebp
							ret 4
						displayInfo endp
						;===============================================================================
						sortGrade proc near32
							push ebp
							
							mov  ebp , esp
							mov esi , [ebp + 24]	; address of all names
							mov edi , [ebp + 20 ]	; address of grades
							mov eax , [ebp + 8] 	
							mov cx  , word ptr [eax] 	
							movsx ecx , cx		; number of all courses		
							mov ebx , [ebp + 12 ]	; each lesson std no Address
							mov edx , [ebp + 16 ] 	; all lesons names
							_EnewLoop :
							output crlf
								output chertopert
								output [edx]
								output chertopert
								add edx , 20
								output crlf
								push edx
								push ecx
								mov cx , word ptr [ebx]
								movzx ecx , cx
								;	SORTING DATA
								_Eloop6 :
									push ecx
									dec ecx
									push edi
									push esi
									cmp ecx , 0
										jle _Eendofloop6
									_Eloop7 :
										mov ax , [edi + 2]
										cmp ax , [edi]
											jge _Eendofloop7
											push ebx
											; swap the numbers
											mov    bx, [edi]
											mov    [edi + 2], bx
											mov    [edi], ax
											pop ebx
											;^^^^^^^^^^^^^^^^^^^^^^^^
											jmp _EndofemergencyEnewLoop
												_emergencyEnewLoop :
													loop _EnewLoop
													jmp _EnewLoopSucks
												_EndofemergencyEnewLoop :
											;^^^^^^^^^^^^^^^^^^^^^^^^
											; swap strings
											push esi
											mov ax , 20
											_Eloop8 :
													cmp ax , 0
														jle _Eendofloop8
														mov dl , byte ptr [esi]
														mov dh , byte ptr [esi + 20 ]
														mov byte ptr [esi] , dh
														mov byte ptr [esi + 20 ] , dl
														inc esi
														dec ax
											jmp _Eloop8
										_Eendofloop8:
										pop esi
										_Eendofloop7:
										add    edi , 2
										add    esi , 20
										loop  _Eloop7
									_Eendofloop6 :
									pop    esi
									pop    edi
									pop    ecx
									loop  _Eloop6
							; PRINTING DATA
							
							  mov cx  , word ptr[ebx] 	; amount of n
							  movzx ecx , cx
								mov edx , 0
								_Eloop9 :
										mov dx , [edi]
										add edi , 2
										itoa io, dx
									
									jmp _Eb1
									_b1 :
									loop _Eloop9
									jmp _Eendofloop9
									_Eb1:
											output [esi]
											add esi , 20
											output io
											output crlf
											output line
											output crlf
								jmp _b1 			
								_Eendofloop9:
								add ebx , 2
								pop ecx
								pop edx
								jmp _emergencyEnewLoop 
								_EnewLoopSucks :
							_endofloopnew :
							
							
							lea esi , allStdNames
							push esi
							
							lea esi , allScores
							push esi
							
							lea esi , allLessons
							push esi
							
							lea esi , eachLessonStdNo
							push esi
							
							lea esi , numberOfAllCourses
							push esi	
							
							call SaveInFile
							
							
							
							
							
							add esp , 20
							pop ebp
							ret 0
							sortGrade endp
						;===============================================================================
						SortName  proc  near32
							push  ebp
							mov    eax , [esp + 16 ]  ; Address : All Courses Names
							mov    ebp , [esp  + 20 ] ; Address : All Scores
							mov    ecx , [ esp + 8  ] ; Address : no of all courses 
							movzx  ecx , word ptr [ecx];no of all courses
							mov    esi , [ esp + 24 ]  ;Address : all std names
							mov    edx , [ esp + 12 ]  ;Address : Each Lesson STD Number
							mov    edi , esi      
							add    esi , 20
							; Esi = Edi + 20
							;check all courses students
							_SLoop6 :
								push ebp
								;output [eax]
								add eax , 20
								;output crlf
								
								push ecx
								movzx ecx , word ptr [edx]
								
								;push edx
								dec ecx;#
											;*****
											jmp _EEMSLoop6
											_EMSLoop6 :
												push eax
												push ebx
												push ecx
												
												mov eax , 20
												movzx ebx , word ptr [edx]
												mov ecx,edx
												mul ebx
												add esi , eax
												add edi , eax 
												
												mov edx , ecx
												
												mov eax , 2
												movzx ebx , word ptr [edx]
												mul ebx
												add ebp , eax

												mov edx , ecx
												
												
												pop ecx
												pop ebx
												pop eax
												add edx , 2
												
												loop _SLoop6
												jmp _EndSLoop6 
											_EEMSLoop6 :
											;*****
								;compare all names of a course
								_SLoop9 :
									
									push ecx
									movzx ecx , word ptr [edx]
									dec ecx
									push edi
									push esi
									push ebp
							
									_SLoop7 :
										push ecx
										mov ecx , 19
										push edi
										push esi
										;Check 2 names 
										_SLoop8 :
											mov bh , byte ptr [esi]
											cmp byte ptr [edi] , bh
												jg _Replace
												jl _AlwaysBlock
												je _Continue
											_Continue:
												inc edi 
												inc esi
												loop _SLoop8
												jmp _AlwaysBlock
												
											;***********
											jmp _EEMSLoop9
											_EMSLoop9 :
											
												loop _SLoop9
												jmp _EndSLoop9 
											_EEMSLoop9 :
											;***********
											_Replace :
												call replace_strings
												;Swap Scores here
												push eax
												push ecx
												
												mov ax , word ptr [ebp + 2 ]
												mov cx , word ptr [ebp ]
												mov word ptr [ ebp + 2 ] , cx
												mov word ptr [ ebp ] , ax
												
												pop ecx
												pop eax
												
											_AlwaysBlock :
												pop esi
												pop edi
												add ebp , 2
												add esi , 20
												add edi , 20
												jmp _EndSLoop8
										_EndSLoop8 :
										pop ecx
										loop _SLoop7
									_EndSLoop7 :
									pop ebp
									pop esi
									pop edi
									pop ecx
									
									jmp _EMSLoop9
								_EndSLoop9 :
								;pop edx
								pop ecx
								pop ebp
								jmp _EMSLoop6
							_EndSLoop6 :
							
							lea esi , allStdNames
							push esi
							
							lea esi , allScores
							push esi
							
							lea esi , allLessons
							push esi
							
							lea esi , eachLessonStdNo
							push esi
							
							lea esi , numberOfAllCourses
							push esi
							
							call ShowAllInfo
							call SaveInFile

							add esp , 20
							pop ebp
							ret 0
							
						SortName  endp
;((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((((
						replace_strings proc near32
							push    ebp
							push eax
							mov     ebp,esp
							mov      ecx,19		;#
							mov     esi,[ebp+12]
							mov    edi,[ebp+16]
						  for9:
							mov    al,[esi]
							mov    ah,[edi]
							mov    [esi],ah
							mov    [edi],al
							inc    esi
							inc    edi
							loop for9
						pop eax
						pop    ebp
						ret    0						;#
							
						replace_strings endp
;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ save in file @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@

	SaveInFile proc near32 
		INVOKE GetStdHandle,myoutput
		mov hStdOut, eax

		INVOKE GetStdHandle,myinput
		mov hStdIn, eax

		pushad
			INVOKE WriteFile,hStdOut, NEAR32 PTR prompt1,24,NEAR32 PTR written,0  ;print promote
		popad
		
		pushad
			INVOKE ReadFile,hStdIn,NEAR32 PTR fileName,60,NEAR32 PTR read,0
		popad
		
		mov ecx, read 
		mov BYTE PTR fileName[ecx-2],0 


		INVOKE CreateFileA,NEAR32 PTR fileName,GENERIC_WRITE,0,0,CREATE_ALWAYS,0,0
		mov hFile, eax 

		;pushad
		;INVOKE WriteFile,hStdOut, NEAR32 PTR fileName,60,NEAR32 PTR written,0  ;print promote
		;popad
		
		mov esi ,  [esp + 20] 	;all std names
		mov edi ,  [esp + 16] 	;all scores
		mov	ebx	,  [esp + 12]   ;all lesson
		mov edx ,  [esp + 4 ]	;
		movzx ecx , word ptr [edx] ;number of all courses
		mov edx ,  [esp + 8 ]	;eachLessonStdNo
		
		myloop1 :
			pushad
			mov	ecx,20
			lea	edi,tmp
			mov esi,ebx
			rep movsb
			popad
			pushad
				INVOKE WriteFile,hfile, NEAR32 PTR tmp,20,NEAR32 PTR written,0 
			popad
			add ebx,20
			pushad
				INVOKE WriteFile,hfile, NEAR32 PTR crlf,2,NEAR32 PTR written,0 
			popad
			push ecx
			movzx ecx , word ptr [edx] ; each lesson No
			add		edx,2
			
			jmp End_emergencyloop
			emergencyloop:
				loop myloop1
				jmp endmyloop1
			End_emergencyloop:
			myloop2 :
				pushad
				mov	ecx,19
				lea	edi,tmp
				rep movsb
				popad
				pushad
					INVOKE WriteFile,hfile, NEAR32 PTR tmp,19,NEAR32 PTR written,0 
				popad
				add		esi,20			
				pushad
				itoa tmp2,[edi]
				popad
				add edi,2
				pushad
					INVOKE WriteFile,hfile, NEAR32 PTR tmp2,6,NEAR32 PTR written,0 
				popad
				pushad
					INVOKE WriteFile,hfile, NEAR32 PTR crlf,2,NEAR32 PTR written,0 
				popad
				loop	myloop2
			_endmyloop2:
			pop ecx
			jmp emergencyloop
		endmyloop1 :
			mov edx ,  [esp + 4 ]
			cmp cx,word ptr [edx]
			_endmyloop1:
			output t
			INVOKE CloseHandle,hfile
			ret 
	SaveInFile endp

;@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@
						;===============================================================================
						exitl:
						
						lea esi , allStdNames
						push esi
						
						lea esi , allScores
						push esi
						
						lea esi , allLessons
						push esi
						
						lea esi , eachLessonStdNo
						push esi
						
						lea esi , numberOfAllCourses
						push esi
						
						_again:
								
								output menu
								input io,10
								atoi io
								
								cmp ax , 1
									je	_ShowAllInfo
								cmp ax , 2
									je _SortByGrade
								cmp ax , 3
									je _SortByName
								cmp ax , 4
									je _SaveOnFile
								cmp ax , 5
									je _SearchByFullName
								cmp ax , 6
									je _ShowInfo
								cmp ax , 7
									je _EndOfProgram
								jmp _WrongInput
								
						
						_ShowAllInfo:
							call ShowAllInfo
							jmp _again
						_ShowInfo:
							call displayInfo
							jmp _again
						
						_SortByGrade:
							call sortGrade
							jmp _again
						
						_SortByName:
							call SortName
							jmp _again
						
						_SaveOnFile:
							call SaveInFile
							jmp _again
						
						_SearchByFullName:
							jmp _again
						
						_WrongInput:
							output wrongInput
							jmp _again	
								
						_EndOfProgram:
					    INVOKE ExitProcess, 0
					    PUBLIC _start
                        END
						
						
						
						
						
