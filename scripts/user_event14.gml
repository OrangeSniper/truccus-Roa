// Muno template - [CORE] init, update

// DO NOT EDIT - Only edit user_event15.gml



if ("phone_inited" in self){

	if !phone_fast && ((!phone_online && fps_real < 60) || (phone_online && keyboard_key == 48)) && !phone.state && !phone.dont_fast && state != PS_SPAWN && (state != PS_IDLE || state_timer > 5){
		if phone_lagging == 0 phone_lagging = 0.1;
		else{
			if (phone_online && keyboard_key == 48){
				print_debug("FAST GRAPHICS ENABLED - 0 KEY PRESSED");
			}
			else{
				print_debug("FAST GRAPHICS ENABLED - FPS REACHED " + string(fps_real));
			}
			phone.settings[phone.setting_fast_graphics].on = 1;
			phone.phone_settings[phone.setting_fast_graphics] = 1;
			phone_lagging = 1;
			phone_fast = 1;
		}
	}
	else if phone_lagging != 1 phone_lagging = 0;
	
	
	
	// char id for ALL
	
	if !phone.char_ided && fps_real >= 60{
		with oPlayer if self != other{
			if "muno_char_id" not in self muno_char_id = noone;
			if "muno_char_name" not in self muno_char_name = get_char_info(player, INFO_STR_NAME);
			if "muno_char_icon" not in self muno_char_icon = get_char_info(player, INFO_ICON);
			if (muno_char_id == other.muno_char_id && muno_char_id != noone) || "url" in self && url == other.url{
				other.phone_ditto = true;
				phone_ditto = true;
			}
		}
		phone.char_ided = true;
	}
	
	
	
	// Attack stuff
	
	if phone_arrow_cooldown > 0 phone_arrow_cooldown--;
	if phone_invis_cooldown > 0 phone_invis_cooldown--;
	
	phone_attacking = (state == PS_ATTACK_AIR || state == PS_ATTACK_GROUND);
	
	if phone_using_landing_cd == noone{
		phone_using_landing_cd = 0;
		phone_using_invul = 0;
		muno_cooldown_checked = [];
		muno_invul_checked = [];
		for (var checked_move = 0; checked_move < 50; checked_move++){
			if (get_attack_value(checked_move, AG_MUNO_ATTACK_COOLDOWN) < 0){
				phone_using_landing_cd = 1;
				array_push(muno_cooldown_checked, checked_move);
			}
			for (var checked_window = 1; get_window_value(checked_move, checked_window, AG_WINDOW_LENGTH) > 0; checked_window++){
				if (get_window_value(checked_move, checked_window, AG_MUNO_WINDOW_INVUL) != 0){
					phone_using_invul = 1;
					array_push(muno_invul_checked, checked_move);
				}
			}
		}
	}
	
	if phone_attacking{
		phone_window_end = floor(get_window_value(attack, window, AG_WINDOW_LENGTH) * ((get_window_value(attack, window, AG_WINDOW_HAS_WHIFFLAG) && !has_hit) ? 1.5 : 1));
		
		if phone_using_invul && !phone_invul_override && array_find_index(muno_invul_checked, attack) != -1{
			super_armor = false;
			invincible = false;
			soft_armor = 0;
			
			switch(get_window_value(attack, window, AG_MUNO_WINDOW_INVUL)){
				case -1:
					invincible = true;
					break;
				case -2:
					super_armor = true;
					break;
				case 0:
					break;
				default:
					soft_armor = get_window_value(attack, window, AG_MUNO_WINDOW_INVUL);
					break;
			}
		}
		
		phone_invul_override = 0;
		
		if get_attack_value(attack, AG_MUNO_ATTACK_COOLDOWN) != 0{
			var set_amt = abs(get_attack_value(attack, AG_MUNO_ATTACK_COOLDOWN));
			
			switch (get_window_value(attack, window, AG_MUNO_WINDOW_CD_SPECIAL)){
				case 1:
					set_amt = -1;
					break;
				case 2:
					set_amt = 0;
					break;
				case 3:
					if has_hit set_amt = 0;
					break;
				case 4:
					if has_hit_player set_amt = 0;
					break;
			}
			
			if set_amt != -1 switch (get_attack_value(attack, AG_MUNO_ATTACK_CD_SPECIAL)){
				case 0:
					move_cooldown[attack] = set_amt;
					break;
				case 1:
					phone_arrow_cooldown = set_amt;
					break;
				case 2:
					phone_invis_cooldown = set_amt;
					break;
			}
		}
	}
	
	if phone_using_landing_cd && (!free || state == PS_WALL_JUMP || state_cat == SC_HITSTUN || state == PS_RESPAWN){
		for (var checked_move = 0; checked_move < array_length(muno_cooldown_checked); checked_move++){
			switch (get_attack_value(muno_cooldown_checked[checked_move], AG_MUNO_ATTACK_CD_SPECIAL)){
				case 0:
					move_cooldown[muno_cooldown_checked[checked_move]] = 0;
					break;
				case 1:
					phone_arrow_cooldown = 0;
					break;
				case 2:
					phone_invis_cooldown = 0;
					break;
			}
		}
	}



	if (phone_attacking && attack == AT_PHONE){
		soft_armor = 9999;
		if (window == 2){
			hsp = 0;
			vsp = 0;
			can_move = false;
			can_fast_fall = false;
			
			switch(phone.state){
				case 0:
				case 3:
				case 4:
				case 5:
					window++;
					window_timer = 0;
					break;
			}
		}
	}
	
	if phone_practice && state == PS_RESPAWN visible = 1;
	
	user_event(10);
	user_event(15);
	
	exit;
}



