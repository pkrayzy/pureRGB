	db DEX_PONYTA ; pokedex id

	db  50,  85,  55,  90,  65
	;   hp  atk  def  spd  spc

	db FIRE, FIRE ; type
	db 190 ; catch rate
	db 152 ; base exp

	INCBIN "gfx/pokemon/front/ponyta.pic", 0, 1 ; sprite dimensions
	dw PonytaPicFront, PonytaPicBackSW

	db EMBER, TACKLE, NO_MOVE, NO_MOVE ; level 1 learnset
	db GROWTH_MEDIUM_FAST ; growth rate

	; tm/hm learnset
	tmhm \
	TOXIC,\
	HORN_DRILL,\
	BODY_SLAM,\
	DOUBLE_EDGE,\
	AURORA_BEAM,\
	BARRIER,\
	SOLARBEAM,\
	DRAGON_RAGE,\
	KINESIS,\ ; FIREWALL
	SWORDS_DANCE,\
	REFLECT,\
	BIDE,\
	AGILITY,\
	BARRAGE,\
	FIRE_BLAST,\
	FLAMETHROWER,\
	SLAM,\ ; FILTHY SLAM
	LIGHT_SCREEN,\
	GLARE,\
	SUBSTITUTE,\
	STRENGTH,\
	FLASH
	; end


	db BANK(PonytaPicFront)
	db 0
	db BANK(PonytaPicBack)
	db BANK(PonytaPicBackSW)

	dw 0, PonytaPicBack

