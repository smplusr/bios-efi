[bits 16]

[org 0x7c00]


preload:	mov	ax, 0x1000
		mov	si, ax
		mov	di, ax


boot:		call	input
		call	output
		call	eval

end:		jmp	boot





input:		push	ax
		
		xor	ax, ax
		int	0x16
		mov	[si], ax
		inc	si
		inc	si
		
		pop	ax
		ret




output:		push	ax
		
		mov	ax, [si - 2]
		mov	ah, 0xe
		int	0x10
		
		pop	ax
		ret




print:		push	ax
		push	bx
		mov	bx, di

.loop		mov	ax, [bx]
		mov	ah, 0xe
		int	0x10
		inc	bx
		inc	bx
		
.test		cmp	bx, si
		jne	.loop

		pop	bx
		pop	ax
		ret





here:		mov	[si], si
		inc	si
		inc	si
		
		ret



base:		mov	[si], di
		inc	si
		inc	si
		
		ret



drop:		push	ax

		mov	[si], ax
		dec	si
		dec	si

		pop	ax
		ret


load:		push	ax

		mov	ax, [si - 2]
		call	drop
		mov	si, ax

		pop	ax
		ret



inc:		push	ax

		mov	ax, [si - 2]
		inc	ax
		mov	[si - 2], ax

		pop	ax
		ret



dec:		push	ax

		mov	ax, [si - 2]
		dec	ax
		mov	[si - 2], ax

		pop	ax
		ret


set:		push	ax
		push	bx

		mov	bx, [si - 2]
		mov	ax, [si - 4]
		mov	[bx], ax

		inc	bx
		inc	bx

		mov	[si - 4], bx
		call	drop

		pop	bx
		pop	ax
		ret


get:		push	ax
		push	bx

		mov	bx, [si - 2]
		mov	ax, [bx]

		dec	bx
		dec	bx
		inc	si
		inc	si

		mov	[si - 4], ax
		mov	[si - 2], bx

		pop	bx
		pop	ax
		ret


eval:		push	ax
		
		mov	ax, [si - 2]	; Getting the character to check
		call	drop		; Remove the top of the stack


		cmp	al, '?'		; Testing character for matching instruction
		je	.print

		cmp	al, ';'
		je	.input

		cmp	al, ','
		je	.output

		cmp	al, '_'
		je	.drop

		cmp	al, '#'
		je	.base

		cmp	al, '@'
		je	.here

		cmp	al, 'L'
		je	.load

		cmp	al, '+'
		je	.inc

		cmp	al, '-'
		je	.dec

		cmp	al, '<'
		je	.set
		
		cmp	al, '>'
		je	.get


		mov	[si], ax	; Case when no instruction has been found
		inc	si		; Push back the checked character and excess data onto the stack
		inc	si

.end		pop	ax
		ret		


.print		call	print
		jmp	.end

.input		call	input
		jmp	.end

.output		call	output
		jmp	.end

.here		call	here
		jmp	.end

.base		call	base
		jmp	.end

.drop		call	drop
		jmp	.end

.load		call	load
		jmp	.end

.inc		call	inc
		jmp	.end

.dec		call	dec
		jmp	.end

.set		call	set
		jmp	.end
	
.get		call	get
		jmp	.end



times 510 - ($ - $$) db 0
dw 0xaa55