muno_char_id = noone;
phone_inited = false;
phone_playtest = (object_index == oTestPlayer);
phone_practice = (get_training_cpu_action() != CPU_FIGHT) && !phone_playtest && get_player_hud_color(player) != c_gray;
phone_online = 0;
for (var cur = 0; cur < 4; cur++){
	if get_player_hud_color(cur+1) == $64e542 phone_online = 1;
}
swallowed = 0; // He is    anguish.
trummel_id = noone;
get_btt_data = false;
amber_startHug = false;
phone_ditto = false;
phone_user_id = self;
phone_attacking = 0;
phone_invul_override = 0;

phone_darkened_player_color = make_color_rgb(
	color_get_red	(get_player_hud_color(player)) * 0.25,
	color_get_green	(get_player_hud_color(player)) * 0.25,
	color_get_blue	(get_player_hud_color(player)) * 0.25
	);

phone_arrow_cooldown = 0;
phone_invis_cooldown = 0;

phone_blastzone_r = room_width - get_stage_data(SD_X_POS) + get_stage_data(SD_SIDE_BLASTZONE);
phone_blastzone_l = get_stage_data(SD_X_POS) - get_stage_data(SD_SIDE_BLASTZONE);
phone_blastzone_t = get_stage_data(SD_Y_POS) - get_stage_data(SD_TOP_BLASTZONE);
phone_blastzone_b = get_stage_data(SD_Y_POS) + get_stage_data(SD_BOTTOM_BLASTZONE);

phone_custom_debug = [69, 420, "woag"];

phone_using_landing_cd = noone;
phone_using_invul = noone;

phone_lagging = false;
phone_fast = 0;

SPK_TRUM = 0;
SPK_ALTO = 1;
SPK_OTTO = 2;
SPK_CODA = 3;
SPK_ECHO = 4;
SPK_MINE = 5;
SPK_SEGA = 6;

GIM_CHOMP			= 2;
GIM_CLONE 			= 3;
GIM_LAUGH_TRACK		= 5;
GIM_SKIP   			= 7;
GIM_DIE    			= 11;
GIM_SHUT_UP			= 13;
GIM_HOWL   			= 17;
GIM_SHADER 			= 19;
GIM_TEXTBOX			= 23;
GIM_COLOR  			= 29;

// Gameplay-relevant, and codecs because im biased :>
pho_has_muno_phone = 1;	// MunoPhone support		(should always be 1, obviously...)
pho_has_trum_codec = 1;	// Trummel & Alto codec
pho_has_copy_power = 0;	// Kirby Copy Ability
pho_has_btt_layout = 0;	// Break the Targets stage

