/obj/item/reagent_containers/glass/cup
	name = "металлическая кружка"
	desc = "Прочная кружка, часто используемая воинами, стражами и другими крепкими мужчинами."
	icon_state = "iron"
	icon = 'icons/roguetown/items/cooking.dmi'
	force = 5
	throwforce = 10
	reagent_flags = OPENCONTAINER
	amount_per_transfer_from_this = 6
	possible_transfer_amounts = list(6)
	dropshrink = 0.8
	w_class = WEIGHT_CLASS_SMALL
	volume = 24
	obj_flags = CAN_BE_HIT
	sellprice = 1
	drinksounds = list('sound/items/drink_cup (1).ogg','sound/items/drink_cup (2).ogg','sound/items/drink_cup (3).ogg','sound/items/drink_cup (4).ogg','sound/items/drink_cup (5).ogg')
	fillsounds = list('sound/items/fillcup.ogg')
	anvilrepair = /datum/skill/craft/blacksmithing

/obj/item/reagent_containers/glass/cup/update_icon(dont_fill=FALSE)
	testing("cupupdate")

	cut_overlays()

	if(reagents.total_volume)
		var/mutable_appearance/filling = mutable_appearance('modular/Neu_Food/icons/cooking.dmi', "[icon_state]filling")

		filling.color = mix_color_from_reagents(reagents.reagent_list)
		filling.alpha = mix_alpha_from_reagents(reagents.reagent_list)
		add_overlay(filling)

/obj/item/reagent_containers/glass/cup/pewter
	name = "оловянная кружка"
	desc = "Изысканная кружка для питья, подражая аристократам."
	icon_state = "pewter"
	sellprice = 10

/obj/item/reagent_containers/glass/cup/wooden
	name = "деревянная кружка"
	desc = "Дно этой кружки шепчет сказки о пьяных битвах и пирах."
	resistance_flags = FLAMMABLE
	icon_state = "wooden"
	drop_sound = 'sound/foley/dropsound/wooden_drop.ogg'
	anvilrepair = null
	sellprice = 0
	metalizer_result = /obj/item/reagent_containers/glass/cup

/obj/item/reagent_containers/glass/cup/steel
	name = "кубок"
	desc = "Стальной кубок, поверхность которого украшена сложной резьбой."
	icon_state = "steel"
	sellprice = 10

/obj/item/reagent_containers/glass/cup/silver
	name = "серебрянный кубок"
	desc = "Серебряный кубок, поверхность которого украшена сложной резьбой и рунами."
	icon_state = "silver"
	sellprice = 30
	var/last_used = 0

/obj/item/reagent_containers/glass/cup/silver/funny_attack_effects(mob/living/target, mob/living/user = usr, nodmg)
	if(world.time < src.last_used + 12 SECONDS)
		to_chat(user, span_notice("Эффект серебра находится на перезарядке."))
		return
	if(ishuman(target))
		var/mob/living/carbon/human/H = target
		if(H.dna && H.dna.species)
			if(istype(H.dna.species, /datum/species/werewolf))
				H.adjustFireLoss(10)
				H.fire_act(1,10)
				to_chat(H, span_userdanger("Меня ударили моей ПОГИБЕЛЬЮ!"))
				src.last_used = world.time
				return
		if(target.mind && target.mind.has_antag_datum(/datum/antagonist/vampirelord))
			var/datum/antagonist/vampirelord/VD = target.mind.has_antag_datum(/datum/antagonist/vampirelord)
			if(!VD.disguised)
				H.adjustFireLoss(10)
				H.fire_act(1,10)
				to_chat(H, span_userdanger("Меня ударили моей ПОГИБЕЛЬЮ!"))
				src.last_used = world.time
				return

