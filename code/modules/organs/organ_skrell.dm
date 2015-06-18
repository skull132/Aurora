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

		var/list/signals[0]
		var/i	//count measure, basically
		var/D	//memory space, needed
		for(var/B in message)
			i++
			//first iteration skips this check
			if(i > 1)
				//If we find that the current element matches the last element
				if(D == B)
					var/list/C = signals.Copy(length(signals))	//Should already be the final member, so second argument not necessary
					C["B"]++
					msg_scopes_list(C)
					msg_scopes("Equals: [C["B"]]")
				//Otherwise we just add another signal with a strength of 1
				else
					signals += list("[B]" = 1)
			else
				//The initial signal comes with a strength of 1
				//This is after the first iteration
				signals += list("[B]" = 1)
				D = B

/obj/item/organ/symbiote
	name = "Skrell symbiote"
	desc = "It looks like it probably just plopped out."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "appendix"
	organ_tag = "symbiote"
	robotic = 0
	organ_type = /datum/organ/internal/symbiote