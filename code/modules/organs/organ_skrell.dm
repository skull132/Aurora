/*
 * A file for housing Skrell organs
 * I prefer to have a clean slate for things like this, so yeah.
 *
 */

//I swear to fuck, there has to be a better way of accessing every single symbiote out there.
//I am /not/ a fan of global lists ;-;
var/list/symbiotes = list()

/datum/organ/internal/symbiote
	name = "Skrell symbiote"
	removed_type = /obj/item/organ/symbiote
	parent_organ = "head"
	vital = 1
	//We'll make it more resiliant, because it is a creature.
	min_bruised_damage = 15
	min_broken_damage = 40

	var/emotions[0]

	New()
		..()
		//This can be customized, modified, etcetera.
		var/list/good = list("butt", "cake", "lie")
		var/list/bad = list("hey", "yes", "no")

		//This contains an index, so to speak, of all emotions present. Useful for most methods used in this.
		emotions["Emotions"] = list("Joy", "Trust"/*, "Fear", "Surprise", "Sadness", "Disgust", "Anger", "Anticipation"*/)

		//And now we add all the things forever.
		emotions["Joy"] = good
		emotions["Trust"] = bad

		symbiotes += src

	Del()
		symbiotes -= src
		..()

	process()
		..()

	proc/receive(var/list/message, var/datum/organ/internal/symbiote/A)
		if(!message)
			msg_scopes("No message!")
			return

//		Check works, but I need it offline for testing purposes. Weeeee!
//		if(src == A)
//			msg_scopes("Src received!")
//			return

		owner.emotionoverlay.overlays = list()

		var/skip		//Memory space to skip iterations.
		var/strength	//Strength of the signal received.
		var/i			//Iteration counter. Easiest to use right now.
		var/flick		//For storing the length of the image, mostly testing.
		for(var/B in message)
			i++
			strength = 1
			//If we are due to skip an iteration, then we do so.
			if(skip)
				skip--
				continue
			//Now for the culmination of strength.
			if(i + 1 <= message.len && message[i + 1] == B)
				strength++
				skip++
				if(i + 2 <= message.len && message[i + 2] == B)
					strength++
					skip++
			//Switch array for doing the effect.
			var/image/I = image("icon" = 'icons/mob/screen1_full.dmi', "icon_state" = "emotion-[B]-[strength]")
			owner.emotionoverlay.overlays += I
			switch(strength)
				if(1)
					owner << "You feel slight [B]."
					flick = 5
				if(2)
					owner << "You feel [B]."
					flick = 10
				if(3)
					owner << "You feel a lot of [B]."
					owner.emotionoverlay.layer = 18.2	//Strong emotion overpowers paaaaain!
					flick = 15

			msg_scopes("wait. Flick = [flick]")
			spawn(flick)
				msg_scopes("wait over")
				//Now we reset all the things for the next iteration!
				owner.emotionoverlay.layer = 18
				owner.emotionoverlay.overlays -= I

/obj/item/organ/symbiote
	name = "Skrell symbiote"
	desc = "It looks like it probably just plopped out."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "appendix"
	organ_tag = "symbiote"
	robotic = 0
	organ_type = /datum/organ/internal/symbiote