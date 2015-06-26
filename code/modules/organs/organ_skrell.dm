/*
 * A file for housing Skrell organs
 * I prefer to have a clean slate for things like this, so yeah.
 *
 */

/datum/organ/internal/symbiote
	name = "Skrell symbiote"
	removed_type = /obj/item/organ/symbiote
	parent_organ = "head"
	vital = 0
	//We'll make it more resiliant, because it is a creature.
	min_bruised_damage = 15
	min_broken_damage = 40

	var/emotions[0]
	var/accuracy = 100

	New()
		..()
		//This can be customized, modified, etcetera.
		var/list/Joy = list("yay", "happy", "bliss", "great", "sweet", "hurrah", "cheer", "joy", "pleased", "invigorate", "revitalise", "energise", "refresh", "nice")
		var/list/Appreciation = list("appreciate", "faith", "approve", "trust", "love", "adore", "praise", "acknowledge", "like", "accept", "motivate", "kind", "admire", "thank you")
		var/list/Fear = list("help", "scare", "fear", "anxious", "dread", "panic", "horror", "worry", "maniac", "harm", "hurt", "crazy")
		var/list/Surprise = list("what", "wow", "oh my god", "dead!", "whoa", "shock", "believe")
		var/list/Sadness = list("sad", "hopeless", "upset", "blue", "devastated", "sorry", "mourn", "not feeling well", "cry", "melancholy", "grief")
		var/list/Disgust = list("ew", "ugh", "disgust", "nasty", "gross", "sicken", "revolting", "horrible", "bored", "tedious", "yuck", "appalling", "terrible")
		var/list/Anger = list("hate", "dislike", "can't stand", "damn", "rage", "annoy", "exasperation", "fury", "stupid", "dumb", "displeased", "resent", "fuck", "shit", "cunt", "dick", "asshole", "mad")
		var/list/Anticipation = list("watch", "wait", "look", "interest", "outlook", "prospect", "hope", "vigil", "attention", "assume", "prepare", "hunch", "suppose", "plan", "guard", "overlook", "expect", "forecast", "predict", "suspense")

		//This contains an index, so to speak, of all emotions present. Useful for most methods used in this.
		emotions["Emotions"] = list("Joy", "Appreciation", "Fear", "Surprise", "Sadness", "Disgust", "Anger", "Anticipation")

		//And now we add all the things forever.
		emotions["Joy"] = Joy
		emotions["Appreciate"] = Appreciation
		emotions["Fear"] = Fear
		emotions["Surprise"] = Surprise
		emotions["Sadness"] = Sadness
		emotions["Disgust"] = Disgust
		emotions["Anger"] = Anger
		emotions["Anticipation"] = Anticipation

		//Accuracy setting. For Skrell 40 or younger, you'll start suffering penalties while receiving massages.
		if(owner && owner.age <= 40)
			switch(owner.age)
				if(0 to 20)
					accuracy = rand(20,60)
				if(21 to 30)
					accuracy = rand(50,80)
				if(31 to 40)
					accuracy = rand(80,100)

	process()
		..()

	proc/receive(var/list/message, var/datum/organ/internal/symbiote/A)
		if(!message)
			return

//		if(src == A)
//			return

		//Dead men tell no tales.
		if(is_broken())
			return

		if(!(status & ORGAN_CUT_AWAY) && !organ_holder)
			if(!owner || owner.stat == 2)	//This should never happen, but, just in case.
				return

			var/Accuracy = accuracy	//Realistic accuracy, for deducing while we're bruised and all. I don't want to touch the base value, so consider this an offset value.
			if(is_bruised())
				Accuracy = accuracy - rand(10,damage)

			var/skip		//Memory space to skip iterations.
			var/strength	//Strength of the signal received.
			var/i			//Iteration counter. Easiest to use right now.
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

				//Accuracy related checks, because younger Skrell have more wouble with wunderstanding.
				if(!prob(Accuracy))
					switch(roll(1,20))
						if(1 to 2)	//Crit failure: lose the feeling completely.
							continue
						if(3 to 5)	//Below average failure: go get fucked.
							B = pick(emotions["Emotions"])
							strength = rand(1,3)
						if(6 to 15)	//Failure: mess with strength, really. This will happen most often.
							strength = rand(1,3)
						//16 to 20 mean a pass, so nothing happens.

				//Switch array for doing the effect.
				//Using flick for the easiest method of making the smooth anims work.
				//Taking over the damage overlay. Making a new one /specifically/ for this seems like a mistake right now.
				flick("emotion-[B]-[strength]", owner.damageoverlay)
				switch(strength)
					if(1)
						owner << "You feel slight [B]."
					if(2)
						owner << "You feel [B]."
					if(3)
						owner << "You feel a lot of [B]."

		else
			if(!organ_holder.health) //Does fuckall while dead
				return

			organ_holder.visible_message(pick("The [src] squirms slightly.","The [src] shivers visibly.","The [src] secretes a small amount of fluids.","The [src] wriggles ever so slightly."))

/obj/item/organ/symbiote
	name = "Skrell symbiote"
	desc = "It looks like it probably just plopped out."
	icon = 'icons/obj/surgery.dmi'
	icon_state = "appendix"
	organ_tag = "symbiote"
	robotic = 0
	organ_type = /datum/organ/internal/symbiote

	process()
		//Doesn't die, nor does it secrete blood or stuff like that. It's a slug, not an organ.
		return