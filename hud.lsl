// VRCC Scavenger Hunt HUD Script
// Written by Dakota Miller
// for INFO 467 Spring 2016
//
// Current implementation changes textures for selected and found items,
// which causes a delay while the new texture loads. For improved performance
// but worse visuals, comment out the texture assignments and uncomment the
// color assignments

// Specifies where the HUD will be attached
integer HUDattachpoint = ATTACH_HUD_BOTTOM_LEFT;

// Coordinate locations of the hidden items
list locations = [<65.236, 137.371, 55.769>,   // Item 1
				  <43.823, 223.906, 45.046>,   // Item 2
				  <173.868, 136.038, 24.166>,  // Item 3 
				  <228.812, 56.431, 93.037>,   // Item 4
				  <120.849, 58.313, 23.079>,   // Item 5
				  <69.5, 26, 55>,    	   	   // Item 6
				  <120.353, 157.626, 22>,      // Item 7
				  <148.355, 226.988, 56.069>,  // Item 8
				  <29.360, 92.526, 21.049>,    // Item 9
				  <216.759, 175.775, 23.559>]; // Item 10

// Whether or not each item has been found
list found =  [FALSE,  // Item 1
			   FALSE,  // Item 2
			   FALSE,  // Item 3 
			   FALSE,  // Item 4
			   FALSE,  // Item 5
			   FALSE,  // Item 6
			   FALSE,  // Item 7
			   FALSE,  // Item 8
			   FALSE,  // Item 9
			   FALSE]; // Item 10

integer selected = 0;
integer found_count = 0;
// If one item has been clicked on yet
integer started = FALSE;

// Formats a float value to a fixed precision ie. for display purposes
string FormatDecimal(float number, integer precision)
{    
    float roundingValue = llPow(10, -precision)*0.5;
    float rounded;
    if (number < 0) rounded = number - roundingValue;
    else            rounded = number + roundingValue;
 
    if (precision < 1) // Rounding integer value
    {
        integer intRounding = (integer)llPow(10, -precision);
        rounded = (integer)rounded/intRounding*intRounding;
        precision = -1; // Don't truncate integer value
    }
 
    string strNumber = (string)rounded;
    return llGetSubString(strNumber, 0, llSubStringIndex(strNumber, ".") + precision);
}

default
{
	// When the HUD loads, requests permissions, sets the initial text, and starts the timer
	state_entry()
	{
		llRequestPermissions(llGetOwner(), PERMISSION_ATTACH);
		llSetLinkPrimitiveParams(14, [PRIM_TEXT, "Scavenger Hunt\n" + (string)found_count + " / 10 items found", <1.0, 1.0, 1.0>, 1.0]);
		llSetLinkPrimitiveParams(13, [PRIM_TEXT,"Click on an item to\nsee the distance between the \nyou and the selected item", <1.0, 1.0, 1.0>, 1.0]);
        llSetTimerEvent(1.0);
	}

	// Handles a touch event on the HUD
	touch_start(integer num_detected)
    {
        integer touched = llDetectedLinkNumber(0);
        // If item touched was one of the items
        if(touched > 1 && touched < 12)
        {
        	// If the previously clicked item has been found already it's texture stays green
            if(llList2Integer(found, selected) == TRUE) 
            {
            	string foundTexture = "item " + (string)(selected + 1) + " found";
            	llSetLinkTexture(selected + 2, foundTexture, ALL_SIDES); // Texture change
                //llSetLinkPrimitiveParamsFast(selected + 2, [PRIM_COLOR, ALL_SIDES, <0.180, 0.800, 0.251>, 1.0]); // Color change
            }
            // Otherwise the previously clicked item's texture reverts to normal
            else
            {
            	string normalTexture = "item " + (string)(selected + 1); 
            	llSetLinkTexture(selected + 2, normalTexture, ALL_SIDES); // Texture change
                //llSetLinkPrimitiveParamsFast(selected + 2, [PRIM_COLOR, ALL_SIDES, <1.0, 1.0, 1.0>, 1.0]); // Color change
                
                
            }
            // Updates selected item to one touched
            selected = touched - 2;
            started = TRUE;

            // If the currently clicked has not been found change its texture to yellow 
            if(llList2Integer(found, selected) == FALSE) 
            {
                string selectedTexture = "item " + (string)(selected + 1) + " selected"; 
            	llSetLinkTexture(selected + 2, selectedTexture, ALL_SIDES); // Texture change
            	//llSetLinkPrimitiveParamsFast(selected + 2, [PRIM_COLOR, ALL_SIDES, <0.7, 0.7, 0.7>, 1.0]); // Color change
            }
            
        }
    }

    // This timer loop checks the distances between the owner and the items every second
    timer()
    {
        // Update selected distance for display
    	vector goal = llList2Vector(locations, selected);
    	float distance = llVecDist(goal, llGetPos());
    	if(started == TRUE)
    	{
    		llSetLinkPrimitiveParams(13, [PRIM_TEXT,FormatDecimal(distance, 2) + "m\nBetween you and the \nselected item", <1.0, 1.0, 1.0>, 1.0]);
    	}
    	
    	// Check all item's distances
        integer i;
        for(i = 0; i < llGetListLength(locations); ++i)
        {
            vector currentGoal = llList2Vector(locations, i);
            float currentDistance = llVecDist(currentGoal, llGetPos());

            // If the owner's avatar has found the item
            if(currentDistance <= 2.0) 
            {
            	// If the item hasn't already been found
                if(llList2Integer(found, i) == FALSE)
                {
                    ++found_count;
                    llSetLinkPrimitiveParams(14, [PRIM_TEXT, "Scavenger Hunt\n" + (string)found_count + " / 10 items found", <1.0, 1.0, 1.0>, 1.0]);
                    // Change the item found's status to true
                    found = llListReplaceList(found, [TRUE], i, i);

                    // Update the texture of the found item to green
                    string foundTexture = "item " + (string)(i + 1) + " found";
                    llSetLinkTexture(i + 2, foundTexture, ALL_SIDES); // Texture change
                    //llSetLinkPrimitiveParamsFast(i + 2, [PRIM_COLOR, ALL_SIDES, <0.180, 0.800, 0.251>, 1.0]); // Color change
                }
                
                // If all the items have now been found
                if(found_count >= 10)
                {
                    llSetLinkPrimitiveParams(13, [PRIM_TEXT, "You Win!", <1.0, 1.0, 1.0>, 1.0]);
                    // Give one of the two rewards, randomly selected
                    integer rand = (integer)llFrand(2.0); // Change to 3.0 once Evan gives trident with copy perms
                    string prize = llGetInventoryName(INVENTORY_OBJECT, rand);
                    llGiveInventory(llDetectedOwner(0), prize);
                    // Stop the timer
                    llSetTimerEvent(0.0); 
                }
            }
        }
    }

    // Gets attach permissions from the owner
	run_time_permissions(integer perms)
	{
		if (perms & PERMISSION_ATTACH) llAttachToAvatar(HUDattachpoint);
	}

	// Reset the script if it's not attached
	on_rez(integer rez)
    {
        if (!llGetAttached() )        
            llResetScript();      
    }
}

