	db DEX_DRAGONAIR ; pokedex id

	db  80,  100,  80,  80,  80
	;   hp  atk  def  spd  spc

	db DRAGON, DRAGON ; type
	db 45 ; catch rate
	db 144 ; base exp

	INCBIN "gfx/pokemon/front/dragonair.pic", 0, 1 ; sprite dimensions
	dw DragonairPicFront, DragonairPicBackSW

	db WRAP, LEER, ROAR, NO_MOVE ; level 1 learnset
	db GROWTH_SLOW ; growth rate

	; tm/hm learnset
	tmhm \
	TOXIC,\
	HORN_DRILL,\
	BODY_SLAM,\
	DOUBLE_EDGE,\
	BUBBLEBEAM,\
	AURORA_BEAM,\
	ICE_BEAM,\
	BLIZZARD,\
	DRAGON_RAGE,\
	THUNDERBOLT,\
	THUNDER,\
	KINESIS,\ ; FIREWALL
	REFLECT,\
	BIDE,\
	AGILITY,\
	BARRAGE,\
	FIRE_BLAST,\
	FLAMETHROWER,\
	SLAM,\ ; FILTHY SLAM
	LIGHT_SCREEN,\
	THUNDER_WAVE,\
	SUBSTITUTE,\
	CUT,\
	SURF,\
	FLASH
	; end

	db BANK(DragonairPicFront)
	db 0
	db BANK(DragonairPicBack)
	db BANK(DragonairPicBackSW)

	dw 0, DragonairPicBack

