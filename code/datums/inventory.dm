/* WIP
datum/inventory
	var/mob/owner = null
	var/list/invList
	var/list/handSlots
	var/list/wornSlots
	var/list/cuffSlots
	var/activeHand = 0


datum/inventory/New( 





datum/inventory/proc/add_slot( inventory_slot/S, id, master_id = null )
	if(!id || (id in invList))
		return 0
	
	if(master_id)
		if(!(master_id in invList))
			return 0
		S.master_slot = invList[master_id]
		if(!S.master_slot.dependant_slots)
			S.master_slot.dependant_slots = new list(0)
		S.master_slot.dependant_slots += S
	
	S.slotID = id
	S.index_slot()
	sort_inv()


datum/inventory/proc/remove_slot( id, qdel_contents = 0 )
	//todo


datum/inventory/proc/sort_inv()
	//todo


datum/inventory/proc/cycle_active_hand( restart_hand = 0 )
	activeHand++
	if(activeHand > handSlots.len())
		activeHand = restart_hand

datum/inventory/proc/get_active_hand()
	if(activeHand)
		return invList[handSlots[activeHand]]
	return null


datum/inventory/proc/get_slot_by_item( obj/item/I )
	var/inventory_slot/S
	for(S in invList)
		if(S.slotItem == I)
			return S
	return null





datum/inventory_slot
	var/inventory/inv
	
	var/slotID = null
	var/slotName = "Slot"
	var/obj/item/slotItem = null
	
	var/max_w_class = 6
	
	var/list/dependant_slots = null
	var/inventory_slot/master_slot = null


datum/inventory_slot/proc/index_slot()
	inv.remove_slot( slotID ) //We should not add undifferentiated slots

datum/inventory_slot/proc/unindex_slot()
	return

datum/inventory_slot/proc/unEquip( force = 0, qdel = 0 )
	//todo

datum/inventory_slot/proc/can_equip( obj/item/I, mob/M, disable_warning = 0 )
	return 0


datum/inventory_slot/proc/get_slot_shown()
	var/dat
	dat = "<BR><B>[slotName]:</B> <A href='?src=\ref[inv.owner];item=[slotItem]'> [(slotItem && !(slotItem.flags&ABSTRACT)) ? slotItem : "Nothing"]</A>"
	if(slotItem)
		dat += slotItem.get_act_shown( inv.owner )  //For internals and such; could allow you to do other things with items on mobs.
	return dat



datum/inventory_slot/worn
	var/slotFlags = 0  //Item can equip if ANY flag is met

datum/inventory_slot/worn/can_equip( obj/item/I, mob/M, disable_warning = 0 )
	if(slotItem)
		return 0
	
	if(master_slot && (I.flags&NODROP)) //Preventing equipping NODROP items in dependant slots... I'd rather just prevent dropping if any dependants are under NODROP.
		return 0
	
	if(I.w_class > max_w_class)
		if(!disable_warning)
			M << "<span class='warning'>The [I.name] is too big to wear.</span>"
		return 0

	if(slotFlags & I.slot_flags)
		return 1
	
	return 0

datum/inventory_slot/worn/index_slot
	if(!(slotID in inv.warnSlots))
		wornSlots += slotID

datum/inventory_slot/worn/unindex_slot
	wornSlots -= slotID


datum/inventory_slot/worn/mask
	slotName = "Mask"
	slotFlags = SLOT_MASK

datum/inventory_slot/worn/back
	slotName = "Back"
	slotFlags = SLOT_BACK

datum/inventory_slot/worn/gloves
	slotName = "Gloves"
	slotFlags = SLOT_GLOVES

datum/inventory_slot/worn/eyes
	slotName = "Eyes"
	slotFlags = SLOT_EYES

datum/inventory_slot/worn/ears
	slotName = "Ears"
	slotFlags = SLOT_EARS

datum/inventory_slot/worn/head
	slotName = "Head"
	slotFlags = SLOT_HEAD

datum/inventory_slot/worn/shoes
	slotName = "Shoes"
	slotFlags = SLOT_SHOES

datum/inventory_slot/worn/belt
	slotName = "Belt"
	slotFlags = SLOT_BELT

datum/inventory_slot/worn/uniform
	slotName = "Uniform"
	slotFlags = SLOT_ICLOTHING

datum/inventory_slot/worn/exosuit
	slotName = "Exosuit"
	slotFlags = SLOT_OCLOTHING

datum/inventory_slot/worn/identification
	slotName = "ID"
	slotFlags = SLOT_ID
	
	//I should add tatoo-barcode IDs...


//TODO: stuff for ID/Unknown status, covering things up, etc.



// Suit storage etc.
datum/inventory_slot/worn/storage
	slotName = "Suit Storage"
	max_w_class = 4
	var/list/allowed = new /list(0)

datum/inventory_slot/worn/storage/can_equip( obj/item/I, mob/M, disable_warning = 0 )
	if(slotItem)
		return 0
	if(master_slot && (I.flags&NODROP) )
			return 0
	if(I.w_class > max_w_class)
		if(!disable_warning)
			M << "<span class='warning'>The [I.name] is too big to attach.</span>"
		return 0
	if((slotFlags&I.slot_flags) || is_type_in_list(I, allowed))
		return 1
	return 0


// Pockets
datum/inventory_slot/worn/pocket
	slotName = "Pocket"
	max_w_class = 2
	slotFlags = SLOT_POCKET  //can be changed to always allow items which can fit in specific slots, for whatever reason.

datum/inventory_slot/worn/pocket/can_equip( obj/item/I, mob/M, disable_warning = 0 )
	if(slotItem)
		return 0
	if(master_slot && (I.flags&NODROP) ) //Note: pockets with no master_slot are possible... Get genetics working on those marsupial-(wo)men!
			return 0
	if(I.slot_flags & slotFlags)
		return 1
	if((I.w_class>max_w_class) || I.slot_flags&SLOT_DENYPOCKET)
		if(!disable_warning)
			M << "<span class='warning'>The [I.name] won't fit in your pocket.</span>"
		return 0
	return 1

datum/inventory_slot/worn/pocket/get_slot_shown()
	return "<BR><B>[slotName]:</B> <A href='?src=\ref[inv.owner];item=[slotItem]'> [(slotItem && !(slotItem.flags&ABSTRACT)) ? "Full" : "Empty"]</A>"


datum/inventory_slot/worn/pocket/left
	slotName = "Left Pocket"

datum/inventory_slot/worn/pocket/right
	slotName = "Right Pocket"




datum/inventory_slot/hand
	//TODO

datum/inventory_slot/hand/index_slot
	if(!(slotID in inv.handSlots))
		handSlots += slotID

datum/inventory_slot/hand/unindex_slot
	handSlots -= slotID



// TODO:

datum/inventory_slot/retraint

datum/inventory_slot/retraint/handcuffs

datum/inventory_slot/retraint/legcuffs

*/
