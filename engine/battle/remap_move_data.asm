; PureRGBnote: ADDED: Certain moves get better accuracy, power, or other effects when used by specific pokemon
; Also this list can be used to modify a move's data such as power/accuracy after selecting it based on the current state of battle.
; TODO: make multiple pokemon able to receive remap for the same move
CheckRemapMoveData::
	call GetMoveRemapData
	push de
	ld hl, RemappableMoves
	ld de, 4
	call IsInArray
	pop de
	ret nc
	inc hl
	ld a, [hl]
	cp -1
	jr z, .donePokemonCheck
	; the move has a specific pokemon required (it is a signature move)
	CheckEvent FLAG_SIGNATURE_MOVES_TURNED_OFF
	ret nz
	ld a, d
	cp VOLCANIC_MAGMAR
	jr nz, .notVolcanicMagmar
	ld a, MAGMAR ; treat VOLCANIC_MAGMAR as MAGMAR when checking for signature moves
.notVolcanicMagmar
	cp [hl]
	ret nz
.donePokemonCheck
	inc hl
	ld a, [hl]
	cp -2
	jr z, .modifierFunction
	call GetMoveRemapData2
	ld a, [hli]
	cp -1
	jr z, .donePowerCheck
	ld [bc], a
.donePowerCheck
	ld a, [hli]
	and a
	ret z ; no accuracy change
	ld [de], a
	ret
.modifierFunction
	inc hl
	ld a, [hl]
	ld hl, ModifierFuncs
	call GetAddressFromPointerArray
	jp hl

GetMoveRemapData:
	ldh a, [hWhoseTurn]
	and a
	ld a, [wBattleMonSpecies]
	ld d, a
	ld a, [wBattleMonLevel]
	ld e, a
	ld a, [wPlayerMoveNum]
	ret z
	ld a, [wEnemyMonSpecies]
	ld d, a
	ld a, [wEnemyMonLevel]
	ld e, a
	ld a, [wEnemyMoveNum]
	ret

GetMoveRemapData2:
	ldh a, [hWhoseTurn]
	and a
	ld bc, wPlayerMovePower
	ld de, wPlayerMoveAccuracy
	ret z
	ld bc, wEnemyMovePower
	ld de, wEnemyMoveAccuracy
	ret

; byte 1 = move
; byte 2 = required pokemon for modifier or -1 for any pokemon
; byte 3 = modified power or -1 if no change or -2 if the move uses a modifier function
; byte 4 = modified accuracy or 0 if no accuracy change, or which modifier function to use if previous byte was -2
RemappableMoves::
	db SING, -1, -2, 1
	db DOUBLESLAP, -1, -2, 0
	db EXPLOSION, -1, -2, 2
	db SELFDESTRUCT, -1, -2, 2
	; db KINESIS, -1, -2, 3 ; CRUNCH ; FIX now that this is crunch
	db TOXIC, -1, -2, 3
	db SKULL_BASH, -1, -2, 4
	db SLAM, -1, -2, 5 ; POISON JAB
	; signature moves start here
	db POISON_STING, BEEDRILL, 45, 0
	db TWINEEDLE, BEEDRILL, 65, 0 
	db ACID, ARBOK, 100, 0
	db DRILL_PECK, FEAROW, 110, 0
	db ROCK_SLIDE, GOLEM, 110, 0
	db HI_JUMP_KICK, HITMONLEE, 160, 0
	db MEGA_PUNCH, HITMONCHAN, 150, 0
	db THUNDERPUNCH, ELECTABUZZ, 105, 0
	db FIRE_PUNCH, MAGMAR, 105, 0
	db ICE_PUNCH, JYNX, 105, 0
	db DRAGON_RAGE, DRAGONITE, 100, 0
	db DRAGON_RAGE, DRAGONAIR, 100, 0 ; New
	db WATERFALL, SEAKING, 160, 0
	db DIZZY_PUNCH, KANGASKHAN, 130, 0
	; db LICK, LICKITUNG, 70, 0
	db LICK, LICKITUNG, 105, 0
	db SPIKE_CANNON, OMASTAR, 70, 0
	db HYPNOSIS, HYPNO, -1, 85 percent
	db FIRE_BLAST, ARCANINE, -1, 100 percent
	db BLIZZARD, DEWGONG, -1, 100 percent
	db HYDRO_PUMP, BLASTOISE, -1, 100 percent ; New
	db SKULL_BASH, BLASTOISE, 130, 0 ; New
	db PSYBEAM, GOLDUCK, 105, 0
	db SMOG, WEEZING, 90, 0 ; New
	db BIND, ONIX, 40, 0 ; New
	db FLAMETHROWER, CHARIZARD, 110, 0 ; New
	db NIGHT_SHADE, HAUNTER, 90, 0 ; New
	db NIGHT_SHADE, GENGAR, 90, 0 ; New
	db -1

ModifierFuncs:
	dw DoubleSlapModifier
	dw SingModifier
	dw ExplosionSelfdestructModifier
	;	dw CRUNCHModifier
	dw ToxicModifier
	dw SkullBashModifier
	dw PoisonJabModifier

CheckIfAsleep::
GetOpponentStatus::
	ldh a, [hWhoseTurn]
	and a
	ld bc, wEnemyMonStatus
	ld hl, wPlayerMovePower
	jr z, .gotStatus
	ld bc, wBattleMonStatus
	ld hl, wEnemyMovePower
