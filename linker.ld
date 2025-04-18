SECTIONS
{
	. = 0x46200000;
	.text : { *(.text.boot) *(.text) }
	.rodata : { *(.rodata) }
	.data : { *(.data) }
	.bss : { *(.bss) }
	_end = . ;
}
_load_start = 0x40200000;
