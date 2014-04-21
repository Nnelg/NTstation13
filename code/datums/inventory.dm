/* WIP
datum/inventory
	var/list/invList
	var/list/handSlots
	var/list/wearSlots
	var/activeHand = 0


datum/inventory/New( 





datum/inventory/proc/addSlot( 


datum/inventory/proc/sortInv(




datum/inventory/






datum/inventory_slot
	var/slotID
	var/slotName
	var/obj/item/contents = null
	var/slotFlags = 0  //Item can equip if ANY flag is met
	
	var/list/dependant_slots
	var/datum/inventory_slot/master_slot = null


datum/inventory_slot/New( id, name )
	slotID = id
	slotName = name

datum/inventory_slot/proc/canEquip( obj/item/I, mob/M, disable_warning = 0 )
	if(contents)
		return 0
	
	if(slotFlags & I.slot_flags)
		return 1
	
	return 0


datum/inventory_slot/proc/get_content_name()
	if(!contents)
		return "Nothing"
	
	if(contents.flags & ABSTRACT)
		return "Nothing"
	
	return contents.name



datum/inventory_slot/






datum/inventory_slot/hand
	slotFlags = SLOT_ANY


datum/inventory_slot/hand/borghand

datum/inventory_slot/hand/borghand/canEquip( obj/item/I, mob/M, disable_warning = 0 )
	//todo:
	//if( istype( I, whateverBorgModulesAre ) )
	//	return 1
	
	return 0



datum/inventory_slot/dependant
	
*/