// Character cosmetics
pho_has_otto_bhead = 1;	// Bobblehead for Otto's bike
pho_has_steve_dmsg = 1;	// Death message for Steve
pho_has_feri_taunt = 0;	// Costume for Feri's taunt
pho_has_hikaru_fak = 0;	// Title for Hikaru's fakie
pho_has_rat_allout = 0;	// Quip for Rat's all-out attack
pho_has_tco_sketch = 0;	// Drawing for The Chosen One's down taunt
pho_has_ahime_dead = 0;	// Sprite for Abyss Hime's slicing effect
pho_has_tink_picto = 0;	// Photograph for Toon Link's picto box
pho_has_fire_taunt = 0; // Fire's Taunt
pho_has_wall_e_ost = 0; // Wall-E's music
pho_has_amber_love = 0; // Amber's plush and/or hug
pho_has_moon_music = 0; // Moonchild's taunt music
pho_has_agentn_cdc = 0; // Agent N's codec

// Stage cosmetics
pho_has_drac_codec = 0;	// Dialogue for the Dracula boss fight
pho_has_miivs_post = 0;	// Posts for the Miiverse stage
pho_has_dede_title = 0;	// Title for the Mt Dedede Stadium stage
pho_has_soul_title = 0; // Text for the Soulbound Conflict stage
pho_has_been_found = 0; // Death sprite for the Trial Grounds stage
pho_has_resort_pic = 0; // Portrait for the Last Resort stage
pho_has_pkmn_image = 0; // Battle sprite for Pokémon Stadium
pho_has_daro_codec = 0; // Dialogue for the Daroach boss fight

// Sprites init, handy for easy sprite referencing as you can do   spr_whatever   instead of   sprite_get("whatever")   and it autocompletes in GMEdit

// Ground
spr_idle = sprite_get("idle");
spr_crouch = sprite_get("crouch");
spr_walk = sprite_get("walk");
spr_walkturn = sprite_get("walkturn");
spr_dash = sprite_get("dash");
spr_dashstart = sprite_get("dashstart");
spr_dashstop = sprite_get("dashstop");
spr_dashturn = sprite_get("dashturn");

// Air
spr_jumpstart = sprite_get("jumpstart");
spr_jump = sprite_get("jump");
spr_doublejump = sprite_get("doublejump");
spr_walljump = sprite_get("walljump");
spr_pratfall = sprite_get("pratfall");
spr_land = sprite_get("land");
spr_landinglag = sprite_get("landinglag");

// Dodge
spr_parry = sprite_get("parry");
spr_roll_forward = sprite_get("roll_forward");
spr_roll_backward = sprite_get("roll_backward");
spr_airdodge = sprite_get("airdodge");
spr_airdodge_waveland = sprite_get("waveland");
spr_tech = sprite_get("tech");

// Hurt
spr_hurt = sprite_get("hurt");
spr_bighurt = sprite_get("bighurt");
spr_hurtground = sprite_get("hurtground");
spr_uphurt = sprite_get("uphurt");
spr_downhurt = sprite_get("downhurt");
spr_bouncehurt = sprite_get("bouncehurt");
spr_spinhurt = sprite_get("spinhurt");

// Attack
spr_jab = sprite_get("jab");
spr_dattack = sprite_get("dattack");
spr_ftilt = sprite_get("ftilt");
spr_dtilt = sprite_get("dtilt");
spr_utilt = sprite_get("utilt");
spr_nair = sprite_get("nair");
spr_fair = sprite_get("fair");
spr_bair = sprite_get("bair");
spr_uair = sprite_get("uair");
spr_dair = sprite_get("dair");
spr_fstrong = sprite_get("fstrong");
spr_ustrong = sprite_get("ustrong");
spr_dstrong = sprite_get("dstrong");
spr_nspecial = sprite_get("nspecial");
spr_fspecial = sprite_get("fspecial");
spr_uspecial = sprite_get("uspecial");
spr_dspecial = sprite_get("dspecial");
spr_taunt = sprite_get("taunt");



