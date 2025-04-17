ENTRY(_start)
SECTIONS
{
	. = 0x84000000;
	.text : { *(.text.boot) *(.text) }
	.rodata : { *(.rodata) }
	.data : { *(.data) }
	.bss : { *(.bss) }
	_end = . ;
}
