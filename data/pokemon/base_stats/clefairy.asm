	db DEX_CLEFAIRY ; pokedex id

	db  70,  70,  70,  35,  70
	;   hp  atk  def  spd  spc

	db FAIRY, FAIRY ; type
	db 150 ; catch rate
	db 68 ; base exp

	INCBIN "gfx/pokemon/front/clefairy.pic", 0, 1 ; sprite dimensions
	dw ClefairyPicFront, ClefairyPicBackSW

	db POUND, GROWL, NO_MOVE, NO_MOVE ; level 1 learnset
	db GROWTH_FAST ; growth rate

	; tm/hm learnset
	tmhm \
	ICE_PUNCH,\
	LEECH_SEED,\
	FIRE_PUNCH,\
	TOXIC,\
	BODY_SLAM,\
	DOUBLE_EDGE,\
	BUBBLEBEAM,\
	AURORA_BEAM,\
	ICE_BEAM,\
	BLIZZARD,\
	AMNESIA,\
	THUNDERPUNCH,\
	ROLLING_KICK,\
	BARRIER,\
	SOLARBEAM,\
	DRAGON_RAGE,\
	THUNDERBOLT,\
	THUNDER,\
	DIG,\
	PSYCHIC_M,\
	KINESIS,\ ; FIREWALL
	REFLECT,\
	BIDE,\
	BARRAGE,\
	FIRE_BLAST,\
	FLAMETHROWER,\
	KARATE_CHOP,\
	MEDITATE,\
	LOVELY_KISS,\
	SKY_ATTACK,\
	LIGHT_SCREEN,\
	THUNDER_WAVE,\
	PSYBEAM,\
	SUBSTITUTE,\
	CUT,\
	STRENGTH,\
	FLASH
	; end


	db BANK(ClefairyPicFront)
	db 0
	db BANK(ClefairyPicBack)
	db BANK(ClefairyPicBackSW)

	dw 0, ClefairyPicBack