/obj/item/reagent_containers/glass/cup/silver/pickup(mob/user)
	. = ..()
	var/mob/living/carbon/human/H = user
	var/datum/antagonist/vampirelord/V_lord = H.mind.has_antag_datum(/datum/antagonist/vampirelord/)
	var/datum/antagonist/werewolf/W = H.mind.has_antag_datum(/datum/antagonist/werewolf/)
	if(ishuman(H))
		if(H.mind.has_antag_datum(/datum/antagonist/vampirelord/lesser))
			to_chat(H, span_userdanger("Я не могу брать в руки серебро, это моя ПОГИБЕЛЬ!"))
			H.Knockdown(10)
			H.Paralyze(10)
			H.adjustFireLoss(25)
			H.fire_act(1,10)
		if(V_lord)
			if(V_lord.vamplevel < 4 && !H.mind.has_antag_datum(/datum/antagonist/vampirelord/lesser))
				to_chat(H, span_userdanger("Я не могу брать в руки серебро, это моя ПОГИБЕЛЬ!"))
				H.Knockdown(10)
				H.adjustFireLoss(25)
		if(W && W.transformed == TRUE)
			to_chat(H, span_userdanger("Я не могу брать в руки серебро, это моя ПОГИБЕЛЬ!"))
			H.Knockdown(10)
			H.Paralyze(10)
			H.adjustFireLoss(25)
			H.fire_act(1,10)

/obj/item/reagent_containers/glass/cup/silver/mob_can_equip(mob/living/M, mob/living/equipper, slot, disable_warning = FALSE, bypass_equip_delay_self = FALSE)
	. = ..()
	if(ishuman(M))
		var/mob/living/carbon/human/H = M
		if(H.dna && H.dna.species)
			if(istype(H.dna.species, /datum/species/werewolf))
				M.Knockdown(10)
				M.Paralyze(10)
				M.adjustFireLoss(25)
				H.fire_act(1,10)
				to_chat(H, span_userdanger("Я не могу брать в руки серебро, это моя ПОГИБЕЛЬ!"))
				return FALSE
	if(M.mind && M.mind.has_antag_datum(/datum/antagonist/vampirelord))
		M.adjustFireLoss(25)
		M.fire_act(1,10)
		to_chat(M, span_userdanger("Я не могу брать в руки серебро, это моя ПОГИБЕЛЬ!"))
		return FALSE

/obj/item/reagent_containers/glass/cup/golden
	name = "золотой кубок"
	desc = "Этот кубок, украшенный драгоценными камнями, излучает богатство и величие."
	icon_state = "golden"
	sellprice = 50

/obj/item/reagent_containers/glass/cup/skull
	name = "кубок из черепа"
	desc = "Полые глазницы расскажут вам о забытых темных ритуалах."
	icon_state = "skull"

/obj/item/reagent_containers/glass/bowl
	name = "миска"
	desc = "Именно пустое пространство делает чашу полезной."
	icon = 'icons/roguetown/items/cooking.dmi'
	icon_state = "bowl"
	force = 5
	throwforce = 10
	reagent_flags = OPENCONTAINER
	amount_per_transfer_from_this = 6
	possible_transfer_amounts = list(6)
	dropshrink = 0.8
	w_class = WEIGHT_CLASS_SMALL
	volume = 24
	obj_flags = CAN_BE_HIT
	sellprice = 1
	drinksounds = list('sound/items/drink_cup (1).ogg','sound/items/drink_cup (2).ogg','sound/items/drink_cup (3).ogg','sound/items/drink_cup (4).ogg','sound/items/drink_cup (5).ogg')
	fillsounds = list('sound/items/fillcup.ogg')
	metalizer_result = /obj/item/roguecoin/copper

/obj/item/reagent_containers/glass/bowl/on_reagent_change(changetype)
	..()
	update_icon()

/obj/item/reagent_containers/glass/bowl/update_icon()
	cut_overlays()
	if(reagents && reagents.total_volume)
		var/mutable_appearance/filling = mutable_appearance(icon, "fullbowl")
		filling.color = mix_color_from_reagents(reagents.reagent_list)
		add_overlay(filling)
	else
		icon_state = "bowl"
