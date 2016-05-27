integer HUDattachpoint = ATTACH_HUD_BOTTOM_LEFT;

// Locate()
// {
// 	integer test = 0;
// 	llSetText(test);
// 	test = test + 1;
// }


default
{

	state_entry()
	{
		//llRequestPermissions(llGetOwner(), PERMISSION_ATTACH);
		llOwnerSay("State entered successfully");
	}

	attach(key id)
	{
		if(id)
		{
			llSetScale(<0.1, 0.15, 0.1>);
            llSetPrimitiveParams([PRIM_TYPE, PRIM_TYPE_BOX, PRIM_HOLE_DEFAULT, <0.0, 1.0, 0.0>, 0.0, <0.0, 0.0, 0.0>, <2.0, 0.5, 1.0>, <0.0, 0.0, 0.0>, PRIM_ROT_LOCAL, <0.000000, -0.707107, 0.000000, 0.707107>, PRIM_COLOR, 0, <1.0,1.0,1.0>, 1.0, PRIM_COLOR, 1, <0.0,1.0,0.0>, 1.0, PRIM_COLOR, 3, <0.0,1.0,0.0>, 1.0, PRIM_COLOR, 2, <1.0,1.0,1.0>, 0.0, PRIM_COLOR, 4, <1.0,1.0,1.0>, 0.0]);
            llRotateTexture(270.0*DEG_TO_RAD,0);
            HUDattachpoint=llGetAttached();
            llOwnerSay("Attached successfully");
            //Locate();
            //llRequestPermissions(llGetOwner(), PERMISSION_TAKE_CONTROLS);
		}
	}



	run_time_permissions(integer perms)
	{
		if (perms & PERMISSION_ATTACH) llAttachToAvatar(HUDattachpoint);
	}

	on_rez(integer rez)
    {
        if (!llGetAttached() )        //reset the script if it's not attached.
            llResetScript();      
    }
}