phone = {
	firmware: 9, // latest public: 9, 21 december 2020
	stage_id: noone,
	
	hint_opac: 2,
	char_ided: 0,
	dont_fast: 0,
	
	taunt_hint_x: 0,
	taunt_hint_y: 0,
	shader: 0,
	
	frame_data_loaded: false,	// Whether frame data has been loaded yet
	state: 0,					// State of phone, i.e. rising/lowering/etc
	state_timer: 0,				// Timer for the above states
	prev_state: 0,				// Last frame's state
	app: 0,						// Current app
	prev_app: 0,				// Last frame's app
	app_timer: 0,				// Countdown that starts when you switch apps
	
	screen_w: 117,		// 1 less than actual value, for use in rectangles etc
	screen_h: 147,
	
	cursor: 0,			// Current list cursor
	prev_cursor: 0,		// Last frame's list cursor
	cursor_timer: 0,	// Countdown that starts when the cursor value changes
	cursor_timer_2: 0,	// countdown that starts when the cursor value in the side screen changes, e.g. selecting options for a cheat
	cursor_x: 0,		// Drawn xpos
	cursor_y: 0,		// Drawn ypos
	cursor_w: 0,		// Drawn width
	cursor_h: 0,		// Drawn height
	prev_cursor_x: 0,	// Previous drawn xpos
	prev_cursor_y: 0,	// Previous drawn ypos
	prev_cursor_w: 0,	// Previous drawn width
	prev_cursor_h: 0,	// Previous drawn height
	scroll_y: 0,		// Scroll amt, for vertical lists
	
	biggest_width: 0,	// For use in settings, cheats, etc
	turn_off: 0,		// Whether or not to power off
	
	sprite_index: asset_get("empty_sprite"),
	image_index: 0,
	x: 0,
	y: 0,
	image_xscale: 1,
	image_yscale: 1,
	image_angle: 0,
	image_blend: c_white,
	image_alpha: 1,
	
	apps: [],
	tips: [],
	patches: [],
	moves: [],
	cheats: [],
	settings: [],
	palette_slots: [],
	stage_settings: [],
	custom_fd_content: [],
	abouts: [],
	
	phone_settings: [], // array of current settings
	
	selected: false,		// Whether or not you've selected a tip, etc and are selected big screen
	prev_selected: false,	// Last frame's value
	
	side_bar: {
		sprite_index: asset_get("empty_sprite"),
		image_index: 0,
		x: 0,
		y: 0,
		image_xscale: 1,
		image_yscale: 1,
		image_angle: 0,
		image_blend: c_white,
		image_alpha: 1,
	
		screen_w: 555-16, // 1 less than actual value, for use in rectangles etc
		screen_h: 325-16,
		state: 0,
		state_timer: 0,
		should_open: 0,
		
		scroll_amt: 0,
		scroll_amt_h: 0,
		
		scroll_x: 0,
		scroll_y: 0,
		scroll_y_target: 0,
		scroll_x_target: 0,
		last_scroll_dir: 0 // 0 vertical, 1 horizontal
	},
	
	room_height: room_height, // why is this not accessible from here? no clue.
	room_width: room_width
};



phone_cheats = [];



initIndexes();
with phone initIndexes();



with phone{
	phone = self;
	player_id = other;
	
	move_names = [
		"???",
		"Jab",
		"???",
		"???",
		"FTilt",
		"DTilt",
		"UTilt",
		"FStrong",
		"DStrong",
		"UStrong",
		"DAttack",
		"FAir",
		"BAir",
		"DAir",
		"UAir",
		"NAir",
		"FSpecial",
		"DSpecial",
		"USpecial",
		"NSpecial",
		"FStrong 2",
		"DStrong 2",
		"UStrong 2",
		"USpecial Ground",
		"USpecial 2",
		"FSpecial 2",
		"FThrow",
		"UThrow",
		"DThrow",
		"NThrow",
		"DSpecial 2",
		"Extra 1",
		"DSpecial Air",
		"NSpecial 2",
		"FSpecial Air",
		"Taunt",
		"Taunt 2",
		"Extra 2",
		"Extra 3",
		"MunoPhone",
		"???",
		"NSpecial Air",
		"???",
		"???",
		"???",
		"???",
		"???",
		"???",
		"???",
		"???",
		"???"
	];
}



