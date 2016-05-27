// Locations of the hidden items
list locations = [<66, 136, 55>,   // Item 1
				  <42, 219, 45>,   // Item 2
				  <175, 136, 24>,  // Item 3 
				  <224, 51, 92>,   // Item 4
				  <229, 217, 23>,  // Item 5
				  <60, 34, 56>,    // Item 6
				  <109, 136, 22>,  // Item 7
				  <211, 66, 30>,   // Item 8
				  <24, 93, 21>,    // Item 9
				  <218, 176, 23>]; // Item 10

// Whether or not each item has been found
list status = [FALSE,  // Item 1
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

default
{
    state_entry()
    {
        llOwnerSay("State entered successfully");
        llSetText("Maybe this?", <1.0, 1.0, 1.0>, 1.0);
        llSetTimerEvent(1.0);
        // integer i;
        // for(i = 0; i < llGetListLength(test); ++i) {
        // 	llOwnerSay(llList2String(location, i));
        // }

    }

    touch_start(integer num_detected)
    {

    	// selected += 1;
    	// if(selected  == 10) 
    	// {
    	// 	selected = 0;
    	// }

    	// integer i;
    	// for(i = 0; i < llGetListLength(status); ++i) 
    	// {
    	// 	llOwnerSay(llList2String(status, i));
    	// }
    }

    timer()
    {
    	vector goal = llList2Vector(locations, selected);
    	float distance = llVecDist(goal, llGetPos());
    	llSetText((string)distance, <1.0, 1.0, 1.0>, 1.0);
    	if(distance <= 1.0) {
    		// Change the selected status to true
    		status = llListReplaceList(status, [TRUE], selected, selected);
    	}
    }
}