.gotStatus
	ld a, [bc]
	and SLP_MASK
	ret

DoubleSlapModifier::
	call CheckIfAsleep
	ret z
	ld a, [hl]
	sla a
	ld [hl], a ; double doubleslap's power when opponent is asleep
	ret

DoubleSlapModifierPart2::
	call CheckIfAsleep
	ret z
	ld a, [bc]
	and %11111000
	inc a
	ld [bc], a ; 1 turn of sleep left now (needs to be applied separately by the effect so it only triggers if the attack hits)
	ret

SingModifier::
	CheckEvent FLAG_SIGNATURE_MOVES_TURNED_OFF
	ret nz
	call GetMoveRemapData
	ld a, d
	cp WIGGLYTUFF
	jr z, .checkLevel
	cp JIGGLYPUFF
	jr z, .checkLevel
	ret
.checkLevel
	ld a, e
	cp 20
	ret c
	call GetMoveRemapData2
	ld a, 85 percent
	ld [de], a ; sing gets 85% accuracy for jigglypuff/wigglytuff if they're past level 20
	ret

ExplosionSelfdestructModifier:
	xor a
	ld [wAnimationType], a
	ldh a, [hWhoseTurn]
	and a
	jr z, .playerTurn
.enemyTurn
	ld d, 3
	callfar FarCheckIfEnemyHPBelowFraction
	jr .doneHPCheck
.playerTurn
	ld d, 3
	callfar FarCheckIfPlayerHPBelowFraction
.doneHPCheck
	ret nc
	ldh a, [hWhoseTurn]
	and a
	ld hl, wPlayerMovePower
	ld bc, wPlayerMoveEffect
	jr z, .gotTurn
	ld hl, wEnemyMovePower
	ld bc, wEnemyMoveEffect
.gotTurn
	; if less then 1/3 hp, explosion/selfdestruct do their original effect and much more power
	ld [hl], 250
	ld a, EXPLODE_EFFECT
	ld [bc], a
	; the below code was originally in ExplodeEffect but was moved because it looks nicer to happen instantly on using the move
	ld hl, wBattleMonHP
	ld de, wPlayerBattleStatus2
	ldh a, [hWhoseTurn]
	and a
	jr z, .faintUser
	ld hl, wEnemyMonHP
	ld de, wEnemyBattleStatus2
.faintUser
	xor a
	ld [hli], a ; set the mon's HP to 0
	ld [hli], a
	inc hl
	ld [hl], a ; set mon's status to 0
	ld a, [de]
	res SEEDED, a ; clear mon's leech seed status
	ld [de], a
	jpfar DrawHUDsAndHPBars

; CRUNCHModifier:
; 	ldh a, [hWhoseTurn]
; 	and a
; 	ld hl, wEnemyBattleStatus3
; 	ld de, wEnemyMonStatus
; 	jr z, .gotTurn
; 	ld hl, wPlayerBattleStatus3
; 	ld de, wBattleMonStatus
; .gotTurn
; 	ld a, [de]
; 	bit BRN, a
; 	ret z ; no power boosts if opponent not already burned
; 	push hl
; 	call GetMoveRemapData
; 	ld a, e
; 	cp 50 ; is pokemon at least level 50
; 	jr nc, .stronger ; if so the move will boost higher in power on burned mons
; .weaker
; 	pop hl
; 	bit BOOSTED_CRUNCH, [hl]
; 	ld a, 50
; 	jr z, .loadPower
; 	ld a, 80
; 	jr .loadPower
; .stronger
; 	pop hl
; 	bit BOOSTED_CRUNCH, [hl]
; 	ld a, 80
; 	jr z, .loadPower
; 	ld a, 140
; .loadPower
; 	push af
; 	call GetMoveRemapData2
; 	pop af
; 	ld [bc], a
; 	ret

; input d = which pokemon
GetRemappedMoveAndPowerFromPokemon::
	ld hl, RemappableMoves + 1
.loop
	ld a, [hl]
	cp d
	jr z, .found
	dec hl
	ld a, [hli]
	cp $FF
	jr z, .notFound
	inc hl
	inc hl
	inc hl
	inc hl
	jr .loop
.notFound
	and a
	ret
.found
	scf
	dec hl
	ld d, [hl] ; move ID
	inc hl
	inc hl
	ld e, [hl] ; move remapped power
	ret

GetUserType:
	ldh a, [hWhoseTurn]
	and a
	ld hl, wBattleMonType1
	ret z
	ld hl, wEnemyMonType1
	ret

ToxicModifier:
	call GetUserType
	ld a, [hli]
	cp POISON
	jr z, Modifier100Accuracy
	ld a, [hl]
	cp POISON
	ret nz
	; fall through
Modifier100Accuracy:
	call GetMoveRemapData2
	ld a, 100 percent
	ld [de], a
	ret

SkullBashModifier:
	call GetUserType
	ld a, [hli]
	cp ROCK
	jr z, Modifier100Accuracy
	cp CRYSTAL
	jr z, Modifier100Accuracy
	ld a, [hl]
	cp ROCK
	jr z, Modifier100Accuracy
	cp CRYSTAL
	ret nz
	jr Modifier100Accuracy

PoisonJabModifier::
	call GetOpponentStatus
	ld a, [bc]
	bit PSN, a
	ret z
	ld [hl], 130 ; increase poison jab power to 130 if opponent poisoned
	ret