// Sprites, sfx init

with phone{ // for GML autocomplete lol

	spr_pho_idle = 0;
	spr_pho_roundtangle_small = 0;
	spr_pho_bar = 0;
	spr_pho_digits = 0;
	spr_pho_app_icons = 0;
	spr_pho_cursor = 0;
	spr_pho_slider = 0;
	spr_pho_side_mask = 0;
	spr_pho_arrow = 0;
	spr_pho_compatibility_badges = 0;
	
}

phone.spr_pho_idle = sprite_get("_pho_idle");
phone.spr_pho_roundtangle_small = sprite_get("_pho_roundtangle_small");
phone.spr_pho_bar = sprite_get("_pho_bar");
phone.spr_pho_digits = sprite_get("_pho_digits");
phone.spr_pho_app_icons = sprite_get("_pho_app_icons");
phone.spr_pho_cursor = sprite_get("_pho_cursor");
phone.spr_pho_slider = sprite_get("_pho_slider");
phone.spr_pho_side_mask = sprite_get("_pho_side_mask");
phone.spr_pho_arrow = sprite_get("_pho_arrow");
phone.spr_pho_compatibility_badges = sprite_get("_pho_compatibility_badges");

// sfx can't be played if stored in phone... idk man

sfx_pho_close1 = sound_get("_pho_close1");
sfx_pho_close2 = sound_get("_pho_close2");
sfx_pho_move = sound_get("_pho_move");
sfx_pho_open1 = sound_get("_pho_open1");
sfx_pho_open2 = sound_get("_pho_open2");
sfx_pho_select1 = sound_get("_pho_select1");
sfx_pho_select2 = sound_get("_pho_select2");

spr_pho_cooldown_arrow = sprite_get("_pho_cooldown_arrow");

phone.sprite_index = phone.spr_pho_idle;
phone.side_bar.sprite_index = phone.spr_pho_slider;



// Variables init

with phone{
	
	low_y = 600;
	mid_y = 360;
	top_y = 240;
}



// Apps init

with phone{
	
	/*
	 * initApp(<index>, <name>, <icons frame>, <background color>)
	 */
	
	initApp(0, 0, "HOME Menu", $3a3026, 0); // uses BGR instead of RGB for... some reason????? wtf gamemaker
	initApp(1, 1, "Fighter Tips", $875825, tips);
	initApp(2, 2, "Patch Notes", $5a7b1d, patches);
	initApp(3, 3, "Phone Settings", $bd5b68, settings);
	initApp(4, 4, "Frame Data", $33929e, moves); // old color: $236b89
	initApp(5, 5, "Cheat Codes", $352587, cheats);
	initApp(6, 6, "Training Town", $6c3e3f, stage_settings);
	initApp(7, 7, "Codecs", $264b87, []);
	initApp(8, 8, "About", $8f2b85, abouts);
	initApp(9, 9, "Power Off", $87263d, 0);
	
}



// Settings init

with phone{
	
	i = 0;
	
	/*
	 * initSetting(<display name>, <backstage name>, <options>, <option names>)
	 * 
	 * Use phone_settings[] to reference these cheats in code, putting the
	 * backstage name (without quotes) as the array index. The backstage name
	 * becomes the name of a variable storing the setting's index. E.g.
	 * 
	 * if (phone_settings[setting_military_time] == 1) {
	 *	   print_debug("woag");
	 * }
	 * 
	 * Both phone_settings[] and the index vars are stored within the phone obj.
	 */
	
	initSetting("Clock Format", "setting_military_time", [0, 1], ["12-Hour", "24-Hour"], "Change the format of the phone's clock.");
	initSetting("Graphics", "setting_fast_graphics", [0, 1], ["Fancy", "Fast"], "Fast Graphics disables the clock and transparency. Unless the character dev specifies otherwise, it will trigger automatically if the FPS drops below 60 for 2+ frames while the MunoPhone is closed.
	
	In online matches, it won't automatically trigger; instead, press the 0 (zero) key on the keyboard to enable Fast Graphics.");


	initSetting("Debug Print", "setting_print_debug", [0, 1], ["Off", "On"], "With this setting enabled, press Ctrl+8 to monitor important values such as current speed, frames per second, and current state.
	
	As the developer of this character, you can define three custom variables to track; see user_event15.gml for details.");
	initSetting("FPS Warning", "setting_fps_warn", [1, 0], ["On", "Off"], "Display a warning onscreen when the FPS drops below 60.");
	
}



// Stage settings init

with phone{
	
	// Probably load these from the stage itself, yea?
	// That way other stages could be released w/ their OWN settings. woag
	
	// Unrelatedly... add an option to disconnect phone from big screen? And reconnect
	
	// Options: go to layout editor, music, make AI less annoying, ...
	
}



// Abouts init

with phone{
	
	/*
	 * initAbout(entry name, entry text)
	 */
	 
	initAbout("About MunoPhone", "MunoPhone firmware v" + string(firmware) + "
	
	by Muno
	    @munomario777
	
	Optimisation help: Archytas
	Beta testing: Tdude
	
	[More Mods] tinyurl.com/muno-collection
	[Community] discord.gg/yhchvBB
	
	SFX: Super Paper Mario"); // if you remove the credits i will come to your house and kick down your door
	
}



user_event(15); // Char specific init

phone_inited = true;



#define initIndexes

// Custom indexes

AT_PHONE = 40;

i = 80; // Change this value if these indexes overlap with custom ones used by your character

// NOTE: All overrides for the frame data guide should be strings. Any non-applicable (N/A) values should be entered as "-"

// General Attack Indexes
AG_MUNO_ATTACK_EXCLUDE = i; i++;		// Set to 1 to exclude this move from the list of moves
AG_MUNO_ATTACK_REFRESH = i; i++;		// Set to 1 to refresh this move's data every frame while the frame data guide is open
AG_MUNO_ATTACK_NAME = i; i++;			// Enter a string to override move name
AG_MUNO_ATTACK_FAF = i; i++;			// Enter a string to override FAF
AG_MUNO_ATTACK_ENDLAG = i; i++;			// Enter a string to override endlag
AG_MUNO_ATTACK_LANDING_LAG = i; i++;	// Enter a string to override landing lag
AG_MUNO_ATTACK_MISC = i; i++;			// Enter a string to OVERRIDE the move's "Notes" section, which automatically includes the Cooldown System and Misc. Window Traits found below
AG_MUNO_ATTACK_MISC_ADD = i; i++;		// Enter a string to ADD TO the move's "Notes" section (preceded by the auto-generated one, then a line break)

// Adding Notes to a move is good for if a move requires a long explanation of the data, or if a move overall has certain behavior that should be listed such as a manually coded cancel window

// General Window Indexes
AG_MUNO_WINDOW_EXCLUDE = i; i++;		// 0: include window in timeline (default)    1: exclude window from timeline    2: exclude window from timeline, only for the on-hit time    3: exclude window from timeline, only for the on-whiff time
AG_MUNO_WINDOW_ROLE = i; i++;			// 0: none (acts identically to AG_MUNO_WINDOW_EXCLUDE = 1)   1: startup   2: active (or BETWEEN active frames, eg between multihits)   3: endlag
AG_MUNO_ATTACK_USES_ROLES = i; i++;		// Must be set to 1 for AG_MUNO_WINDOW_ROLE to take effect

// If your move's windows are structured non-linearly, you can use AG_MUNO_WINDOW_ROLE to force the frame data system to parse the window order correctly.

// Cooldown System (do this instead of manually setting in attack_update, and cooldown/invul/armor will automatically appear in the frame data guide)
AG_MUNO_ATTACK_COOLDOWN = i; i++;		// Set this to a number, and the move's move_cooldown[] will be set to it automatically. Set it to any negative number and it will refresh when landing, getting hit, or walljumping. (gets converted to positive when applied)
AG_MUNO_ATTACK_CD_SPECIAL = i; i++;		// Set various cooldown effects on a per-attack basis.
AG_MUNO_WINDOW_CD_SPECIAL = i; i++;		// Set various cooldown effects on a per-window basis.
AG_MUNO_WINDOW_INVUL = i; i++;			// -1: invulnerable    -2: super armor    above 0: that amount of soft armor

/*
 * AG_MUNO_ATTACK_CD_SPECIAL values:
 * - 1: the cooldown will use the phone_arrow_cooldown variable instead of move_cooldown[attack], causing it to display on the overhead player indicator; multiple attacks can share this cooldown.
 * - 2: the cooldown will use the phone_invis_cooldown variable instead of move_cooldown[attack], which doesn't display anywhere (unless you code your own HUD element) but does allow you to share the cooldown between moves.
 * 
 * AG_MUNO_WINDOW_CD_SPECIAL values:
 * - 1: a window will be exempted from causing cooldown. It is HIGHLY RECOMMENDED to do this for any startup windows, so that the cooldown doesn't apply if you're hit out of the move before being able to use it.
 * - 2: a window will reset the cooldown to 0.
 * - 3: a window will set cooldown only if the has_hit	      variable is false, and set it to 0 if has_hit        is true.
 * - 4: a window will set cooldown only if the has_hit_player variable is false, and set it to 0 if has_hit_player is true.
 */



i = 80; // Change this value if these indexes overlap with custom ones used by your character

HG_MUNO_HITBOX_EXCLUDE = i; i++;		// Set to 1 to exclude this hitbox from the frame data guide
HG_MUNO_HITBOX_NAME = i; i++;			// Enter a string to override hitbox name

HG_MUNO_HITBOX_ACTIVE = i; i++;			// Enter a string to override active frames
HG_MUNO_HITBOX_DAMAGE = i; i++;			// Enter a string to override damage
HG_MUNO_HITBOX_BKB = i; i++;			// Enter a string to override base knockback
HG_MUNO_HITBOX_KBG = i; i++;			// Enter a string to override knockback growth
HG_MUNO_HITBOX_ANGLE = i; i++;			// Enter a string to override angle
HG_MUNO_HITBOX_PRIORITY = i; i++;		// Enter a string to override priority
HG_MUNO_HITBOX_GROUP = i; i++;			// Enter a string to override group
HG_MUNO_HITBOX_BHP = i; i++;			// Enter a string to override base hitpause
HG_MUNO_HITBOX_HPG = i; i++;			// Enter a string to override hitpause scaling
HG_MUNO_HITBOX_MISC = i; i++;			// Enter a string to override the auto-generated misc notes (which include misc properties like angle flipper or elemental effect)
HG_MUNO_HITBOX_MISC_ADD = i; i++;		// Enter a string to ADD TO the auto-generated misc notes, not override (line break will be auto-inserted)

// Misc. Hitbox Traits
HG_MUNO_OBJECT_LAUNCH_ANGLE = i; i++;	// Override the on-hit launch direction of compatible Workshop objects, typically ones without gravity. For example, Otto uses this for the ball rehit angles. Feel free to code this into your attacks, AND to support it for your own hittable articles.

/* Set the obj launch angle to:
 * - -1 to send horizontally away (simulates flipper 3, angle 0)
 * - -2 to send radially away (simulates flipper 8)
 */



#define initAbout(obj_name, obj_text)

var para = {
	type: 0,
	text: obj_text,
	align: fa_left,
	color: c_white,
	indent: 0,
	gimmick: 0,
	side_by_side_exempt: false
};

var tip = {
	name: obj_name,
	objs: [para]
};

array_push(abouts, tip);



#define initApp(idx, app_sprite, app_name, app_color, app_arr)

apps[idx] = {
	name: app_name,			// Name displayed on HOME Menu, etc
	sprite: app_sprite,		// App icon displayed on HOME Menu
	color: app_color,		// Background color while in app
	array: app_arr,			// Array of items to be shown in the list
	dark_color: make_color_rgb(
		color_get_red(app_color) * 0.25,
		color_get_green(app_color) * 0.25,
		color_get_blue(app_color) * 0.25
		)
};



#define initSetting(st_name, st_cmd, st_opt, st_opt_name, st_desc)

settings[i] = {
	name: st_name,
	command: st_cmd,
	options: st_opt,
	option_names: st_opt_name,
	description: st_desc,
	on: 0
};

variable_instance_set(self, st_cmd, i);
phone_settings[i] = st_opt[0];

i++;